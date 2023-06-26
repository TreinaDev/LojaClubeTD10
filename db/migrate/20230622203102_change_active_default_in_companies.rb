class ChangeActiveDefaultInCompanies < ActiveRecord::Migration[7.0]
  def change
    change_column_default :companies, :active, from: false, to: true
  end
end
