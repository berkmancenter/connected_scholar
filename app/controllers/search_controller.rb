class SearchController < ApplicationController
  include SearchUtil

  def search
    if params[:filter] != ""
      @items = item_search(params[:search_type], params[:query], params[:filter_type], params[:filter])
    else
      @items = item_search(params[:search_type], params[:query])
    end

    respond_to do |format|
      format.html {render :partial=>'search/results', :content_type => "text/html", :layout => false, :locals => {:searchresults => @items['docs']}}
      format.js {render :json => @items['docs']}
    end
  end

end
