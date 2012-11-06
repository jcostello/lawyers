FactoryGirl.define do
  factory :law_case do |law_case|
    law_case.number 1234
    initialize_with { new(number) }
  end
end
