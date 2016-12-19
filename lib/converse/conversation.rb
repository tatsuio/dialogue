module Converse
  class Conversation
    attr_reader :channel_id, :current_step, :user_id

    def initialize(&block)
      @current_step = block
    end

    def ask(question, &block)
      say question
      @current_step = block
    end

    def say(statement)
      # TODO: Make this configurable
      Converse::Streams::Slack.new.puts statement
    end
    alias_method :reply, :say

    def start(message)
      unless Converse.conversation_registered? self
        # TODO: Wrap the message in a Slack decorator
        @channel_id = message.channel
        @user_id = message.user

        Converse.register_conversation self
      end

      perform

      self
    end
    alias_method :continue, :start

    private

    def perform
      current_step.call unless current_step.nil?
      @current_step = nil
    end
  end
end
