class DefaultValueForFinalGrade < ActiveRecord::Migration[7.0]
  def change
    change_column :students, :final_grade, :string, :default => ""
  end
end
