class AddSignupWithProviderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :signup_with_provider, :boolean, default: false
  end
end
