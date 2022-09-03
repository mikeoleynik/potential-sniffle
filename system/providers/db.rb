require 'rom'
require 'rom-sql'

Container.register_provider(:db) do
  prepare do
    require 'pg'

    opts = {
      username: 'dry_user',
      password: ENV['PG_PASSWORD'],
      encoding: 'UTF8'
    }

    ROM::Configuration.new(:sql, 'postgres://localhost:5432/dry_course', opts)
  end

  start do
    rom = ROM.container(:sql, 'postgres://localhost:5432/dry_course', username: 'dry_user', password: ENV['PG_PASSWORD']) do |conf|
      class Accounts < ROM::Relation[:sql]
        schema(infer: true)
      end

      class CatToys < ROM::Relation[:sql]
        schema(infer: true)
      end

      conf.register_relation(Accounts)
      conf.register_relation(CatToys)
    end

    register('persistance.toy_testing.repositories.account.rom', ToyTesting::Repositories::Account.new(container: rom))
    register('persistance.toy_testing.repositories.cat_toy.rom', ToyTesting::Repositories::CatToy.new(container: rom))
    register('persistance.accounting.repositories.account.rom', Accounting::Repositories::Account.new(container: rom))
  end

  stop do
    # ...
  end
end

