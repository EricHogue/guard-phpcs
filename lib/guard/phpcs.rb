require 'guard'
require 'guard/guard'

module Guard
	class PHPCS < Guard

  		VERSION = '0.0.5'

  		DEFAULT_OPTIONS = {
			:standard => 'Zend',
			:executable => 'phpcs',
	    }

	    def initialize(watchers = [], options = {})
	      defaults = DEFAULT_OPTIONS.clone
	      @options = defaults.merge(options)
        @tabs = @options[:tabs]? " --tab-width=#{@options[:tabs]} " : ' '
	      super(watchers, @options)
	    end

	    def run_on_changes(paths)
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