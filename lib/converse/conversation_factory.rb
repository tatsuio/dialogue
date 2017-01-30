require "eventmachine"
require "singleton"

module Converse
  class ConversationFactory
    include Singleton

    @factory_thread = nil
    @status = :dormant

    attr_accessor :conversations

    class << self
      attr_reader :status

      def conversations
        instance.conversations
      end

      def dormant?
        status == :dormant
      end

      def running?
        status == :running
      end

      def shutdown
        unless dormant?
          Thread.kill(@factory_thread)
          @status = :dormant
        end
        conversations.clear
        @factory_thread
      end

      def startup
        unless running?
          @status = :running
          factory_thread do
            instance.start
          end
        end
        factory_thread
      end

      def factory_thread(&block)
        return @factory_thread unless @factory_thread.nil?
        @factory_thread = Thread.new &block
        @factory_thread.abort_on_exception = true
        @factory_thread
      end
    end

    def initialize
      @conversations = []
    end

    def start
      EM.run {}
    end
  end
end
