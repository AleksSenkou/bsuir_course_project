class AddTypeToAdverts < ActiveRecord::Migration
  def change
    add_column :adverts, :type, :string
  end
end
