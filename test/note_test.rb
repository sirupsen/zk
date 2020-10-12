require "minitest/autorun"
require_relative "../lib/note"
ENV["ZK_PATH"] = File.expand_path(File.join(File.dirname(__FILE__), "../samples"))

class TestNote < Minitest::Test
  def setup
    @id = "202001111211"
    @name_without_ext = "#{@id} A"
    @name_with_ext = "#{@name_without_ext}.md"
    @note_abs_path = File.join(ENV["ZK_PATH"], @name_with_ext)
  end

  def test_from_absolute_path
    note = Note.from_absolute_path(@note_abs_path)
    assert_equal @note_abs_path, note.absolute_file_path
    assert_equal @id, note.id
    assert note.body
  end

  def test_from_name_without_extension
    note = Note.from_name(@name_without_ext)
    assert_equal @note_abs_path, note.absolute_file_path
    assert_equal @id, note.id
    assert note.body
  end

  def test_from_name_with_extension
    note = Note.from_name(@name_with_ext)
    assert_equal @note_abs_path, note.absolute_file_path
    assert_equal @id, note.id
    assert note.body
  end

  def test_from_id
    note = Note.from_id(@id)
    assert_equal @note_abs_path, note.absolute_file_path
    assert_equal @id, note.id
    assert note.body
  end

  def test_links
    note = Note.from_absolute_path(@note_abs_path)
    note.links.map { |link| link.body } # will raise if file doesn't exist
  end

  def test_backlinks
    note = Note.from_id("202002020636")
    assert_equal ["202001111211"], note.backlinks.map(&:id)
  end

  def test_name_with_extension
    note = Note.from_id(@id)
    assert_equal @name_with_ext, note.name_with_ext
  end

  def test_name_without_extension
    note = Note.from_id(@id)
    assert_equal @name_without_ext, note.name_without_ext
  end

  def test_name_without_id
    note = Note.from_id(@id)
    assert_equal "A", note.name_without_id
  end

  def test_created_at
    note = Note.from_id(@id)
    assert_equal Time.parse("2020-01-11 12:11:00"), note.created_at
  end

  def test_to_link
    note = Note.from_id(@id)
    assert_equal "[[202001111211 A]]", note.to_link
  end

  def test_append
    note = Note.from_id(@id)
    body_before = note.body
    note.append("more content")
    assert_equal "more content", note.body.split("\n").last
  ensure
    note.body = body_before
  end

  def test_append_backlinks
    note = Note.from_id("202002020636")
    body_before = note.body
    note.append_backlinks(confirm: false)
    assert_equal "Backlink: [[202001111211 A]]", note.body.split("\n").last
  ensure
    note.body = body_before
  end

  def test_append_no_backlinks_when_already_linked
    note = Note.from_id("18113220711")
    body_before = note.body
    note.append_backlinks(confirm: false)
    assert_equal body_before, note.body
  ensure
    note.body = body_before
  end
end
