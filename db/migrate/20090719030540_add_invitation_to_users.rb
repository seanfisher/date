class AddInvitationToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :invitation_id, :integer
    add_column :users, :invitation_limit, :integer
    User.reset_column_information
    User.find(:all).each_with_index do |u,i|
      u.update_attribute :invitation_id, i
      u.update_attribute :invitation_limit, 5
    end
  end

  def self.down
    remove_column :users, :invitation_limit
    remove_column :users, :invitation_id
  end
end
