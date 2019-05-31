class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email, index: true, uniq: true, null: false
      t.integer :messages_count, default: 0
      t.timestamps
    end
  end
end
