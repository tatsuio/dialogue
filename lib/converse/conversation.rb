module Converse
  class Conversation
    attr_reader :intent

    def initialize(intent)
      @intent = intent
    end
  end
end
