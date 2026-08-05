package ui;

import data.FloorData;
import data.Question;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFormat;

class IncidentPanel extends Sprite {
    var heading:TextField;
    var body:TextField;
    var questionPrompt:TextField;
    var questionHint:TextField;
    var choiceButtons:Array<Sprite>=[];
    var choiceLabels:Array<TextField>=[];
    var choiceHandler:Int->Void;

    public function new() {
        super();
        graphics.beginFill(Theme.BG,.97);graphics.drawRect(0,0,960,540);graphics.endFill();
        graphics.beginFill(Theme.PANEL);graphics.drawRoundRect(82,52,796,432,22);graphics.endFill();
        graphics.lineStyle(1,0x344867);graphics.drawRoundRect(82,52,796,432,22);

        heading=Theme.field(15,Theme.MINT,true);heading.x=116;heading.y=79;heading.width=730;heading.height=30;addChild(heading);
        body=Theme.field(20,Theme.TEXT,false);body.x=116;body.y=120;body.width=730;body.height=325;addChild(body);

        questionPrompt=Theme.field(23,Theme.TEXT,false);questionPrompt.x=116;questionPrompt.y=124;questionPrompt.width=730;questionPrompt.height=62;addChild(questionPrompt);
        for(i in 0...3)makeChoiceButton(i);
        questionHint=Theme.field(14,Theme.MUTED,false);questionHint.x=116;questionHint.y=416;questionHint.width=730;questionHint.height=24;questionHint.text="Click an answer or press 1, 2, or 3";addChild(questionHint);
        showQuestionControls(false);visible=false;
    }

    function makeChoiceButton(index:Int):Void {
        var button=new Sprite();button.x=116;button.y=198+index*70;button.buttonMode=true;button.mouseChildren=false;
        button.graphics.beginFill(0x17243A,1);button.graphics.drawRoundRect(0,0,730,56,10);button.graphics.endFill();
        button.graphics.lineStyle(2,0x5CDAFF,.42);button.graphics.drawRoundRect(1,1,728,54,10);
        var label=Theme.field(18,Theme.TEXT,false);label.x=17;label.y=13;label.width=696;label.height=31;button.addChild(label);
        var choice=index+1;
        button.addEventListener(MouseEvent.CLICK,function(e:MouseEvent){e.stopPropagation();if(choiceHandler!=null)choiceHandler(choice);});
        button.addEventListener(MouseEvent.MOUSE_OVER,function(_:MouseEvent){button.alpha=.82;});
        button.addEventListener(MouseEvent.MOUSE_OUT,function(_:MouseEvent){button.alpha=1;});
        addChild(button);choiceButtons.push(button);choiceLabels.push(label);
    }

    public function setChoiceHandler(handler:Int->Void):Void choiceHandler=handler;

    function showQuestionControls(show:Bool):Void {
        body.visible=!show;questionPrompt.visible=show;questionHint.visible=show;
        for(button in choiceButtons){button.visible=show;button.alpha=1;}
    }

    public function question(floor:FloorData,index:Int):Void {
        var q=floor.questions[index];visible=true;showQuestionControls(true);
        heading.textColor=Theme.MINT;heading.text="INCIDENT REVIEW  "+(index+1)+" / 3    "+floor.department.toUpperCase();
        questionPrompt.text=q.prompt;
        for(i in 0...3)choiceLabels[i].text=(i+1)+"    "+q.choices[i];
    }

    public function feedback(q:Question,correct:Bool,integrity:Int):Void {
        visible=true;showQuestionControls(false);
        heading.text=correct?"PATCH ACCEPTED":"PATCH REJECTED · INTEGRITY "+integrity+" / 3";heading.textColor=correct?Theme.MINT:Theme.DANGER;
        body.htmlText='<font size="23" color="'+(correct?'#72F1B8':'#FF6174')+'">'+(correct?'CONTROL RESTORED':'WHY THIS IS NOT SAFE')+'</font>\n\n'+q.explanation+'\n\n<font size="16" color="#FFCB6B">CONSEQUENCE</font>\n<font size="17">'+q.consequence+'</font>\n\n<font size="16" color="#72F1B8">PRINCIPLE: '+q.principle+'</font>';
    }

    public function briefing(floor:FloorData):Void {
        visible=true;showQuestionControls(false);heading.text="FLOOR BRIEFING    "+floor.department.toUpperCase();heading.textColor=floor.accent;
        body.htmlText='<font size="28" color="#FFFFFF">'+floor.subtitle+'</font>\n\n<font size="20">'+floor.briefing+'</font>\n\n<font size="16" color="#8FA1C6">Find three pieces of evidence before confronting '+floor.robot+'. Wrong answers teach the consequence and return you to the decision.</font>';
    }

    public function hide():Void {showQuestionControls(false);visible=false;}

    public function setLargeText(enabled:Bool):Void {
        heading.defaultTextFormat=new TextFormat("_sans",enabled?18:15,Theme.MINT,true);
        body.defaultTextFormat=new TextFormat("_sans",enabled?23:20,Theme.TEXT,false);
        questionPrompt.defaultTextFormat=new TextFormat("_sans",enabled?25:23,Theme.TEXT,false);
        for(label in choiceLabels)label.defaultTextFormat=new TextFormat("_sans",enabled?20:18,Theme.TEXT,false);
    }
}
