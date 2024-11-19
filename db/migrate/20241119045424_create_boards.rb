class CreateBoards < ActiveRecord::Migration[8.0]
  def change
    create_table :boards do |t|
      t.string :name
      t.integer :rows
      t.integer :columns
      t.integer :number_of_mines
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
