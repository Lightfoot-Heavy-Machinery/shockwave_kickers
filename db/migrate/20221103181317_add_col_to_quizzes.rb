class AddColToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :completed, :boolean, default:false
  end
end
