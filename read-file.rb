#!/usr/bin/env ruby

require "optparse"

def parse_commandline_args(args)
  args = args.dup

  encoding = "shift_jis"
  hour = nil
  move = false

  parser = OptionParser.new
  parser.banner = <<~BANNER
    Usage: read-file.rb path [options]
    Example: ruby read-file.rb /path/to/file.log --hour 20 --move

  BANNER
  parser.on("--encoding ENCODING", "Encoding of the file to collect, such as utf-8, shift_jis.", "Default: #{encoding}") do |v|
    encoding = v
  end
  parser.on("--hour HOUR", "Execute collection only at this hour.", "Default: Disabled", Integer) do |v|
    hour = v
  end
  parser.on("--move", "move the file after collecting to prevent duplicate colleting by adding `.collected` extension.", "Default: Disabled") do
    move = true
  end

  begin
    parser.parse!(args)
  rescue OptionParser::ParseError
    return nil
  end

  begin
    Encoding.find(encoding)
  rescue ArgumentError => e
    puts e
    puts parser.help
    return nil
  end

  if hour and (hour < 0 or hour > 23)
    puts "--hour #{hour} must be an integer from 0 to 23."
    puts parser.help
    return nil
  end

  if args.size == 0
    puts "Need the filepath to collect."
    puts parser.help
    return nil
  end
  if args.size > 1
    puts "Invalid arguments: #{args[1..]}"
    puts parser.help
    return nil
  end

  path = args.first

  return path, encoding, hour, move
end

def read(path, encoding, hour, move)
  return nil if hour and Time.now.hour != hour
  return nil unless File.exist?(path)

  content = File.read(path, mode: "rb", encoding: encoding)

  if move
    require 'fileutils'
    FileUtils.mv(path, path + '.collected')
  end

  content
end

if __FILE__ == $PROGRAM_NAME
  args = parse_commandline_args(ARGV)
  exit 1 unless args

  content = read(*args)
  print content if content
end
