class Post < ActiveRecord::Base
  has_many :comment_threads, class_name: 'Comment', as: :commentable
end
