require 'flipper/ui/configuration/option'

module Flipper
  module UI
    class Configuration
      attr_reader :delete

      attr_accessor :banner_text,
                    :banner_class

      # Public: If you set this, the UI will always have a first breadcrumb that
      # says "App" which points to this href. The href can be a path (ie: "/")
      # or full url ("https://app.example.com/").
      attr_accessor :application_breadcrumb_href

      # Public: Object to repond to `.call` with an object that reponds to permit (boolean) and message (string).
      # Defaults to nil.
      # If set to falsey value, users of the UI can perform all actions.
      # If set to object, users will be authed per action performed
      attr_accessor :authorization

      # Public: Is feature creation allowed from the UI? Defaults to true. If
      # set to false, users of the UI cannot create features. All feature
      # creation will need to be done through the configured flipper instance.
      attr_accessor :feature_creation_enabled

      # Public: Is feature deletion allowed from the UI? Defaults to true. If
      # set to false, users won't be able to delete features from the UI.
      attr_accessor :feature_removal_enabled

      # Public: Are you feeling lucky? Defaults to true. If set to false, users
      # won't see a videoclip of Taylor Swift when there aren't any features
      attr_accessor :fun

      # Public: What should show up in the form to add actors. This can be
      # different per application since flipper_id's can be whatever an
      # application needs. Defaults to "a flipper id".
      attr_accessor :add_actor_placeholder

      # Public: If you set this, Flipper::UI will fetch descriptions
      # from your external source. Descriptions for `features` will be shown on `feature`
      # page, and optionally the `features` pages. Defaults to empty block.
      attr_accessor :descriptions_source

      # Public: Should feature descriptions be show on the `features` list page.
      # Default false. Only works when using descriptions.
      attr_accessor :show_feature_description_in_list

      VALID_BANNER_CLASS_VALUES = %w(
        danger
        dark
        info
        light
        primary
        secondary
        success
        warning
      ).freeze

      DEFAULT_DESCRIPTIONS_SOURCE = ->(_keys) { {} }

      def initialize
        @delete = Option.new("Danger Zone", "Deleting a feature removes it from the list of features and disables it for everyone.")
        @banner_text = nil
        @banner_class = 'danger'
        @feature_creation_enabled = true
        @feature_removal_enabled = true
        @fun = true
        @add_actor_placeholder = "a flipper id"
        @descriptions_source = DEFAULT_DESCRIPTIONS_SOURCE
        @show_feature_description_in_list = false
        @authorization = Struct.new(:present?).new(false)
      end

      def using_descriptions?
        @descriptions_source != DEFAULT_DESCRIPTIONS_SOURCE
      end

      def show_feature_description_in_list?
        using_descriptions? && @show_feature_description_in_list
      end

      def banner_class=(value)
        unless VALID_BANNER_CLASS_VALUES.include?(value)
          raise InvalidConfigurationValue, "The banner_class provided '#{value}' is " \
            "not one of: #{VALID_BANNER_CLASS_VALUES.join(', ')}"
        end
        @banner_class = value
      end
    end
  end
end
