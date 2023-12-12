class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :gender, index: true
      t.string :category, index: true

      t.timestamps
    end
  end
end
