class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: false do |t|

	  t.string :name
	  t.string :username, unique: true, primary_key: true
	  t.string :password

      t.timestamps
    end
  end
end
