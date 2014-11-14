class Building < ActiveRecord::Base
  belongs_to :town
  belongs_to :created_by, foreign_key: "created_by_id", class_name: "Townsman"
  serialize :area
end
