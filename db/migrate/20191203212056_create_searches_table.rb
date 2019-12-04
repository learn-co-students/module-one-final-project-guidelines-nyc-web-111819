class CreateSearchesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :searches do |t|
      t.string :user_name
      t.string :train_name
      t.string :train_status
      t.timestamps 
    end
  end
end
