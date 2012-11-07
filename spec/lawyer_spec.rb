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
      another_lawyer.permissions.case_permissions.count.should == 1
    end

    it "should update the permission if it already exist" do
      another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_case_permission(another_lawyer, @law_case, :full_access);
      @lawyer.grant_case_permission(another_lawyer, @law_case, :read_only);
      another_lawyer.permissions.case_permissions.count.should == 1
    end
  end

  describe "#grant_lawyer_cases_permission" do

    it "should not give the permission if the lawyer isnt from the same law firm" do
      another_law_firm = build(:law_firm, name: "Evil law firm")
      another_lawyer = build(:lawyer, name: "pedro", law_firm: another_law_firm)
      lambda do
        @lawyer.grant_lawyer_cases_permission(another_lawyer, :full_access);
      end.should raise_error Exceptions::GrantPermissionException
    end

    it "should add the permission the lawyer" do
      another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_lawyer_cases_permission(another_lawyer, :full_access);
      another_lawyer.permissions.lawyer_cases_permissions.count.should == 1
    end

    it "should update the permission if it already exist" do
      another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_lawyer_cases_permission(another_lawyer, :full_access);
      @lawyer.grant_lawyer_cases_permission(another_lawyer, :read_only);
      another_lawyer.permissions.lawyer_cases_permissions.count.should == 1
    end
  end

  describe "#can_read?" do

    context "for his own cases" do
      
      before(:each) do
        @law_case = @lawyer.init_case(1234)
      end
      it "should return true for his own cases" do
        @lawyer.can_read?(@law_case).should be_true
      end

      it "should return true even if it has denied permissions" do
        @lawyer.permissions.stub(:can_read?) { false }
        @lawyer.can_read?(@law_case).should be_true
      end
    end

    context "for another lawyer's case" do

      it "should return true if the permissions allow to read" do
        @lawyer.permissions.stub(:can_read?) { true }
        @lawyer.can_read?(@law_case).should be_true
      end

      it "should return false if the permissions denied to read" do
        @lawyer.permissions.stub(:can_read?) { false }
        @lawyer.can_read?(@law_case).should be_false
      end
    end
  end
  
  describe "#can_read?" do

    context "for his own cases" do
      
      before(:each) do
        @law_case = @lawyer.init_case(1234)
      end
      it "should return true for his own cases" do
        @lawyer.can_write?(@law_case).should be_true
      end

      it "should return true even if it has denied permissions" do
        @lawyer.permissions.stub(:can_write?) { false }
        @lawyer.can_write?(@law_case).should be_true
      end
    end

    context "for another lawyer's case" do

      it "should return true if the permissions allow to read" do
        @lawyer.permissions.stub(:can_write?) { true }
        @lawyer.can_write?(@law_case).should be_true
      end

      it "should return false if the permissions denied to read" do
        @lawyer.permissions.stub(:can_write?) { false }
        @lawyer.can_write?(@law_case).should be_false
      end
    end
  end
  
  describe "#remove_case_permission" do
    
    before(:each) do
      @law_case = @lawyer.init_case(1234)
      @another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_case_permission(@another_lawyer, @law_case, :full_access);
    end

    it "should remove a case permission" do
      @lawyer.remove_case_permission(@another_lawyer, @law_case)
      @another_lawyer.permissions.case_permissions.count.should == 0
    end

    it "should not remove the permission if the case isn't his owns" do
      lambda do
        @another_lawyer.remove_case_permission(@another_lawyer, @law_case)
      end.should raise_error Exceptions::RemovePermissionException
    end
  end
  
  describe "#remove_lawyer_cases_permission" do
    
    before(:each) do
      @another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_lawyer_cases_permission(@another_lawyer, :full_access);
    end

    it "should remove a case permission" do
      @lawyer.remove_lawyer_cases_permission(@another_lawyer)
      @another_lawyer.permissions.lawyer_cases_permissions.count.should == 0
    end

    it "should not remove the permission if the case isn't his owns" do
      another_law_firm = build(:law_firm, name: "Evil law firm")
      another_lawyer = build(:lawyer, name: "pedro", law_firm: another_law_firm)
      lambda do
        @lawyer.remove_lawyer_cases_permission(another_lawyer)
      end.should raise_error Exceptions::RemovePermissionException
    end
  end
end

