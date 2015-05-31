class AddLessonRefToOptions < ActiveRecord::Migration
  def change
    add_reference :options, :lesson, index: true, foreign_key: true
  end
end
