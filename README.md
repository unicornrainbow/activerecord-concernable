# Activerecord::Concernable

A DSL for defining ActiveRecord concerns.

## Installation

**Detour:** Because or the recent Rubygems vulnerability exploit, they're not
currently accepting new gems so I haven't been able to publish it. In the mean
time, you can install the gem with bundler as follow.

    # File: ./Gemfile
    gem "activerecord-concernable", "~> 0.4.0", :git => "git://github.com/blakefrost/activerecord-concernable.git"

## Usage

The Concernable DSL is available within any ActiveRecord::Base. The DSL consist
of a single command `concern`. Use it to define concerns for the object. The
body of the concern follows the same rules that of [ActiveSupport::Concern][1].

Defining concerns:

    class Notification < ActiveRecord::Base

      belongs_to :user
      belongs_to :notifiable, polymorphic: true

      # Extend user with has_many :notifications. When concern is passed a class
      # the generated concern will automatically be mixed into that class.
      concern User do
        included do
          has_many :notifications
        end
      end

      # Create a named concern by passing a symbol. Mix into any number of
      # classes by passing them as `:of` in the options hash.
      concern :notifiable, of: [Comments, Posts] do
        included do
          has_many :notifications, as: :subject, dependent: :destroy
        end

        def create_notification(message)
          notifications.create(message: message)
        end
      end
    end

### Why would I want to do this?

The primary reason for using the DSL is to keep ActiveRecord models skinny and
well defined, and to avoid the inevitability of monolithic model object (1000
line user.rb anyone?).

The idea is that as new models are introduced, they will often be related, and
therefore "concerned" with other models in the system. To a large extent, this
is the very point of relational data and ActiveRecord. Unfortunately, This
creates pain points at the cruxes of the domain model. New objects are concerned
with the popular objects, and the popular objects accumulate the inverse
concerns and functionality.

Concern modules can solve this problem is by allowing you to avoid adding
additional code to the centralized definition of the core class when adding a
new associated class. Instead, you simply add a concern and mix it in.

This is essentially what the DSL does, but takes things a few steps further, by
allowing you to easily nest the concern definition right inside the dependent
model and then mix into the dependant classes unobtrusively.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[1]: http://api.rubyonrails.org/classes/ActiveSupport/Concern.html
