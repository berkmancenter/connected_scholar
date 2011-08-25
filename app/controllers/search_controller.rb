class SearchController < ApplicationController
  include LibraryCloudUtil

  def search
    @items = item_search(:keyword, params[:query])

    render :partial=>'search/results', :layout => false, :locals => {:searchresults => @items['docs']}
  end

end
