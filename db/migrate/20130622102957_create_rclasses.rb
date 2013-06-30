class CreateRclasses < ActiveRecord::Migration
  def change
    create_table :rclasses do |t|
    	t.text :name
      t.timestamps
    end
  end
end
