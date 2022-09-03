# frozen_string_literal: true

require "hanami/api"
require "hanami/middleware/body_parser"
require 'hanami/action'
require "hanami/router"

module HTTP
  class App < Hanami::API
    use Hanami::Middleware::BodyParser, :json

    get '/' do
      'Hello, World'
    end

    get '/toys_for_testing', to: Container['http.actions.queries.show_toys_for_testing']

    scope "api" do
      scope "v1" do
        post "/assign_toy/:id", to: Container['http.actions.commands.assign_toy']
        post "/send_result", to: Container['http.actions.commands.send_result']
      end
    end
  end
end