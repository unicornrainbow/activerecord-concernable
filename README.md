# Activerecord::Concernable

A DSL for defining ActiveRecord concerns.

## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-concernable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-concernable

## Usage

The concernable DSL is available from within any object that inherits from
ActiveRecord::Base. The DSL consist of a single command `concern`. Use this
command to define concerns for the object. The body of the concern follows the
same rules that of ActiveSupport::Concern.

Defining a concern.

    class Notification < ActiveRecord::Base

      belongs_to :user
      belongs_to :notifiable, polymorphic: true

      # Extend user with has_many :notifications. When concern is passed a class
      # the generated concern will automatically be mixed into the class.
      concern User do
        included do
          has_many :notifications
        end
      end

      # Create a named concern by passing a symbol. Mix into any number of
      # classes by passing them to of.
      concern :notifiable, of: [Comments, Posts] do
        include do
          has_many :notifications, as: :subject, dependent: :destroy
        end

        def create_notification(message)
          notifications.create(message: message)
        end
      end
    end

### Why would I want to do this?

The primary reason for using the DSL is to keep active record models skinny and
well defined and to avoid the inevitability of, for example, the monolithic User
model.

The idea is that as new models are introduced, the generally will be related,
and therefore "concerned" with other models in the system. To a large extent,
this is the very point of relational data and activerecord. This creates real
pain points at the cruxes of the domain model, User being the prime example in
many case. I refer to these classes as "Core Classes" or "Tier I". There can be
multiple Tiers in the system, depending on how stratified the system is.

The reason for pain points is because with each new model introduced to the
system, which is concerned with one of these Core objects, there is generally an
inverse relationship (and functionality) of the Core class now being concerned
with it. The commonality is that prior to the new class (and concern), the core
class could have cared less, but now it's required to become a dumping ground
for the additional functionality.

The simple solution, is to not add additional code to the centralized definition
of the core class when adding a new associated class, but to instead add a
concern that will be mixed in. This is essentially what the DSL does, but takes
things a few steps further, by allowing you to easily nest the concern
definition right inside the dependent model and then allowing you to mix it into
the dependant classes by default.

At the end of the day, activerecord-concernable allows you to move associated
functionality around interrelated classes to keep an even distribution of code
with no lumps.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
