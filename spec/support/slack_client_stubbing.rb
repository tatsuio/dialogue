module Dialogue
  module Test
    module SlackClientStubbing
      def stubbed_conversations
        @stubbed_conversations ||= []
      end

      def stub_slack_chat(record=false)
        allow_any_instance_of(::Slack::Web::Client).to \
          receive(:chat_postMessage) do |_client, arguments|
          stubbed_conversations << arguments[:text] if record
        end
      end
    end
  end
end
