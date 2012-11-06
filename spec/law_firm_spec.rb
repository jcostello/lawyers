require 'spec_helper'

describe LawFirm do

  it "should be equal with another law firm if both have the same name" do
    law_firm1 = LawFirm.new("Law Firm")
    law_firm2 = LawFirm.new("Law Firm")
    law_firm1.should == law_firm2
  end
end
