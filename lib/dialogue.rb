require "dialogue/conversation_factory"
require "dialogue/conversation_options"
require "dialogue/conversation_template"
require "dialogue/conversation_template_runner"
require "dialogue/conversation"
require "dialogue/conversation_handler"
require "dialogue/conversation_options_validator"
require "dialogue/invalid_options_error"
require "dialogue/dsl"
require "dialogue/message_decorators"
require "dialogue/storable"
require "dialogue/streams"
require "dialogue/template_already_registered_error"
require "dialogue/template_factory"
require "dialogue/version"

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
