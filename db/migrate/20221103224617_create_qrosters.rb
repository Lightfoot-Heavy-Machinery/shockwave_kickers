class CreateQrosters < ActiveRecord::Migration[7.0]
  def change
    create_table :qrosters do |t|
      t.integer :quiz_id
      t.integer :student_id
      t.boolean :correct_resp

      t.timestamps
    end
  end
end
