class CreateLinesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :lines do |t|
      t.string :train_name
      t.string :status
      
      t.timestamps
    end
  end
end
