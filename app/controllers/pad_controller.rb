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

  def view_pad
    @document = Document.find(params[:document_id])
    redirect_to "/p/#{@document.pad_id}?document_id=#{@document.id}"
  end

  def pad
    @document = Document.find(params[:document_id]) if params[:document_id]
    if @document && @document.can_be_viewed_by(current_user)
      valid_until = VALID_UNTIL_DAYS.days.from_now
      @session_id = create_etherpad_session(current_user, @document, valid_until.to_time.to_i)
      cookies[:sessionID] = {:value => @session_id, :expires => valid_until }
      create_group_pad(@document)

      unless is_pad_password_protected(@document)
        # TODO use a unique password for each pad, and store in the DB
        #set_pad_password(@document, 'pass0wrd')
      end
      
      render :action => 'pad'
    else
      redirect_to documents_path
    end
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.warn e
      redirect_to documents_path
  end
  
  def export
    type = params[:type]
    if ["txt", "html"].include?(type)
      pad_id = params[:pad_id]
      output = nil
      with_etherpad_url do |url|
        http = HTTPClient.new
        export_url = "#{url}/p/#{pad_id}/export/#{type}"
        http.cookie_manager.parse("sessionID=#{cookies[:sessionID]}", URI.parse(export_url))
        output = http.get_content(export_url)
      end
      render :text => output
    else
      render :text => "Unsupported type."
    end
  end
  
  def timeslider
    @document = Document.find(params[:document_id]) if params[:document_id]
    if @document && @document.can_be_viewed_by(current_user)
      render :action => 'timeslider', :layout => false
    else
      redirect_to documents_path
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.warn e
    redirect_to documents_path
  end
end
