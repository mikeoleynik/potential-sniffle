module InMemory
  module Transport
    class AccountingRequest
      include Import[service: 'contexts.accounting.service']

      def call
        puts 'Hello from in_memory/transport/accounting_request'
        puts 'Call logic:'
        puts
        sleep 0.5

        service.call

        puts
        sleep 0.5
        puts 'Request done'
      end
    end
  end
end