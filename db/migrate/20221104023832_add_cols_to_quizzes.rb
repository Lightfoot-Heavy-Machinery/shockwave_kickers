class AddColsToQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :active_streak, :boolean, default:false
    add_column :quizzes, :current_streak, :integer, default:0
    add_column :quizzes, :validate_id, :integer, default:nil
  end
end
