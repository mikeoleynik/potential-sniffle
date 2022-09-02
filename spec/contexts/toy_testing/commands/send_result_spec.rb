RSpec.describe ToyTesting::Commands::SendResult, type: :command do
  subject do
    command.call({ account_id: account_id, cat_toy_id: cat_toy_id, characteristic_type: 'playful', value: 'qw12' })
  end

  let(:command) { described_class.new(account_repo: account_repo, cat_toys_repo: cat_toy_repo) }

  let(:account_id) { 1 }
  let(:account_repo) { instance_double('ToyTesting::Repositories::Account', find: account) }
  let(:account) { ToyTesting::Entities::Account.new(id: 1, point: 100, state: 'active', toys_count: 0, toys_ids: []) }

  let(:cat_toy_id) { 1 }
  let(:cat_toy_repo) { instance_double('ToyTesting::Repositories::CatToy', find: cat_toy, update: cat_toy) }
  let(:cat_toy) do
    ToyTesting::Entities::CatToy.new(
      id: 1, account_id: 1, comment: '', tested: false, negative: false, characteristic_type: 'playful', value: 'qw12'
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

  context 'много игрушка уже протестирована' do
    let(:cat_toy) do
      ToyTesting::Entities::CatToy.new(
        id: 1, account_id: 1, comment: '', tested: true, negative: false, characteristic_type: 'playful', value: 'qw12'
      )
    end

    it { expect(subject).to be_failure }
    it { expect(subject.failure).to eq([:already_tested, { cat_toy_id: cat_toy_id }]) }
  end

  context 'много игрушка имеет отрицательный отзыв' do
    let(:cat_toy) do
      ToyTesting::Entities::CatToy.new(
        id: 1, account_id: 1, comment: '', tested: false, negative: true, characteristic_type: 'playful', value: 'qw12'
      )
    end

    it { expect(subject).to be_failure }
    it { expect(subject.failure).to eq([:negative_characteristics, { cat_toy_id: cat_toy_id }]) }
  end
end
