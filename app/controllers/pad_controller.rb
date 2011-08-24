class PadController < ApplicationController
  def read_only
    pad_id = params[:pad_id]
    html = nil
    with_etherpad_url do |url|
      http = HTTPClient.new
      html = http.get_content("#{url}/ro/#{pad_id}")
    end
    render :text => html
  end

  def pad
    @document = Document.where(:name => params[:pad_id], :owner_id => current_user.id).first
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
  
  def timeslider
    render :action => 'timeslider', :layout => false
  end
end
