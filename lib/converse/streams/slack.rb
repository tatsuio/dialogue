require "slack-ruby-client"

module Converse
  module Streams
    class Slack
      def initialize(access_token=nil)
        @client = ::Slack::Web::Client.new(token: access_token)
      end

      def puts(output, channel_id, user_id)
        options = { channel: channel_id, as_user: true }
        options.merge!(text: "<@#{user_id}> #{output}")
        client.chat_postMessage options
      end

      private

      attr_reader :client
    end
  end
end
