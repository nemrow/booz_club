class StatsController < ApplicationController
  def index
    @searches = Search.includes(:places, :user, :search_places).order("created_at DESC")

    @success_number = 0
    @searches.each do |search|
      @success_number += 1 if SearchPlace.where(search: search, result: SearchPlace::IN_STOCK).count > 0
    end
  end
end
