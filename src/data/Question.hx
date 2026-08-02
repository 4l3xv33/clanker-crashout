package data;

class Question {
    public var prompt:String;
    public var choices:Array<String>;
    public var correct:Int;
    public var explanation:String;
    public var consequence:String;
    public var principle:String;

    public function new(prompt:String, choices:Array<String>, correct:Int, explanation:String, consequence:String, principle:String) {
        this.prompt = prompt;
        this.choices = choices;
        this.correct = correct;
        this.explanation = explanation;
        this.consequence = consequence;
        this.principle = principle;
    }
}
