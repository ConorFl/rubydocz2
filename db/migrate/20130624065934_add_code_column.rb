class AddCodeColumn < ActiveRecord::Migration
  def up
  	add_column :rmethods, :code, :string
  end

  def down
  	remove_column :rmethods, :code
  end
end

