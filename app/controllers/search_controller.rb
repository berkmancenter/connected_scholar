class SearchController < ApplicationController
  include SearchUtil

  def keyword
    @items = item_search(params[:search_type], params[:query])

    render_items
  end

  def advanced
    filters = []

    (1..3).each do |i|
      if !params["filter#{i}"].nil? && params["filter#{i}"].strip != ""
        filters << {:filter_type => params["filter#{i}_type"], :filter => params["filter#{i}"]}
      end
    end

    @items = item_search(params[:search_type], params[:query], params[:limit], params[:start], params[:sort], filters)

    render_items
  end

  def google
    @items = google_search(params[:query], params[:limit], params[:start])
    render_items
  end

  private

  def render_items
    if @items
      if @items['docs']
        respond_to do |format|
          format.html do
            render :partial=>'search/results',
                   :content_type => "text/html",
                   :layout => false,
                   :locals => {
                       :searchresults => @items['docs'],
                       :limit => @items['limit'].to_i,
                       :start => @items['start'].to_i,
                       :num_found => @items['num_found'].to_i,
                       :sort => @items['sort'],
                       :sortable => @items['sortable'] != false
                   }
          end
          format.js {render :json => @items['docs']}
        end
      else
        Rails.logger.error("Search Error: #{@items.inspect}")
        respond_to do |format|
          format.html {render :text => (@items['errors'] || "There was a problem with the search! ")}
          format.js {render :json => @items}
        end
      end
    else
      Rails.logger.error("Search Error: No response from server")
      respond_to do |format|
        format.html {render :text => "There was a problem with the search!"}
        format.js {render :json => []}
      end
    end
  end

end
