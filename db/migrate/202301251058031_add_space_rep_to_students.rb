class AddSpaceRepToStudents < ActiveRecord::Migration[7.0]
    def change
      add_column :students, :last_practice_at, :datetime
      add_column :students, :curr_practice_interval, :string
    end
  end