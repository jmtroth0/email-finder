require 'set'
require 'nokogiri'
require 'spidr'
require 'byebug'

class DomainReader
  attr_reader :uri, :emails, :url_map

  def initialize(domain_name)
    self.uri = domain_name
  end

  def find_emails(page_limit = nil)
    @emails = Set.new # use a set to ensure unique emails efficiently

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
      emails.each { |email| puts email }
    end
    nil
  end

  private

  # upon setting the name, validates it and adds the protocol and sub-domain
  def uri=(name)
    name = validate_domain(name)
    @uri = "http://www.#{name}"
  end

  # makes sure it is not nil and generally looks like a domain name
  def validate_domain(name)
    until !name.nil? && name.match(/\w+\.\w+/)
      puts "Please enter valid domain"
      name = STDIN.gets.chomp
    end
    name
  end

 # built on top of Spidr's #every_page hook,
 # adding an optional page limit and placing the callback in context
  def every_page(lambda, page_limit = nil)
    num_checked_pages = 0

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


reader = DomainReader.new(ARGV[0])

puts "Would you like to limit the number of pages searched? ('no' or the number)"
limit = STDIN.gets.chomp
limit = limit.match(/\A\d+\z/) ? limit.to_i : nil
# if there is a page limit, converts it to integer

puts "Searching..."

reader.find_emails(limit)

puts "\nFound these email addresses:"
reader.print_email_addresses
puts "..."
