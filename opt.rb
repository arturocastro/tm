require 'ostruct'
require 'optparse'

def self.parse(args)
  options = OpenStruct.new
  options.browser = "firefox"
  options.user = ""
  options.pass = ""
  options.phantomjs_path = ""
  options.verbose = false

  opt_parser = OptionParser.new do |opts|
    opts.banner = "Usage: example.rb [options]"

    opts.separator ""
    opts.separator "Specific options:"

    opts.on("-uUSER", "--user USER", "User") do |u|
      options.user = u
    end

    opts.on("-pPASS", "--pass PASS", "Password") do |p|
      options.pass = p
    end

    opts.on("-bBROWSER", "--browser BROWSER", "User [firefox|chrome|phantomjs]") do |b|
      options.browser = b
    end

    opts.on("-j[PATH]", "--js-bin-path[=PATH]", "PhantomJS bin path") do |j|
      options.phantomjs_path = j
    end

    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      options.verbose = v
    end

    opts.separator ""
    opts.separator "Common options:"

    opts.on_tail("-h", "--help", "Show this message") do
      puts opts
      exit
    end
  end

  opt_parser.parse!(args)
  options
end
