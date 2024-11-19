class Board < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :rows, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :columns, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :number_of_mines, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def mines
    stored_mines = self[:mines]
    stored_mines = JSON.parse(stored_mines) if stored_mines.is_a?(String)
    (stored_mines || []).map { |mine| mine.map(&:to_i) }
  end
end
