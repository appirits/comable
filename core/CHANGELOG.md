## Comable 0.5.0 (June 29, 2015) ##

*   Implement Themes.

*   Implement Pages.

*   Implement functionaly to edit order items.


## Comable 0.4.2 (June 01, 2015) ##

*   Commonize the app name and the homepage url.

*   Implement comable_sample gem.

*   Change the condition of `completed?` methods.


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

*   Remove deprecated methods.

    - `Comable::Order#soldout_stocks`
    - `Comable::OrderItem#soldout_stock?`
    - `Comable::Product#unsold?`
    - `Comable::Product#soldout?`
    - `Comable::Stock.unsold`
    - `Comable::Stock.soldout`
    - `Comable::Stock#unsold?`
    - `Comable::Stock#soldout?`

*   Fix validations of Order.

*   Implement functionality to export.

    - products
    - stocks
    - orders

*   Implement functionality to import.

    - products
    - stocks

*   Implement functionality to change the state of orders.

*   Rename the method and change to throw an exception.
    `Comable::Order#complete` => `#complete!`

*   Implement shipments and payments.

*   Rename the state.
    `complete` => `completed`

*   Implement functionality to edit orders.

*   Implement trackers.


## Comable 0.3.4 (April 07, 2015) ##

*   Rename the depecated method.
    `ensure_length_of` => `validate_length_of`.

*   Implement the generator.

*   Change method names on Stock model.

*   Add locales for English.


## Comable 0.3.3 (March 03, 2015) ##

*   Support Ruby 2.2.0

*   Support Rails 4.2

*   Add required_ruby_version to gemspec

*   Add version specifiers to gemspec


## Comable 0.3.2 (February 10, 2015) ##

*   Remove jquery-rails.


## Comable 0.3.1 (February 05, 2015) ##

*   No changes.


## Comable 0.3.0 (February 04, 2015) ##

*   Improve validations for quantity.

*   Remove deprecated methods and columns.

    - Order#preorder
    - orders.family_name, orders.first_name
    - customers.family_name, customers.first_name
    - Stock#decriment!
    - stocks.product_id_num

*   Remove the order deliveries table.

*   Improve the order flow.
    Add state_mashine gem for status management.

*   Change names of method, column, and table.

    - Order#complete? => Order#completed?
    - stores.meta_keyword => stores.meta_keywords
    - payment_methods => payment_providers
    - payments => payment_methods
    - *.comable_*_id => *.*_id

*   Move the CartOwner module to concerns.

*   Change the number of cart items.
    "Number of items" to "Total number of item quantities".

*   Implement featues (products search, category, products image, pagination).

*   Add brakeman gem.

*   Fix requirements of gemspec.
    Add an upper limit on the version of Rails.


## Comable 0.2.3 (November 30, 2014) ##

*   Destroy the address when destroy the order or customer.

*   Copy new addresses from the order to the customer.

*   Fix to inherit cart items when guest to sign in.

*   Implement billing and shipping addresses for the order and customer.


## Comable 0.2.2 (November 04, 2014) ##

*   Implement the members feature.

*   Improve the order completion.


## Comable 0.2.1 (October 29, 2014) ##

*   Improve the error for no stock.


## Comable 0.2.0 (September 29, 2014) ##

*   Add columns to order details.

*   Implement the order completion mail.

*   Implement feature for store settings.

*   Improve calculation at checkout.

*   Implement feature for shipments.

*   Implement the callback for the order to complete.
    You can use `before_complete`, `around_complete` and `after_complete` callbacks.

*   Remove decorator. Because it can be controlled by the application.
    Also, in order to simplify the gem.


## Comable 0.1.0 (September 18, 2014) ##

*   Change versioning.

*   Initialize gem.
