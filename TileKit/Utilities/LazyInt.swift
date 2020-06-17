infix operator |+: AdditionPrecedence
infix operator |-: AdditionPrecedence

extension Int {
    static func |+(left: Int, right: Int) -> Int {
        let result = left.addingReportingOverflow(right)
        return result.overflow
            ? (right < 0 ? .min : .max)
            : result.partialValue
    }
    
    static func |-(left: Int, right: Int) -> Int {
        let result = left.subtractingReportingOverflow(right)
        return result.overflow
            ? (right > 0 ? .min : .max)
            : result.partialValue
    }
}
