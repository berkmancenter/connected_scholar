class SearchController < ApplicationController
  include SearchUtil

  def search
    filters = []

    (1..3).each do |i|
      if params["filter#{i}"] != "" && !params["filter#{i}"].nil?
        filters << {:filter_type => params["filter#{i}_type"], :filter => params["filter#{i}"]}
      end
    end

    @items = item_search(params[:search_type], params[:query], filters)

    if @items
      if @items['docs']
        respond_to do |format|
          format.html {render :partial=>'search/results', :content_type => "text/html", :layout => false, :locals => {:searchresults => @items['docs']}}
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
