package com.bitstrips.character
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import com.bitstrips.BSConstants;
   import com.bitstrips.character.custom.HeadStick;
   import com.bitstrips.character.skeleton.SkeletonBuddy;
   import com.bitstrips.core.ArtLoader;
   import com.bitstrips.core.ColourData;
   import com.bitstrips.core.LoadDat;
   import com.bitstrips.core.Remote;
   import flash.display.DisplayObject;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.ColorTransform;
   
   public class CharLoader extends EventDispatcher
   {
      
      public static var pose_data:Object;
       
      
      private var load_calls:Object;
      
      public var dat_loader:LoadDat;
      
      public var art_loader:ArtLoader;
      
      public var loaded:uint = 0;
      
      public var loaded_done:Boolean = false;
      
      private var remote:Remote;
      
      private var debug:Boolean = false;
      
      private var load_prop_list:Object;
      
      private var loaders:Object;
      
      public function CharLoader(param1:Remote, param2:Boolean = false)
      {
         var _loc4_:Array = null;
         this.load_calls = new Object();
         this.art_loader = ArtLoader.getInstance();
         this.load_prop_list = new Object();
         this.loaders = new Object();
         super();
         this.remote = param1;
         this.dat_loader = new LoadDat(param1,param2);
         this.dat_loader.addEventListener(BulkLoader.ERROR,this.bulk_error);
         var _loc3_:* = BSConstants.NEW_ASSET_URL + "art/v1/lines.dat";
         if(BSConstants.AIR)
         {
            _loc3_ = "app:/lines.dat";
         }
         this.dat_loader.load_dat(_loc3_,this.done_load);
         if(BSConstants.SKELETON)
         {
            _loc3_ = BSConstants.NEW_ASSET_URL + "art/v1/poses.dat";
            if(BSConstants.AIR)
            {
               _loc3_ = "app:/poses.dat";
            }
            this.dat_loader.load_dat(_loc3_,this.pose_load);
         }
         _loc3_ = BSConstants.NEW_ASSET_URL + "art/v1/head_new.swf";
         if(BSConstants.AIR)
         {
            _loc3_ = "app:/head_new.swf";
         }
         _loc4_ = [_loc3_];
         if(BSConstants.OLD_BODY)
         {
            this.dat_loader.load_dat(param1.assurl("body_art/points.dat"),this.done_load2);
            _loc4_.push(param1.assurl("body_art/simple_bare.swf"));
         }
         if(BSConstants.PROPS)
         {
            _loc4_.push(param1.new_assurl("props.swf"));
         }
         if(BSConstants.BODY_BUILDER)
         {
            _loc4_.push(ArtLoader.clothing_url("bare"));
            _loc4_.push(ArtLoader.clothing_url("pants05"));
            _loc4_.push(ArtLoader.clothing_url("shirt02"));
         }
         var _loc5_:uint = this.art_loader.load_swfs(_loc4_,this.art_loaded);
         if(this.debug)
         {
            trace("Load ID: " + _loc5_);
         }
         this.art_loader.addEventListener(BulkProgressEvent.PROGRESS,dispatchEvent);
         this.art_loader.addEventListener(BulkLoader.ERROR,this.bulk_error);
      }
      
      private function bulk_error(param1:ErrorEvent) : void
      {
         this.remote.log_error("BulkLoader Error " + param1.text.substr(7),param1.text);
         dispatchEvent(param1);
      }
      
      private function done_load(param1:Object) : void
      {
         if(this.debug)
         {
            trace("CL: Done dat");
         }
         this.art_loader.line_data = param1;
         this.loaded = this.loaded + 1;
         this.load3_check();
      }
      
      private function pose_load(param1:Object) : void
      {
         if(this.debug)
         {
            trace("CL: Done dat");
         }
         CharLoader.pose_data = param1;
         this.load3_check();
      }
      
      private function done_load2(param1:Object) : void
      {
         if(this.debug)
         {
            trace("CL: Done points dat");
         }
         this.art_loader.points = param1;
         this.loaded = this.loaded + 1;
         this.load3_check();
      }
      
      private function art_loaded(param1:uint) : void
      {
         trace("Art has loaded, can now proceed with any new_char calls...");
         this.loaded = this.loaded + 1;
         this.load3_check();
      }
      
      private function load3_check() : void
      {
         var _loc1_:* = undefined;
         if(BSConstants.SKELETON && CharLoader.pose_data == null)
         {
            return;
         }
         if(BSConstants.OLD_BODY && this.loaded < 3)
         {
            return;
         }
         if(this.loaded >= 2)
         {
            trace("Load3 check is OK");
            for(_loc1_ in this.load_calls)
            {
               if(this.dat_loader.get_char_data(_loc1_) != null || _loc1_ == -1)
               {
                  trace("\tData Loaded: " + _loc1_);
                  this.call_load_calls(_loc1_);
               }
            }
            dispatchEvent(new Event("LOADED"));
            this.loaded_done = true;
         }
         else
         {
            trace("load3: Not loaded" + this.loaded);
         }
      }
      
      public function new_head(param1:String, param2:int = -1, param3:Boolean = false) : Head
      {
         var _loc4_:Object = null;
         var _loc5_:PPData = null;
         var _loc6_:ColourData = null;
         var _loc7_:Head = null;
         if(param1 == "-1")
         {
            _loc5_ = new PPData();
            _loc6_ = new ColourData();
            _loc7_ = new Head(_loc5_,_loc6_);
            return _loc7_;
         }
         _loc4_ = this.dat_loader.get_char_data(param1,param2);
         _loc5_ = new PPData(_loc4_);
         _loc6_ = new ColourData(_loc4_["colours"]);
         _loc7_ = new Head(_loc5_,_loc6_);
         return _loc7_;
      }
      
      public function new_char_from_data(param1:Object) : SkeletonBuddy
      {
         var _loc4_:HeadBase = null;
         var _loc5_:SkeletonBuddy = null;
         var _loc6_:String = null;
         var _loc2_:PPData = new PPData(param1);
         var _loc3_:ColourData = new ColourData(param1["colours"]);
         _loc3_.name = int(Math.random() * 1000).toString();
         if(param1.hasOwnProperty("head_type") && param1["head_type"] != "Buddy")
         {
            _loc6_ = param1["head_type"];
            _loc4_ = new HeadStick(_loc2_,_loc3_);
            if(this.art_loader.clip_loaded(_loc6_) == true)
            {
               (_loc4_ as HeadStick).set_clip(this.art_loader.get_clip(_loc6_));
            }
            else
            {
               this.art_loader.clip_queue(_loc6_,(_loc4_ as HeadStick).set_clip);
            }
         }
         else
         {
            _loc4_ = new Head(_loc2_,_loc3_);
         }
         _loc5_ = new SkeletonBuddy(_loc4_,this.art_loader,param1["body"]);
         if(param1["user_id"])
         {
            _loc5_.name = param1["user_id"];
         }
         _loc5_.init();
         if(param1["state"])
         {
            if(this.debug)
            {
               trace("There\'s state! Calling load_state - " + param1["state"]);
            }
            _loc5_.load_state(param1["state"]);
         }
         else
         {
            _loc5_.body_rotation = 0;
         }
         return _loc5_;
      }
      
      public function new_char(param1:String) : SkeletonBuddy
      {
         var _loc2_:Object = null;
         var _loc3_:PPData = null;
         var _loc4_:ColourData = null;
         var _loc5_:HeadBase = null;
         var _loc6_:SkeletonBuddy = null;
         trace("New char for body: " + param1);
         if(param1 == "-1")
         {
            _loc3_ = new PPData();
            _loc4_ = new ColourData();
            _loc5_ = new Head(_loc3_,_loc4_);
            if(BSConstants.KID_MODE)
            {
               _loc6_ = new SkeletonBuddy(_loc5_,this.art_loader,{
                  "body_height":3,
                  "breast_type":3
               });
            }
            else
            {
               _loc6_ = new SkeletonBuddy(_loc5_,this.art_loader,undefined);
            }
            _loc6_.init();
            _loc6_.body_rotation = 0;
            return _loc6_;
         }
         return this.new_char_from_data(this.dat_loader.get_char_data(param1));
      }
      
      public function loaded_body(param1:Object) : void
      {
         var _loc2_:String = param1["body_id"];
         trace("Load data call returned for body: " + _loc2_);
         if(this.loaded >= 2)
         {
            this.call_load_calls(_loc2_);
         }
      }
      
      private function call_load_calls(param1:String) : void
      {
         var _loc3_:* = null;
         var _loc4_:* = null;
         trace("CL -- Call load_calls: " + param1);
         var _loc2_:uint = 0;
         while(_loc2_ < this.load_calls[param1].length)
         {
            trace("\tCL - Calling load: " + _loc2_);
            this.load_calls[param1][_loc2_](param1,this.new_char(param1));
            _loc2_ = _loc2_ + 1;
         }
         this.load_calls[param1] = new Array();
         for(_loc3_ in this.load_prop_list)
         {
            for(_loc4_ in this.load_prop_list[_loc3_])
            {
               trace("Loaded: " + _loc2_);
               this.load_prop_list[_loc3_][_loc4_].loadComplete(this.get_prop(_loc3_));
            }
         }
         trace("\tI made the all load_calls for the body...");
      }
      
      public function get_prop(param1:String) : Object
      {
         var _loc2_:String = null;
         var _loc4_:* = null;
         var _loc5_:* = null;
         var _loc3_:Object = this.art_loader.props;
         for(_loc4_ in _loc3_)
         {
            for(_loc5_ in _loc3_[_loc4_])
            {
               if(_loc5_ == param1)
               {
                  _loc2_ = _loc4_;
                  break;
               }
            }
         }
         if(param1 == "parallelogram3" || param1 == "parallelogram4")
         {
            _loc2_ = "shapes";
         }
         return this.art_loader.get_prop(_loc2_,param1);
      }
      
      public function get_prop_asset(param1:String) : ComicPropAsset
      {
         var _loc2_:ComicPropAsset = new ComicPropAsset(param1);
         if(this.loaded >= 2)
         {
            _loc2_.loadComplete(this.get_prop(param1));
         }
         else
         {
            if(this.load_prop_list[param1] == undefined)
            {
               this.load_prop_list[param1] = new Array();
            }
            this.load_prop_list[param1].push(_loc2_);
         }
         return _loc2_;
      }
      
      public function get_char_asset(param1:String, param2:DisplayObject, param3:int = -1) : ComicCharAsset
      {
         var _loc4_:ComicCharAsset = new ComicCharAsset(param1);
         if(param2)
         {
            param2.scaleX = param2.scaleY = param2.scaleY * (BSConstants.RESCALE / 0.45);
            _loc4_.artwork.addChild(param2);
            param2.x = -param2.width / 2;
            param2.y = -param2.height;
            param2.transform.colorTransform = new ColorTransform(1,1,1,1,-100,-100,-100);
         }
         this.get_char(param1,_loc4_.loaded_body,param3);
         return _loc4_;
      }
      
      public function get_char(param1:String, param2:Function, param3:int = -1) : Boolean
      {
         trace("In get char, requesting " + param1);
         if((this.dat_loader.get_char_data(param1,param3) || param1 == "-1") && this.loaded == 2)
         {
            trace("\tI already have body_id " + param1 + ", imediattely calling load_call");
            param2(param1,this.new_char(param1));
            return true;
         }
         if(this.load_calls[param1])
         {
            trace("\tSomeone already requested this body, adding our load_call to the list");
            this.load_calls[param1].push(param2);
            return true;
         }
         trace("\tI don\'t have the body yet, making a load_data call");
         this.load_calls[param1] = [param2];
         if(param1 != "-1")
         {
            this.dat_loader.load_char(param1,this.loaded_body,param3);
         }
         return true;
      }
   }
}
