require 'spec_helper'

describe PermissionCollection do

  before(:each) do
    @law_case = build(:law_case)
    @permission_collection = PermissionCollection.new
  end

  describe "#add_case_permission" do
    it "should add a case permission" do
      @permission_collection.add_case_permission(@law_case, :read_only)
      @permission_collection.case_permissions.count.should == 1
    end
  end

  describe "#add_lawyer_cases_permission" do
    it "should add a case permission" do
      @permission_collection.add_lawyer_cases_permission(@lawyer, :read_only)
      @permission_collection.lawyer_cases_permissions.count.should == 1
    end
  end

  describe "#can_read?" do

    context "for another lawyer's case" do

      it "should return false with no permissions" do
        law_case = build(:law_case)
        @permission_collection.can_read?(law_case).should be_false
      end

      context "with a case permission on the given law case" do

        before(:each) do
          @law_case = build(:law_case)
        end

        it "should return true for full_access" do
          @permission_collection.add_case_permission(@law_case, :full_access)
          @permission_collection.can_read?(@law_case).should be_true
        end

        it "should return true for read_only" do
          @permission_collection.add_case_permission(@law_case, :read_only)
          @permission_collection.can_read?(@law_case).should be_true
        end

        it "should return false for no_access" do
          @permission_collection.add_case_permission(@law_case, :no_access)
          @permission_collection.can_read?(@law_case).should be_false
        end
      end

      context "with a lawyer cases permission" do

        before(:each) do
          @lawyer = build(:lawyer)
          @law_case = @lawyer.init_case(1234)
        end

        it "should return true for full_access" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :full_access)
          @permission_collection.can_read?(@law_case).should be_true
        end

        it "should return true for read_only" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :read_only)
          @permission_collection.can_read?(@law_case).should be_true
        end

        it "should return false for no_access" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :no_access)
          @permission_collection.can_read?(@law_case).should be_false
        end
      end

      context "with a lawyer cases permission but a not access case permission" do

        before(:each) do
          @lawyer = build(:lawyer)
          @law_case = @lawyer.init_case(1234)
          @permission_collection.add_case_permission(@law_case, :no_access)
        end

        it "should return false if the permission is full_access and the lawyer onws the case" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :full_access)
          @permission_collection.can_read?(@law_case).should be_false
        end

        it "should return false if the permission is read_only and the lawyer onws the case" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :read_only)
          @permission_collection.can_read?(@law_case).should be_false
        end

        it "should return false if the permission is no_access" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :no_access)
          @permission_collection.can_read?(@law_case).should be_false
        end

      end
    end
  end
  describe "#can_write?" do

    context "for another lawyer's case" do

      it "should return false with no permissions" do
        law_case = build(:law_case)
        @permission_collection.can_write?(law_case).should be_false
      end

      context "with a case permission on the given law case" do

        before(:each) do
          @law_case = build(:law_case)
        end

        it "should return true for full_access" do
          @permission_collection.add_case_permission(@law_case, :full_access)
          @permission_collection.can_write?(@law_case).should be_true
        end

        it "should return true for read_only" do
          @permission_collection.add_case_permission(@law_case, :read_only)
          @permission_collection.can_write?(@law_case).should be_false
        end

        it "should return false for no_access" do
          @permission_collection.add_case_permission(@law_case, :no_access)
          @permission_collection.can_write?(@law_case).should be_false
        end
      end

      context "with a lawyer cases permission" do

        before(:each) do
          @lawyer = build(:lawyer)
          @law_case = @lawyer.init_case(1234)
        end

        it "should return true for full_access" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :full_access)
          @permission_collection.can_write?(@law_case).should be_true
        end

        it "should return true for read_only" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :read_only)
          @permission_collection.can_write?(@law_case).should be_false
        end

        it "should return false for no_access" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :no_access)
          @permission_collection.can_write?(@law_case).should be_false
        end
      end

      context "with a lawyer cases permission but a not access case permission" do

        before(:each) do
          @lawyer = build(:lawyer)
          @law_case = @lawyer.init_case(1234)
          @permission_collection.add_case_permission(@law_case, :no_access)
        end

        it "should return false if the permission is full_access and the lawyer onws the case" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :full_access)
          @permission_collection.can_write?(@law_case).should be_false
        end

        it "should return false if the permission is read_only and the lawyer onws the case" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :read_only)
          @permission_collection.can_write?(@law_case).should be_false
        end

        it "should return false if the permission is no_access" do
          @permission_collection.add_lawyer_cases_permission(@lawyer, :no_access)
          @permission_collection.can_read?(@law_case).should be_false
        end
      end
    end
  end

  describe "#remove_case_permission" do
    before(:each) do
      @lawyer = build(:lawyer)
      @permission_collection.add_case_permission(@law_case, :read_only)
    end

    it "should add a case permission" do
      @permission_collection.remove_case_permission(@law_case)
      @permission_collection.case_permissions.count.should == 0
    end
  end

  describe "#remove_lawyer_cases_permission" do
    before(:each) do
      @permission_collection.add_lawyer_cases_permission(@lawyer, :read_only)
    end

    it "should add a case permission" do
      @permission_collection.remove_lawyer_cases_permission(@lawyer)
      @permission_collection.lawyer_cases_permissions.count.should == 0
    end
  end

  describe "#all_redeable_cases" do
    before(:each) do
      @lawyer = build(:lawyer)
      @law_case1 = build(:law_case, number: 1234)
      @law_case2 = build(:law_case, number: 2345)
      @law_case3 = build(:law_case, number: 3456)
      @law_case4 = @lawyer.init_case(4567)
      @law_case5 = @lawyer.init_case(5678)
      @permission_collection.add_case_permission(@law_case1, :read_only)
      @permission_collection.add_case_permission(@law_case2, :read_only)
      @permission_collection.add_case_permission(@law_case3, :read_only)
      @permission_collection.add_lawyer_cases_permission(@lawyer, :read_only)
    end

    it "should return all cases that can read" do
      @permission_collection.all_redeable_cases.should =~ [@law_case1, @law_case2, @law_case3, @law_case4,  @law_case5] 
    end
  end
end
