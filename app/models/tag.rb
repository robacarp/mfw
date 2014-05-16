class Tag < ActiveRecord::Base
  has_and_belongs_to_many :images

  def self.from_text text
    text.strip!
    tag = self.where(name: text).first
    if tag.nil?
      tag = self.create name: text
    end

    tag
  end
end
