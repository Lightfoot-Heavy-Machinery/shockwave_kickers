class AddTeacherToStudentsTags < ActiveRecord::Migration[7.0]
  def change
	add_column :students_tags, :teacher, :string
	add_foreign_key :students_tags, :users, column: :teacher, primary_key: :email
  end
end
