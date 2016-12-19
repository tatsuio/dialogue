require "singleton"

module Converse
  class Factory
    include Singleton

    attr_reader :conversations

    def initialize
      @conversations = []
    end

    def find(conversation)
      conversations.find do |c|
        c.channel_id == conversation.channel_id &&
          c.user_id == conversation.user_id
      end if conversation.channel_id.nil? && conversation.user_id.nil?
    end

    def register(conversation)
      conversations << conversation
    end

    def registered?(conversation)
      !find(conversation).nil?
    end
  end
end
