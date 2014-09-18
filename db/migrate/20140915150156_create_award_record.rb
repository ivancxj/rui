#encoding: utf-8
# 兑奖记录
class CreateAwardRecord < ActiveRecord::Migration
  def change
    create_table :award_records do |t|
      t.references :user
      t.references :award

      t.string :weixin_name
      t.string :name
      t.string :mobile

      t.timestamps
    end

    add_index :award_records, :user_id
  end
end
