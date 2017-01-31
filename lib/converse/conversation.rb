module Converse
  class Conversation
    attr_reader :channel_id, :steps, :template, :user_id

    def initialize(template=nil, options={})
      guard_options! options

      @steps = []
      @template = template
      @steps << @template.template unless @template.nil?
      @options = options.freeze
    end

    def ask(question, &block)
      say question
      steps << block
    end

    def method_missing(method, *args)
      return options.fetch method if options.key? method
      super
    end

    def perform
      step = steps.pop
      step.call self unless step.nil?
      # TODO: Remove this from the factory if there are no more steps to perform
    end

    def say(statement)
      Converse::Streams::Slack.new(options[:access_token]).puts statement, channel_id, user_id
    end
    alias_method :reply, :say

    def start(message)
      unless message_from_author?(message)
        @channel_id = message.channel
        @user_id = message.user

        unless Converse.conversation_registered?(user_id, channel_id)
          # TODO: Register this conversation in the Template (Runner)
          Converse.register_conversation(self)
        end

        perform
      end

      self
    end
    alias_method :continue, :start

    private

    attr_reader :options

    def guard_options!(options)
      result = ConversationOptionsValidator.new.validate options
      raise InvalidOptionsError.new(result.error_messages) unless result.success?
    end

    def message_from_author?(message)
      message.user == options[:author_id] && (channel_id.nil? || message.channel == channel_id)
    end
  end
end
