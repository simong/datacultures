FactoryGirl.define do
  factory :generic_url do
    sequence (:assignment_id) { |n| n + rand(400000) }
    sequence (:canvas_user_id) { |n| n + rand(400000) }
    gallery_id { 'url-' + rand(200).to_s + '-' + rand(200).to_s }
    url { Faker::Internet.url }
    image_url 'http://localhost:3000/file.png'
    submitted_at  {Faker::Date.between(2.weeks.ago, Date.today) }
  end
end
