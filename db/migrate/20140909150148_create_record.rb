#encoding: utf-8
# 刮卡记录
class CreateRecord < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :user

      t.integer  :award, default: 0

      t.datetime :created_at

    end
  end
end
