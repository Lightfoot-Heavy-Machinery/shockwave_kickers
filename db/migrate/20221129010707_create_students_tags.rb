class CreateStudentsTags < ActiveRecord::Migration[7.0]
  def change
    create_table :students_tags do |t|
	  t.integer :student_id
	  t.integer :tag_id
      t.timestamps
    end
  end
end
