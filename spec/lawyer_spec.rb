require 'spec_helper'

describe Lawyer do

  before(:each) do
    @lawyer = build(:lawyer)
    @law_case = build(:law_case)
  end

  describe "#take_case" do
    it "should add a case to his own cases" do
      @lawyer.take_case(@law_case)
      @lawyer.own_cases.should == [@law_case]
    end

    it "should make the owner who take the case" do
      @lawyer.take_case(@law_case)
      @law_case.owner.should be(@lawyer)
    end

    it "should reject the case if its already has a owner" do
      another_lawyer = build(:lawyer, name: "pedro")
      another_lawyer.take_case(@law_case)
      lambda do
        @lawyer.take_case(@law_case)
      end.should raise_error Exceptions::CaseAlreadyTakenException
    end

    it "should reject the case if its already taken by himself" do
      @lawyer.take_case(@law_case)
      lambda do
        @lawyer.take_case(@law_case)
      end.should raise_error Exceptions::CaseAlreadyTakenException
    end
  end

  describe "#grant_case_permission" do
    it "should not give the permission if isnt his case" do
      @lawyer.take_case(@law_case)
      another_lawyer = build(:lawyer, name: "pedro")
      lambda do
        another_lawyer.grant_case_permission(@lawyer, @law_case, :full_access);
      end.should raise_error Exceptions::GrantPermissionException
    end

    it "should not give the permission if the lawyer isnt from the same law firm" do
      @lawyer.take_case(@law_case)
      another_law_firm = build(:law_firm, name: "Evil law firm")
      another_lawyer = build(:lawyer, name: "pedro", law_firm: another_law_firm)
      lambda do
        @lawyer.grant_case_permission(another_lawyer, @law_case, :full_access);
      end.should raise_error Exceptions::GrantPermissionException
    end

    it "should add the permission the lawyer" do
    end
    
    it "should update the permission if it already exist" do
    end
  end
end

