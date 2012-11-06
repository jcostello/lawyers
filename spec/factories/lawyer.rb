FactoryGirl.define do
  factory :lawyer do |lawyer|
    lawyer.name 'John'
    lawyer.law_firm { build(:law_firm) }
    initialize_with { new(name, law_firm) }
  end
end
