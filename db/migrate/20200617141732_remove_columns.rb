class RemoveColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :ingredients, :calories, :integer
  end
end
