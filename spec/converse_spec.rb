RSpec.describe Converse do
  describe ".build" do
    it "runs the DSL with the specified block" do
      block = Proc.new {}

      expect(Converse::DSL).to receive(:run).with(block)

      described_class.build &block
    end
  end
end
