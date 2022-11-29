class ChangeTagNameToNotNull < ActiveRecord::Migration[7.0]
  def change
	change_column_null :tags, :tag_name, false
  end
end
