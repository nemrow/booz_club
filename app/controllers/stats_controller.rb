class StatsController < ApplicationController
  def index
    @searches = Search.includes(:places, :user, :search_places)
  end
end
