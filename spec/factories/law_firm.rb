FactoryGirl.define do
  factory :law_firm do |lawyer|
    lawyer.name "Marshall's law firm"
    initialize_with { new(name) }
  end
end
