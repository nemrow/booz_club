class SearchPlace < ActiveRecord::Base
  belongs_to :search
  belongs_to :place
end
