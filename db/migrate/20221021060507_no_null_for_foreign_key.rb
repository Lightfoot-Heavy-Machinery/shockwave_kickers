class NoNullForForeignKey < ActiveRecord::Migration[7.0]
  def change
    change_column_null :students, :teacher, false
  end
end
