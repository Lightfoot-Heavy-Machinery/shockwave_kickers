class ChangeDataTypeOfUin < ActiveRecord::Migration[7.0]
  def change
	  change_column(:students, :uin, :string)
  end
end
