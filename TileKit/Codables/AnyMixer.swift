// swiftlint:disable cyclomatic_complexity

public struct AnyMixer: Mixer, Codable {
    public let mixer: Mixer

    public init(_ mixer: Mixer) {
        self.mixer = mixer
    }

    public func mix() -> [Tile] {
        return mixer.mix()
    }

    public func next() -> AnyMixer {
        return AnyMixer(mixer.next())
    }

    private enum CodingKeys: String, CodingKey {
        case mixerType
        case deterministic
        case mixer
    }

    private enum MixerTypes: String, Codable {
        case simple
        case classic
        case duality
        case insanity
        case fibonacci
        case unlimited
        case harald
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mixerType = try container.decode(MixerTypes.self, forKey: .mixerType)
        let deterministic = try container.decode(Bool.self, forKey: .deterministic)
        switch (mixerType, deterministic) {
        case (.simple, false):
            mixer = try container.decode(SimpleMixer<ChaoticGameOfDice>.self, forKey: .mixer)
        case (.simple, true):
            mixer = try container.decode(SimpleMixer<NeutralGameOfDice>.self, forKey: .mixer)
        case (.classic, false):
            mixer = try container.decode(ClassicMixer<ChaoticGameOfDice>.self, forKey: .mixer)
        case (.classic, true):
            mixer = try container.decode(ClassicMixer<NeutralGameOfDice>.self, forKey: .mixer)
        case (.duality, false):
            mixer = try container.decode(DualityMixer<ChaoticGameOfDice>.self, forKey: .mixer)
        case (.duality, true):
            mixer = try container.decode(DualityMixer<NeutralGameOfDice>.self, forKey: .mixer)
        case (.insanity, false):
            mixer = try container.decode(InsanityMixer<ChaoticGameOfDice>.self, forKey: .mixer)
        case (.insanity, true):
            mixer = try container.decode(InsanityMixer<NeutralGameOfDice>.self, forKey: .mixer)
        case (.fibonacci, false):
            mixer = try container.decode(FibonacciMixer<ChaoticGameOfDice>.self, forKey: .mixer)
        case (.fibonacci, true):
            mixer = try container.decode(FibonacciMixer<NeutralGameOfDice>.self, forKey: .mixer)
        case (.unlimited, false):
            mixer = try container.decode(UnlimitedMixer<ChaoticGameOfDice>.self, forKey: .mixer)
        case (.unlimited, true):
            mixer = try container.decode(UnlimitedMixer<NeutralGameOfDice>.self, forKey: .mixer)
        case (.harald, false):
            mixer = try container.decode(HaraldMixer<ChaoticGameOfDice>.self, forKey: .mixer)
        case (.harald, true):
            mixer = try container.decode(HaraldMixer<NeutralGameOfDice>.self, forKey: .mixer)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch mixer {
        case let mixer as SimpleMixer<ChaoticGameOfDice>:
            try encode(mixer, mixerType: .simple, deterministic: false, to: &container)
        case let mixer as SimpleMixer<NeutralGameOfDice>:
            try encode(mixer, mixerType: .simple, deterministic: true, to: &container)
        case let mixer as ClassicMixer<ChaoticGameOfDice>:
            try encode(mixer, mixerType: .classic, deterministic: false, to: &container)
        case let mixer as ClassicMixer<NeutralGameOfDice>:
            try encode(mixer, mixerType: .classic, deterministic: true, to: &container)
        case let mixer as DualityMixer<ChaoticGameOfDice>:
            try encode(mixer, mixerType: .duality, deterministic: false, to: &container)
        case let mixer as DualityMixer<NeutralGameOfDice>:
            try encode(mixer, mixerType: .duality, deterministic: true, to: &container)
        case let mixer as InsanityMixer<ChaoticGameOfDice>:
            try encode(mixer, mixerType: .insanity, deterministic: false, to: &container)
        case let mixer as InsanityMixer<NeutralGameOfDice>:
            try encode(mixer, mixerType: .insanity, deterministic: true, to: &container)
        case let mixer as FibonacciMixer<ChaoticGameOfDice>:
            try encode(mixer, mixerType: .fibonacci, deterministic: false, to: &container)
        case let mixer as FibonacciMixer<NeutralGameOfDice>:
            try encode(mixer, mixerType: .fibonacci, deterministic: true, to: &container)
        case let mixer as UnlimitedMixer<ChaoticGameOfDice>:
            try encode(mixer, mixerType: .unlimited, deterministic: false, to: &container)
        case let mixer as UnlimitedMixer<NeutralGameOfDice>:
            try encode(mixer, mixerType: .unlimited, deterministic: true, to: &container)
        case let mixer as HaraldMixer<ChaoticGameOfDice>:
            try encode(mixer, mixerType: .harald, deterministic: false, to: &container)
        case let mixer as HaraldMixer<NeutralGameOfDice>:
            try encode(mixer, mixerType: .harald, deterministic: true, to: &container)
        default:
            throw EncodingError.invalidValue(mixer, .init(
                codingPath: encoder.codingPath, debugDescription: "Mixer out of range"))
        }
    }

    private func encode<T: Mixer & Encodable>(_ mixer: T,
                                              mixerType: MixerTypes,
                                              deterministic: Bool,
                                              to container: inout KeyedEncodingContainer<CodingKeys>) throws {
        try container.encode(mixerType, forKey: .mixerType)
        try container.encode(deterministic, forKey: .deterministic)
        try container.encode(mixer, forKey: .mixer)
    }
}
