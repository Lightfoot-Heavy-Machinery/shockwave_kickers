class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :firstname
      t.string :lastname
      t.integer :uin
      t.string :email
      t.string :classification
      t.string :major
      t.text :notes

      t.timestamps
    end
  end
end
