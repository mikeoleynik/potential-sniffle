require 'json'
require 'hanami/action'

module HTTP
  module Actions
    module Commands
      class SendResult < Hanami::Action
        include Dry::Monads[:result]

        include Import[
          configuration: 'hanami.action.configuration',
          command: 'contexts.toy_testing.commands.send_result'
        ]

        def handle(req, res)
          result = command.call(
            account_id: req.params[:account_id].to_i,
            cat_toy_id: req.params[:cat_toy_id].to_i,
            characteristic_type: req.params[:characteristic_type],
            value: req.params[:value]
          )

          case result
          in Success
            res.status  = 200
            res.body    = { account_id: result.value!.id }.to_json
          in Failure[_, error_message]
            halt 422, error_message.to_json
          end
        end
      end
    end
  end
end