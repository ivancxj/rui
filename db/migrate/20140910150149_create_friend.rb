#encoding: utf-8
class CreateFriend < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.references :user
      t.integer :friend_id

      t.datetime :created_at
    end

    add_index :friends, :user_id
  end
end
