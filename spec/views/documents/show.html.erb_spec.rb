require 'spec_helper'

describe "documents/show.html.erb" do
  before(:each) do
    @document = assign(:document, stub_model(Document))
  end

  it "renders attributes in <p>" do
    render
  end
end
