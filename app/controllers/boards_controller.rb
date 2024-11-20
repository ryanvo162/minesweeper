class BoardsController < ApplicationController
  def index
    sort_order = params[:sort_order] || 'desc'
    @boards = Board.order(created_at: sort_order)
    @boards = @boards.where("name LIKE ?", "%#{params[:search]}%") if params[:search].present?
    per_page = params[:per_page] || 10
    @boards = @boards.page(params[:page]).per(per_page)
  end

  def show
    @board = Board.find(params[:id])
    start_row = params[:start_row].to_i || 0
    start_column = params[:start_column].to_i || 0
    limit_rows = (params[:limit_rows] || 20).to_i
    limit_columns = (params[:limit_columns] || 20).to_i
    end_row = [start_row + limit_rows - 1, @board.rows - 1].min
    end_column = [start_column + limit_columns - 1].min

    @board_cells = @board.board_cells
                         .where(row: start_row..end_row, column: start_column..end_column)
                         .index_by { |cell| [cell.row, cell.column] }
  end

  def click_cell
    @board = Board.find(params[:id])
    row = params[:row].to_i
    column = params[:column].to_i

    cell = @board.board_cells.find_or_initialize_by(row: row, column: column)
    cell.clicked = true
    cell.save

    mine_found = cell.mine
    render json: { mine_found: mine_found }
  end

  def create
    user = User.find_or_create_by(email: params[:user][:email])
    @board = Board.new(board_params.except(:email))
    @board.user = user
    if @board.save
      generate_mines(@board)
      redirect_to @board
    else
      @boards = Board.order(created_at: :desc).limit(5)
      render 'home/index'
    end
  end

  private

  def board_params
    params.require(:board).permit(:name, :rows, :columns, :number_of_mines)
  end

  def generate_mines(board)
    total_cells = board.rows * board.columns
    mine_positions = (0...total_cells).to_a.sample(board.number_of_mines)
    board_cells = mine_positions.map do |pos|
      row = pos / board.columns
      column = pos % board.columns
      { board_id: board.id, row: row, column: column, mine: true, created_at: Time.now, updated_at: Time.now }
    end
    BoardCell.insert_all(board_cells)
  end
end
