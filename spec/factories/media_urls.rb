FactoryGirl.define do
  factory :media_url do
    site_tag {['vimeo_id', 'youtube_id'].sample }
    site_id { rand(50000).to_s}
    sequence (:canvas_assignment_id) { |n| n + rand(400000) }
    sequence (:canvas_user_id) { |n| n + rand(400000) }
    gallery_id { 'video-' + rand(200).to_s + '-' + rand(200).to_s }
    thumbnail_url 'http://localhost:3000/file.png'
    submitted_at  {Faker::Date.between(2.weeks.ago, Date.today) }
  end
end
