class CreateStudentCourse < ActiveRecord::Migration[7.0]
  def change
    create_table :student_courses do |t|
      t.integer :student_id
      t.integer :course_id
      t.string :final_grade
      t.timestamps
    end
  end
end
