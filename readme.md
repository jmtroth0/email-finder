# Email Finder

> Command line crawler to find emails within a domain

> Uses spidr to scrape for hrefs

## To Use

> Make sure you have the spidr crawler. If you're not sure, run `gem install spidr`

> Then run `ruby find_emails.rb`, giving it a domain, like `nytimes.com`, as an argument.

> When it prompts you for a page limit, either give it a number or, if you don't want a limit, just press enter.

## Limitations

> Many apps do not adhere to typical crawling standards instead relying on listeners and internal callbacks or hooks for navigation, like Backbone using history.navigate and Angular's location path. Luckily for them, Google's crawler is more advanced than the typical library.

> However, most crawling libraries, including Spidr, won't be able to scrape those that don't use hrefs for navigation.

> I also assume that all requested domains are http. If they are more secured, they are often unfriendly to crawlers anyway.
