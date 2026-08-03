package data;

class EvidenceData {
    public var title:String;
    public var artifact:String;
    public var prompt:String;
    public var choices:Array<String>;
    public var correct:Int;
    public var explanation:String;
    public var principle:String;
    public var summary:String;

    public function new(title:String,artifact:String,prompt:String,choices:Array<String>,correct:Int,explanation:String,principle:String,summary:String) {
        this.title=title;this.artifact=artifact;this.prompt=prompt;this.choices=choices;this.correct=correct;this.explanation=explanation;this.principle=principle;this.summary=summary;
    }
}
