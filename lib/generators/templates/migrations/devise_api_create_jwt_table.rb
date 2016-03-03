class DeviseApiCreateJwtTable < ActiveRecord::Migration
  def change
    create_table(:jwts) do |t|
      ## Database authenticatable
      t.string :uid, null: false
      t.string :token, null: false, default: ''
      t.string :email, null: true
      t.string :exprire, null: true

      t.timestamps null: false
    end
  end
end
