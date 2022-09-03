# frozen_string_literal: true

RSpec.describe HTTP::Actions::Queries::ShowToysForTesting, type: :http_action do
  subject { action.call(valid_params) }

  let(:action) { described_class.new(query: query) }
  let(:valid_params) { {} }

  let(:cat_toy) do
    ToyTesting::Entities::CatToy.new(
      id: 1, account_id: 1, comment: '', tested: true, negative: false, characteristic_type: 'playful', value: 'qw12'
    )
  end

  context 'успешный результат' do
    let(:query) { ->(*) { Success([]) } }

    it { expect(subject.status).to eq(200) }
    it { expect(subject.body.first).to eq(nil) }

    it 'вызывается команда' do
      expect(query).to receive(:call).and_return(Success([]))
      subject
    end
  end

  context 'когда результат фейлится' do
    context 'когда аккаунт не найден' do
      let(:query) { ->(*) { Failure([:cat_toys_not_founded, { error: 'cat_toys_not_founded' }]) } }

      it { expect(subject.status).to eq(422) }
      it { expect(subject.body.first).to eq({ error: 'cat_toys_not_founded' }.to_json) }

      it 'вызывается команда' do
        expect(query).to receive(:call).and_return(Failure([:cat_toys_not_founded, {}]))
        subject
      end
    end
  end
end


