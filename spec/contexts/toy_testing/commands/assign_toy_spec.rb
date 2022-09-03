RSpec.describe ToyTesting::Commands::AssignToy, type: :command do
  subject { command.call({ account_id: account_id, cat_toy_id: cat_toy_id }) }

  let(:command) { described_class.new(account_repo: account_repo) }

  let(:account_id) { 1 }
  let(:account_repo) { instance_double('ToyTesting::Repositories::Account', find: account, update: account) }
  let(:account) { ToyTesting::Entities::Account.new(id: 1, point: 100, state: 'active', toys_count: 0, toys_ids: []) }

  let(:cat_toy_id) { 1 }

  context 'успех' do
    it { expect(subject).to be_success }
    it { expect(subject.value!).to eq(account) }
  end

  context 'когда не находит аккаунт' do
    let(:account_repo) { instance_double('Accounting::Repositories::Account', find: nil) }

    it { expect(subject).to be_failure }
    it { expect(subject.failure).to eq([:account_not_founded, { error: 'account_not_founded', account_id: account_id }]) }
  end

  context 'много игрушек в очереди' do
    let(:account) { ToyTesting::Entities::Account.new(id: 1, point: 100, state: 'active', toys_count: 3, toys_ids: []) }

    it { expect(subject).to be_failure }
    it { expect(subject.failure).to eq([:many_toys, { error: 'many_toys', account_id: account_id }]) }
  end
end
