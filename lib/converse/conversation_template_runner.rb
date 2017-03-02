module Converse
  class ConversationTemplateRunner
    include ConversationOptions

    attr_reader :message, :options

    def initialize(message, options={})
      guard_options! options

      @message = message
      @options = options.freeze
    end

    def channel_id
      decorated_message.channel_id
    end

    def decorated_message
      @decorated_message ||= MessageDecorators::Slack.new(message)
    end

    def message_from_author?
      user_id == options[:author_id]
    end

    def run(template)
      unless message_from_author?
        if Converse.conversation_registered? user_id, channel_id
          conversation = Converse.find_conversation user_id, channel_id
        else
          conversation = Conversation.new template, decorated_message, options

          Converse.register_conversation conversation
        end

        conversation.perform decorated_message
      end
    end

    def user_id
      decorated_message.user_id
    end
  end
end
