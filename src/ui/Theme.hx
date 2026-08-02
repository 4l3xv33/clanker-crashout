package ui;

import flash.text.TextField;
import flash.text.TextFormat;

class Theme {
    public static inline var BG=0x080B14;
    public static inline var PANEL=0x111A2E;
    public static inline var TEXT=0xE7EEF9;
    public static inline var MUTED=0x8FA1C6;
    public static inline var MINT=0x72F1B8;
    public static inline var AMBER=0xFFCB6B;
    public static inline var DANGER=0xFF6174;

    public static function field(size:Int,color:Int=TEXT,bold:Bool=false):TextField {
        var t=new TextField();t.defaultTextFormat=new TextFormat("_sans",size,color,bold);t.selectable=false;t.multiline=true;t.wordWrap=true;return t;
    }
}
