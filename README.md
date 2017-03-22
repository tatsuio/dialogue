Dialogue
========

[ ![Codeship Status for tatsuio/dialogue](https://app.codeship.com/projects/9afef670-f132-0134-a265-7e8cdab40218/status?branch=master)](https://app.codeship.com/projects/209305)

## DESCRIPTION

A DSL for defining conversations and workflows in Ruby. The conversations follow those workflows based on incoming messages and their intents.

This currently supports only [Slack](https://slack.com).

### Defining conversations

A conversation can be defined inline or within a `ConversationRouter`.

A conversation wraps the message and is comprised of several handlers. Each `ConversationHandler` defines the intent as well as a callback that get's called when that intent is reached.

#### Defining conversations inline

```ruby
Dialogue::ConversationTemplate.build(:order_shirt) do |conversation|
  conversation.ask("What size do you wear?") do |response, conversation|
    conversation.reply("Gotcha. Size #{response}. Noted.")
    conversation.ask("What color would you like?") do |response, conversation|
      conversation.reply("Great. I have you down for a #{response}.")
      conversation.end("Thank you for your order.")
    end
  end
end.register
```

You can `reply` to the conversation or `ask` the participant a question.

You can move onto a different conversation thread with a `diverge` followed by the name of the conversation.

```
conversation.diverge :end_order
```

You `start` a conversation which will store a `user`, a `channel`, and the conversation id. This is the placeholder for the conversation.

You can `end` a conversation which will clear the conversation from the storage mechanism.

A conversation can `timeout`.

#### Defining conversations within a router

### Starting a conversation

A `message` comes in from somewhere and you can handle that message in a conversation. A `message` has a `user_id` and a `channel_id` along with some text. If the message matches one of the stored conversations (meaning the user id and channel id match), then the conversation is continued where it left off. If the conversation is not found, then a new conversation is started.

```ruby
Dialogue.find_template(:select_size).start message
```

```ruby
Dialogue.handle(message) # Will find a template based on intent of the message
```

This will register the conversation for the user and channel with the factory and activate the conversation.

## TODO:

- [ ] Add DSL to `Dialogue` that allows you to specify templates with a name, a list of intents, and a template
- [ ] Implement `ConversationHandler` that handles a message based on an intent
- [ ] Add pluggable intent handlers (Api.ai, Wit.ai, etc)
- [ ] Implement `ConversationRouter`
- [ ] Add timeouts for conversations
- [ ] Add support for Facebook
- [ ] Add support for persistent conversations (serializable proc)

## RELEASING A NEW GEM

1. Bump the VERSION in `lib/dialogue/version.rb`
1. Commit changes and push to GitHub
1. run `bundle exec rake release`

## LICENSE

Copyright (c) 2016, [Tatsu, Inc.](http://tatsu.io).

This project is licensed under the [MIT License](LICENSE.md).
