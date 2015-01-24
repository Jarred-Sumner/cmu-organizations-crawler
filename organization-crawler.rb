require 'bundler/setup'
require 'wombat'
require 'json'

Bundler.setup
NUMBER_OF_PAGES = 33.freeze unless defined?(NUMBER_OF_PAGES)

emails = []

(1..NUMBER_OF_PAGES).each do |index|

  emails << Wombat.crawl do
    base_url "https://thebridge.cmu.edu/"
    path "organizations?SearchType=None&SelectedCategoryId=0&CurrentPage=#{index}"

    organizations 'css=#results div h5', :iterator do
      contact 'css=a', :follow do
        email 'css=#smallColumn > div:nth-child(3) > div.summarySection.contactInfo > div:nth-child(2)'
      end
    end

  end['organizations'].collect { |contact| contact['contact'].first['email'] }
  puts "Completed Page #{index}"

end


puts emails.flatten.uniq.compact.to_json