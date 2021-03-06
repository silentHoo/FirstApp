class DeviseCreateOZBPerson < ActiveRecord::Migration
  def self.up
    change_table(:OZBPerson) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable

      # t.encryptable
      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable


      t.timestamps
    end

    add_index :OZBPerson, :mnr,                :unique => true
    add_index :OZBPerson, :reset_password_token, :unique => true
    # add_index :ozb_people, :confirmation_token,   :unique => true
    # add_index :ozb_people, :unlock_token,         :unique => true
    # add_index :ozb_people, :authentication_token, :unique => true
  end

  def self.down
    drop_table :OZBPerson
  end
end
