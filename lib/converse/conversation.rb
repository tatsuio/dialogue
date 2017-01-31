module Converse
  class Conversation
    attr_accessor :channel_id, :user_id
    attr_reader :steps, :template

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

    private

    attr_reader :options

    def guard_options!(options)
      result = ConversationOptionsValidator.new.validate options
      raise InvalidOptionsError.new(result.error_messages) unless result.success?
    end
  end
end
