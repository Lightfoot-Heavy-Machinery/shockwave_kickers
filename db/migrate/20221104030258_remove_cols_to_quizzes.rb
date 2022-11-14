class RemoveColsToQuizzes < ActiveRecord::Migration[7.0]
  def change
    remove_column :quizzes, :active_streak
  end
end
