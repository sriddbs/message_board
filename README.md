## Storytel Backend Coding Challenge

#### Task

Design and build a RESTful API to serve as the backend for a public message board. It should support the following features:

* A client can create a message in the service

* A client can modify their own messages

* A client can delete their own messages

* A client can view all messages in the service

Use Postgres for storing any data for this service. Consider the appropriate HTTP verbs, headers and responses to use. You are encouraged to apply design patterns for the project that's useful for organizing a larger project and we expect you to include tests to assert the correctness of your solution. Imagine you are starting a project where another team of developers will take over the responsibility of the project you are working on. You are expected to create a good foundation and make sure the transition is smooth. We like you to put all the code inside a public GitHub repository. When you are done, we will review your code together with you. You can expect to be able to reason about the design decisions you’ve taken and guide us through the changes.

*If you wish to show off your fullstack skills, you are welcome to include a UI over the API, but this is completely optional.*

#### Technical Details

This should be a Ruby application and your choice of frameworks/libraries to help implement the web and testing layer. Consider including a Dockerfile if you wish to demonstrate your knowledge of containers.


#### Built with
* Rails 6.0.0.rc1
* Ruby 2.6.2

#### API Details

**NOTE: Assume that the user has authenticated elsewhere and read values from the Authorization header. Using user_id as the authenticated user**

1.Create message API endpoint

```sh
$ curl -X POST -d \
> 'message[user_id]=1&message[title]=abc&message[description]=desc'\
> localhost:3000/api/v1/messages

Response:
{"id":1,"title":"abc","slug":"abc","description":"desc",
"user":{"id":1,"email":"abc@example.com"}

In case of pagination, the response will include the
following in the headers

Link: <http://localhost:3000/api/v1/messages?page=2>; rel="last",
<http://localhost:3000/api/v1/messages?page=2>; rel="next"
Total: 2
```

2.List all messages API endpoint

```sh
$ curl -X GET localhost:3000/api/v1/messages

Response: [{"id":1,"title":"abc","slug":"abc","description":"desc",
"user":{"id":1,"email":"abc@example.com"}}]
```

3.Update message API endpoint

```sh
curl -X PATCH -d \
> 'message[user_id]=1&message[title]=abc&message[description]=desc1' \
> localhost:3000/api/v1/messages/abc

Response: {"id":1,"title":"abc","slug":"abc","description":"desc1",
"user":{"id":1,"email":"abc@example.com"}}
```

4.Delete message API endpoint

```sh
$  curl -X DELETE -d \
> 'message[user_id]=1' localhost:3000/api/v1/messages/abc
```

#### Running the specs
The application uses RSpec framework for testing

```sh
rspec

Message
  validations
    should validate that :title cannot be empty/falsy
    should validate that :slug is case-sensitively unique
    should validate that :description cannot be empty/falsy
    should validate that :user cannot be empty/falsy
  associations
    should belong to user required: true
User
  validations
    should validate that :email cannot be empty/falsy
  associations
    should have many messages
Messages Request spec
  Messages API
    GET /api/v1/messages
      default pagination params
        returns all the messages paginated
      per_page set to 1
        returns 1 message per page
    POST /api/v1/messages
      when params are valid
        creates a message for a given user
      when params are invalid
        when user exists
          returns status 422
        when user does not exists
          returns status 404
    PATCH /api/v1/messages/:id
      when user not found
        fails and returns error message
      when user and message does not belong to each other
        fails to update the message
      when user is present
        updates the messages
      invalid params
        does not updates the message
      DELETE /api/v1/messages/:id
        when message exists
          deletes the message
        when messages does not exist
          returns 404
Messages create service
  Api::V1::Messages::Create
    invalid params
      fails to create a message
    valid params
      creates a message
Messages destroy service
  Api::V1::Messages::Destroy
    destroys the message
Messages update service
  Api::V1::Messages::Update
    invalid params
      fails to update the message
    valid params
      updates the message
Finished in 0.49798 seconds (files took 2.92 seconds to load)
23 examples, 0 failures

```

#### Running the application using Docker

Clone the repo
```sh
$ git clone git@github.com:sriddbs/message_board.git
```

```sh
$ cd message_board
```
Build the image

```sh
$ docker-compose build
```

Run the containers

```sh
$ docker-compose up
```

Setup the database

```sh
$ docker-compose run web bundle exec rails db:setup
```
