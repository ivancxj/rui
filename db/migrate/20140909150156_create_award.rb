#encoding: utf-8
# 奖品
class CreateAward < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.integer :award_type, default: 1
      t.string  :name
      t.integer :count
    end

    add_index :awards, :award_type
  end
end
