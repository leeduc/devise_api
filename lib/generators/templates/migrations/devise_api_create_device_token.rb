class DeviseApiCreateDeviceToken < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|
      t.text :token, null: false
      t.string :device, limit: 3, null: false, default: 0
      t.integer :user_id, null: false
    end
  end
end
