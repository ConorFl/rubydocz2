class CreateRmethods < ActiveRecord::Migration
  def change
    create_table :rmethods do |t|
    	t.text :name
    	t.references :rclass
      t.timestamps
    end
  end
end
