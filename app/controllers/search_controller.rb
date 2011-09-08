class SearchController < ApplicationController
  include SearchUtil

  def search
    filters = []

    (1..3).each do |i|
      if params["filter#{i}"] != ""
        filters << {:filter_type => params["filter#{i}_type"], :filter => params["filter#{i}"]}
      end
    end

    @items = item_search(params[:search_type], params[:query], filters)

    respond_to do |format|
      format.html {render :partial=>'search/results', :content_type => "text/html", :layout => false, :locals => {:searchresults => @items['docs']}}
      format.js {render :json => @items['docs']}
    end
  end

end
