class AddAttemptsToQrosters < ActiveRecord::Migration[7.0]
  def change
    add_column :qrosters, :attempts, :integer, default:1
  end
end
