#encoding: utf-8
class CreateAward < ActiveRecord::Migration
  def change
    create_table :awards do |t|
      t.integer :award_type, default: 1
      t.string  :name
      t.string  :img

    end
  end
end
