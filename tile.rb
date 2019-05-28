require 'colorize'

class Tile
    attr_accessor :value
    attr_reader   :given

    def initialize(value, given = false)
        @value = value
        @given = given
    end

    def to_s
        colored_value = value.to_s.red

        return empty_character if value == 0
        return colored_value   if given
        return value.to_s
    end

    def value=(new_val)
        return alert_invalid_value_UI if given
        
        @value = new_val
    end

    # UI Methods

    def empty_character
        "·"
    end

    def alert_invalid_value_UI
        puts
        print "[Error] ".light_red
        puts  "You cannot change given numbers!".red
        sleep 1
    end
end