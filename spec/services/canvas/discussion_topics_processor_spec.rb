require 'rails_helper'

RSpec.describe Canvas::DiscussionTopicsProcessor, :type => :model do

  context "#call"  do

    before(:all) do
      PointsConfiguration.delete_all
      Activity.delete_all
      Student.delete_all
      PointsConfiguration.create({interaction: "DiscussionTopic", points_associated: 12, active: true, pcid: "Foo" })
      PointsConfiguration.create({interaction: "DiscussionEdit", points_associated: 3, active: true, pcid: "Bar" })
    end

    after(:all) do
      PointsConfiguration.delete_all
      Activity.delete_all
      Student.delete_all
    end

    # request configuration data (for rare actual call testing)
    let(:base_url)   {  AppConfig::CourseConstants.base_url                                          }
    let(:api_key)    {  AppConfig::CourseConstants.api_key                                           }
    let(:course)     {  AppConfig::CourseConstants.course                                            }

    # YAML stored mock data hashes -- these are examples of the API call returns
    let(:discussion) { YAML.load_file('spec/fixtures/discussions/discussions.yml')                   }
    let(:entries)    { YAML.load_file('spec/fixtures/discussions/discussion_entries.yml')             }

    # test specific configuration, depends on YAML fixtures and app_config
    let(:topic_id)   { "7"                                                                           }
    let(:topic_path) { "api/v1/courses/#{course}/discussion_topics/#{topic_id}"                      }
    let(:entry_path) { "api/v1/courses/#{course}/discussion_topics/#{topic_id}/entries?per_page=250" }
    let(:ok_return)  { {status: 200, body: {"author" => {"id" => topic_id}} }                        }

    ## Ruby objects
    let(:request_object) {  ApiRequest.new(base_url: base_url, api_key: api_key)           }
    let(:processor)      {  Canvas::DiscussionTopicsProcessor.new({request_object: request_object, course: '1'}) }

    ## simple mock data
    let(:create_score_change) {              12        }
    let(:reply_score_change)  {               5        }

    before(:all) do
      FactoryGirl.create(:student, {canvas_user_id: 3})
    end

    after(:all) do
      Student.delete_all
    end

    context "A new top-level post" do

       it "scores the post as a top-level discussion" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(Activity).to receive(:score!).once
        processor.call(discussion)
       end

       it "does not score for an assigned discussion" do
         setup_request {
           stub_request(:get, base_url + topic_path ).to_return(ok_return)
         }
         expect{processor.call([discussion.first.merge('assignment_id' => 15)])}.
           to_not change{Activity.student_scores}
       end

      it "changes the Activities table" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect{processor.call(discussion)}.to change{Activity.count}.by(1)
      end

      it "will not call the entries API without a number (> 0) entries from the stream" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(request_object.request).to_not receive(:get).with(entry_path)
        processor.call(discussion)
      end
    end

    context "An existing post" do

      before (:each) do
         Activity.create({reason: 'DiscussionTopic', canvas_user_id: 3, scoring_item_id: 7,
                         delta: 3, body: discussion.first['message']+discussion.first['title'],
                         canvas_updated_at: Time.now - 5.years })
      end

      after (:each) do
        Activity.where({reason: 'DiscussionTopic', scoring_item_id: '7'}).delete_all
      end

      context "which was not edited" do

        it "does not change the Activities table" do
          setup_request {
            stub_request(:get, base_url + topic_path ).to_return(ok_return)
          }
          expect{processor.call(discussion)}.to_not change{Activity.count}
        end

        it "does not score the post" do
          setup_request {
            stub_request(:get, base_url + topic_path ).to_return(ok_return)
          }
          expect(Activity).to_not receive(:score!)
          processor.call(discussion)
        end

      end

      context "which was edited" do

        it "changes the Activities table" do
          setup_request {
            stub_request(:get, base_url + topic_path ).to_return(ok_return)
          }
          discussion.first['message'] = 'EDITED'
          expect{processor.call(discussion)}.to change{Activity.count}
        end

        it "scores the post" do
          setup_request {
            stub_request(:get, base_url + topic_path ).to_return(ok_return)
          }
          discussion.first['message'] = 'EDITED'
          expect(Activity).to receive(:score!)
          processor.call(discussion)
        end
      end
    end

    context "discussion does not have replies" do

      it "does not call a Canvas::DiscussionEntriesProcessor" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(Canvas::DiscussionEntriesProcessor).to_not receive(:new)
        processor.call(discussion)
      end

      it "does not call a Canvas::DiscussionEntriesProcessor" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
        }
        expect(Canvas::PagedApiProcessor).to_not receive(:new)
        processor.call(discussion)
      end
    end

    context "discussion has replies" do

      it "creates a Canvas::DiscussionEntriesProcessor" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
          stub_request(:get, base_url + entry_path ).to_return(ok_return)
          allow_any_instance_of(Canvas::PagedApiProcessor).to receive(:call).and_return([])
        }
        discussion.first['discussion_subentry_count'] = 3
        expect(Canvas::DiscussionEntriesProcessor).to receive(:new).and_call_original
        processor.call(discussion)
      end

      it "creates a Canvas::DiscussionEntriesProcessor" do
        setup_request {
          stub_request(:get, base_url + topic_path ).to_return(ok_return)
          stub_request(:get, base_url + entry_path ).to_return(ok_return)
          allow_any_instance_of(Canvas::PagedApiProcessor).to receive(:call).and_return([])
        }
        discussion.first['discussion_subentry_count'] = 3
        expect(Canvas::PagedApiProcessor).to receive(:new).and_call_original
        processor.call(discussion)
      end

    end

  end
end
