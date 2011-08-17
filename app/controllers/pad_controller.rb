class PadController < ApplicationController
  def index
    
  end
  
  def pad
    
  end
  
  def read_only
    @pad_id = params[:id]
    html = nil
    with_etherpad_url do |url|
      http = HTTPClient.new
      html = http.get_content("#{url}/ro/#{@pad_id}")
    end
    render :text => html, :content_type => 'text/html'
  end
end
