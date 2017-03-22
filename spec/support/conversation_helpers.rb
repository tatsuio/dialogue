module Dialogue
  module Test
    module ConversationHelpers
      def answer_all_questions(*answers)
        conversation = Dialogue.conversations.first

        answers.each do |answer|
          conversation.continue answer
        end unless conversation.nil?
      end
    end
  end
end
