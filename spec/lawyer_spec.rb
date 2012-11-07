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
      another_lawyer.permissions[:lawyer_cases].count.should == 1
    end

    it "should update the permission if it already exist" do
      another_lawyer = build(:lawyer, name: "pedro")
      @lawyer.grant_lawyer_cases_permission(another_lawyer, :full_access);
      @lawyer.grant_lawyer_cases_permission(another_lawyer, :read_only);
      another_lawyer.permissions[:lawyer_cases].count.should == 1
    end
  end

  describe "#can_read?" do

    it "should return true for his own cases" do
      law_case = @lawyer.init_case(1234)
      @lawyer.can_read?(law_case).should be_true
    end

    context "for another lawyer's case" do

      it "should return false with no permissions" do
         another_lawyer = build(:lawyer, name: "pedro")
         law_case = another_lawyer.init_case(2345)
        @lawyer.can_read?(law_case).should be_false
      end

      context "with a case permission on the given law case" do

        before(:each) do
          @another_lawyer = build(:lawyer, name: "pedro")
          @law_case = @another_lawyer.init_case(2345)
        end

        it "should return true for full_access" do
          @another_lawyer.grant_case_permission(@lawyer, @law_case, :full_access)
          @lawyer.can_read?(@law_case).should be_true
        end

        it "should return true for read_only" do
          @another_lawyer.grant_case_permission(@lawyer, @law_case, :read_only)
          @lawyer.can_read?(@law_case).should be_true
        end

        it "should return false for no_access" do
          @another_lawyer.grant_case_permission(@lawyer, @law_case, :no_access)
          @lawyer.can_read?(@law_case).should be_false
        end
      end

      context "with a lawyer cases permission" do

        before(:each) do
          @another_lawyer = build(:lawyer, name: "pedro")
          @law_case = @another_lawyer.init_case(2345)
        end

        it "should return true if the permission is full_access and the lawyer onws the case" do
          @another_lawyer.grant_lawyer_cases_permission(@lawyer, :full_access)
          @lawyer.can_read?(@law_case).should be_true
        end

        it "should return true if the permission is read_only and the lawyer onws the case" do
          @another_lawyer.grant_lawyer_cases_permission(@lawyer, :read_only)
          @lawyer.can_read?(@law_case).should be_true
        end

        it "should return false if the permission is no_access" do
          @another_lawyer.grant_lawyer_cases_permission(@lawyer, :no_access)
          @lawyer.can_read?(@law_case).should be_false
        end
      end

      context "with a lawyer cases permission but a not access case permission" do
        before(:each) do
          @another_lawyer = build(:lawyer, name: "pedro")
          @law_case = @another_lawyer.init_case(2345)
          @another_lawyer.grant_case_permission(@lawyer, @law_case, :no_access)
        end

        it "should return false if the permission is full_access and the lawyer onws the case" do
          @another_lawyer.grant_lawyer_cases_permission(@lawyer, :full_access)
          @lawyer.can_read?(@law_case).should be_false
        end

        it "should return false if the permission is read_only and the lawyer onws the case" do
          @another_lawyer.grant_lawyer_cases_permission(@lawyer, :read_only)
          @lawyer.can_read?(@law_case).should be_false
        end

        it "should return false if the permission is no_access" do
          @another_lawyer.grant_lawyer_cases_permission(@lawyer, :no_access)
          @lawyer.can_read?(@law_case).should be_false
        end
      
      end
    end
  end
end

