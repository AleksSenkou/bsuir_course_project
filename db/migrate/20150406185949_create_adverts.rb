class CreateAdverts < ActiveRecord::Migration
  def change
    create_table :adverts do |t|
      t.references :user, index: true
      t.string :name
      t.string :description
      t.decimal :price

      t.timestamps null: false
    end
    add_foreign_key :adverts, :users
  end
end
