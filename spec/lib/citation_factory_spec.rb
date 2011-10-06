require 'spec_helper'

describe CitationFactory do
  describe "#citation_formatter" do
    it "should return MlaCitation for :mla type" do 
      CitationFactory.citation_formatter(:mla).should == MlaCitation
    end
  end
end
