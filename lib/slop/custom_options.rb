require 'slop'
# Custom Slop Options for command line arguments parsing
module Slop
  class PlayerOption < ArrayOption
    def call(value)
      super
      # try and parse whatever it is the user typed in
      #  if we can't, throw an exception like tom brady
      #   remember, players format is:
      #   type:name_or_level:marker,[type:name_or_level:marker,...]
      #   it's lacking marker validation
      @value.map! do |p|
        type, name_or_level, marker = p.split(/:/).map(&:to_sym)

        unless [:human, :computer].include?(type)
          raise Slop::Error, "Invalid type of player #{type}"
        end
        if type == :human
          { type: type, name: name_or_level.to_s, marker: marker.to_s }
        else
          unless [:easy, :medium, :hard].include?(name_or_level)
            raise Slop::Error, "Invalid computer level #{name_or_level}"
          end
          { type: type, level: name_or_level, marker: marker.to_s }
        end
      end
    end
  end

  # Maximum value treatment to Integer Option
  class IntmaxOption < IntegerOption
    def call(value)
      super
      raise Slop::Error, "Maximum value of #{max} exceeded" if value.to_i >= max
      value
    end

    def max
      config.fetch(:max, 3)
    end
  end
end

