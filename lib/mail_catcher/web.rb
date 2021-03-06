require "rack/builder"

require "mail_catcher/web/application"

module MailCatcher
  module Web extend self

    def http_prefix=(prefix)
      prefix += "/" if not prefix.end_with?("/")
      @http_prefix = prefix
    end

    def http_prefix
      @http_prefix.nil? ? "/" : @http_prefix
    end

    def app
      @@app ||= Rack::Builder.new do
        map(MailCatcher.options[:http_path]) do
          if MailCatcher.development?
            require "mail_catcher/web/assets"
            map("/assets") { run Assets }
          end

          run Application
        end

        # This should only affect when http_path is anything but "/" above
        run lambda { |env| [302, {"Location" => MailCatcher.options[:http_path]}, []] }
      end
    end

    def call(env)
      app.call(env)
    end
  end
end
