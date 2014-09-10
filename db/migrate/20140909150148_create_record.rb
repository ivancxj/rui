#encoding: utf-8
class CreateRecord < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :user
      t.references :award

      t.datetime :created_at

    end
  end
end
