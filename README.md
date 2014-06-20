# error example

## versions

- `ruby` 2.1.2
- `rails` 4.1.1

## problem

`t.integer :commentable_id` with `default: 0` in migration,
`belongs_to` with `:touch => true` in `Comment`,
and `comment.save` raises error in `touch_record`.

## how to re-produce

some debug information added in `config/initializers/belongs_to.rb`

    % rake db:seed
    [:touch_record, #<Comment id: 1, commentable_id: 1, commentable_type: "Post", created_at: "2014-06-20 00:47:39", updated_at: "2014-06-20 00:47:39">, "commentable_id", :commentable, true]
    {"commentable_id"=>0, "commentable_type"=>nil, "created_at"=>nil, "updated_at"=>nil, "id"=>nil}
    [#<Comment id: 1, commentable_id: 1, commentable_type: "Post", created_at: "2014-06-20 00:47:39", updated_at: "2014-06-20 00:47:39">, "Post", nil]
    rake aborted!
    NoMethodError: undefined method `constantize' for nil:NilClass
    /private/tmp/error-example-for-rails-polymorphic/config/initializers/belongs_to.rb:14:in `touch_record'
    /private/tmp/error-example-for-rails-polymorphic/db/seeds.rb:10:in `<top (required)>'
    Tasks: TOP => db:seed
    (See full trace by running task with --trace)
