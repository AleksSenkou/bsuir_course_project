class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :teacher
      t.string :subject
      t.string :week_number
      t.string :day
      t.string :time
      t.string :lesson_type
      t.string :class_room
      t.string :num_subgroup
    end
  end
end
