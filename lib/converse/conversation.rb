require "converse/storable"

module Converse
  class Conversation
    include ConversationOptions
    include Storable

    attr_accessor :channel_id, :team_id, :user_id
    attr_reader :steps, :template

    def initialize(template=nil, options={})
      guard_options! options

      @steps = []
      @template = template
      @steps << @template.template unless @template.nil?
      @options = options.freeze
    end

    def ask(question, opts={}, &block)
      say question, opts
      steps << block
    end

    def end(statement=nil)
      say statement unless statement.nil?
      Converse.unregister_conversation self
    end

    def perform(*args)
      step = steps.pop
      step.call self, *args unless step.nil?
      Converse.unregister_conversation self if steps.empty?
    end
    alias_method :continue, :perform

    def say(statement, opts={})
      Converse::Streams::Slack.new(options[:access_token])
        .puts statement, channel_id, user_id, opts
    end
    alias_method :reply, :say
  end
end
