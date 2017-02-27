module Converse
  module Test
    module SlackClientStubbing
      def stubbed_conversations
        @stubbed_conversations ||= []
      end

      def stub_slack_chat
        allow_any_instance_of(::Slack::Web::Client).to \
          receive(:chat_postMessage) do |_client, arguments|
          stubbed_conversations << arguments[:text]
        end
      end
    end
  end
end
