class AddTeacherToTags < ActiveRecord::Migration[7.0]
  def change
	add_column :tags, :teacher, :string
	add_foreign_key :tags, :users, column: :teacher, primary_key: :email
  end
end
