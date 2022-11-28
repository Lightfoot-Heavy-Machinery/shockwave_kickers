class DefaultValueForFinalGradeStudentCourse < ActiveRecord::Migration[7.0]
  def change
    change_column :student_courses, :final_grade, :string, :default => ""
  end
end
