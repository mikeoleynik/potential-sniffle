module ToyTesting
  class Types
    include Dry.Types()

    CharacteristicTyppes = Types::String.enum('happines', 'playful', 'safeties', 'brightness')

    CatToyCharacteristics = Types::Array.of(ToyTesting::Entities::Characteristic)
  end
end