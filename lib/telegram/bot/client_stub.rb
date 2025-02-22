module Telegram
  module Bot
    # Stubbed client for tests. Saves all requests into #requests hash.
    class ClientStub < Client
      attr_reader :requests

      module StubbedConstructor
        def new(*args)
          if self == ClientStub || !ClientStub.stub_all?
            super
          else
            ClientStub.new(args[1])
          end
        end
      end

      class << self
        # Makes all
        def stub_all!(enabled = true)
          Client.extend(StubbedConstructor) unless Client < StubbedConstructor
          return @_stub_all = enabled unless block_given?
          begin
            old = @_stub_all
            stub_all!(enabled)
            yield
          ensure
            stub_all!(old)
          end
        end

        def stub_all?
          @_stub_all
        end
      end

      def initialize(username = nil)
        @username = username
        reset
      end

      def reset
        @requests = Hash.new { |h, k| h[k] = [] }
      end

      def request(action, body)
        requests[action.to_sym] << body
      end
    end
  end
end
