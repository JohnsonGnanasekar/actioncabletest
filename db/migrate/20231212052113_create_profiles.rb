class CreateProfiles < ActiveRecord::Migration[7.1]
  def change
    create_table :profiles do |t|
      t.string :name, null: false
      t.string :gender, null: false
      t.string :category, null: false

      t.timestamps
    end
  end
end
