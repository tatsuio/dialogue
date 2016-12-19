module Converse
  module Test
    module SlackClientStubbing
      def stub_chat
        allow_any_instance_of(::Slack::Web::Client).to receive(:chat_postMessage)
      end
    end
  end
end
