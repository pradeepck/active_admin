module ActiveAdmin
  module ViewHelpers
    module FormHelper

      # Flatten a params Hash to an array of fields.
      #
      # @param params [Hash]
      # @param options [Hash] :namespace and :except
      #
      # @return [Array] of [Hash] with one element.
      #
      # @example
      #   fields_for_params(scope: "all", users: ["greg"])
      #     => [ {"scope" => "all"} , {"users[]" => "greg"} ]
      #
      def fields_for_params(params, options = {})
        namespace = options[:namespace]
        except = options[:except]

        params.map do |k, v|
          next if namespace.nil? && %w(controller action commit utf8).include?(k.to_s)
          next if except && k.to_s == except.to_s

          if namespace
            k = "#{namespace}[#{k}]"
          end

          case v
          when String
            { k => v }
          when Hash
            fields_for_params(v, :namespace => k)
          when Array
            v.map do |v|
              { "#{k}[]" => v }
            end
          else
            raise "I don't know what to do with #{v.class} params: #{v.inspect}"
          end
        end.flatten.compact
      end
    end
  end
end
