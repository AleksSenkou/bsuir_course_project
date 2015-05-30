class AddAssotiationToLessons < ActiveRecord::Migration
  def change
    add_reference :lessons, :schedule, index: true, foreign_key: true
  end
end
