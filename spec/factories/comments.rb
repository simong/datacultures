require 'faker'

Faker::Config.locale = 'en-US'

FactoryGirl.define do
  factory :comment do
    authors_canvas_id  { rand(120)              }
    gallery_id         { Faker::Lorem.word      }
    content            { Faker::Lorem.paragraph }
  end
end
