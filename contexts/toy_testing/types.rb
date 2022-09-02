module ToyTesting
  class Types
    include Dry.Types()

    CharacteristicTyppes = Types::String.enum('happines', 'playful', 'safeties', 'brightness')
  end
end