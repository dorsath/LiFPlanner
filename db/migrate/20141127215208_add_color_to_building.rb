class AddColorToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :color, :string, default: "8ae234"
  end
end
