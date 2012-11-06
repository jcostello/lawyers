FactoryGirl.define do
  factory :lawyer do |lawyer|
    lawyer.name 'John'
    initialize_with { new(name) }
  end
end
