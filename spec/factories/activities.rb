# Read about factories at https://github.com/thoughtbot/factory_girl

reasons =
  [
    "Post artwork in Mission Gallery",
    "+1 a peer's artwork in Mission Gallery",
    "+1 a peer's comment in Mission Gallery",
    "-1 a peer's artwork in Mission Gallery",
    "-1 a peer's comment in Mission Gallery",
    "Receive +1 on your artwork in Mission Gallery",
    "Receive +1 on your comment in Mission Gallery",
    "Receive a -1 from a peer on your artwork or comment",
    "Comment on peer's artwork in Mission Gallery",
    "Comment on lecture videos in Mission",
    "Add new Comment in Readings tab",
    "Reply to a topic in the Mission Help tab",
    "Reply to a peer's comment in Readings tab"
  ]

FactoryGirl.define do
  factory :activity do
    canvas_user_id  1
    reason {reasons[rand(reasons.length)]}
    delta  { -1 + rand(10)}
    canvas_scoring_item_id  {rand(1000)}
    canvas_updated_at Time.now
  end
end
