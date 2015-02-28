class Place < ActiveRecord::Base
  has_many :search_places
  has_many :searches, through: :search_places
end
