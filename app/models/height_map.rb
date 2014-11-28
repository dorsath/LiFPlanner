class HeightMap < ActiveRecord::Base
  belongs_to :town
  serialize :area
end
