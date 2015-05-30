class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.references :advert, index: true

      t.timestamps null: false
    end
    add_foreign_key :pictures, :adverts
  end
end
