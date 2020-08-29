package com.bitstrips
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public final class BSConstants
   {
      
      public static var IMAGE_UPLOAD:Boolean = false;
      
      public static var params:Object = {};
      
      public static const HQ:Boolean = false;
      
      public static var EDU:Boolean = false;
      
      public static var STAGING:Boolean = false;
      
      public static const SHARED_CLIPBOARD:Boolean = false;
      
      public static var CREATIVEBLOCK:String = "_CreativeBlock BB";
      
      public static var KID_MODE:Boolean = false;
      
      public static const PROP_ASSET_DIR:String = "2009_12_04_3/";
      
      public static var AIR:Boolean = false;
      
      public static const TRANSPARENT:Boolean = false;
      
      public static var TESTING_PF:String = "";
      
      public static const NEW_PROP_ASSET_DIR:String = "art/v5/";
      
      public static const HR_MULT:Number = 3;
      
      public static var FLICKR:Boolean = false;
      
      public static var STICKMAN:Boolean = false;
      
      public static var DOMAIN:String = "bitstripsforschools.com";
      
      public static var SKELETON:Boolean = true;
      
      public static var URL:String = "www." + BSConstants.DOMAIN;
      
      public static var PROPS:Boolean = true;
      
      private static var cb_tf:TextFormat;
      
      public static const NO_BM_HEAD:Boolean = true;
      
      public static var RESCALE:Number = 0.45;
      
      public static var OLD_BODY:Boolean = false;
      
      private static var v_tf:TextFormat;
      
      public static var CHARS_URL:String = "http://chars.bitstrips4schools.com/";
      
      public static var BODY_BUILDER:Boolean = false;
      
      public static var NEW_ASSET_URL:String = "http://static.bitstripsforschools.com/";
      
      public static const VERSION:String = "BS 2010-05-04-3";
      
      public static const ASSET_URL:String = "http://cassets.bitstrips.com/";
      
      public static var TESTING:Boolean = false;
      
      public static const VERDANA:String = "_Verdana";
      
      public static var IMAGES:Boolean = false;
      
      public static const FLEX:Boolean = true;
      
      public static const ASSET_DIR:String = "2009_10_12/";
      
      public static const NEW_ASSET_DIR:String = "2010_02_16/";
       
      
      public function BSConstants()
      {
         super();
      }
      
      public static function tf_fix(param1:TextField) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(v_tf == null)
         {
            v_tf = new TextFormat(BSConstants.VERDANA);
         }
         param1.embedFonts = true;
         param1.defaultTextFormat = v_tf;
         param1.setTextFormat(v_tf);
      }
      
      public static function tf_fix_cb(param1:TextField) : void
      {
         if(cb_tf == null)
         {
            cb_tf = new TextFormat(BSConstants.CREATIVEBLOCK);
         }
         param1.embedFonts = true;
         param1.defaultTextFormat = cb_tf;
         param1.setTextFormat(cb_tf);
      }
   }
}
