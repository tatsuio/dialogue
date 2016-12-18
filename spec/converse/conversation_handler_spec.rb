RSpec.describe Converse::ConversationHandler do
  describe "#can_handle?" do
    xit "returns true if the intent of the message was found"
    xit "returns false if the intent of the message was not found"
  end

  describe "#handle!" do
    xit "returns false if the message cannot be handled"
  end

  # The runner
  # Looks at the DSL
  # Compile it
  # Creates a queue of conversations
  # Each response pops off the queue and runs it
  # A queue can have child queues which represent subconversations
  # The storage mechanism should be pluggable
  # You should be able to review the conversation as it has happened
end
