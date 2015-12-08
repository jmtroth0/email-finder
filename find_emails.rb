require 'set'
require 'nokogiri'
require 'spidr'
require 'uri'

class DomainReader
  attr_accessor :uri

  def initialize(uri)
    self.uri = uri
  end

  def find_emails(page_limit = nil)
    search = lambda do |page|
               page.search('//a[@href]').each do |link| # gets all a's with hrefs
                 link_email = link['href'].match(/\w+@\w+\.\w+/)
                  # pulls email from href if applicable
                  # could add further qualifications to regexp in the future
                  # but this is generally good enough as few hrefs have '@'
                 emails << link_email if link_email # puts email in set
               end
             end

    every_page(search, page_limit)
  end

  def print_email_addresses
    if emails.size == 0
      puts "Found no emails"
    else
      puts "\nFound these email addresses:"
      emails.each { |email| puts email }
      puts "..."
    end
    nil
  end

  private

  def emails # getter method ensures existence as well
    @emails ||= Set.new # use a set to ensure unique emails efficiently
  end

 # built on top of Spidr's #every_page hook,
 # adding an optional page limit and placing the callback in context
  def every_page(lambda, page_limit = nil)
    num_checked_pages = 0

    puts "Searching..."

    Spidr.site(uri) do |spider|
      spider.every_page do |page|
        spider.pause! if page_limit && page_limit <= num_checked_pages

        num_checked_pages += 1
        puts "Checked #{num_checked_pages} pages" if num_checked_pages % 5 == 0
        # because only printing emails at the end, status updates are nice

        lambda.call(page)
      end
    end
    nil
  end
end

# makes sure it is not nil and generally looks like a domain name
def input_and_validate(name)
  uri = URI.parse("http://#{name}")
  until !name.nil? && uri.kind_of?(URI::HTTP)
    puts "Please enter valid domain"
    name = STDIN.gets.chomp
    uri = URI.parse("http://#{name}")
  end
  uri
end

name = input_and_validate(ARGV[0])

reader = DomainReader.new(name)

puts "Would you like to limit the number of pages searched? ('no' or the number)"
limit = STDIN.gets.chomp
limit = limit.match(/\A\d+\z/) ? limit.to_i : nil
# if there is a page limit, converts it to integer

reader.find_emails(limit)

reader.print_email_addresses
