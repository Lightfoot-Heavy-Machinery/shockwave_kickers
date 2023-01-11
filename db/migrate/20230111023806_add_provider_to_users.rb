class AddProviderToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string, default: ""
    add_column :users, :uid, :string, default: ""
  end
end
