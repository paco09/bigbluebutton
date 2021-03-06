package org.bigbluebutton.modules.present.model
{
  import flash.events.Event;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;
  import flash.utils.ByteArray;

  public class Page {
    private var _id: String;
    private var _num: int;
    private var _swfUri: String;
    private var _txtUri: String;
    private var _pngUri: String;
    private var _thumbUri: String;
    
    public var current: Boolean;
    public var xOffset: Number;
    public var yOffset: Number;
    public var widthRatio: Number;
    public var heightRatio: Number
    
    private var _swfLoader:URLLoader;
    private var _swfLoaded:Boolean = false;
    private var _swfLoadedListener:Function;
    
    private var _txtLoader:URLLoader;
    private var _txtLoaded:Boolean = false;
    private var _txtLoadedListener:Function;
    
	private var _preloadCount:uint = 0;
	
    public function Page(id: String, num: int, current: Boolean,
                swfUri: String, thumbUri: String, txtUri: String,
                pngUri: String, x: Number, y: Number,
                width: Number, height: Number) {
       _id = id;
       _num = num;
       this.current = current;
       _swfUri = swfUri;
       _thumbUri = thumbUri;
       _txtUri = txtUri;
       _pngUri = pngUri;
       this.xOffset = x;
       this.yOffset = y;
       this.widthRatio = width;
       this.heightRatio = height;
       
       _swfLoader = new URLLoader();
       _swfLoader.addEventListener(Event.COMPLETE, handleSwfLoadingComplete);	
       _swfLoader.dataFormat = URLLoaderDataFormat.BINARY;
       
       _txtLoader = new URLLoader();
       _txtLoader.addEventListener(Event.COMPLETE, handleTextLoadingComplete);	
       _txtLoader.dataFormat = URLLoaderDataFormat.TEXT;	
    }
    
    public function get id():String {
      return _id;
    }
    
    public function get num():int {
      return _num;
    }
       
    public function get swfUri():String {
      return _swfUri;
    }
    
    public function get thumbUri():String {
      return _thumbUri;
    }
    
    public function get txtUri():String {
      return _txtUri;
    }
    
    public function get swfData():ByteArray {
      if (_swfLoaded) return _swfLoader.data;
      return null;
    }
    
    public function loadSwf(swfLoadedListener:Function, preloadCount:uint):void {
      if (_swfLoaded) {
        swfLoadedListener(_id, preloadCount);
      } else {
        _swfLoadedListener = swfLoadedListener;
		_preloadCount = preloadCount;
        _swfLoader.load(new URLRequest(_swfUri));
      }
    }
    
    private function handleSwfLoadingComplete(e:Event):void{
      _swfLoaded = true;
      if (_swfLoadedListener != null) {
        _swfLoadedListener(_id, _preloadCount);
      }
	  _preloadCount = 0;
    }

    public function get txtData():String {
      if (_txtLoaded) {
        return _txtLoader.data;
      }
      return null;
    }
    
    public function loadTxt(txtLoadedListener:Function):void {
      if (_txtLoaded) {
        txtLoadedListener(_id);
      } else {
        _txtLoadedListener = txtLoadedListener;
        _txtLoader.load(new URLRequest(_txtUri));
      }
    }
    
    private function handleTextLoadingComplete(e:Event):void{
      _txtLoaded = true;
      if (_txtLoadedListener != null) {
        _txtLoadedListener(_id);
      }		
    }    
    
  }
}