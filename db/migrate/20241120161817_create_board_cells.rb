class CreateBoardCells < ActiveRecord::Migration[8.0]
  def change
    create_table :board_cells do |t|
      t.references :board, null: false, foreign_key: true
      t.integer :row
      t.integer :column
      t.boolean :mine
      t.boolean :clicked

      t.timestamps
    end
  end
end
