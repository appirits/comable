## Comable 0.7.1 (November 29, 2015) ##

*   Improve performance in frontend.

    - Add fragment caching for products.
    - Add indexes to variants and stocks.


## Comable 0.7.0 (November 20, 2015) ##

*   Add a index to orders to improve performance in frontend.

    - Products page
    - Home page


## Comable 0.7.0.beta2 (October 31, 2015) ##

*   Implement Multiple Shipments.

*   Implement Product Property.

*   bugfix: Cannot add a variant to the cart.


## Comable 0.7.0.beta1 (September 25, 2015) ##

*   Implement Navigations.

*   Implement the visibility of Products.

*   Change the architecture of stocks.
    Implement Variant, OptionType and OptionValue.

*   Fix the problem that cannot rescue exceptions for Payment.


## Comable 0.6.0 (July 16, 2015) ##

*   Rename this gem: comable_frontend => comable-frontend


## Comable 0.5.0 (June 29, 2015) ##

*   Implement Themes.

*   Implement Pages.


## Comable 0.4.2 (June 01, 2015) ##

*   Commonize the app name and the homepage url.

*   Implement the home page.


## Comable 0.4.1 (May 15, 2015) ##

*   Remove database index name.

*   Remove FactoryGirl prefix form tests.

*   Add timestamps to all tables.

*   Change the condition to send email to customer.

    - Remove `Comable::Store#email_activate_flag` column.
    - Rename column: `Comable::Store#email_sender` => `Comable::Store#email`

*   Rename flag columns.

    - `Comable::ShipmentMethod#activate_flag` => `#activated_flag`
    - `Comable::Tracker#activate_flag` => `#activated_flag`


## Comable 0.4.0 (May 15, 2015) ##

*   Rename models.

    - `Comable::Customer` => `Comable::User`
    - `Comable::OrderDetail` => `Comable::OrderItem`

*   Implement trackers.


## Comable 0.3.4 (April 07, 2015) ##

*   Add locales for English.


## Comable 0.3.3 (March 03, 2015) ##

*   Support Ruby 2.2.0

*   Support Rails 4.2


## Comable 0.3.2 (February 10, 2015) ##

*   Remove gems of rails-asstes.org.


## Comable 0.3.1 (February 05, 2015) ##

*   No changes.


## Comable 0.3.0 (February 04, 2015) ##

*   Improve validations for quantity.

*   Remove the order deliveries table.

*   Improve the order flow.
    Add state_mashine gem for status management.

*   Change the number of cart items.
    "Number of items" to "Total number of item quantities".

*   Implement featues (products search, category, products image, pagination).

*   Fix a bug that error occured when email address is empty.

*   Implement the look and feel.

*   Fix requirements of gemspec.
    Add an upper limit on the version of Rails.


## Comable 0.2.3 (November 30, 2014) ##

*   Refactor the order flow.

*   Implement billing and shipping addresses for the order and customer.


## Comable 0.2.2 (November 04, 2014) ##

*   Implement the members feature.

*   Improve the order completion.


## Comable 0.2.1 (October 29, 2014) ##

*   Fix a bug that app side namespace is used.

*   Improve the error for no stock.


## Comable 0.2.0 (September 29, 2014) ##

*   Implement the order completion mail.

*   Implement feature for store settings.

*   Improve calculation at checkout.

*   Implement feature for shipments.


## Comable 0.1.0 (September 18, 2014) ##

*   Initialize gem.
