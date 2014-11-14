class Building < ActiveRecord::Base
  belongs_to :town
  belongs_to :created_by, foreign_key: "created_by_id", class_name: "Townsman"
  serialize :area

  def center
    min_x = area.min_by(&:first)
    max_x = area.max_by(&:first)
    min_y= area.min_by(&:last)
    max_y= area.max_by(&:last)
    width  = max_x[0] - min_x[0] + 1
    height = max_y[1] - min_y[1] + 1
    
    center = [
      min_x[0] + (width / 2),
      min_y[1] + (height / 2)
    ]
  end
end
