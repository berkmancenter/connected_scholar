class SearchController < ApplicationController
  include LibraryCloudUtil

  def search
    @items = item_search(:keyword, params[:query])

    respond_to do |format|
      format.html {render :partial=>'search/results', :content_type => "text/html", :layout => false, :locals => {:searchresults => @items['docs']}}
      format.js {render :json => @items['docs']}
    end
  end

end
