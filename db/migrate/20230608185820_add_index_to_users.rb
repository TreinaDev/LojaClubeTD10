class AddIndexToUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :cpf, unique: true
  end
end
