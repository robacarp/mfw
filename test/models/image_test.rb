require "test_helper"

class ImageTest < ActiveSupport::TestCase
  def test_file_list
    file_list = Image.files

    (0..1).each do |i|
      refute_match /^\.{1,2}$/, file_list[i]
    end
  end

  def test_creates_object
    name = ""
    12.times { name += (rand(25) + 65).chr }
    name += ".png"

    path = Rails.root.join "public/images/#{name}"
    FileUtils.touch "#{path}"

    before_count = Image.count
    Image.from_file name
    after_count = Image.count

    assert_equal before_count + 1, after_count
    FileUtils.rm path
  end

  def test_auto_creates_tags_from_string
    tags = %w|foo bar|
    img = Image.rand
    img.tag_group = tags.join(', ')

    tags.each do |tag|
      assert img.tags.map(&:name).include?(tag), "should have assigned '#{tag}', actually assigned '#{img.tag_group}'"
    end

    img.tags = []

    string = ", tag2"
    img.tag_group = string
    assert_equal 1, img.tags.count, "blank tags shouldn't get assigned"

    img.tags = []
    img.tag_group = "tag2, tag2,   tag2"
    assert_equal 1, img.tags.count, "duplicate tags should not get inserted"
    img.tag_group = "tag2 , tag3"
    assert_equal 2, img.tags.count, "spacing around tags shouldn't matter"
  end

  def test_auto_deletes_tags_when_updated_by_string
    img = Image.rand
    img.tag_group = "one, two"

    img.reload
    tags = %w|three four|
    img.tag_group = tags.join(', ')
    assert_equal 2, img.tags.count

    tags.each do |tag|
      assert img.tags.map(&:name).include?(tag), "should have assigned '#{tag}'"
    end
  end
end
