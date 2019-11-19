require 'chong/dsl'
require 'chong/link_parser'

class Chong
  def self.run
    Dir.glob("**/chong_*.rb").each {|f| load f}

    each_host do |host|
      url_queue = Queue.new

      cosumer = Thread.new do
        link = url_queue.pop
        while link != "end"
          begin
            doc = Nokogiri::HTML(open(link, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}))
            host[:handle].call doc
          rescue OpenURI::HTTPError => ex
            # puts ex.to_s
          end
          link = url_queue.pop
        end
      end

      productor = Thread.new do
        extract_links host[:url], url_queue, []
        url_queue << "end"
      end

      productor.join
      cosumer.join
    end
  end
end