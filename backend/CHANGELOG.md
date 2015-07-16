## Comable 0.6.0 (July 16, 2015) ##

*   Rename this gem: comable_backend => comable-backend


## Comable 0.5.0 (June 29, 2015) ##

*   Implement Themes.

*   Implement Pages.

*   Implement functionaly to edit order items.

*   Add Turbolinks.

*   Improve the navigation of the admin panel.

*   Fix a problem that cannot add a new category on Firefox.


## Comable 0.4.2 (June 01, 2015) ##

*   Commonize the app name and the homepage url.

*   Fix a bug that raise an exception when the customer access to
    the admin panel.


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

*   Implement functionality to export.

    - products
    - stocks
    - orders

*   Implement functionality to import.

    - products
    - stocks

*   Implement functionality to change the state of orders.

*   Implement shipments and payments.

*   Implement functionality to edit orders.

*   Implement trackers.


## Comable 0.3.4 (April 07, 2015) ##

*   Fix the problem that pace-rails does not work.

*   Implement advanced search.

*   Add locales for English.

*   Add gritter assets to precompile.


## Comable 0.3.3 (March 03, 2015) ##

*   Support Ruby 2.2.0

*   Support Rails 4.2

*   Improve look and feel

*   Fix manager of categories to work

*   Fix the problem that would be created two images when add a new product.


## Comable 0.3.2 (February 10, 2015) ##

*   Remove gems of rails-asstes.org.


## Comable 0.3.1 (February 05, 2015) ##

*   No changes.


## Comable 0.3.0 (February 04, 2015) ##

*   Implement the look and feel.

*   Fix requirements of gemspec.
    Add an upper limit on the version of Rails.


## Comable 0.2.3 (November 30, 2014) ##

*   No changes.


## Comable 0.2.2 (November 04, 2014) ##

*   No changes.


## Comable 0.2.1 (October 29, 2014) ##

*   No changes.


## Comable 0.2.0 (September 29, 2014) ##

*   Implement feature for store settings.

*   Implement feature for shipments.


## Comable 0.1.0 (September 18, 2014) ##

*   Change versioning.

*   Initialize gem.
