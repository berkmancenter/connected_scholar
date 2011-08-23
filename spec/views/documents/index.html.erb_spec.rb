require 'spec_helper'

describe "documents/index.html.erb" do
  before(:each) do
    assign(:documents, [
      stub_model(Document),
      stub_model(Document)
    ])
  end

  it "renders a list of documents" do
    render
  end
end
