FactoryGirl.define do
  factory :attachment do
    canvas_user_id  { rand(120) }
    assignment_id { rand(10)}
    submission_id { rand(30)}
    attachment_id { rand(50)}
    gallery_id  { id.to_s + '-' + assignment_id.to_s }
    content_type { 'image/jpg'}
    author { 'Aristotle'}
    image_url  "image.jpg"
    date Time.now
  end
end