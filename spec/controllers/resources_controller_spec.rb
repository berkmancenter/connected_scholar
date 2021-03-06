require 'spec_helper'

describe ResourcesController do
  include Devise::TestHelpers

  let :user do
    u = User.create! :name => "Test User",
                 :email => 'test@test.com',
                 :password => 'password',
                 :password_confirmation => 'password'

    u.approve!
    u.save!
    u
  end

  let :document do
    Document.create! :name => 'foobar'
  end

  before (:each) do
    sign_in :user, user
  end

  def valid_form_attributes
    {:title => 'Some Paper Title', :creators => "", :id_isbn => "", :desc_subject =>""}
  end

  def valid_attributes
    {:title => 'Some Paper Title', :creators => [], :id_isbn => [], :desc_subject =>[]}
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Resource" do
        expect {
          post :create, :resource => valid_form_attributes, :document_id => document.id
        }.to change(Resource, :count).by(1)
      end

      it "assigns a newly created resource as @resource" do
        post :create, :resource => valid_form_attributes, :document_id => document.id
        assigns(:resource).should be_a(Resource)
        assigns(:resource).should be_persisted
      end

      it "redirects to the created resource" do
        post :create, :resource => valid_form_attributes, :document_id => document.id
        response.should redirect_to(view_pad_path(document))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved resource as @resource" do
        # Trigger the behavior that occurs when invalid params are submitted
        Resource.any_instance.stub(:save).and_return(false)
        post :create, :resource => valid_form_attributes, :document_id => document.id
        assigns(:resource).should be_a_new(Resource)
      end

      it "re-renders the '?' template" do
        pending
        Resource.any_instance.stub(:save).and_return(false)
        post :create, :resource => valid_form_attributes, :document_id => document.id
        response.should render_template("documents/show")
      end
    end

    describe "with item id" do
      it "creates a new Resource" do
        JsonUtil.should_receive(:get_json).and_return({'docs' => [{'id' => 'e402b831-935c-4060-9b4c-9079e96c54d6', 'title' => 'Sample Title'}]})
        expect {
          post :create, :item_id => "e402b831-935c-4060-9b4c-9079e96c54d6", :document_id => document.id
        }.to change(Resource, :count).by(1)
      end

      it "assigns a newly created resource as @resource" do
        JsonUtil.should_receive(:get_json).and_return({'docs' => [{'id' => 'e402b831-935c-4060-9b4c-9079e96c54d6', 'title' => 'Sample Title'}]})
        post :create, :item_id => "e402b831-935c-4060-9b4c-9079e96c54d6", :document_id => document.id
        assigns(:resource).should be_a(Resource)
        assigns(:resource).should be_persisted
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested resource" do
      resource = Resource.create! valid_attributes.merge(:document_id => document.id)
      expect {
        delete :destroy, :id => resource.id.to_s, :document_id => document.id
      }.to change(Resource, :count).by(-1)
    end

    it "redirects to the resources list" do
      resource = Resource.create! valid_attributes.merge(:document_id => document.id)
      delete :destroy, :id => resource.id.to_s, :document_id => document.id
      response.should redirect_to(view_pad_path(document))
    end
  end

end
