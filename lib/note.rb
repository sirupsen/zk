require 'time'
require 'byebug'

class Note
  attr_accessor :absolute_file_path

  @id_to_note = {}
  @backlinks = {}

  def initialize(absolute_file_path)
    @absolute_file_path = absolute_file_path
  end

  def ==(other)
    id == other.id
  end

  def eql?(other)
    id == other.id
  end

  def <=>(other)
    id == other.id
  end

  def self.from_absolute_path(absolute_path)
    Note.new(absolute_path)
  end

  def self.from_name(name)
    return from_id(name) if name =~ /\A\d+\z/

    Note.new(File.join(ENV['ZK_PATH'], "#{name.chomp('.md')}.md"))
  end

  def self.from_id(id)
    all if @id_to_note.empty?
    @id_to_note[id.to_s]
  end

  def id
    @id ||= absolute_file_path.match(%r{#{Regexp.escape(ENV["ZK_PATH"])}/(\d+)})[1]
  end

  def body
    File.read(absolute_file_path)
  end

  def body=(new_body)
    File.open(absolute_file_path, 'w+') { |file| file.write(new_body) }
  end

  def backlinks
    self.class.backlinks[id] || []
  end

  def append(text)
    body_before = body
    body_after = body_before.clone
    body_after << text << "\n"
    self.body = body_after
  end

  def append_backlinks(confirm: true)
    backlinks_text = (backlinks - links).map { |note| note.to_backlink }.join("\n")
    return if backlinks_text.empty?

    confirm(body, body + backlinks_text) if confirm
    append backlinks_text
  end

  def confirm(before, after)
    puts <<~EOS
      About to commit changes to #{name_with_ext}

      Before
      #{before}

      After
      #{after}\n
    EOS

    print 'Confirm? [Y/n] '
    raise ArgumentError, 'Bailing!' unless $stdin.gets.strip.downcase == 'y'
  end

  def name_without_id
    name_without_ext.match(/\d+ (.+)/)[1]
  end

  def created_at
    Time.strptime(id, '%Y%m%d%H%M')
  end

  def name_without_ext
    name_with_ext.chomp('.md')
  end

  def name_with_ext
    File.basename(@absolute_file_path)
  end

  def to_link
    "[[#{name_with_ext}]]"
  end

  def to_backlink
    "Backlink: #{to_link}"
  end

  def self.backlinks
    return @backlinks unless @backlinks.empty?

    all.each do |note|
      note.links.each do |link|
        @backlinks[link.id] ||= []
        @backlinks[link.id] << note
        @backlinks[link.id].uniq!
      end
    end

    @backlinks
  end

  def valid?
    return false unless File.exist?(@absolute_file_path)
    return false unless @absolute_file_path =~ %r{#{Regexp.escape(ENV["ZK_PATH"])}/\d+ }

    true
  end

  def links
    body.scan(/\[\[(.*)\]\]/).map { |(link)| Note.from_name(link) }.select { |note| note.valid? }
  end

  def self.all
    notes = Dir[File.join(ENV['ZK_PATH'], '/*.md')].select do |file|
      file =~ %r{#{Regexp.escape(ENV["ZK_PATH"])}/\d+ }
    end.map { |file| Note.from_absolute_path(file) }

    # TODO: raise on conflicts
    notes.each { |note| @id_to_note[note.id] = note }

    notes
  end
end
