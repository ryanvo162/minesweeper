class AddMinesToBoards < ActiveRecord::Migration[8.0]
  def change
    add_column :boards, :mines, :text
  end
end
