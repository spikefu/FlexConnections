package
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.utils.StringUtil;

	public class SourceInfo
	{
		public var file:File;
		
		public var imports:Array;
		
		public var namespaces:Array;
		
		public function SourceInfo(file:File)
		{
			this.file = file;
			imports = [];
			namespaces = [];
			readAndParse();
		}
		
		private function readAndParse():void {
			var fileStream:FileStream = new FileStream();
			fileStream.open(file,FileMode.READ); 
			var contents:String = fileStream.readUTFBytes(fileStream.bytesAvailable);
			if (contents && StringUtil.trim(contents).length > 0) {
				var lines:Array = contents.split("\n");
				if (contents.split("\r").length > lines.length) {
					lines = contents.split("\r");
				}
				for each (var line:String in lines) {
					if (line.indexOf("import") >= 0) {
						imports.push(getImportString(line));
					} else if (line.indexOf("xmlns:") >=0) {
						var offset:int = 0;
						while (offset >= 0) {
							offset = line.indexOf("xmlns:",offset);
							if (offset >= 0) {
								namespaces.push(getXmlNamespace(line,offset));
								offset++;
							}
						}
					}
				}
			}
			trace("Found " + imports.length + " imports and " + namespaces.length + " namespaces in " + file.nativePath);
		}
		
		private function getImportString(s:String):String {
			var token:String = "import";
			var start:int = s.indexOf(token) + token.length;
			var end:int = s.indexOf(";");
			return StringUtil.trim(s.substring(start,end));
		}
		
		private function getXmlNamespace(s:String,offset:int):String {
			var token:String = "xmlns:";
			var start:int = s.indexOf(token,offset);
			start = s.indexOf('"',start)+1;
			var end:int = s.indexOf('"',start+1);
			return s.substring(start,end);
		}
	}
}