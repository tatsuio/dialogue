require "converse/conversation_options"
require "converse/conversation_template"
require "converse/conversation_template_runner"
require "converse/conversation"
require "converse/conversation_handler"
require "converse/conversation_options_validator"
require "converse/invalid_options_error"
require "converse/dsl"
require "converse/factory"
require "converse/message_decorators"
require "converse/streams"
require "converse/template_already_registered_error"
require "converse/template_factory"
require "converse/version"

module Converse
  class << self
    def build(&block)
      DSL.run block
    end

    def clear_conversations
      factory.conversations.clear
    end

    def conversation_registered?(user_id, channel_id)
      factory.registered? user_id, channel_id
    end

    def conversations
      factory.conversations
    end

    def find_conversation(user_id, channel_id)
      factory.find user_id, channel_id
    end

    def register_conversation(conversation)
      factory.register(conversation)
    end

    def unregister_conversation(conversation)
      factory.unregister(conversation)
    end

    private

    def factory
      Factory.instance
    end
  end
end
