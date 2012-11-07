FactoryGirl.define do
  factory :case_permission do |case_permission|
    case_permission.target { build(:law_case) }
    case_permission.access { :full_access }
    initialize_with { new(target, access) }
  end
end
