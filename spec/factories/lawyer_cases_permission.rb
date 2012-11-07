FactoryGirl.define do
  factory :lawyer_cases_permission do |lawyer_cases_permission|
    lawyer_cases_permission.target { build(:lawyer) }
    lawyer_cases_permission.access { :full_access }
    initialize_with { new(target, access) }
  end
end
