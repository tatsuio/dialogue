require "singleton"

module Converse
  class Factory
    include Singleton

    attr_reader :conversations

    def initialize
      @conversations = []
    end

    def register(conversation)
      conversations << conversation
    end
  end
end
