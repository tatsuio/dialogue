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
end
