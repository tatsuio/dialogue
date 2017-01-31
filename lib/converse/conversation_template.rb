module Converse
  class ConversationTemplate
    attr_reader :name, :template

    def initialize(name=nil, &block)
      @name = name
      @template = block
    end

    def self.build(name=nil, &block)
      # TODO: Check for a unique name within the factory
      ConversationTemplate.new name, &block
    end

    def start(message, options={})
      # TODO: A runner should run this

      decorated_message = MessageDecorators::Slack.new(message)

      if Converse.conversation_registered? decorated_message.user_id, decorated_message.channel_id
        Converse.find_conversation(decorated_message.user_id, decorated_message.channel_id)
          .continue decorated_message
      else
        Conversation.new(self, options).start(decorated_message)
      end
    end
  end
end
