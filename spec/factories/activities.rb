# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    canvas_user_id  "MOO"
    reason "CAW"
    delta  { -1 + rand(2)}
    canvas_scoring_item_id  309
  end
end
