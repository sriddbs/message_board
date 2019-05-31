class CreateMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.string :slug, null: false, index: true
      t.text :description, null: false
      t.references :user, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
