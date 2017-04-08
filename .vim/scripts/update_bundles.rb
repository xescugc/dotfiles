#!/usr/bin/env ruby

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "../bundle")

puts "dir: #{bundles_dir}"

FileUtils.cd(bundles_dir)

puts "trashing everything (lookout!)"

Dir["*"].each do |d|
  puts "pulling #{d}"
  FileUtils.cd(d)
  `git pull`
  FileUtils.cd("..")
end
