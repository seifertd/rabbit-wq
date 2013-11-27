require 'yell'

# Provides logging services for the base server.
#
module BrerRabbit
  module ServerLogging

  protected

    def initialize_loggers
      if options[:interactive] || options[:log].nil? || options[:log].empty?
        BrerRabbit.logger = Yell.new do |l|
          l.level = log_level
          l.adapter $stdout, :level => [:debug, :info, :warn]
          l.adapter $stderr, :level => [:error, :fatal]
        end
      else
        BrerRabbit.logger = Yell.new do |l|
          l.level = log_level
          l.adapter :file, options[:log]
        end

        Celluloid.logger = Yell.new do |l|
          l.level = :info
          l.adapter :file, File.join( File.dirname( options[:log] ), "#{APP_ID}-celluloid.log" )
        end
      end
    end

    def log_startup
      start_banner( options ).each do |line|
        BrerRabbit.logger.info line
      end
    end

    def start_banner( options )
      [
        "",
        "***",
        "* #{BrerRabbit::APP_NAME} started",
        "*",
        "* #{VERSION_COPYRIGHT}",
        "***",
        "",
      ]
    end

    def log_level
      options.fetch( :log_level, :info ).to_sym
    end

  end
end