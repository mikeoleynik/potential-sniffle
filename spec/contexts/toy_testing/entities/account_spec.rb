RSpec.describe ToyTesting::Entities::Account, type: :entity do
  subject { described_class.new(params) }

  context 'когда валидные параметры' do
    let(:params) { { id: 1, toys_count: 2, toys_ids: [] }  }

    it { expect(subject.id).to eq(1) }
    it { expect(subject.toys_count).to eq(2) }
  end

  context 'когда параметры невалидные' do
    context 'когда невалидный :toys_count' do
      let(:params) { { id: 2, toys_count: 4, toys_ids: [] }  }

      it 'проверка падает с ошибкой' do
        expect { subject }.to raise_error(Dry::Struct::Error)
      end
    end
  end
end