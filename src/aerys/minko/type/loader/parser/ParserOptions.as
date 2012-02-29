package aerys.minko.type.loader.parser
{
	import aerys.minko.render.effect.Effect;
	
	import flash.net.URLRequest;
	
	import spark.layouts.BasicLayout;

	/**
	 * ParserOptions objects provide properties and function references
	 * to customize how a LoaderGroup object will load and interpret 
	 * content.
	 *  
	 * @author Jean-Marc Le Roux
	 * 
	 */
	public final class ParserOptions
	{
		public var debug : *; 
		
		private var _loadDependencies		: Boolean	= false;
		private var _dependencyURLRewriter	: Function	= defaultRewriteDependencyFunction;
		private var _mipmapTextures			: Boolean	= true;
		private var _meshEffect				: Effect	= null;
		private var _vertexStreamUsage		: uint		= 0;
		private var _indexStreamUsage		: uint		= 0;
		private var _parser					: Class		= null;
		
		public function get parser():Class
		{
			return _parser;
		}
		
		public function set parser(value:Class):void
		{
			_parser = value;
		}
		
		public function get indexStreamUsage():uint
		{
			return _indexStreamUsage;
		}
		
		public function set indexStreamUsage(value:uint):void
		{
			_indexStreamUsage = value;
		}
		
		public function get vertexStreamUsage():uint
		{
			return _vertexStreamUsage;
		}
		
		public function set vertexStreamUsage(value:uint):void
		{
			_vertexStreamUsage = value;
		}
		
		public function get effect():Effect
		{
			return _meshEffect;
		}
		
		public function set effect(value:Effect):void
		{
			_meshEffect = value;
		}
		
		public function get mipmapTextures():Boolean
		{
			return _mipmapTextures;
		}
		
		public function set mipmapTextures(value:Boolean):void
		{
			_mipmapTextures = value;
		}
		
		public function get dependencyURLRewriter():Function
		{
			return _dependencyURLRewriter;
		}
		
		public function set dependencyURLRewriter(value:Function):void
		{
			_dependencyURLRewriter = value;
		}
		
		public function get loadDependencies():Boolean
		{
			return _loadDependencies;
		}
		
		public function set loadDependencies(value:Boolean):void
		{
			_loadDependencies = value;
		}

		
		public function ParserOptions(loadDependencies		: Boolean = false,
									  dependencyURLRewriter : Function = null,
									  mipmapTextures		: Boolean = true,
									  meshEffect			: Effect = null,
									  vertexStreamUsage		: uint = 0,
									  indexStreamUsage		: uint = 0,
									  parser				: Class = null)
		{
			_loadDependencies = loadDependencies;
			_dependencyURLRewriter = dependencyURLRewriter || _dependencyURLRewriter;
			_mipmapTextures = mipmapTextures;
			_meshEffect = meshEffect;
			_vertexStreamUsage = vertexStreamUsage;
			_indexStreamUsage = indexStreamUsage;
			_parser = parser;
		}
		
		private function defaultRewriteDependencyFunction(url : String) : String
		{
			return url;
		}
	}
}