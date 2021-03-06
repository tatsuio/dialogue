require "delegate"

module Dialogue
  module MessageDecorators
    class Slack < SimpleDelegator
      attr_reader :original_message

      def initialize(message)
        @original_message = message
        __setobj__ @original_message
      end

      def channel_id
        original_message.channel
      end

      def team_id
        original_message.team || original_message.source_team
      end

      def user_id
        original_message.user
      end
    end
  end
end
