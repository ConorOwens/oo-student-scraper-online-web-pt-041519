require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    page_html = Nokogiri::HTML(open(index_url))
    info = []
    page_html.css('div.student-card a').each do |student|
      name = student.css('h4').text
      location = student.css('p').text
      url = student.attr('href')
      info << {name: name, location: location, profile_url: url}
    end
    info
  end

  def self.scrape_profile_page(profile_url)
    info = {}
    profile_page = Nokogiri::HTML(open(profile_url))
    links = profile_page.css(".social-icon-container a").map { |link| link.attribute('href').value}
    links.each do |link|
      if link.include?("linkedin")
        info[:linkedin] = link
      elsif link.include?("github")
        info[:github] = link
      elsif link.include?("twitter")
        info[:twitter] = link
      else
        info[:blog] = link
      end
    end
    info[:profile_quote] = profile_page.css(".profile-quote").text if profile_page.css(".profile-quote")
    info[:bio] = profile_page.css("div.bio-content.content-holder div.description-holder p").text if profile_page.css("div.bio-content.content-holder div.description-holder p")
    info
  end

end

