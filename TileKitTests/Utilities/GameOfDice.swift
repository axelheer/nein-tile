func trimGameOfDice(_ text: String) -> String {
    var result = text
    for value in [ "\"child\" : ", "\"seed\" : " ] {
        while let range = result.range(of: value) {
            result.removeSubrange(result.lineRange(for: range))
        }
    }
    return result
}
