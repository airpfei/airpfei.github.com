require 'fileutils'
require 'date'
require 'yaml'
require 'rexml/document'
require "stringex"
include REXML


doc = Document.new File.new(ARGV[0])

FileUtils.mkdir_p "_posts"

doc.elements.each("rss/channel/item[wp:status = 'publish' and wp:post_type = 'post']") do |e|
  post = e.elements
  slug = post['title'].text.to_url
  date = DateTime.parse(post['wp:post_date'].text)
  name = "%02d-%02d-%02d-%s.markdown" % [date.year, date.month, date.day, slug]

  content = post['content:encoded'].text

  content = content.gsub(/<code>(.*?)<\/code>/, '`\1`')

  content = content.gsub(/<pre lang="([^"]*)">(.*?)<\/pre>/m, '')

  (1..3).each do |i|
    content = content.gsub(/<h#{i}>([^<]*)<\/h#{i}>/, ('#'*i) + ' \1')
  end

  puts "Converting: #{name}"

  data = {
    'layout' => 'post',
    'title' => post['title'].text,
    'excerpt' => post['excerpt:encoded'].text,
    'wordpress_id' => post['wp:post_id'].text,
    'wordpress_url' => post['guid'].text
    }.delete_if { |k,v| v.nil? || v == ''}.to_yaml

    File.open("_posts/#{name}", "w") do |f|
      f.puts data
      f.puts "---"
      f.puts content
    end

  end

