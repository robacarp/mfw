class Image < ActiveRecord::Base
  has_and_belongs_to_many :tags

  def full_path
    "/images/#{path}"
  end

  def tag_group
    tags.map(&:name).join(',')
  end

  def tag_group= tag_input
    current_tags = tags.map(&:name)
    new_tags = tag_input
                  .split(',')
                  .map(&:strip)
                  .uniq
                  .reject {|t| t.blank? }

    to_be_deleted = current_tags - new_tags
    to_be_created = new_tags - current_tags

    to_be_created.each do |t|
      tag = Tag.from_text t
      self.tags << tag
    end

    to_be_deleted.each do |t|
      tag = Tag.from_text t
      tag.images.delete self
    end

    tag_group
  end

  def self.files
    path = Rails.root.join 'public/images'
    list = Dir.entries path
    list.shift
    list.shift

    list
  end

  def self.rand
    from_file files.sample
  end

  def self.from_file file
    img = Image.where(path: file).first
    if img.nil?
      img = Image.create path: file
    end

    img
  end
end
