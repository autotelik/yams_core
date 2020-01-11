require 'rails-settings-cached'

module YamsCore

  class SettingExtension < ::RailsSettings::Base

    # Extend the base class so we can access the fields anonymously or in loops
    #
    class << self

      # Extend the base class to build more useful dynamic helpers
      def field(key, **opts)
        add_name(key)
        add_type(key,  opts[:type])
        add_docs(key,  opts[:docs])
        add_enums(key, opts[:enum])
        add_readonly(key) if opts[:readonly] == true
        super
      end

      # Return the value of the supplied Field
      #
      def fetch(key)
        send(key)
      end

      # Set the value of the supplied Field, if it's not readonly
      #
      def set(key, value)
        cmd = "#{key}="

        return send(cmd, value.to_s.casecmp('true').zero?) if boolean?(key) && respond_to?(cmd)

        send(cmd, value.strip) if respond_to?(cmd) && value.present?
      end

      # Helpers

      def add_docs(key, text)
        documentation[key] = text if text.present?
      end

      def add_enums(key, enum)
        enums[key] = enum if enum.present?
      end

      def add_name(key)
        names << key
      end

      def add_type(key, type)
        field_types[key] = type if type.present?
      end

      def add_readonly(key)
        readonly_fields <<  key
      end

      # FETCHERS
      #
      def array?(key)
        field_types[key] == :array
      end

      def boolean?(key)
        field_types[key] == :boolean
      end

      def enum?(key)
        field_types[key] == :enum
      end

      # Return the docs for the supplied field
      #
      def docs(key)
        documentation[key]
      end

      # Return the validating enum list of the supplied enum field
      #
      def enum_for(key)
        enums[key]
      end

      # Return the type of the supplied field
      #
      def field_type(key)
        field_types[key]
      end

      # Return true if supplied Field is readonly
      #
      def readonly?(key)
        readonly_fields.include?(key)
      end

      #################
      ## COLLECTIONS ##
      #################

      # Return a map of Field -> Documentation
      #
      def documentation
        @documentation ||= {}.with_indifferent_access
      end

      def enums
        @enums ||= {}.with_indifferent_access
      end

      # Return the list of all Field names
      #
      def names
        @names ||= []
      end

      # Return a map of Field -> Type
      #
      def field_types
        @field_types ||= {}.with_indifferent_access
      end

      # Return the list of all Fields that are readonly
      #
      def readonly_fields
        @readonly_fields ||= []
      end

    end
  end

end
