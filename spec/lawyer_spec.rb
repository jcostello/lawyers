require 'spec_helper'

describe Lawyer do

  before(:each) do
    @lawyer = build(:lawyer)
  end

  describe "#init_case" do
    it "should add a case to his own cases" do
      law_case = @lawyer.init_case(1234)
      @lawyer.own_cases.should == [law_case]
    end

    it "should make the owner who take the case" do
      law_case = @lawyer.init_case(1234)
      law_case.owner.should be(@lawyer)
    end
  end

  describe "#grant_case_permission" do

    before(:each) do
      @law_case = @lawyer.init_case(1234)
    end

    it "should not give the permission if isnt his case" do
      another_lawyer = build(:lawyer, name: "pedro")
      lambda do
        another_lawyer.grant_case_permission(@lawyer, @law_case, :full_access);
      end.should raise_error Exceptions::GrantPermissionException
    end

    it "should not give the permission if the lawyer isnt from the same law firm" do
      another_law_firm = build(:law_firm, name: "Evil law firm")
      another_lawyer = build(:lawyer, name: "pedro", law_firm: another_law_firm)
      lambda do
        @lawyer.grant_case_permission(another_lawyer, @law_case, :full_access);
      end.should raise_error Exceptions::GrantPermissionException
    end

    it "should add the permission the lawyer" do
      another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_case_permission(another_lawyer, @law_case, :full_access);
      another_lawyer.permissions[:case].count.should == 1
    end
    
    it "should update the permission if it already exist" do
      another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_case_permission(another_lawyer, @law_case, :full_access);
      @lawyer.grant_case_permission(another_lawyer, @law_case, :read_only);
      another_lawyer.permissions[:case].count.should == 1
    end
  end
end

