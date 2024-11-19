class HomeController < ApplicationController
  def index
    @boards = Board.order(created_at: :desc).limit(5)
    @board = Board.new
  end
end
