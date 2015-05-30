class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :teacher
      t.string :subject
      t.string :weeks
    end
  end
end
