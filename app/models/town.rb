class Town < ActiveRecord::Base
  has_many :users, through: :townsman
  has_many :townsmen, class_name: "Townsman"

  def add_townsman(user, rank, name)
    townsmen.create(user: user, rank: Townsman::RANKS.index(rank), name: name)
  end
end
