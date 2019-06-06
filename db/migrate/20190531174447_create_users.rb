class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, index: true, uniq: true, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :role, default: 0
      t.integer :messages_count, default: 0
      t.timestamps
    end
  end
end
