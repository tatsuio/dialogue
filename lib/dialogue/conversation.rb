require "dialogue/storable"

module Dialogue
  class Conversation
    include ConversationOptions
    include Storable

    attr_accessor :channel_id, :team_id, :user_id
    attr_reader :message, :steps, :templates

    def initialize(template=nil, message=nil, options={})
      guard_options! options

      @templates = []
      @steps = []

      unless template.nil?
        @templates = [template]
        @steps << template.template
      end

      @message = message
      unless @message.nil?
        @channel_id = message.channel_id
        @team_id = message.team_id
        @user_id = message.user_id
      end

      @data = options.delete(:data)
      @options = options.freeze
    end

    def ask(question, opts={}, &block)
      say question, opts
      steps << block
    end

    def diverge(template_name)
      template = Dialogue.find_template template_name
      unless template.nil?
        templates << template
        steps << template.template
        perform
      end
    end

    def end(statement=nil)
      say statement unless statement.nil?
      Dialogue.unregister_conversation self
    end

    def perform(*args)
      step = steps.pop
      step.call self, *args unless step.nil?
      Dialogue.unregister_conversation self if steps.empty?
    end
    alias_method :continue, :perform

    def say(statement, opts={})
      ensure_registration
      Dialogue::Streams::Slack.new(options[:access_token])
        .puts statement, channel_id, user_id, opts
    end
    alias_method :reply, :say

    private

    def ensure_registration
      # The conversation can be unregistered from a diverge, so let's ensure it
      # is registered
      if !Dialogue.conversation_registered? user_id, channel_id
        Dialogue.register_conversation self
      end
    end
  end
end
