RSpec.describe Dialogue::ConversationOptions do
  let(:dummy_class) do
    Class.new do
      include Dialogue::ConversationOptions

      def initialize(options)
        guard_options! options

        @options = options.freeze
      end
    end
  end

  context "valid options" do
    it "allows for empty options" do
      expect { dummy_class.new({}) }.to_not raise_error
    end

    it "allows for an access token" do
      expect { dummy_class.new({ access_token: "BLAH" }) }.to_not raise_error
    end

    it "allows for an author id" do
      expect { dummy_class.new({ author_id: "BLAH" }) }.to_not raise_error
    end

    it "allows the options to respond as methods" do
      subject = dummy_class.new({ author_id: "BLAH" })

      expect(subject.author_id).to eq "BLAH"
    end

    it "does not respond to messages that are not options" do
      expect { dummy_class.new({}).blah }.to raise_error NoMethodError
    end
  end

  context "invalid options" do
    it "does not allow for random options" do
      expect { dummy_class.new({ blah: :bleh }) }.to \
        raise_error Dialogue::InvalidOptionsError, "blah is not a valid option"
    end
  end
end
