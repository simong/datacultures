# Read about factories at https://github.com/thoughtbot/factory_girl

require 'faker'

Faker::Config.locale = 'en-US'

FactoryGirl.define do
  factory :student do
    sequence (:canvas_user_id) { |n| n + rand(100) }
    name { Faker::Name.name  }
    sortable_name {"#{name}".split.reverse.join(', ')}
    sis_user_id 123
    primary_email  { Faker::Internet.email }
    section {["A", "B", "C", "D", "E"].sample}
    share {[true, false].sample}
  end
end
