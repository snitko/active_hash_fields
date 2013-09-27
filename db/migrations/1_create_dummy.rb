class CreateDummy < ActiveRecord::Migration

  def change
    create_table :dummies do |t|
      t.text :notifications
    end
  end

end
