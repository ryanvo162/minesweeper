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
  end

  def click_cell
    @board = Board.find(params[:id])
    clicked_cells = @board.clicked_cells || []
    row = params[:row].to_i
    column = params[:column].to_i
    clicked_cells << [row, column]
    @board.clicked_cells = clicked_cells
    @board.save
    redirect_to board_path(@board, start_row: params[:start_row], start_column: params[:start_column], limit_rows: params[:limit_rows], limit_columns: params[:limit_columns])
  end

  def create
    user = User.find_or_create_by(email: params[:user][:email])
    @board = Board.new(board_params.except(:email))
    @board.user = user
    generate_mines(@board)
    if @board.save
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
    board.mines = []
    positions = Set.new

    while positions.size < board.number_of_mines
      row = rand(board.rows)
      column = rand(board.columns)
      positions.add([row, column])
    end

    board.mines = positions.to_a
  end
end
