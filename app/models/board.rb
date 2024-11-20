class Board < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :rows, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :columns, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :number_of_mines, presence: true, numericality: { only_integer: true, greater_than: 0 }

  has_many :board_cells, dependent: :destroy
end
