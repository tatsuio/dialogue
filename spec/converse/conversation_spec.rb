RSpec.describe Converse::Conversation do
  include Converse::Test::SlackClientStubbing

  describe "#initialize" do
    let(:proc) { Proc.new {} }
    let(:template) { Converse::ConversationTemplate.new &proc }
    subject { described_class.new template }

    it "is initialized with a template" do
      expect(subject.template).to eq template
    end

    it "sets the current step to the template" do
      expect(subject.steps.first).to eq proc
    end

    context "valid options" do
      it "allows for empty options" do
        expect { described_class.new(template, {}) }.to_not raise_error
      end

      it "allows for an access token" do
        expect { described_class.new(template, { access_token: "BLAH" }) }.to_not raise_error
      end

      it "allows for an author id" do
        expect { described_class.new(template, { author_id: "BLAH" }) }.to_not raise_error
      end

      it "allows the options to respond as methods on the conversation" do
        subject = described_class.new(template, { author_id: "BLAH" })

        expect(subject.author_id).to eq "BLAH"
      end

      it "does not respond to messages that are not options" do
        expect { subject.blah }.to raise_error NoMethodError
      end
    end

    context "invalid options" do
      it "does not allow for random options" do
        expect { described_class.new(template, { blah: :bleh }) }.to \
          raise_error Converse::InvalidOptionsError, "blah is not a valid option"
      end
    end
  end

  describe "#ask" do
    let(:channel_id) { nil }
    let(:user_id) { nil }

    before { stub_slack_chat }

    it "sets the current step to be the current block" do
      proc = Proc.new { }

      subject.ask("Are you ok?", &proc)

      expect(subject.steps.last).to eq proc
    end

    it "streams the message to slack by default" do
      question = "Are you ok?"

      expect_any_instance_of(Converse::Streams::Slack).to \
        receive(:puts).with(question, channel_id, user_id)

      subject.ask question
    end
  end

  describe "say" do
    let(:channel_id) { nil }
    let(:user_id) { nil }

    before { stub_slack_chat }

    it "streams the message" do
      statement = "Hello world"

      expect_any_instance_of(Converse::Streams::Slack).to \
        receive(:puts).with(statement, channel_id, user_id)

      subject.say statement
    end
  end

  describe "#start" do
    let(:channel_id) { "C12345" }
    let(:message) { double(:message, user: user_id, channel: channel_id) }
    let(:proc) { Proc.new {} }
    let(:template) { Converse::ConversationTemplate.new &proc }
    let(:user_id) { "U12345" }

    before { Converse.clear_conversations }

    it "sets the user and channel" do
      subject.start message

      expect(subject.channel_id).to eq channel_id
      expect(subject.user_id).to eq user_id
    end

    it "adds the conversation to the factory" do
      subject.start message

      expect(Converse.conversations.count).to eq 1
      expect(Converse.conversations.last).to eq subject
    end

    it "performs the current step" do
      ran = false
      template = Converse::ConversationTemplate.new { ran = true }
      subject = described_class.new template

      subject.start message

      expect(ran).to eq true
    end

    it "passes the conversation when the current step is performed" do
      conversation = nil
      template = Converse::ConversationTemplate.new { |c| conversation = c }
      subject = described_class.new template

      subject.start message

      expect(conversation).to eq subject
    end

    context "for a conversation that is already in the factory" do
      it "does not add it again" do
        allow(subject).to \
          receive_messages(user_id: user_id, channel_id: channel_id)
        Converse.register_conversation subject

        subject.start message

        expect(Converse.conversations.count).to eq 1
      end
    end

    context "with a message from the author" do
      subject { described_class.new(template, author_id: "BOT") }

      before { allow(message).to receive(:user).and_return "BOT" }

      it "skips the message" do
        expect(proc).to_not receive(:call)

        subject.start message
      end

      it "does not register the conversation" do
        subject.start message

        expect(Converse.conversations).to be_empty
      end
    end
  end
end
