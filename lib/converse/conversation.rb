module Converse
  class Conversation
    attr_reader :current_step

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
  end
end
