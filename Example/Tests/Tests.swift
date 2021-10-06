import XCTest
import EasyAttributer

class Tests: XCTestCase {
    
    struct UserMentionRegex: ESRegexBehavior {
        var group: ESRegexGroup = .init(partialTextIndex: 1)
        var pattern: String = "(@([^\\s@\\[\\]]+))\\[([^\\[\\]]+)\\]"
    }
    
    struct InvalidUserMentionRegex: ESRegexBehavior {
        var group: ESRegexGroup = .init(partialTextIndex: 5)
        var pattern: String = "(@([^\\s@\\[\\]]+))\\[([^\\[\\]]+)\\]"
    }
    
    struct URLRegex: ESRegexBehavior {
        var group: ESRegexGroup = .init(partialTextIndex: nil)
        var pattern: String = "https?:\\/\\/(www\\.)?[-a-zA-Z0-9@:%._\\+~#=]{1,256}\\.[a-zA-Z0-9()]{1,6}\\b([-a-zA-Z0-9()@:%_\\+.~#?&//=]*)"
        
    }
    
    
    func testUserMentionRegexWithoutCheckingAttributes() {
        let str = "Hi @Merlia[AVV] how old are you?"
        let parser = EasyAttributer(regexes: [UserMentionRegex()])

        do {
            let attributedText = try parser.transform(text: str) { (r) -> [NSAttributedString.Key : Any] in
                return [NSAttributedString.Key.foregroundColor : UIColor.blue]
            }
            XCTAssertNotNil(attributedText)
            XCTAssertEqual(attributedText!.string, "Hi @Merlia how old are you?")
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testUserMentionRegexWithInvalidPartialTextIndex() {
        let str = "Hi @Jack[JP343245] How are you?"
        let parser = EasyAttributer(regexes: [InvalidUserMentionRegex()])
        XCTAssertThrowsError(try parser.transform(text: str, attribute: { (result) -> [NSAttributedString.Key : Any] in
            return [NSAttributedString.Key.foregroundColor : UIColor.blue]
        }), "Error is not occured") { (error) in
            XCTAssertEqual(error as? EasyAttributerError , EasyAttributerError.regexGroupPartialTextIndexNotValid)
        }
    }
    
    func testUserMentionRegexWithCheckingAttributes() {
        let str = "@Joe[12XXXX] how's the weather today?"
        let attribute = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        let mutableAttributedString = NSMutableAttributedString(string: str)
        let rangeOfMention = (str as NSString).range(of: "@Joe[12XXXX]")
        mutableAttributedString.addAttributes(attribute, range: .init(location: 0, length: 4))
        mutableAttributedString.replaceCharacters(in: rangeOfMention, with: "@Joe")
        
        let parser = EasyAttributer(regexes: [UserMentionRegex()])
        do {
            let attributedText = try parser.transform(text: str) { (r) -> [NSAttributedString.Key : Any] in
                return attribute
            }
            XCTAssertNotNil(attributedText)
            XCTAssertEqual(attributedText, mutableAttributedString)
            
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testMultipleRegexWithCheckingAttributes() {
        let str = "@Merlia[AVV] how old are you?. This my website url: https://www.google.com"
        let attribute = [NSAttributedString.Key.foregroundColor : UIColor.blue]
        let mutableAttributedString = NSMutableAttributedString(string: str)
        let rangeOfMention = (str as NSString).range(of: "@Merlia[AVV]")
        let rangeOfURL = (str as NSString).range(of: "https://www.google.com")
        mutableAttributedString.addAttributes(attribute, range: rangeOfMention)
        mutableAttributedString.replaceCharacters(in: rangeOfMention, with: "@Merlia")
        // because @Merlia[AVV] replace with @Merlia we should update URL range
        mutableAttributedString.addAttributes(attribute, range: .init(location: rangeOfURL.location - 5, length: rangeOfURL.length))

        let parser = EasyAttributer(regexes: [UserMentionRegex(), URLRegex()])

        do {
            let attributedText = try parser.transform(text: str) { (r) -> [NSAttributedString.Key : Any] in
                return [NSAttributedString.Key.foregroundColor : UIColor.blue]
            }
            XCTAssertNotNil(attributedText)
            XCTAssertEqual(attributedText!.string, "@Merlia how old are you?. This my website url: https://www.google.com")
            XCTAssertEqual(attributedText, mutableAttributedString)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
}
