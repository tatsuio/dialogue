require "singleton"

module Dialogue
  class ConversationFactory
    include Singleton

    attr_reader :conversations

    def initialize
      @conversations = []
    end

    def find(user_id, channel_id)
      conversations.find do |c|
        c.user_id == user_id && c.channel_id == channel_id
      end if !user_id.nil? && !channel_id.nil?
    end

    def register(conversation)
      conversations << conversation unless registered?(conversation.user_id, conversation.channel_id)
    end

    def registered?(user_id, channel_id)
      !find(user_id, channel_id).nil?
    end

    def unregister(conversation)
      conversations.delete conversation
    end
  end
end
