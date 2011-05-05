package
{
	import flash.filesystem.File;

	public class PackageInfo
	{
		
		public var folder:File;
		
		public var sources:Array;
		
		public function PackageInfo(folder:File)
		{
			this.folder = folder;
			sources = [];
		}
	}
}