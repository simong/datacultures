require 'rails_helper'

RSpec.describe Canvas::DiscussionEntriesProcessor, :type => :model do

  before(:all) do
    PointsConfiguration.delete_all
    Activity.delete_all
    Student.delete_all
    PointsConfiguration.create({interaction: "DiscussionEntry",   points_associated:  7, active: true, pcid: "Baz"})
  end

  after(:all) do
    Student.delete_all
    PointsConfiguration.delete_all
    Activity.delete_all
  end

  # request configuration data (for rare actual call testing)
  let(:base_url)   {  AppConfig::CourseConstants.base_url                                          }
  let(:api_key)    {  AppConfig::CourseConstants.api_key                                           }
  let(:course)     {  AppConfig::CourseConstants.course                                            }

  # YAML stored mock data hashes -- these are examples of the API call returns
  let(:entries)    { YAML.load_file('spec/fixtures/discussions/discussion_entries.yml')            }

  # test specific configuration, depends on YAML fixtures and app_config
  let(:topic_id)   { "7"                                                                           }
  let(:entry_path) { "api/v1/courses/#{course}/discussion_topics/#{topic_id}/entries?per_page=250" }
  let(:ok_return)  { {status: 200, body: {"author" => {"id" => topic_id}} }                        }

  ## Ruby objects
  let(:request_object) {  ApiRequest.new(base_url: base_url, api_key: api_key)           }
  let(:processor)      {  Canvas::DiscussionEntriesProcessor.new({request_object: request_object, course: '1'}) }

  ## simple mock data
  let(:entry_score_change)  {               5        }

  before(:all) do
    FactoryGirl.create(:student, {canvas_user_id: 11})
    FactoryGirl.create(:student, {canvas_user_id: 13})
  end

  after(:all) do
    Student.delete_all
  end

  context "#call" do

    it "scores both children and grandchildren" do
      setup_request {
        stub_request(:get, base_url + entry_path ).to_return(ok_return)
      }
      expect{processor.call(entries)}.to change{Activity.count}.by(2)
    end

    it "does not add Activity (scoring) for already scored actions." do
      setup_request {
        stub_request(:get, base_url + entry_path ).to_return(ok_return)
      }
      processor.call(entries)
      expect{processor.call(entries)}.to_not change{Activity.count}
    end

    it "does nothing for an empty input (no entries on a topic)" do
      setup_request {
        stub_request(:get, base_url + entry_path ).to_return(ok_return)
      }
      processor.call(entries)
      expect{processor.call([{}])}.to_not change{Activity.count}
    end

  end
end
