require "converse/conversation_template"
require "converse/dsl"
require "converse/factory"

module Converse
  class << self
    def build(&block)
      DSL.run block
    end

    def conversations
      factory.conversations
    end

    def factory
      @factory ||= Factory.new
    end

    def register_conversation(conversation)
      factory.register(conversation)
    end
  end
end
