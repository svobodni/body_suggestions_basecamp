desc "Generate application layout"
task :generate_layout do
	require 'yaml'
	require 'open-uri'
	
	config = YAML.load_file('config.yml')
	
	app_config = config["application"]
	template = Processor.new
	template.fetch
	template.head = ''	
	template.title = "#{app_config["title"]}"
    template.breadcrumb = ''
    template.store

	class Processor

		attr_accessor :output

	    def fetch
			self.external = open("http://web.svobodni.cz/external").read
	    end

		def external=(source)
			@output = source
		    @output.gsub!(/src="\//,'src="//web.svobodni.cz/')
		    @output.gsub!(/href="\//,'href="//web.svobodni.cz/')
			@output.gsub!(/\<\% navigation.begin \%\>/, '')
			@output.gsub!(/\<\% navigation.end \%\>/, '')
		    @output.gsub!(/\<\% content.begin \%\>\<\% content.end \%\>/, '<%= yield %>')
	    end

		def title=(value)
			@output.gsub!(/\<title\>(.*?)\<\/title\>/, "<title>#{value}</title>")
		    @output.gsub!(/\<\% title.begin \%\>Titulek\<\% title.end \%\>/, value)
		end

	    def head=(value)
			@output.gsub!(/\<\/head\>/, "#{value}\n</head>")
	    end

		def breadcrumb=(value)
			@output.gsub!(/\<ul class=\"breadcrumb\"\>(.*?)\<\/ul\>/m, "<ul class=\"breadcrumb\">#{value}</ul>")
	    end

		def store(path=File.join('views/layout.erb'))
	      file = File.open(path,'w')
		  file.write(@output)
	      file.close
		end
	end		
end
