class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :content
      t.boolean :private, null: false, default: false

      t.references :user

      t.timestamps
    end
  end
end