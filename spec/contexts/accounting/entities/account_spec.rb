RSpec.describe Accounting::Entities::Account, type: :entity do
  subject { described_class.new(params) }

  context 'когда валидные параметры' do
    let(:params) { { id: 1, point: 100, state: 'active' }  }

    it { expect(subject.id).to eq(1) }
    it { expect(subject.point).to eq(100) }
    it { expect(subject.state).to eq('active') }
  end

  context 'когда параметры невалидные' do
    context 'когда невалидный :state' do
      let(:params) { { id: 2, point: 100, state: 'removed' }  }

      it 'проверка падает с ошибкой' do
        expect { subject }.to raise_error(Dry::Struct::Error)
      end
    end

    context 'когда невалидный :state' do
      let(:params) { { id: 2, point: '100 point', state: 'blocked' }  }

      it 'проверка падает с ошибкой' do
        expect { subject }.to raise_error(Dry::Struct::Error)
      end
    end
  end
end