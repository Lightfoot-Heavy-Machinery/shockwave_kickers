class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :firstname
      t.string :lastname
      t.integer :uin
	  t.integer :class_id
      t.string :email
      t.string :classification
      t.string :major
	  t.string :final_grade
      t.text :notes
	  t.text :tags
	  t.string :photo

      t.timestamps
    end
  end
end
