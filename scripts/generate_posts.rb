#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"

SOURCE_DIR = File.expand_path("../content/posts", __dir__)
OUTPUT_DIR = File.expand_path("../_posts", __dir__)
TIMEZONE_OFFSET = "+0800"

def escape_yaml_string(value)
  value.to_s.dump
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
  body.gsub(/\((assets\/[^)]+)\)/) do
    "({{ '/#{$1}' | relative_url }})"
  end
end

def build_front_matter(title:, subtitle:, date:)
  lines = []
  lines << "---"
  lines << "layout: post"
  lines << "title: #{escape_yaml_string(title)}"
  lines << "subtitle: #{escape_yaml_string(subtitle)}" if subtitle
  lines << "date: #{date} 00:00:00 #{TIMEZONE_OFFSET}"
  lines << "background: \"/img/bg-post.jpg\""
  lines << "---"
  lines << ""
  lines.join("\n")
end

raise "Source directory does not exist: #{SOURCE_DIR}" unless Dir.exist?(SOURCE_DIR)

FileUtils.mkdir_p(OUTPUT_DIR)
Dir.glob(File.join(OUTPUT_DIR, "*.md")).each { |path| File.delete(path) }

Dir.glob(File.join(SOURCE_DIR, "*.md")).sort.each do |source_path|
  basename = File.basename(source_path)
  match = basename.match(/^(\d{4}-\d{2}-\d{2})-(.+)\.md$/)
  raise "Source filename must follow YYYY-MM-DD-slug.md: #{basename}" unless match

  date_part = match[1]
  slug_part = match[2]
  raw = File.read(source_path, encoding: "UTF-8").gsub("\r\n", "\n")
  lines = raw.lines(chomp: true)

  title = extract_title(lines)
  body_lines = remove_leading_title(lines)
  subtitle, body_lines = extract_optional_subtitle(body_lines)
  body = rewrite_asset_paths(body_lines.join("\n")).strip

  output = +""
  output << build_front_matter(title: title, subtitle: subtitle, date: date_part)
  output << body
  output << "\n" unless output.end_with?("\n")

  output_path = File.join(OUTPUT_DIR, "#{date_part}-#{slug_part}.md")
  File.write(output_path, output)
end
