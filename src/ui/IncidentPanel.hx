package ui;

import data.FloorData;
import data.Question;
import flash.display.Sprite;
import flash.text.TextField;

class IncidentPanel extends Sprite {
    var heading:TextField;
    var body:TextField;
    public function new() {super();graphics.beginFill(Theme.BG,.97);graphics.drawRect(0,0,960,540);graphics.endFill();graphics.beginFill(Theme.PANEL);graphics.drawRoundRect(82,52,796,432,22);graphics.endFill();graphics.lineStyle(1,0x344867);graphics.drawRoundRect(82,52,796,432,22);heading=Theme.field(15,Theme.MINT,true);heading.x=116;heading.y=79;heading.width=730;heading.height=30;addChild(heading);body=Theme.field(20,Theme.TEXT,false);body.x=116;body.y=120;body.width=730;body.height=325;addChild(body);visible=false;}
    public function question(floor:FloorData,index:Int):Void {var q=floor.questions[index];visible=true;heading.textColor=Theme.MINT;heading.text="INCIDENT REVIEW  "+(index+1)+" / 3    "+floor.department.toUpperCase();body.htmlText='<font size="24" color="#E7EEF9">'+q.prompt+'</font>\n\n<font color="#FFCB6B">1</font>  '+q.choices[0]+'\n\n<font color="#FFCB6B">2</font>  '+q.choices[1]+'\n\n<font color="#FFCB6B">3</font>  '+q.choices[2]+'\n\n<font size="14" color="#8FA1C6">Press 1, 2, or 3 · Evidence remains visible in your field notes</font>';}
    public function feedback(q:Question,correct:Bool,integrity:Int):Void {heading.text=correct?"PATCH ACCEPTED":"PATCH REJECTED · INTEGRITY "+integrity+" / 3";heading.textColor=correct?Theme.MINT:Theme.DANGER;body.htmlText='<font size="23" color="'+(correct?'#72F1B8':'#FF6174')+'">'+(correct?'CONTROL RESTORED':'WHY THIS IS NOT SAFE')+'</font>\n\n'+q.explanation+'\n\n<font size="16" color="#FFCB6B">CONSEQUENCE</font>\n<font size="17">'+q.consequence+'</font>\n\n<font size="16" color="#72F1B8">PRINCIPLE: '+q.principle+'</font>\n\n<font size="14" color="#8FA1C6">Press Space to '+(correct?'continue':'review the evidence and retry')+'</font>';}
    public function briefing(floor:FloorData):Void {visible=true;heading.text="FLOOR BRIEFING    "+floor.department.toUpperCase();heading.textColor=floor.accent;body.htmlText='<font size="28" color="#FFFFFF">'+floor.subtitle+'</font>\n\n<font size="20">'+floor.briefing+'</font>\n\n<font size="16" color="#8FA1C6">Find three pieces of evidence before confronting '+floor.robot+'. Wrong answers teach the consequence and return you to the decision.</font>\n\n<font color="#72F1B8">PRESS SPACE TO ENTER THE FLOOR</font>';}
    public function hide():Void visible=false;
    public function setLargeText(enabled:Bool):Void {heading.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?18:15,Theme.MINT,true);body.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?23:20,Theme.TEXT,false);}
}
