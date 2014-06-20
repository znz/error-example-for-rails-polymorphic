class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :commentable_id, default: 0
      t.string :commentable_type

      t.timestamps
    end
  end
end
