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


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
