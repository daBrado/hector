module Hector
  class Identity
    attr_accessor :username

    class << self
      attr_accessor :adapter

      def permit_no_password?
        adapter.respond_to?(:permit_no_password?) && adapter.permit_no_password?
      end

      def authenticate(username, password)
        adapter.authenticate(username, password) do |authenticated|
          yield authenticated ? new(username) : nil
        end
      end
    end

    def initialize(username)
      @username = username
    end

    def ==(identity)
      Identity.adapter.normalize(username) == Identity.adapter.normalize(identity.username)
    end
  end
end
