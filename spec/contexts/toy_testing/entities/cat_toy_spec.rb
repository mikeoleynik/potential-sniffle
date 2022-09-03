RSpec.describe ToyTesting::Entities::CatToy, type: :entity do
  subject { described_class.new(params) }

  let(:valid_params) do
    {
      id: 1,
      account_id: 1,
      comment: 'qwerty',
      tested: true,
      negative: false,
      characteristic_type: 'playful',
      value: 'qwerty'
    }
  end

  context 'когда валидные параметры' do
    let(:params) { valid_params }

    it { expect(subject.id).to eq(1) }
    it { expect(subject.account_id).to eq(1) }
    it { expect(subject.comment).to eq('qwerty') }
    it { expect(subject.tested).to eq(true) }
    it { expect(subject.negative).to eq(false) }
    it { expect(subject.characteristic_type).to eq('playful') }
    it { expect(subject.value).to eq('qwerty') }
  end

  context 'когда параметры невалидные' do
    context 'когда невалидный :characteristic_type' do
      let(:params) { valid_params.merge(characteristic_type: 'qwerty')  }

      it 'проверка падает с ошибкой' do
        expect { subject }.to raise_error(Dry::Struct::Error)
      end
    end

    context 'когда невалидный :value' do
      let(:params) { valid_params.merge(value: 'qwerty-qwerty')  }

      it 'проверка падает с ошибкой' do
        expect { subject }.to raise_error(Dry::Struct::Error)
      end
    end

    context 'когда невалидный :value' do
      let(:params) { valid_params.merge(comment: 'q' * 256)  }

      it 'проверка падает с ошибкой' do
        expect { subject }.to raise_error(Dry::Struct::Error)
      end
    end
  end
end