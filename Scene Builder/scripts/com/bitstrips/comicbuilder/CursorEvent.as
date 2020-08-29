package com.bitstrips.comicbuilder
{
   import flash.events.Event;
   
   public final class CursorEvent extends Event
   {
      
      public static const CURSOR_EVENT:String = "cursorEvent";
       
      
      public var cursorType:String;
      
      public var button_down:Boolean;
      
      public function CursorEvent(param1:String, param2:Boolean = false)
      {
         super(CURSOR_EVENT,false,false);
         cursorType = param1;
         button_down = param2;
      }
      
      override public function clone() : Event
      {
         return new CursorEvent(cursorType,button_down);
      }
   }
}
