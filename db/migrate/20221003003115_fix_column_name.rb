class FixColumnName < ActiveRecord::Migration[7.0]
    def self.up
      rename_column :students, :uni, :uin
    end
  end
