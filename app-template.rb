# -*- coding: utf-8 -*-
git :init
git add: '.'
git commit: '-m "Initial commit"'

generate :model, 'post'
generate :model, 'comment commentable_id:integer commentable_type:string'
Dir.glob('db/migrate/*_create_comments.rb') do |f|
  gsub_file f, /t\.integer :commentable_id.*/ do
    't.integer :commentable_id, default: 0'
  end
end

rake 'db:migrate'

insert_into_file 'app/models/post.rb', <<-RUBY, before: /^end/
  has_many :comment_threads, class_name: 'Comment', as: :commentable
RUBY

insert_into_file 'app/models/comment.rb', <<-RUBY, before: /^end/
  belongs_to :commentable, :polymorphic => true, :touch => true
RUBY

git add: '.'
git commit: '-n -m "setup models"'

append_file 'db/seeds.rb', <<-RUBY
post = Post.first_or_create
comment = post.comment_threads.build
comment.save!
RUBY

git add: '.'
git commit: '-m "add some code"'

initializer 'belongs_to.rb', <<-'RUBY'
require 'active_record/associations/builder/belongs_to'
module ActiveRecord::Associations::Builder
  class BelongsTo < SingularAssociation #:nodoc:
    def self.touch_record(o, foreign_key, name, touch) # :nodoc:
      p [:touch_record, o, foreign_key, name, touch]
      p o.changed_attributes
      old_foreign_id = o.changed_attributes[foreign_key] # Why 0?

      if old_foreign_id
        association = o.association(name)
        reflection = association.reflection
        if reflection.polymorphic?
          p [o, o.public_send(reflection.foreign_type), o.public_send("#{reflection.foreign_type}_was")]
          klass = o.public_send("#{reflection.foreign_type}_was").constantize
        else
          klass = association.klass
        end
        old_record = klass.find_by(klass.primary_key => old_foreign_id)

        if old_record
          if touch != true
            old_record.touch touch
          else
            old_record.touch
          end
        end
      end

      record = o.send name
      if record && record.persisted?
        if touch != true
          record.touch touch
        else
          record.touch
        end
      end
    end
  end
end
RUBY

git add: '.'
git commit: '-m "show debug info"'
