require "singleton"

module Converse
  class Factory
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
      conversations << conversation
    end

    def registered?(user_id, channel_id)
      !find(user_id, channel_id).nil?
    end
  end
end
