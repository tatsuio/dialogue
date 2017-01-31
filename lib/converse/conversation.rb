module Converse
  class Conversation
    include ConversationOptions

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

    def perform
      step = steps.pop
      step.call self unless step.nil?
      Converse.unregister_conversation self if steps.empty?
    end

    def say(statement)
      Converse::Streams::Slack.new(options[:access_token]).puts statement, channel_id, user_id
    end
    alias_method :reply, :say
  end
end
