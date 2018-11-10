class CreateWaffles < ActiveRecord::Migration[5.1]
  def change
    create_table :waffles do |t|

      t.timestamps
    end
  end
end
