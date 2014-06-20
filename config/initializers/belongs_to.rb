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
