FactoryGirl.define do
  factory :law_case do |law_case|
    law_case.number 1234
    law_case.owner { build(:lawyer) }
    initialize_with { new(number, owner) }
  end
end
