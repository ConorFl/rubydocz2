class CreateRclasses < ActiveRecord::Migration
  def change
    create_table :rclasses do |t|
    	t.string :name
      t.timestamps
    end
  end
end
