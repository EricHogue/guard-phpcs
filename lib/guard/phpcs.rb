require 'guard'

module Guard
	class PHPCS < ::Guard::Plugin

  		VERSION = '0.0.7'

  		DEFAULT_OPTIONS = {
			:standard => 'Zend',
			:executable => 'phpcs',
	    }

	    def initialize(options = {})
	      defaults = DEFAULT_OPTIONS.clone
	      @options = defaults.merge(options)
        @tabs = @options[:tabs]? " --tab-width=#{@options[:tabs]} " : ' '
	      super(@options)
	    end

	    def run_on_modifications(paths)
			paths.each do |path|
				results = `#{@options[:executable]} --report=full#{@tabs}--standard=#{@options[:standard]} #{path}`
				if $?.to_i > 0 then
					::Guard::Notifier.notify(results.gsub(/^-+\n/, '').gsub(/^FILE:.*\n/, '').gsub(/^Time:.*\n/, ''), :title => 'PHP Codesniffer', :image => :failed)
					puts results
				end
			end
	    end
	end
end
