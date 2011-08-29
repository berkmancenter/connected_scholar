require 'spec_helper'

describe SearchController do
  include Devise::TestHelpers

  describe "GET 'search'" do
    it "should be successful" do
      pending
      get 'search'
      response.should be_success
    end
  end

end
