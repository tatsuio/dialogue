module Converse
  module MessageDecorators
    class Slack
      attr_reader :original_message

      def initialize(message)
        @original_message = message
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
