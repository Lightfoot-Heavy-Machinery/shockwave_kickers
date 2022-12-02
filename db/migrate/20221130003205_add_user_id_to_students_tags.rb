class AddUserIdToStudentsTags < ActiveRecord::Migration[7.0]
  def change
    add_column :students_tags, :user_id, :integer
  end
end
