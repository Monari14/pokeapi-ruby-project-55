class CreatePokes < ActiveRecord::Migration[8.0]
  def change
    create_table :pokes do |t|
      t.timestamps
    end
  end
end
