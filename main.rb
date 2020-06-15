# frozen_string_literal: true

require "pathname"

$LOAD_PATH << Pathname.new(__dir__).join("lib").expand_path

require "error"
require "models/person"
require "relationship"
require "program/parser"
require "program/runner"
require "program/presenter"

require_relative "./spec/fixtures/king_shan_family"

if ARGV.count == 0
  puts "Usage: ruby main.rb input_filename"
  exit 1
end

king_shan_family = KingShanFamily.create

input_file = ARGV[0]

lines = File.read(input_file)
commands = lines.split("\n")
  .select { |line| !line.empty? }
  .map { |line| Parser.parse(line) }
command_results = commands.map { |command| Runner.run(command: command, family: king_shan_family) }
outputs = command_results.map { |result| Presenter.present(result) }

puts outputs
