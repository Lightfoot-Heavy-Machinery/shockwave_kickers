class AddForeignKeysToTables < ActiveRecord::Migration[7.0]
  def change
	  # add_foreign_key :students, :classes, column: :class_id, primary_key: :id
	  # add_foreign_key :classes, :users, column: :teacher, primary_key: :username
  end
end