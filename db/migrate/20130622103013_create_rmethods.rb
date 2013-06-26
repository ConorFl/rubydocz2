class CreateRmethods < ActiveRecord::Migration
  def change
    create_table :rmethods do |t|
    	t.string :name
    	t.references :rclass
      t.timestamps
    end
  end
end
