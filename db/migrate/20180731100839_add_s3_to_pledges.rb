class AddS3ToPledges < ActiveRecord::Migration[5.0]
  def change
    add_column :pledges, :image, :string
  end
end
