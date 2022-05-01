
public struct ESRegexGroup {
    // Regex full-text group index. default is zero.
    let fullTextIndex: Int
    // Regex partial text(display text) index. If it's nil EasyAttributer uses 'fullTextIndex' instead.
    let partialTextIndex: Int?
    
    public init(partialTextIndex: Int?, fullTextIndex: Int = 0) {
        self.partialTextIndex = partialTextIndex
        self.fullTextIndex = fullTextIndex
    }
}

/**
 A regex behavior type.
 Create your regex by conforming to this protocol.
 */
public protocol ESRegexBehavior {
    // Regex pattern
    var pattern: String { get }
    // Regex group
    var group: ESRegexGroup { get  }
    
}

public struct ESTextResult {
    public let regex: ESRegexBehavior
    public let nsTextCheckingResult: NSTextCheckingResult
}

/*
 EasyAttributer is a type that accepts an array of 'ESRegexBehavior' and transforms it into your custom attributed string.
 */
public struct EasyAttributer {
    
    private let regexes: [ESRegexBehavior]
    
    public init(regexes: [ESRegexBehavior]) {
        self.regexes = regexes
    }
    
    /**
     Search the string to find matches in an array of regexes, finally return an array of 'ESTextResult.'
     */
    private func findRegexMatches(text: String, regex: ESRegexBehavior) throws -> [ESTextResult] {
        let regularExpression = try NSRegularExpression(pattern: regex.pattern, options: .caseInsensitive)
        return regularExpression.matches(in: text, options: [], range: NSRange(location: 0, length: text.count))
            .reversed()
            .map { (nsTextCheckingResult) -> ESTextResult in
                return .init(regex: regex, nsTextCheckingResult: nsTextCheckingResult)
            }
    }
    /**
     Return partial text range by using regex group.
     */
    private func getPartialTextRange(textResult: ESTextResult) throws -> NSRange {
        guard let partailTextRange = textResult.nsTextCheckingResult.rangeAt(safe: textResult.regex.group.partialTextIndex ?? textResult.regex.group.fullTextIndex) else {
            throw EasyAttributerError.regexGroupPartialTextIndexNotValid
        }
        return partailTextRange
    }
    /**
     Return full-text range by using regex group.
     */
    private func getFullTextRange(textResult: ESTextResult) throws -> NSRange {
        guard let fullTextRange = textResult.nsTextCheckingResult.rangeAt(safe: textResult.regex.group.fullTextIndex) else {
            throw EasyAttributerError.regexGroupFullTextIndexNotValid
        }
        return fullTextRange
    }
    /**
     Generate none-mutable attributed string by iterate over matches that found by 'findRegexMatches(text:_) method'
     - Parameters:
       - text: text that contains your custom regex.
       - matches: found regex matches.
       - initialAttributedString: This is an initially attributed string. Because this method is called multiple times by 'transform(text:_)' method, so they must pass the previous regex attributed text to continue.
       - matchAttribute: A callback that calls on every match. Use this to attribute to your matches.
     */
    private func generateAttributedString(text: String, matches: [ESTextResult], initialAttributedString: NSMutableAttributedString? = nil, attribute matchAttribute: @escaping (ESTextResult) -> [NSAttributedString.Key : Any]) throws -> NSMutableAttributedString? {
        let attributedString: NSMutableAttributedString = initialAttributedString ?? NSMutableAttributedString(string: text)
        
        try matches.forEach { (textResult) in
            let partailTextRange = try getPartialTextRange(textResult: textResult)
            let fullTextRange = try getFullTextRange(textResult: textResult)
            
            let partialText = attributedString.attributedSubstring(from: partailTextRange).string
            attributedString.replaceCharacters(in: fullTextRange, with: partialText)
            attributedString.addAttributes(matchAttribute(textResult), range: partailTextRange)
        }
         
        return attributedString
        
    }
    
    /**
     Return the none-mutable attributed string and attributes your regex matches.
     - Parameters:
        - text: text that transformer searches for regex patterns.
        - matchAttribute: A callback that calls on every match. Use this to attribute to your matches.
     */
    public func transform(text: String, attribute matchAttribute: @escaping (ESTextResult) -> [NSAttributedString.Key : Any]) throws -> NSAttributedString? {
        var attributedString: NSMutableAttributedString? = nil
        try regexes.forEach { (regex) in
            let textResuts = try findRegexMatches(text: attributedString?.string ?? text, regex: regex)
           attributedString = try generateAttributedString(text: text, matches: textResuts, initialAttributedString: attributedString, attribute: matchAttribute)
            
        }
        return attributedString?.copy() as? NSAttributedString

    }
    
}

fileprivate extension NSTextCheckingResult {
    func rangeAt(safe idx: Int) -> NSRange? {
        if idx <= numberOfRanges - 1 {
            return range(at: idx)
        } else {
            return nil
        }
    }
}




