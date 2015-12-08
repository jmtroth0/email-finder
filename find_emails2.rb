require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'set'

Capybara.current_driver = :selenium
# takes a domain name and initializes capybara
Capybara.app_host = "http://#{ARGV[0]}"

module DomainReader
  class EmailSearch
    include Capybara::DSL

    # recursive method to check through angular apps
    def check_page(extension = "/")
      visit(extension)
      find_email_addresses
      page.all('*[ng-click^="changeRoute"]')
          .each do |link|
            next unless validate_link(link)

            # range from 13 to the second to last accounts for the angular method 'changeRoute'
            visited_urls << link['ng-click'][13...-2]
            check_page("/#{link['ng-click'][13...-2]}")
          end
    end

    def validate_link (link)
      !link.nil? &&
        !link['ng-click'].nil? &&
        !visited_urls.include?(link['ng-click'][13...-2])
    end

    def find_email_addresses
      current_addresses = page.all('a[href]')
                            .map { |a| a['href'].match(/\w+@\w+\.\w+/) }
                            .select { |href| !href.nil? }
                            .each { |email| email_addresses << email.to_s }
    end

    def email_addresses
      @email_addresses ||= Set.new
    end

    def visited_urls
      @visited_urls ||= Set.new
    end
  end
end

t = DomainReader::EmailSearch.new
puts "Searching..."
t.check_page
puts "Found emails:"
t.email_addresses.each { |email| puts email }
puts "..."
