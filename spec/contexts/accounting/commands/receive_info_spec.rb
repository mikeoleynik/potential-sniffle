RSpec.describe Accounting::Commands::ReceiveInfo, type: :command do
  subject { command.call({ account_id: account_id, cat_toy_id: cat_toy_id }) }

  let(:command) { described_class.new(account_repo: account_repo, cat_toy_repo: cat_toy_repo) }

  let(:account_id) { 1 }
  let(:account_repo) { instance_double('Accounting::Repositories::Account', find: account, update: account) }
  let(:account) { Accounting::Entities::Account.new(id: 1, point: 100, state: 'active') }

  let(:cat_toy_id) { 1 }
  let(:cat_toy_repo) { instance_double('ToyTesting::Repositories::CatToy', find: cat_toy) }
  let(:cat_toy) do
    ToyTesting::Entities::CatToy.new(
      id: 1, account_id: 1, comment: '', tested: true, negative: false, characteristic_type: 'playful', value: 'qw12'
    )
  end

  context 'успех' do
    it { expect(subject).to be_success }
    it { expect(subject.value!).to eq(account) }
  end

  context 'когда не находит аккаунт' do
    let(:account_repo) { instance_double('Accounting::Repositories::Account', find: nil) }

    it { expect(subject).to be_failure }
    it { expect(subject.failure).to eq([:account_not_founded, { account_id: account_id }]) }
  end

  context 'когда не находит игрушку' do
    let(:cat_toy_repo) { instance_double('ToyTesting::Repositories::CatToy', find: nil) }

    it { expect(subject).to be_failure }
    it { expect(subject.failure).to eq([:toy_not_founded, { cat_toy_id: cat_toy_id }]) }
  end

  context 'игрушка не протестирована' do
    let(:cat_toy) do
      ToyTesting::Entities::CatToy.new(
        id: 1, account_id: 1, comment: '', tested: false, negative: false, characteristic_type: 'playful', value: 'qw12'
      )
    end

    it { expect(subject).to be_failure }
    it { expect(subject.failure).to eq([:no_testing, { cat_toy_id: cat_toy_id }]) }
  end
end