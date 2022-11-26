class RemoveStudentCols < ActiveRecord::Migration[7.0]
  def change
    remove_column :students, :final_grade
    remove_column :students, :course_id
  end
end
