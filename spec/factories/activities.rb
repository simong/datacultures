# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :activity do
    uid  "MOO"
    reason "CAW"
    delta  { -1 + rand(2)}
  end
end
