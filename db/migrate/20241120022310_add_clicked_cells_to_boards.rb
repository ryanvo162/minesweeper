class AddClickedCellsToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :clicked_cells, :text
  end
end
