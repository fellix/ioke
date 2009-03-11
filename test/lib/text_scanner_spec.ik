use("ispec")
use("text_scanner")

describe(TextScanner,
  it("should have the correct kind",
    TextScanner should have kind("TextScanner")
  )

  describe("mimic",
    it("should be possible to mimic a new TextScanner with a given piece of text",
      t = TextScanner mimic("text")
      t should have kind("TextScanner")
    )
  )

  describe("text",
    it("should be possible to retrieve the original piece of text to be scanned",
      t = TextScanner mimic("original text")
      t text should == "original text"
    )
  )

  describe("delimiter",
    it("should match whitespace as default",
      t = TextScanner mimic("original text")
      t delimiter should == #/\s+/
    )

    it("should be possible to set the delimeter",
      t = TextScanner mimic("original text")
      t delimeter = #/new delimeter/
      t delimeter should == #/new delimeter/
    )
  )

   describe("next",
     it("should return nil if there are no more tokens to return",
       t = TextScanner mimic("")
       t next should == nil
     )
     
     describe("with the default delimiter",
       it("should return each token as delimited by the delimiter",
         t = TextScanner mimic("original text with whitespace separated tokens")
         t next should == "original"
         t next should == "text"
         t next should == "with"
         t next should == "whitespace"
         t next should == "separated"
         t next should == "tokens"
       )

       it("should return the entire text if the delimiter can't be found",
         t = TextScanner mimic("original-text-with-hyphen-separated-words")
         t next should == "original-text-with-hyphen-separated-words"
       )
     )
  )

  describe("rest",
    it("should return all of the text before any scanning has taken place",
      t = TextScanner mimic("original text")
      t rest should == "original text"
    )

    it("should return the remainder of the text after an initial scan",
      t = TextScanner mimic("original text")
      t scan(#/original/)
      t rest should == " text"
    )
  )

  describe("scan",
    it("should return the matching text if the provided regexp matches text from the pointer position",
      t = TextScanner mimic("original matchable text")
      t scan(#/original/) should == "original"
    )

    it("should not match if the match doesn't start at the pointer position",
      t = TextScanner mimic("original matchable text")
      t scan(#/matchable/) should == nil
    )

    it("should advance the pointer position to the position after the first match",
      t = TextScanner mimic("original matchable text")
      t position should == 0
      t scan(#/original/)
      t position should == 8
    )

    it("should advance the pointer position multiple times with multiple matches",
      t = TextScanner mimic("my umbrella is asymetric")
      t position should == 0
      t scan(#/my/) should == "my"
      t position should == 2
      t scan(#/umbrella/) should == nil
      t position should == 2
      t scan(#/ /) should == " "
      t position should == 3
      t scan(#/umb.*/) should == "umbrella is asymetric"
      t position should == "my umbrella is asymetric" length
    )
  )

  describe("positionScan",
    it("should return the pointer position if the provided regexp matches text from the pointer position",
      t = TextScanner mimic("original matchable text")
      t positionScan(#/original/) should == 8
    )

    it("should not match if the match doesn't start at the pointer position",
      t = TextScanner mimic("original matchable text")
      t positionScan(#/matchable/) should == nil
    )

    it("should not adance the pointer position if the match doesn't start at the pointer position",
      t = TextScanner mimic("original matchable text")
      originalPosition = t position
      t positionScan(#/matchable/)
      t position should == originalPosition
    )

    it("should advance the pointer position to the position after the first match",
      t = TextScanner mimic("original matchable text")
      t position should == 0
      t positionScan(#/original/)
      t position should == 8
    )

    it("should advance the pointer position multiple times with multiple matches",
      t = TextScanner mimic("my umbrella is asymetric")
      t position should == 0
      t positionScan(#/my/) should == 2
      t position should == 2
      t positionScan(#/umbrella/) should == nil
      t position should == 2
      t positionScan(#/ /) should == 3
      t position should == 3
      t positionScan(#/umb.*/) should == "my umbrella is asymetric" length
      t position should == "my umbrella is asymetric" length
    )
  )

  describe("search",
    it("should find a match at the end of the text and return the match",
      t = TextScanner mimic("original matchable text")
      t search(#/text/) should == "original matchable text"
    )

    it("should find a match in the middle of the text and return the match",
      t = TextScanner mimic("original matchable text")
      t search(#/matchable/) should == "original matchable"
    )

    it("should find a match in the middle of the text and return all the text from the pointer position to the match",
      t = TextScanner mimic("original matchable text")
      t scan(#/original/)
      t position should == 8
      t search(#/text/) should == " matchable text"
      t position should == "original matchable text" length
    )

    it("should advance the pointer position",
      t = TextScanner mimic("original matchable text")
      t search(#/matchable/)
      t position should == 18
    )

    it("should return nil if the pattern given could not be found in the rest of the text",
      t = TextScanner mimic("original matchable text")
      t search(#/moonunit/) should == nil
    )

    it("should not advance the pointer position if no match was found",
      t = TextScanner mimic("original matchable text")
      originalPosition = t position
      t search(#/plinky/)
      t position should == originalPosition
    )
  )

  describe("positionSearch",
    it("should find a match at the end of the text and return the position",
      t = TextScanner mimic("original matchable text")
      t positionSearch(#/text/) should == "original matchable text" length
    )

    it("should find a match in the middle of the text and return the position",
      t = TextScanner mimic("original matchable text")
      t positionSearch(#/matchable/) should == "original matchable" length
    )

    it("should find a match in the middle of the text and return all the text from the pointer position to the match",
      t = TextScanner mimic("original matchable text")
      t scan(#/original/)
      t position should == 8
      t positionSearch(#/text/) should == "original matchable text" length
      t position should == "original matchable text" length
    )

    it("should advance the pointer position",
      t = TextScanner mimic("original matchable text")
      t positionSearch(#/matchable/)
      t position should == 18
    )

    it("should return nil if the pattern given could not be found in the rest of the text",
      t = TextScanner mimic("original matchable text")
      t positionSearch(#/blimp/) should == nil
    )

    it("should not advane the pointer position if the pattern given could not be found in the rest of the text",
      t = TextScanner mimic("original matchable text")
      originalPosition = t position
      t positionSearch(#/blimp/)
      t position should == originalPosition
    )
  )

  describe("position",
    it("should return 0 before any scanning has been done",
      t = TextScanner mimic("text")
      t position should == 0
    )
  )

  describe("beforeMatch",
    it("should return the text before the match of the last scan",
      t = TextScanner mimic("original matchable text")
      t search(#/matchable/)
      t beforeMatch should == "original "
      t search(#/text/)
      t beforeMatch should == "original matchable "
    )

    it("should return nil if no scans have been performed yet",
      t = TextScanner mimic("original matchable text")
      t beforeMatch should == nil
    )
  )

  describe("afterMatch",
    it("should return the text after the match of the last scan",
      t = TextScanner mimic("original matchable text")
      t search(#/original/)
      t afterMatch should == " matchable text"
    )

    it("should return nil if no scans have been performed yet",
      t = TextScanner mimic("original matchable text")
      t afterMatch should == nil
    )
  )

  describe("textStart?",
    it("should return true if the pointer position is at the start of the text",
      t = TextScanner mimic("original matchable text")
      t textStart? should == true
    )

    it("should return false if the pointer position is in the middle of the text",
      t = TextScanner mimic("original matchable text")
      t search(#/matchable/)
      t textStart? should == false
    )

    it("should return false if the pointer position is at the end of the text",
      t = TextScanner mimic("original matchable text")
      t search(#/text/)
      t textStart? should == false
    )
  )

 describe("textEnd?",
    it("should return false if the pointer position is at the start of the text",
      t = TextScanner mimic("original matchable text")
      t textEnd? should == false
    )

    it("should return false if the pointer position is in the middle of the text",
      t = TextScanner mimic("original matchable text")
      t search(#/matchable/)
      t textEnd? should == false
    )

    it("should return true if the pointer position is at the end of the text",
      t = TextScanner mimic("original matchable text")
      t search(#/text/)
      t textEnd? should == true
    )
  )

  describe("getChar",
    it("should return the first character no scanning has taken place",
      t = TextScanner mimic("original matchable text")
      t getChar should == "o"
    )

    it("should advance the pointer",
      t = TextScanner mimic("original matchable text")
      t position should == 0
      t getChar
      t position should == 1
    )

    it("should return nil if the pointer is at the end of the text",
      t = TextScanner mimic("original matchable text")
      t position = "original matchable text" length
      t getChar should == nil
    )
  )

)