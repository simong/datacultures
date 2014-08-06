# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    canvas_user_id 1
    name "Jonathan Doe"
    sortable_name {"#{name}".split.reverse.join(', ')}
    sis_user_id 123
    primary_email  {"#{name}".delete(' ') + "@gmail.com"}
    section {["A", "B", "C", "D", "E"].sample}
    share {[true, false].sample}
  end
end
