class AddRefToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :lesson, index: true, foreign_key: true
  end
end
