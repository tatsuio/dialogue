module Converse
  class Factory
    attr_reader :conversations

    def initialize
      @conversations = []
    end

    def register(conversation)
      conversations << conversation
    end
  end
end
