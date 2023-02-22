class AddForeignKeyBack < ActiveRecord::Migration[7.0]
  def change
    # add_foreign_key :courses, :users, column: :teacher, primary_key: :email
  end
end
