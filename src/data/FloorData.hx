package data;

class FloorData {
    public var department:String;
    public var subtitle:String;
    public var accent:Int;
    public var secondary:Int;
    public var wall:Int;
    public var coworker:String;
    public var role:String;
    public var robot:String;
    public var briefing:String;
    public var rescueLine:String;
    public var evidence:Array<String>;
    public var questions:Array<Question>;

    public function new(department:String, subtitle:String, accent:Int, secondary:Int, wall:Int, coworker:String, role:String, robot:String, briefing:String, rescueLine:String, evidence:Array<String>, questions:Array<Question>) {
        this.department = department;
        this.subtitle = subtitle;
        this.accent = accent;
        this.secondary = secondary;
        this.wall = wall;
        this.coworker = coworker;
        this.role = role;
        this.robot = robot;
        this.briefing = briefing;
        this.rescueLine = rescueLine;
        this.evidence = evidence;
        this.questions = questions;
    }
}
