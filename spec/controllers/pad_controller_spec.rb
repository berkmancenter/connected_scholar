require 'spec_helper'

describe PadController do
  include Devise::TestHelpers

  let :user do
    User.create! :name => "Test User", :email => 'test@test.com', :password => 'password', :password_confirmation => 'password'
  end

  let :document do
    Document.create! :name => 'foobar', :owner => user
  end

  let :pad_id do
    document.pad_id
  end

  let :document_no_owner do
    Document.create! :name => 'barfoo'
  end

  before do
    sign_in :user, user
  end

  describe "view_pad" do
    describe "with a valid document id" do
      it "should redirect to /p/:pad_id" do
        get :view_pad, :document_id => document.id
        response.should redirect_to "/p/#{pad_id}?document_id=#{document.id}"
      end
    end
    describe "with an invalid document id" do
      it "should redirect_to documents path" do
        get :view_pad, :document_id => "g.1234"
        response.should redirect_to documents_path
      end
    end
  end

  describe "pad" do
    describe "with a valid document id" do
      it "should render pad view" do
        get :pad, :pad_id => pad_id, :document_id => document.id
        response.should render_template :pad
      end
      describe "and no owner" do
        it "should redirect to documents path" do
          get :pad, :pad_id => pad_id, :document_id => document_no_owner
          response.should redirect_to documents_path
        end
      end
    end
    describe "with an invalid document id" do
      it "should redirect_to documents path" do
        get :pad, :pad_id => pad_id, :document_id => "g.1234"
        response.should redirect_to documents_path
      end
    end
  end

  describe "export" do
    describe "when type is valid" do
      before do
        controller.should_receive(:with_etherpad_url).and_yield("http://0.0.0.0:9001")
        @http = HTTPClient.new
        HTTPClient.should_receive(:new).and_return(@http)
      end
      describe "when type is html" do
        it "should render html" do
          html = "<html><head></head><body>the document</body></html>"
          @http.should_receive(:get_content).and_return(html)
          get :export, :pad_id => pad_id, :type => 'html'
          response.body.should == html
        end
      end
      describe "when type is txt" do
        it "should render txt" do
          txt = "the document"
          @http.should_receive(:get_content).and_return(txt)
          get :export, :pad_id => pad_id, :type => 'txt'
          response.body.should == txt
        end
      end
    end
    describe "when type is invalid" do
      it "should render 'Unsupported type.'" do
        get :export, :pad_id => pad_id, :type => 'invalid'
        response.body.should == 'Unsupported type.'
      end
    end
  end
  describe "timeslider" do
    describe "with a valid document id" do
      it "should render timeslider" do
        get :timeslider, :pad_id => pad_id, :document_id => document.id
        response.should render_template :timeslider
      end
      describe "and no owner" do
        it "should redirect to documents path" do
          get :timeslider, :pad_id => pad_id, :document_id => document_no_owner
          response.should redirect_to documents_path
        end
      end
    end
    describe "with an invalid document id" do
      it "should redirect_to documents path" do
        get :timeslider, :pad_id => pad_id, :document_id => "g.1234"
        response.should redirect_to documents_path
      end
    end
  end
end