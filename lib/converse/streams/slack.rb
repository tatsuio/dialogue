require "slack-ruby-client"

module Converse
  module Streams
    class Slack
      def initialize(access_token=nil)
        @client = ::Slack::Web::Client.new(token: access_token)
      end

      def puts(output, channel_id, user_id, opts={})
        options = { channel: channel_id, as_user: true }
        text = output
        text = text.insert 0, "<@#{user_id}> " if opts[:direct_mention]
        options.merge!(text: text)
        options.merge!(attachments: opts[:attachments]) if opts[:attachments]
        client.chat_postMessage options
      end

      private

      attr_reader :client
    end
  end
end
