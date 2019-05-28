require_relative 'tile'

class Board
    SUCCESS = [1,2,3,4,5,6,7,8,9]

    def self.grid_with_tiles(board_choice)
        file = File.readlines(board_choice).map(&:chomp)
        grid = file.map { |line| line.split("").map(&:to_i) }

        grid = grid.map do |row|
            row.map do |num|
                if num == 0
                    Tile.new(num)
                else
                    Tile.new(num,true)
                end
            end
        end

        return grid
    end

    attr_accessor :rows
    attr_reader   :size

    def initialize(board_choice = 'puzzles/sudoku1.txt')
        @rows = Board.grid_with_tiles(board_choice)
        @size = @rows.length
    end

    def [](pos)
        row, col = pos
        rows[row][col]
    end

    def []=(pos, value)
        row, col = pos
        rows[row][col].value = value
    end

    def render
        system "clear"

        puts "  #{(0...size).to_a.join(" ").green}"
        self.tiles_to_s.each_with_index { |row, i| puts "#{i.to_s.green} #{row.join(" ")}" }

        puts
    end

    def tiles_to_s
        rows.map { |row| row.map(&:to_s) }
    end

    def tiles_to_i
        rows.map { |row| row.map(&:value) }
    end

    def won?
        self.rows_solved?(tiles_to_i) &&
        self.cols_solved? &&
        self.quadrants_solved?
    end
    
    def rows_solved?(tiles_to_i)
        tiles_to_i.all? { |row| row.sort == SUCCESS }
    end

    def cols_solved?
        swap_row_and_col = Array.new(rows.length) { Array.new }

        tiles_to_i.each do |row|
            row.each_with_index { |tile, i| swap_row_and_col[i] << tile }
        end

        rows_solved?(swap_row_and_col)
    end

    def quadrants_solved?
        quad = []
        grid = tiles_to_i

        until grid.flatten.empty?
            grid.each_index do |i|
                quad << grid[i].pop(3)
                
                if quad.count == 3
                    return false if quad.flatten.sort != SUCCESS
                    quad = []
                end
            end
        end

        return true
    end
end
