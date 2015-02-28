class Search < ActiveRecord::Base
  belongs_to :user
  has_many :search_places
  has_many :places, through: :search_places
end
