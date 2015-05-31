class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :week_number
      t.string :day
      t.string :time
      t.string :lesson_type
      t.string :num_subgroup
      t.string :class_room
    end
  end
end
