class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :role, index: true
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

  end
end
