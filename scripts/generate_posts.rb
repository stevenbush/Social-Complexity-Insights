#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"
require "yaml"
require "zlib"

ROOT_DIR = File.expand_path("..", __dir__)
SOURCE_DIR = File.join(ROOT_DIR, "content/posts")
OUTPUT_DIR = File.join(ROOT_DIR, "_posts")
POST_BACKGROUND_DIR = File.join(ROOT_DIR, "img/posts")
DEFAULT_POST_BACKGROUND = "/img/bg-post.jpg"
TIMEZONE_OFFSET = "+0800"

def escape_yaml_string(value)
  value.to_s.dump
end

def extract_source_front_matter(raw)
  return [{}, raw] unless raw.start_with?("---\n")

  parts = raw.split(/^---\s*$\n?/, 3)
  return [{}, raw] unless parts.length >= 3 && parts[0].empty?

  metadata = YAML.safe_load(parts[1], permitted_classes: [], aliases: false)
  unless metadata.nil? || metadata.is_a?(Hash)
    raise "Source front matter must be a YAML mapping"
  end

  [metadata || {}, parts[2]]
end

def extract_title(lines)
  first_nonempty = lines.find { |line| !line.strip.empty? }
  raise "Post is missing a level-1 title" unless first_nonempty&.match?(/^#\s+/)

  first_nonempty.sub(/^#\s+/, "").strip
end

def remove_leading_title(lines)
  index = lines.index { |line| !line.strip.empty? }
  raise "Post is missing a level-1 title" unless index && lines[index].match?(/^#\s+/)

  lines[(index + 1)..] || []
end

def extract_optional_subtitle(lines)
  working = lines.dup
  working.shift while working.first&.strip == ""

  paragraph = []
  while working.first && !working.first.strip.empty?
    paragraph << working.shift
  end

  subtitle = nil
  if paragraph.length == 1
    candidate = paragraph.first.strip
    if candidate.match?(/^\*[^*].*[^*]\*$/)
      subtitle = candidate[1..-2].strip
      working.shift while working.first&.strip == ""
    else
      working = paragraph + working
    end
  else
    working = paragraph + working
  end

  [subtitle, working]
end

def rewrite_asset_paths(body)
  rewritten = body.gsub(/\((assets\/[^)]+)\)/) do
    "({{ '/#{$1}' | relative_url }})"
  end

  rewritten.gsub(/(<img\b[^>]*\bsrc=)(["'])(assets\/[^"']+)\2/i) do
    %(#{$1}#{$2}{{ '/#{$3}' | relative_url }}#{$2})
  end
end

def discover_post_backgrounds
  return [] unless Dir.exist?(POST_BACKGROUND_DIR)

  Dir.children(POST_BACKGROUND_DIR)
     .sort
     .select { |name| File.file?(File.join(POST_BACKGROUND_DIR, name)) }
     .each_with_object([]) do |name, backgrounds|
       extension = File.extname(name).downcase
       next unless %w[.jpg .jpeg .png .webp .avif].include?(extension)

       backgrounds << "/img/posts/#{name}"
     end
end

def select_post_background(backgrounds:, post_key:)
  return DEFAULT_POST_BACKGROUND if backgrounds.empty?

  backgrounds[Zlib.crc32(post_key) % backgrounds.length]
end

def build_front_matter(title:, subtitle:, date:, background:)
  lines = []
  lines << "---"
  lines << "layout: post"
  lines << "title: #{escape_yaml_string(title)}"
  lines << "subtitle: #{escape_yaml_string(subtitle)}" if subtitle
  lines << "date: #{date} 00:00:00 #{TIMEZONE_OFFSET}"
  lines << "background: #{escape_yaml_string(background)}"
  lines << "---"
  lines << ""
  lines.join("\n")
end

raise "Source directory does not exist: #{SOURCE_DIR}" unless Dir.exist?(SOURCE_DIR)

FileUtils.mkdir_p(OUTPUT_DIR)
Dir.glob(File.join(OUTPUT_DIR, "*.md")).each { |path| File.delete(path) }
post_backgrounds = discover_post_backgrounds

Dir.glob(File.join(SOURCE_DIR, "*.md")).sort.each do |source_path|
  basename = File.basename(source_path)
  match = basename.match(/^(\d{4}-\d{2}-\d{2})-(.+)\.md$/)
  raise "Source filename must follow YYYY-MM-DD-slug.md: #{basename}" unless match

  date_part = match[1]
  slug_part = match[2]
  raw = File.read(source_path, encoding: "UTF-8").gsub("\r\n", "\n")
  source_metadata, raw_body = extract_source_front_matter(raw)
  background = source_metadata["background"] || select_post_background(backgrounds: post_backgrounds, post_key: "#{date_part}-#{slug_part}")
  lines = raw_body.lines(chomp: true)

  title = extract_title(lines)
  body_lines = remove_leading_title(lines)
  subtitle, body_lines = extract_optional_subtitle(body_lines)
  body = rewrite_asset_paths(body_lines.join("\n")).strip

  output = +""
  output << build_front_matter(title: title, subtitle: subtitle, date: date_part, background: background)
  output << body
  output << "\n" unless output.end_with?("\n")

  output_path = File.join(OUTPUT_DIR, "#{date_part}-#{slug_part}.md")
  File.write(output_path, output)
end
