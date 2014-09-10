#encoding: utf-8
class CreateShare < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.integer :share_user_id
      t.integer :click_user_id

      t.integer :share_time

      t.datetime :created_at

    end
  end
end
