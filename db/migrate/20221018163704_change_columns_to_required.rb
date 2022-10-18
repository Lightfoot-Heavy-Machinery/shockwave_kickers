class ChangeColumnsToRequired < ActiveRecord::Migration[7.0]
  def change
	  change_column_null :users, :password, false
	  change_column_null :users, :name, false


	  change_column_null :courses, :semester, false
	  change_column_null :courses, :teacher, false
	  change_column_null :courses, :section, false
	  change_column_null :courses, :course_name, false


	  change_column_null :students, :firstname, false
	  change_column_null :students, :lastname, false
	  change_column_null :students, :uin, false
	  change_column_null :students, :class_id, false
	  change_column_null :students, :email, false
	  change_column_null :students, :classification, false
	  change_column_null :students, :major, false
  end
end
