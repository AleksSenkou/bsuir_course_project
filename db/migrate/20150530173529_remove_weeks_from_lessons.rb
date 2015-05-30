class RemoveWeeksFromLessons < ActiveRecord::Migration
  def change
    remove_column :lessons, :weeks
  end
end
