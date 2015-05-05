class Premailer
  module Rails
    module CSSLoaders
      module NetworkLoader
        extend self

        def load(url)
          uri = uri_for_url(url)
          Net::HTTP.get(uri) if uri
        end

        def uri_for_url(url)
          uri = URI(url)
          if not valid_uri?(uri) and defined?(::Rails)
            asset_uri = URI(::Rails.configuration.action_controller.asset_host) rescue return
            uri.host ||= asset_uri.host
            uri.port ||= asset_uri.port
            unless uri.scheme
              uri.scheme = asset_uri.scheme || 'http'
              uri = URI(uri.to_s)
            end
          end

          uri if valid_uri?(uri)
        end

        def valid_uri?(uri)
          uri.host.present? && uri.scheme.present?
        end

        def asset_host
          host = ::Rails.configuration.action_controller.asset_host

          if host.respond_to?(:call)
            host.call
          else
            host
          end
        end
      end
    end
  end
end
