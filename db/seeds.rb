require 'factory_girl_rails'
require 'faker'

(1..20).each do |n|
  FactoryGirl.create(:student, name: Faker::Name.name, canvas_user_id: n)
end

(1..20).each do |n|
  FactoryGirl.create(:activity, canvas_user_id: n)
end
