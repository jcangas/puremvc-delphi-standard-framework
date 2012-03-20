# 
# http://baldowl.github.com/2011/04/13/rough-gallery-plugin-for-jekyll.html
# Basic: add a `gallery` attribute to the YAML header of any page with value
# being the extension of your images. Every image with that extension stored
# inside the page's directory (and every one of its subdirectories) will be
# added to the `gallery_items` attribute of that same page (alphabetically
# sorted).

module Jekyll
	class Gallery < Generator
		safe true

		def generate site
			site.pages.each do |page|
				gallery(site, page) if page.data['gallery']
			end
		end

		def gallery site, page
			base = page.instance_variable_get :@dir
			# search = File.join '**', "*.#{page.data['gallery']}"
			search = "#{page.data['gallery']}"
			items = Dir.chdir(base[1..-1] || '.') do
				Dir.glob(search).sort.map {|item| File.join base, item}
			end
			page.data = page.data.deep_merge 'gallery_items' => items
		end
	end
end

module Jekyll
	module AssetFilter
		def download_entry(input)      
			info = File.basename(input, '.zip').split('-')[1..-1]
			"%1s | %2s | %3s " % info
		end
	end
end

Liquid::Template.register_filter(Jekyll::AssetFilter)