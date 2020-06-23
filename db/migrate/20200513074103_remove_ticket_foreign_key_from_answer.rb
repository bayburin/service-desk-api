class RemoveTicketForeignKeyFromAnswer < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :answers, name: 'fk_rails_f78b6653c5'
  end
end
