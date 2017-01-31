require "converse/conversation_factory"
require "converse/conversation_options"
require "converse/conversation_template"
require "converse/conversation_template_runner"
require "converse/conversation"
require "converse/conversation_handler"
require "converse/conversation_options_validator"
require "converse/invalid_options_error"
require "converse/dsl"
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
      conversation_factory.conversations.clear
    end

    def clear_templates
      template_factory.templates.clear
    end

    def conversation_registered?(user_id, channel_id)
      conversation_factory.registered? user_id, channel_id
    end

    def conversations
      conversation_factory.conversations
    end

    def find_conversation(user_id, channel_id)
      conversation_factory.find user_id, channel_id
    end

    def find_template(name)
      template_factory.find name
    end

    def register_conversation(conversation)
      conversation_factory.register conversation
    end

    def register_template(template)
      template_factory.register template
    end

    def templates
      template_factory.templates
    end

    def template_registered?(name)
      template_factory.registered? name
    end

    def unregister_conversation(conversation)
      conversation_factory.unregister(conversation)
    end

    private

    def conversation_factory
      ConversationFactory.instance
    end

    def template_factory
      TemplateFactory.instance
    end
  end
end
