module Converse
  class Conversation
    attr_reader :channel_id, :current_step, :user_id

    # TODO: Need the author user id to stop from echoing it's messages
    def initialize(options={}, &block)
      guard_options! options

      @options = options
      @current_step = block
    end

    def ask(question, &block)
      say question
      @current_step = block
    end

    def say(statement, options={})
      # TODO: Make this configurable
      token = options[:access_token]
      Converse::Streams::Slack.new(token).puts statement, channel_id, user_id
    end
    alias_method :reply, :say

    def start(message)
      # TODO: Guard against the message from this bot

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

    def guard_options!(options)
      result = ConversationOptionsValidator.new.validate options
      raise InvalidOptionsError.new(result.error_messages) unless result.success?
    end

    def perform
      current_step.call self unless current_step.nil?
      @current_step = nil
    end
  end
end
