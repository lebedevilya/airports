require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'thor'
end

require_relative "wayfinder"

ROUTES_SOURCE = 'https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat'

class CLI < Thor
  option :from, :required => true
  option :transfers, :required => true
  option :to, :required => true
  option :path
  desc "scan", "scan all possible flights"
  long_desc <<-LONGDESC
    `airpots scan` will print out all possible flights from airport one to airport two with <= required amount of transfers
 
    You can optionally specify path to routes file if you locally have one. Otherwise it will be downloaded automatically.\n

    > $ airports scan --from=KZN --to=ASF --transfers=2\n
 
    > from: Lebedev Ilya
  LONGDESC
  def scan
    unless options[:path] || File.file?('./routes.dat')
      puts "downloading routes data..."
      `wget #{ROUTES_SOURCE}`
    end
    puts "scanning all routes from #{options[:from]} to #{options[:to]}"
    puts "with <= #{options[:transfers]} transfers"
    if options[:transfers].to_i > 3
      puts "Be careful, recommended amount of transfers is <= 3. Proper work with higher amount of transfers is not guaranteed."
    end

    wayfinder = WayFinder.new(options)
    wayfinder.scan
    wayfinder.routes
  end 
end

CLI.start(ARGV)