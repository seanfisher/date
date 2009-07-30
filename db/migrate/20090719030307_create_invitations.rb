class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :sender_id
      t.string :recipient_email
      t.string :token
      t.datetime :sent_at
      t.text :personal_message
      t.string :recipient_name

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end