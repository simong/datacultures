require 'rails_helper'

class RespondsToOrder

  def new
    []
  end

  def order(args)
    []
  end
end

RSpec.describe Canvas::DiscussionsProcessor, :type => :model do

  context "#process"  do

    before(:all) do
      PointsConfiguration.delete_all
      Activity.delete_all
      PointsConfiguration.create({interaction: "DiscussionTopic", points_associated: 12, active: true, pcid: "Foo" })
      PointsConfiguration.create({interaction: "DiscussionEdit", points_associated: 3, active: true, pcid: "Bar" })
      PointsConfiguration.create({interaction: "DiscussionReply",   points_associated:  7, active: true, pcid: "Baz"})
    end

    let(:conf)        {  Rails.application.secrets['requests']                                }

    # request configuration data (for rare actual call testing)
    let(:base_url)   {  conf['base_url']                                                     }
    let(:api_key)    {  conf['api_keys']['teacher']                                          }
    let(:course)     {  conf['course']                                                       }

    # YAML stored mock data hashes -- these are examples of the API call returns
    let(:discussion) { YAML.load_file('spec/fixtures/discussions/discussions.yml')           }
    let(:entries)    { YAML.load_file('spec/fixtures/discussions/discussion_entries.yml')    }
    let(:stream)     { YAML.load_file('spec/fixtures/activity_streams/activity_stream.yml').select{|y| y['type'] == "DiscussionTopic"} }

    # test specific configuration, depends on YAML fixtures and secrets.yml
    let(:topic_id)   { conf['discussion_topic_id']                                           }
    let(:dstream)    { discussion.merge({"discussion_topic_id" => topic_id})                 }
    let(:discussion_stream_with_replies)   \
                     { dstream.merge({"total_root_discussion_entries" => 2})}
    let(:topic_path) { "api/v1/courses/#{course}/discussion_topics/#{topic_id}"              }
    let(:entry_path) { "api/v1/courses/#{course}/discussion_topics/#{topic_id}/entries"      }
    let(:ok_return)  { {status: 200, body: {"author" => {"id" => topic_id}} }                }

    ## Ruby objects
    let(:request_object) {  Canvas::ApiRequest.new({base_url: base_url, api_key: api_key})   }
    let(:processor)      {  Canvas::DiscussionsProcessor.new({request_object: request_object})                                 }

    ## simple mock data
    let(:create_score_change) {              12        }
    let(:reply_score_change)  {               5        }
    let(:other_hash)          {  {'foo' => 'bar'}      }


    it "does not change the activities if called without a discussion hash" do
      setup_request {
        stub_request(:get, base_url + "api/v1/courses/#{course}/discussion_topics/" ).to_return({status: 200})
      }
      expect{processor.process(other_hash)}.to_not change{Activity.count}
    end

    context "A new top-level post" do
      it "will call the discussions API (to get the creator's ID)" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(request_object.request).to receive(:get).with(topic_path).once
        processor.process(dstream)
      end

      it "checks for the action having already been scored" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        allow(Activity).to receive(:where) { RespondsToOrder.new }
        allow(Activity).to receive(:score!) {[]}
        expect(Activity).to receive(:where).once
        processor.process(dstream)
      end

      it "scores the post as a top-level discussion" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(Activity).to receive(:score!).once
        processor.process(dstream)
      end

      it "changes the Activities table" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect{processor.process(dstream)}.to change{Activity.count}.by(1)
      end

      it "will not call the entries API without a number (> 0) entries from the stream" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(request_object.request).to_not receive(:get).with(entry_path)
        processor.process(dstream)
      end
    end

    context "An existing post" do

      before (:each) do
        Activity.create({reason: 'DiscussionTopic', canvas_user_id: 7, canvas_scoring_item_id: topic_id, delta: 3 })
      end

      after (:each) do
        Activity.where({reason: 'DiscussionTopic', canvas_user_id: 7, canvas_scoring_item_id: topic_id, delta: 3 }).delete_all
      end

      it "does not call the API for the discussion itself" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(request_object.request).to_not receive(:get).with(topic_path)
        processor.process(dstream)
      end

      it "does not changes the Activities table" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect{processor.process(dstream)}.to_not change{Activity.count}
      end

      it "scores the post as a top-level discussion" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(Activity).to_not receive(:score!)
        processor.process(dstream)
      end

      it "does not create a new entry in Activities" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect{processor.process(dstream)}.to_not change{Activity.count}
      end
    end

    context "top level discussion has replies" do
      it "calls the entries API" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
          stub_request(:get, base_url + entry_path ).to_return([ok_return])
        }
        expect(request_object.request).to receive(:get).twice
        processor.process(discussion_stream_with_replies)
      end

      context "new replies" do
        it "adds an entry to the Activities table" do
          expect{processor.process_children(entries)}.to change{Activity.count}.by(2)
        end
      end

      context "no new replies" do   # this is actually going to be common, Canvas serves up data
        # for far longer than our polling frequency
        it "does not add any entries to the Activities table" do
          Activity.create({reason: 'DiscussionReply', delta: 3, canvas_user_id: 7, canvas_scoring_item_id: 10})
          Activity.create({reason: 'DiscussionReply', delta: 3, canvas_user_id: 9, canvas_scoring_item_id: 11})
          expect{processor.process_children(entries)}.to_not change{Activity.count}
        end

      end
    end

  end
end
