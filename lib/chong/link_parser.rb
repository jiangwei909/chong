require 'nokogiri'
require 'open-uri'
require 'openssl'

def extract_links(base_url, options = {})
  begin
    # puts "base url = #{base_url}"
    base = URI.parse(base_url)
    open(base_url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}) do |f|
      doc = Nokogiri::HTML(f.read)
      
      doc.css('a').each do |link|
        # ignore if the <a> tag withou a href attribute
        next unless link[:href]

        href = URI.parse(link[:href])

        # 空链接
        next unless href.path 
        next if href.path.empty?

        # 绝对路径
        if href.absolute?
          next if href.scheme != base.scheme or href.host != base.host
        else
          # this is relative path
          href.scheme = base.scheme
          href.host = base.host

          root = "/"
          base_absolute_dir = File.expand_path(File.dirname(base.path), root)

          href.path = File.expand_path(href.path, base_absolute_dir)

        end

        next_href = href.to_s

        next if options[:history].include?(next_href)

        options[:queue] << next_href
        options[:history] << next_href

        extract_links next_href, options if options[:recursive]
      end
    end
  rescue OpenURI::HTTPError => ex
    # puts ex.to_s
  end
end