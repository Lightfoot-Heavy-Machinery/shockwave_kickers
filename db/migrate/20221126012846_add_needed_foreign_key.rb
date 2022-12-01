class AddNeededForeignKey < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :student_courses, :courses, column: :course_id
    add_foreign_key :student_courses, :students, column: :student_id
  end
end
