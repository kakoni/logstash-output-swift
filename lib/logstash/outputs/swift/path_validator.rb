# encoding: utf-8
module LogStash
  module Outputs
    class Swift
      class PathValidator
        INVALID_CHARACTERS = "\^`><"

        def self.valid?(name)
          name.match(matches_re).nil?
        end

        def self.matches_re
          /[#{Regexp.escape(INVALID_CHARACTERS)}]/
        end
      end
    end
  end
end
