Converse
========

## DESCRIPTION

A DSL for defining conversations and workflows in Ruby. The conversations follow those workflows based on incoming messages and their intents.

This currently supports only [Slack](https://slack.com).

### Defining conversations

A conversation can be defined inline or within a `ConversationRouter`.

A conversation wraps the message and is comprised of several handlers. Each `ConversationHandler` defines the intent as well as a callback that get's called when that intent is reached.

#### Defining conversations inline

```
Converse.build do
  name :select_size
  configure { access_token: ENV["SLACK_ACCESS_TOKEN"] }
  conversation do |conversation|
    conversation.ask("What size do you wear?") do |response, conversation|
      conversation.reply("Gotcha. Size #{response.reply}. Noted.")
      conversation.ask("What color would you like?") do |response, conversation|
        conversation.reply("Great.")
        conversation.continue
      end
    end
  end
end
```

You can `reply` to the conversation or `ask` the participant a question.

You can move onto the next flow in the conversation with a `continue` method on a conversation.

You `start` a conversation which will store a `user`, a `channel`, and the conversation id. This is the placeholder for the conversation.

You can `end` a conversation which will clear the conversation from the storage mechanism.

A conversation can `timeout`.

#### Defining conversations within a router

### Starting a conversation

A `message` comes in from somewhere and you can handle that message in a conversation. A `message` has a `user_id` and a `channel_id` along with some text. If the message matches one of the stored conversations (meaning the user id and channel id match), then the conversation is continued where it left off. If the conversation is not found, then a new conversation is started.

```
Converse.find_template(:select_size).start message
```

```
Converse.handle(message) # Will find a template based on intent of the message
```

This will register the conversation for the user and channel with the factory and activate the conversation.

## TODO:

- [ ] Add DSL to `Converse` that allows you to specify templates with a name, a list of intents, and a template
- [ ] Implement `ConversationHandler` that handles a message based on an intent
- [ ] Add pluggable intent handlers (Api.ai, Wit.ai, etc)
- [ ] Implement `ConversationRouter`
- [ ] Add timeouts for conversations
- [ ] Add support for Facebook
- [ ] Add support for persistent conversations (serializable proc)

## LICENSE

Copyright (c) 2016, [Tatsu, Inc.](http://tatsu.io).

This project is licensed under the [MIT License](LICENSE.md).
