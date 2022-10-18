class DropSemesters < ActiveRecord::Migration[7.0]
  def change
		drop_table(:semesters, if_exists: true)
  end
end
