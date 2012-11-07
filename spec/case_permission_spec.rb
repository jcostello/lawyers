require 'spec_helper'

describe CasePermission do

  describe "#can_read?" do

    before(:each) do
      @law_case = build(:law_case)
    end
    it "should return true if the permission is full_access and the target is the given case" do
      case_permission = build(:case_permission, target: @law_case, access: :full_access)
      case_permission.can_read?(@law_case).should be_true
    end

    it "should return true if the permission is read_only and the target is the given case" do
      case_permission = build(:case_permission, target: @law_case, access: :read_only)
      case_permission.can_read?(@law_case).should be_true
    end

    it "should return false if the target isnt the given case" do
      another_law_case = build(:law_case, number: 2345)
      case_permission = build(:case_permission, target: another_law_case, access: :full_access)
      case_permission.can_read?(@law_case).should be_false
    end

    it "should return false if the permission is no_access" do
      case_permission = build(:case_permission, target: @law_case, access: :no_access)
      case_permission.can_read?(@law_case).should be_false
    end
  end
end
