module Converse
  class Conversation
    attr_reader :message

    def initialize(message)
      @message = message
    end

    def handle!
      ConversationHandler.handle!(message)
    end
  end
end
