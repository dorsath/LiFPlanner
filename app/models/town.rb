class Town < ActiveRecord::Base
  has_many :users, through: :townsman
  has_many :townsmen, class_name: "Townsman"
  has_one :todo_list
  has_many :buildings

  def add_townsman(user, rank, name)
    townsmen.create(user: user, rank: Townsman::RANKS.index(rank), name: name)
  end

  def founder?(user)
    townsmen.find_by_user_id(user.id).named_rank == :founder
  end
end
