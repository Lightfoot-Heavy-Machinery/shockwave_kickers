class RemovefirstNamelastNamefromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :firstName
    remove_column :users, :lastName
  end
end
