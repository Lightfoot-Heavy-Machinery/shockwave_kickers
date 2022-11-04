class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.integer :course_id
      t.integer :correct
      t.integer :incorrect
      t.float :score
      t.integer :longest_streak

      t.timestamps
    end
  end
end
