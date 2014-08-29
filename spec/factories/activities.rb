# Read about factories at https://github.com/thoughtbot/factory_girl

reasons =
[
'DiscussionTopic',
'DiscussionEdit',
'DiscussionEntry',
'Submission',
'GalleryComment',
'Like',
'Dislike'
]

FactoryGirl.define do
  factory :activity do
    canvas_user_id  { rand(120) }
    reason {reasons[rand(reasons.length)]}
    delta  { rand(10) + 3}                 # no negative values
    canvas_scoring_item_id  {rand(1000)}
    canvas_updated_at Time.now
    score true
  end
end
