require "converse/conversation_template"
require "converse/conversation"
require "converse/conversation_handler"
require "converse/dsl"
require "converse/factory"
require "converse/streams"

module Converse
  class << self
    def build(&block)
      DSL.run block
    end

    def clear_conversations
      factory.conversations.clear
    end

    def conversation_registered?(conversation)
      factory.registered? conversation
    end

    def conversations
      factory.conversations
    end

    def factory
      Factory.instance
    end

    def register_conversation(conversation)
      factory.register(conversation)
    end
  end
end
