class AddLabelColumn < ActiveRecord::Migration
  def up
  	add_column :rmethods, :label, :string
  end

  def down
  	remove_column :rmethods, :label
  end
end
