
public enum EasyAttributerError: Error {
  case regexGroupFullTextIndexNotValid
  case regexGroupPartialTextIndexNotValid
  
  var localizedDescription: String? {
    switch self {
    case .regexGroupFullTextIndexNotValid:
      return "RegexGroup: Your full text index is not valid. Please set a valid index."
    case .regexGroupPartialTextIndexNotValid:
      return "RegexGroup: Your partail text index is not valid. Please set a valid index."
    }
  }
}

