require "activerecord-concernable/version"

module ActiveRecord
  module Concernable
    # Defines a concern.
    #
    # Concern will be named by convention below the ::Concerns module. Concern
    # will be wrapped in namespace named by convention from the class defining the
    # concern. For example, a User concern within the Notification class would
    # be available at ::Concerns::Notification::User
    #
    # By convention, if a class is passed as the concern name, the concern will be
    # automatically mixed into the passed class. If this functionality is not
    # desirable, pass the name as a symbol i.e. :user.
    #
    # To mix into additional classes, pass them classes as an array to the of
    # option key.
    #
    # Example:
    #
    #   class Notification
    #     extend Concernable
    #
    #     concern :user do
    #       included do
    #         has_many :notifications
    #       end
    #     end
    #
    #     concern :notifiable, of: [Comments, Posts] do
    #       include do
    #         has_many :notifications, as: :subject, dependent: :destroy
    #       end
    #
    #       def create_notifcation(*args)
    #         notications.create(*args)
    #       end
    #     end
    #   end
    #
    def concern(name, opts={}, &block)
      namespace = self.to_s.split('::').reduce(::Concerns) do |namespace, module_name|
        namespace.const_defined?(module_name, false) ? namespace.const_get(module_name) : namespace.const_set(module_name, Module.new)
      end

      # Create and populate concern module.
      camelized_name = name.to_s.camelize
      concern = Module.new
      concern.send(:extend, ActiveSupport::Concern)
      concern.class_eval(&block)
      concern = namespace.const_set(camelized_name, concern)

      # Mix-in concern
      opts.symbolize_keys!
      opts[:of] = Array(opts[:of])
      opts[:of] << name if name.instance_of? Class
      Array(opts[:of]).each { |klass| klass.send(:include, concern) }
    end

  end
end

# Defines namespace for where concerns will be defined to.
module Concerns; end

# Extend Active Record Base with Concernable.
ActiveRecord::Base.extend ActiveRecord::Concernable
