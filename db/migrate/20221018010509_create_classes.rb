class CreateClasses < ActiveRecord::Migration[7.0]
  def change
    create_table :classes do |t|

	  t.string :semester
	  t.string :teacher
	  t.integer :section
	  t.string :course_name

      t.timestamps
    end
  end
end
