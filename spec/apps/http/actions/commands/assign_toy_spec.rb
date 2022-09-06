# frozen_string_literal: true

RSpec.describe HTTP::Actions::Commands::AssignToy, type: :http_action do
  subject { action.call(params) }

  let(:action) { described_class.new(command: command) }
  let(:params) { { account_id: 12, id: 1 } }

  let(:account) { ToyTesting::Entities::Account.new(id: 1, point: 100, state: 'active', toys_count: 0, toys_ids: []) }

  context 'успешный результат' do
    let(:command) { ->(*) { Success(account) } }

    it { expect(subject.status).to eq(200) }
    it { expect(subject.body.first).to eq({ id: 1, toys_count: 0, toys_ids: [] }.to_json) }

    it 'вызывается команда' do
      expect(command).to receive(:call).with(cat_toy_id: 1, account_id: 12).and_return(Success(account))
      subject
    end
  end

  context 'когда результат фейлится' do
    context 'когда аккаунт не найден' do
      let(:command) { ->(*) { Failure([:account_not_founded, { error: 'account_not_founded', account_id: 12 }]) } }

      it { expect(subject.status).to eq(404) }
      it { expect(subject.body.first).to eq({ error: 'account_not_founded', account_id: 12 }.to_json) }

      it 'вызывается команда' do
        expect(command).to receive(:call)
          .with(cat_toy_id: 1, account_id: 12).and_return(Failure([:account_not_founded, {}]))

        subject
      end
    end

    context 'когда у аккаунта много игрушек в очереди' do
      let(:command) { ->(*) { Failure([:many_toys, { error: 'many_toys', account_id: 12 }]) } }

      it { expect(subject.status).to eq(422) }
      it { expect(subject.body.first).to eq({ error: 'many_toys', account_id: 12 }.to_json) }

      it 'вызывается команда' do
        expect(command).to receive(:call)
          .with(cat_toy_id: 1, account_id: 12).and_return(Failure([:many_toys, {}]))

        subject
      end
    end
  end
end