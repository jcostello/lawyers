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
end

