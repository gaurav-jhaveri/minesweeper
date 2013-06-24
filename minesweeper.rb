require 'set'

# types of squares
# * - unexplored
# m - unrevealed mine
# M - revealed mine
# F - flagged correctly
# f - flagged incorrectly
# _ - interior
# 1 - fringe square

class Minesweeper
  attr_accessor :board, :game_over

  @@adjacent = [[0,-1], [-1,-1], [-1,0], [-1,1],
                [0,1], [1,1], [1,0], [1,-1]]

  def initialize(size=9, mines=10)
    @game_over = 0
    @board = Array.new

    @mine_locs = rand_n(mines, size**2)
    @mine_locs.map! do |mine_loc|
      [mine_loc / size, mine_loc % size]
    end

    size.times do |i|
      @board << []
      size.times do |j|
        if @mine_locs.include?([i,j])
          symbol = :m
        else
          symbol = :*
        end

        @board.last << symbol
      end
    end
  end

  def play
    until done?
      puts "Do you want to (1) reveal or (2) flag?"
      move = gets.to_i
      puts "Which square? (ex: '1,1')"
      x,y = gets.split(",").map{|coord| coord.to_i}

      case move
      when 1
        reveal(x,y)
      when 2
        flag(x,y)
      end
    end
  end

  def flag(x,y)
    case @board[x][y]
    when :m # correctly flagged
      @board[x][y] = :F
    when :* # incorrectly flagged
      @board[x][y] = :f
    end
  end

  def reveal(x, y, first=true)
    #if mine then end
    if @board[x][y] == :m
      @game_over = -1 if first
      return
    else
      adj_mine_locs = adjacent_mines(x,y)
      if adj_mine_locs.empty?
        @board[x][y] = :_
        @@adjacent.each do |adj_arr|
          # only recurse on unexplored squares
          if @board[x+adj_arr[0]][y+adj_arr[1]] == "*"
            puts "RECURSED"
            reveal(x+adj_arr[0], y+adj_arr[1], false)
          end
        end
      else
        @board[x][y] = adj_mine_locs.length.to_s
      end
    end
    #else recursively reveal that square and all adjacent ones
  end

  def adjacent_mines(x,y)
    adj_mine_locs = []
    @@adjacent.each do |adj_arr|
      i,j = adj_arr

      if @board[x+i][y+j] == :m
        adj_mine_locs << [x+i, y+j]
      end
    end
    adj_mine_locs
  end

  def print_board
    @board.each do |row|
      row.each do |square|
        if done? || square != :m
          disp_sq = square
        elsif square == :m
          disp_sq = :*
        end
        print disp_sq
      end
      print "\n"
    end
  end

  def done?
    0
  end

  private

  def rand_n(n, max)
    randoms = Set.new
    loop do
      randoms << rand(max)
      return randoms.to_a if randoms.size >= n
    end
  end
end

Minesweeper.new.print_board
