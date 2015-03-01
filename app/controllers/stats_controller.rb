class StatsController < ApplicationController
  def index
    @searches = Search.includes(:places, :user, :search_places).order("created_at DESC")
    @total_calls = SearchPlace.count

    total_responses = SearchPlace.where("result = ? or result = ?", "in stock", "not in stock").count
    total_hangups = SearchPlace.where("result != ?", "no answer").count
    total_answers = total_responses + total_hangups

    in_stock = SearchPlace.where("result = ?", "in stock").count
    not_in_stock = SearchPlace.where("result = ?", "not in stock").count

    @stats = {
      response_rates: {
        total_hangups: ((total_hangups.to_f / total_answers) * 100).round().to_i,
        total_responses: ((total_responses.to_f / total_answers) * 100).round().to_i,
      },
      stock: {
        in_stock: ((in_stock.to_f / total_responses) * 100).round().to_i,
        not_in_stock: ((not_in_stock.to_f / total_responses) * 100).round().to_i
      },
      search_success: {
        fail: (((Search.count - search_success_number(@searches).to_f) / Search.count) * 100).round().to_i,
        success: ((search_success_number(@searches).to_f / Search.count) * 100).round().to_i
      }
    }
  end

  private

  def search_success_number(searches)
    @success_number ||= begin
      success_number = 0
      searches.each do |search|
        success_number += 1 if SearchPlace.where(search: search, result: SearchPlace::IN_STOCK).count > 0
      end
      success_number
    end
  end
end
