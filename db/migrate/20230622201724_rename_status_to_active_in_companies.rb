class RenameStatusToActiveInCompanies < ActiveRecord::Migration[7.0]
  def change
    rename_column :companies, :status, :active
  end
end
