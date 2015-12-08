# Email Finder

> Command line crawler to find emails within a domain

> Uses spidr to scrape for hrefs

> Second file version crawls an angular app for emails, through the ngclick directed to a changeRoute method

## Spidr Email Crawler

### To Use General Find Emails

> Make sure you have the spidr crawler. If you're not sure, run `gem install spidr`

> Then run `ruby find_emails.rb`, giving it a domain, like `www.nytimes.com`, as an argument.

> When it prompts you for a page limit, either give it a number or, if you don't want a limit, just press enter.

### Limitations

> Many apps do not adhere to typical crawling standards instead relying on listeners and internal callbacks or hooks for navigation, like Backbone using history.navigate and Angular's location path. Luckily for them, Google's crawler is more advanced than the typical library.

> However, most crawling libraries, including Spidr, won't be able to scrape those that don't use hrefs for navigation.


## Angular Email Crawler

> Because of the limitations, I built another version that checks for ng-click properties on objects that include the changeRoute method. This one relies on capybara.

> To run it, make sure capybara is installed. `gem install capybara` should also work, but if not, follow the instructions at https://github.com/jnicklas/capybara#setup.

> Then, run in the same way, executing `ruby find_emails2.rb` from the command line, giving it a domain name.
