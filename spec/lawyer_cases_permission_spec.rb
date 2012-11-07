require 'spec_helper'

describe LawyerCasesPermission do

  describe "#can_read?" do

    before(:each) do
      @lawyer = build(:lawyer)
      @law_case = @lawyer.init_case(1234)
    end

    it "should return true if the permission is full_access and the target has the case" do
      lawyer_cases_permission = build(:lawyer_cases_permission, target: @lawyer, access: :full_access)
      lawyer_cases_permission.can_read?(@law_case).should be_true
    end

    it "should return true if the permission is read_only and the target has the case" do
      lawyer_cases_permission = build(:lawyer_cases_permission, target: @lawyer, access: :read_only)
      lawyer_cases_permission.can_read?(@law_case).should be_true
    end

    it "should return false if the target has not the case" do
      another_law_case = build(:law_case, number: 2345)
      lawyer_cases_permission = build(:lawyer_cases_permission, target: @lawyer, access: :full_access)
      lawyer_cases_permission.can_read?(another_law_case).should be_false
    end

    it "should return false if the permission is no_access" do
      lawyer_cases_permission = build(:lawyer_cases_permission, target: @lawyer, access: :no_access)
      lawyer_cases_permission.can_read?(@law_case).should be_false
    end
  end
end
