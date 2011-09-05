class SearchController < ApplicationController
  include SearchUtil

  def search
    @items = item_search(params[:search_type], params[:query])

    respond_to do |format|
      format.html {render :partial=>'search/results', :content_type => "text/html", :layout => false, :locals => {:searchresults => @items['docs']}}
      format.js {render :json => @items['docs']}
    end
  end

end
