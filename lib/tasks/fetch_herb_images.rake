require 'open-uri'
require 'nokogiri'

namespace :herbs do
  desc "fetch herbs from lifeisfeudal.gamepedia.com"
  task :fetch => :environment do
    path = Rails.root.join("app", "assets", "herbs")
    url = "http://lifeisfeudal.gamepedia.com/Category:Alchemy_herb_images"
    doc = Nokogiri::HTML(open(url))
    DatabaseCleaner.clean_with(:truncation, :only => %w[herbs])

    doc.css('ul.gallery a.image > img').each do |img|
      filename = img.attribute("alt")
      name = filename.to_s.split(".")[0]
      src = img.attribute("src").to_s

      Herb.create(name: name, img_path: filename.to_s)
      File.open(path.join(filename.to_s), 'wb') do |fo|
        fo.write open(src).read
      end
    end
  end
end
