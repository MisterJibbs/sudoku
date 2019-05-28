require_relative 'board'
require_relative 'tile'

require 'pry'

class Sudoku
    attr_accessor :board

    def initialize
        @board = Board.new
    end

    def play
        intro_announcement_UI
        choose_a_board

        until game_over?
            board.render
            make_move
        end

        win_announcement_UI
    end

    def game_over?
        board.won?
    end

    def make_move
        prompt_for_pos_UI
        pos = get_pos

        prompt_for_val_UI
        board[pos] = get_value
    end

    def get_pos
        pos = parse_pos(gets)

        until valid_pos?(pos)
            alert_invalid_("position")
            pos = parse_pos(gets) 
        end

        return pos
    end

    def get_value
        value = parse_val(gets)

        until valid_value?(value)
            alert_invalid_("value")
            value = parse_parse(gets) until valid_value?(value)
        end

        return value
    end
    
    def parse_pos(input)
        pos = input.chomp.split(",").map(&:to_i)
    end

    def parse_val(input)
        value = input.chomp.to_i
    end

    def valid_pos?(pos)
        pos.is_a?(Array) && 
        pos.count == 2 && 
        pos_within_grid?(pos)
    end

    def valid_value?(value)
        value.is_a?(Integer) &&
        value.between?(0, 9)
    end

    def choose_a_board
        board_choice = nil

        until board_choice
            prompt_for_board_choice_UI
            board_choice = gets.chomp

            if board_choice == "1"
                board_choice = 'puzzles/sudoku1.txt'
            elsif board_choice == "2"
                board_choice = 'puzzles/sudoku2.txt'
            elsif board_choice == "3"
                board_choice = 'puzzles/sudoku3.txt'
            else
                board_choice = nil
            end
        end

        @board = Board.new(board_choice)
    end
    
    # Beautify Methods

    def pos_within_grid?(pos)
        pos.all? { |n| n.between?(0, board.size - 1) }
    end

    # UI Methods

    def intro_announcement_UI
        system "clear"

        puts
        puts  "\tWelcome to".blue
        puts
        puts  "\t╔════════╗".green
        print "\t║ ".green
        print     "SUDOKU ".light_yellow
        puts             "║".green
        puts  "\t╚════════╝".green

        sleep 1.5

        puts
        puts "   Press enter to start".blue
        puts

        gets
    end

    def win_announcement_UI
        board.render
        puts  "\t╔══════════╗".white
        print "\t║ ".white
        print "Y".light_red
        print "o".red
        print "u".light_yellow
        print " "
        print "W".light_green
        print "i".blue
        print "n".light_blue
        print "!".magenta
        puts " ║".white
        puts  "\t╚══════════╝".light_white
        puts
    end

    def prompt_for_board_choice_UI
        system 'clear'

        puts
        puts  "   Please choose a board:".blue
        puts 
        print "        1".green
        print     "    2".light_blue
        puts      "    3".magenta
        puts
        print "> ".green
    end

    def prompt_for_pos_UI
        puts  "Enter a position (example: 4,7)".blue
        print "> ".green
    end

    def prompt_for_val_UI
        puts
        print  "Enter a value between 1 and 9 ".blue 
        puts   "(enter 0 to reset the value)".light_black
        print  "> ".green
    end

    def alert_invalid_(object)
        puts  "That's not a valid #{object}.".blue
        print "> ".green
    end
end

# game = Sudoku.new

# binding.pry