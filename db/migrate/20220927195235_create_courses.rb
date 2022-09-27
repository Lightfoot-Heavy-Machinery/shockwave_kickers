class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :course_number
      t.string :sections
      t.integer :number_of_students

      t.timestamps
    end
  end
end
