# frozen_string_literal: true

RSpec.describe HTTP::Actions::Commands::SendResult, type: :http_action do
  subject { action.call(params) }

  let(:action) { described_class.new(command: command) }
  let(:params) { { account_id: 12, cat_toy_id: 1, characteristic_type: 'playful', value: 'qw12' } }

  let(:account) { ToyTesting::Entities::Account.new(id: 1, point: 100, state: 'active', toys_count: 0, toys_ids: []) }

  context 'успешный результат' do
    let(:command) { ->(*) { Success(account) } }

    it { expect(subject.status).to eq(200) }
    it { expect(subject.body.first).to eq({ account_id: 1 }.to_json) }

    it 'вызывается команда' do
      expect(command).to receive(:call)
        .with(account_id: 12, cat_toy_id: 1, characteristic_type: 'playful', value: 'qw12')
        .and_return(Success(account))

      subject
    end
  end

  context 'когда результат фейлится' do
    context 'когда аккаунт не найден' do
      let(:command) { ->(*) { Failure([:account_not_founded, { error: 'account_not_founded', account_id: 12 }]) } }

      it { expect(subject.status).to eq(422) }
      it { expect(subject.body.first).to eq({ error: 'account_not_founded', account_id: 12 }.to_json) }

      it 'вызывается команда' do
        expect(command).to receive(:call)
          .with(account_id: 12, cat_toy_id: 1, characteristic_type: 'playful', value: 'qw12')
          .and_return(Failure([:account_not_founded, {}]))

        subject
      end
    end

    context 'когда у игрушка не найдена' do
      let(:command) { ->(*) { Failure([:toy_not_founded, { error: 'toy_not_founded', cat_toy_id: 12 }]) } }

      it { expect(subject.status).to eq(422) }
      it { expect(subject.body.first).to eq({ error: 'toy_not_founded', cat_toy_id: 12 }.to_json) }

      it 'вызывается команда' do
        expect(command).to receive(:call)
          .with(account_id: 12, cat_toy_id: 1, characteristic_type: 'playful', value: 'qw12')
          .and_return(Failure([:toy_not_founded, {}]))

        subject
      end
    end

    context 'когда игрушка уже протестирована' do
      let(:command) { ->(*) { Failure([:already_tested, { error: 'already_tested', cat_toy_id: 12 }]) } }

      it { expect(subject.status).to eq(422) }
      it { expect(subject.body.first).to eq({ error: 'already_tested', cat_toy_id: 12 }.to_json) }

      it 'вызывается команда' do
        expect(command).to receive(:call)
          .with(account_id: 12, cat_toy_id: 1, characteristic_type: 'playful', value: 'qw12')
          .and_return(Failure([:already_tested, {}]))

        subject
      end
    end

    context 'когда у игрушки негативная характеристика' do
      let(:command) { ->(*) { Failure([:negative_characteristics, { error: 'negative_characteristics', cat_toy_id: 12 }]) } }

      it { expect(subject.status).to eq(422) }
      it { expect(subject.body.first).to eq({ error: 'negative_characteristics', cat_toy_id: 12 }.to_json) }

      it 'вызывается команда' do
        expect(command).to receive(:call).with(account_id: 12, cat_toy_id: 1, characteristic_type: 'playful', value: 'qw12').and_return(Failure([:negative_characteristics, {}]))
        subject
      end
    end
  end
end


