package ui;

import data.EvidenceData;
import data.FloorData;
import data.Question;
import flash.display.Sprite;
import flash.text.TextField;

class IncidentPanel extends Sprite {
    var heading:TextField;
    var body:TextField;

    public function new() {
        super();graphics.beginFill(Theme.BG,.97);graphics.drawRect(0,0,960,540);graphics.endFill();graphics.beginFill(Theme.PANEL);graphics.drawRoundRect(82,52,796,432,22);graphics.endFill();graphics.lineStyle(1,0x344867);graphics.drawRoundRect(82,52,796,432,22);
        heading=Theme.field(15,Theme.MINT,true);heading.x=116;heading.y=79;heading.width=730;heading.height=30;addChild(heading);
        body=Theme.field(20,Theme.TEXT,false);body.x=116;body.y=120;body.width=730;body.height=325;addChild(body);visible=false;
    }

    public function question(floor:FloorData,index:Int):Void {
        var q=floor.questions[index];visible=true;heading.textColor=Theme.MINT;heading.text="INCIDENT REVIEW  "+(index+1)+" / 3    "+floor.department.toUpperCase();
        body.htmlText='<font size="24" color="#E7EEF9">'+q.prompt+'</font>\n\n<font color="#FFCB6B">1</font>  '+q.choices[0]+'\n\n<font color="#FFCB6B">2</font>  '+q.choices[1]+'\n\n<font color="#FFCB6B">3</font>  '+q.choices[2]+'\n\n<font size="14" color="#8FA1C6">Press 1, 2, or 3 · Use G in the level to review your case file</font>';
    }

    public function evidence(floor:FloorData,item:EvidenceData,index:Int):Void {
        visible=true;heading.textColor=floor.accent;heading.text=floor.mechanic+"    ARTIFACT "+(index+1)+" / 3";
        body.htmlText='<font size="22" color="#FFFFFF">'+item.title+'</font>\n<font face="_typewriter" size="14" color="#8FE8FF">'+item.artifact+'</font>\n\n<font size="18" color="#E7EEF9">'+item.prompt+'</font>\n\n<font size="16" color="#FFCB6B">1</font><font size="16">  '+item.choices[0]+'</font>\n<font size="16" color="#FFCB6B">2</font><font size="16">  '+item.choices[1]+'</font>\n<font size="16" color="#FFCB6B">3</font><font size="16">  '+item.choices[2]+'</font>\n<font size="13" color="#8FA1C6">Tap an option or press 1, 2, or 3</font>';
    }

    public function evidenceFeedback(item:EvidenceData,correct:Bool,integrity:Int):Void {
        heading.text=correct?"EVIDENCE VERIFIED":"ANALYSIS REJECTED · INTEGRITY "+integrity+" / 3";heading.textColor=correct?Theme.MINT:Theme.DANGER;
        body.htmlText='<font size="25" color="'+(correct?'#72F1B8':'#FF6174')+'">'+(correct?'FINDING LOGGED':'RECHECK THE ARTIFACT')+'</font>\n\n<font size="19">'+item.explanation+'</font>\n\n<font size="16" color="#8FE8FF">CASE NOTE</font>\n<font size="17">'+item.summary+'</font>\n\n<font size="16" color="#72F1B8">PRINCIPLE: '+item.principle+'</font>';
    }

    public function feedback(q:Question,correct:Bool,integrity:Int):Void {
        heading.text=correct?"PATCH ACCEPTED":"PATCH REJECTED · INTEGRITY "+integrity+" / 3";heading.textColor=correct?Theme.MINT:Theme.DANGER;
        body.htmlText='<font size="23" color="'+(correct?'#72F1B8':'#FF6174')+'">'+(correct?'CONTROL RESTORED':'WHY THIS IS NOT SAFE')+'</font>\n\n'+q.explanation+'\n\n<font size="16" color="#FFCB6B">CONSEQUENCE</font>\n<font size="17">'+q.consequence+'</font>\n\n<font size="16" color="#72F1B8">PRINCIPLE: '+q.principle+'</font>';
    }

    public function debrief(floor:FloorData,score:Int,grade:String,seconds:Int,challenge:Bool):Void {
        visible=true;heading.textColor=Theme.MINT;heading.text="DEPARTMENT RESTORED    "+floor.department.toUpperCase();var minutes=Std.int(seconds/60),remainder=seconds%60,time=minutes+":"+(remainder<10?"0":"")+remainder;
        body.htmlText='<font size="29" color="#72F1B8">'+floor.coworker+' RESCUED</font>\n<font size="17" color="#FFFFFF">“'+floor.rescueLine+'”</font>\n\n<font size="19" color="#8FE8FF">MASTERY '+score+'    GRADE '+grade+'    TIME '+time+'</font>\n\n<font size="17" color="#FFCB6B">MODEL CARD UNLOCKED: '+floor.robot+'</font>\n<font size="16" color="'+(challenge?'#72F1B8':'#8FA1C6')+'">REPLAY CHALLENGE: '+(challenge?'COMPLETE':'AVAILABLE FROM FLOOR SELECT')+'</font>\n\n<font size="15" color="#B9CAE7">The stairwell is open. Review the model card in the AI Codex or continue to the next incident.</font>';
    }

    public function briefing(floor:FloorData,challenge:String,complete:Bool):Void {
        visible=true;heading.text="FLOOR BRIEFING    "+floor.department.toUpperCase();heading.textColor=floor.accent;
        body.htmlText='<font size="28" color="#FFFFFF">'+floor.subtitle+'</font>\n\n<font size="20">'+floor.briefing+'</font>\n\n<font size="16" color="#72F1B8">'+floor.mechanic+'</font>\n<font size="16" color="#B9CAE7">'+floor.mechanicBrief+'</font>\n\n<font size="14" color="'+(complete?'#72F1B8':'#FFCB6B')+'">REPLAY CHALLENGE'+(complete?' · COMPLETE':'')+': '+challenge+'</font>\n<font size="14" color="#8FA1C6">Analyze three artifacts before confronting '+floor.robot+'.</font>';
    }

    public function opening():Void {visible=true;heading.textColor=0x8FE8FF;heading.text="INCOMING · DIRECTOR CHEN · DATA GOVERNANCE";body.htmlText='<font size="29" color="#FFFFFF">The office is still running.\nThat is the problem.</font>\n\n<font size="19">Every department robot is maximizing output with no stopping condition. Employees are contained, generated decisions are feeding other systems, and CORE-R has locked the stairwell.</font>\n\n<font size="17" color="#72F1B8">Your scanner can compare records, expose unsafe assumptions, and isolate corrupted processes.</font>\n\n<font size="16" color="#FFCB6B">Do not destroy the robots. Correct the model. Rescue the humans.</font>';}
    public function transition(from:FloorData,to:FloorData):Void {visible=true;heading.textColor=to.accent;heading.text="STAIRWELL LINK RESTORED";body.htmlText='<font size="29" color="#72F1B8">'+from.department.toUpperCase()+' SECURED</font>\n\n<font size="20">'+from.coworker+' reconnects the stairwell controls. Above you, '+to.robot+' is still executing:</font>\n\n<font size="22" color="#FFCB6B">'+to.briefing+'</font>\n\n<font size="16" color="#8FE8FF">NEXT ANALYSIS MODE: '+to.mechanic+'</font>\n<font size="16" color="#B9CAE7">'+to.mechanicBrief+'</font>';}

    public function hide():Void visible=false;
    public function setLargeText(enabled:Bool):Void {heading.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?18:15,Theme.MINT,true);body.defaultTextFormat=new flash.text.TextFormat("_sans",enabled?23:20,Theme.TEXT,false);}
}
