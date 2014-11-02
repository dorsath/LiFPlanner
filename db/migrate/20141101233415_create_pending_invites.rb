class CreatePendingInvites < ActiveRecord::Migration
  def change
    create_table :pending_invites do |t|
      t.integer :town_id
      t.integer :user_id

      t.timestamps
    end
  end
end
