require 'spec_helper'

describe LawCase do
  
  it "should be equal with another law case if both have the same number" do
    law_case1 = build(:law_case, number: 1234)
    law_case2 = build(:law_case, number: 1234)
    law_case1.should == law_case2
  end
end
