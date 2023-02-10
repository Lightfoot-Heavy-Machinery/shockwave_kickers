class AddForeignKeyToStudents < ActiveRecord::Migration[7.0]
  def change
    add_column :students, :teacher, :string
    add_foreign_key :students, :users, column: :teacher, primary_key: :email
  end
end
