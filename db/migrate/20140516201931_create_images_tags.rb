class CreateImagesTags < ActiveRecord::Migration
  def change
    create_table :images_tags do |t|
      t.integer :image_id
      t.integer :tag_id
    end
  end
end
