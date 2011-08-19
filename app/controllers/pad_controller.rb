class PadController < ApplicationController
  before_filter :authenticate_user!
  def read_only
    pad_id = params[:pad_id]
    html = nil
    with_etherpad_url do |url|
      http = HTTPClient.new
      html = http.get_content("#{url}/ro/#{pad_id}")
    end
    render :text => html
  end
  
  def export
    type = params[:type]
    if ["txt", "html"].include?(type)
      pad_id = params[:pad_id]
      output = nil
      with_etherpad_url do |url|
        http = HTTPClient.new
        output = http.get_content("#{url}/p/#{pad_id}/export/#{type}")
      end
      render :text => output
    else
      render :text => "Unsupported type."
    end
  end
end
