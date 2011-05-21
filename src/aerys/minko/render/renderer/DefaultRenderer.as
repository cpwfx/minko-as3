package aerys.minko.render.renderer
{
	import aerys.common.Factory;
	import aerys.minko.ns.minko;
	import aerys.minko.ns.minko_render;
	import aerys.minko.render.Viewport;
	import aerys.minko.render.state.RenderState;
	import aerys.minko.scene.visitor.data.TransformManager;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.IndexBuffer3D;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class DefaultRenderer implements IRenderer
	{
		use namespace minko;
		use namespace minko_render;
		
		private static const RENDER_SESSION	: Factory			= Factory.getFactory(RenderSession);
		private static const RENDER_STATE	: Factory			= Factory.getFactory(RenderState);
		private static const SORT			: Boolean			= true;
		private static const DEBUG			: Boolean			= true;
		
		private var _context		: Context3D					= null;
		private var _state			: RenderState				= new RenderState();
		private var _actualState	: RenderState				= new RenderState();
		private var _transform		: TransformManager			= new TransformManager();
		private var _numTriangles	: uint						= 0;
		private var _viewport		: Viewport					= null;
		private var _drawingTime	: int						= 0;
		private var _frame			: uint						= 0;
		
		private var _sessions		: Vector.<RenderSession>	= new Vector.<RenderSession>();
		private var _currentSession	: RenderSession				= new RenderSession();
		private var _numSessions	: int						= 0;
		
		public function get state() 		: RenderState	{ return _state; }
		public function get numTriangles()	: uint			{ return _numTriangles; }
		public function get viewport()		: Viewport		{ return _viewport; }
		public function get drawingTime()	: int			{ return _drawingTime; }
		public function get frameId()		: uint			{ return _frame; }
		
		public function DefaultRenderer(viewport : Viewport, context : Context3D)
		{
			_viewport = viewport;
			_context = context;
			
			_context.enableErrorChecking = DEBUG;
		}
		
		public function begin()	: void
		{
			_state = RENDER_STATE.create();
			_state.clear();
			
			_currentSession = RENDER_SESSION.create();
			_currentSession.renderState = _state;
			_currentSession.offsets.length = 0;
			_currentSession.numTriangles.length = 0;
		}
		
		public function end() : void
		{
			if (_currentSession && _currentSession.renderState)
				_sessions[int(_numSessions++)] = _currentSession;
		}
		
		public function drawTriangles(offset : uint = 0, numTriangles : int = -1) : void
		{
			_currentSession.renderState = _state;
			_currentSession.offsets.push(offset);
			_currentSession.numTriangles.push(numTriangles);
			
			_numTriangles += numTriangles == -1 ? _state._indexStream.length / 3. : numTriangles;
		}
		
		public function clear(red		: Number	= 0.,
							  green		: Number	= 0.,
							  blue		: Number	= 0.,
							  alpha		: Number	= 0.,
							  depth		: Number	= 0.,
							  stencil	: uint		= 0,
							  mask		: uint		= 0xffffffff)  :void
		{
			_context.clear(red, green, blue, alpha, depth, stencil, mask);
			
			_numTriangles = 0;
			_drawingTime = 0;
			_currentSession = null;
			_numSessions = 0;
			
			_actualState.clear();
			
			end();
		}
		
		public function present() : void
		{
			var time : int = getTimer();
			
			if (SORT && _numSessions > 1)
				_sessions = _sessions.sort(compareRenderStates);
			
			for (var i : int = 0; i < _numSessions; ++i)
			{
				_currentSession = _sessions[i];
				
				var state			: RenderState 	= _currentSession.renderState;
				var offsets 		: Vector.<uint>	= _currentSession.offsets;
				var numTriangles 	: Vector.<int> 	= _currentSession.numTriangles;
				var numCalls 		: int 			= offsets.length;
				
				state.prepareContext(_context, _actualState);
				
				for (var j : int = 0; j < numCalls; ++j)
				{
					var ib : IndexBuffer3D = state._indexStream.getIndexBuffer3D(_context);
					
					if (ib)
						_context.drawTriangles(ib, offsets[j], numTriangles[j]);
				}
				
				RENDER_SESSION.free(_currentSession);
				RENDER_STATE.free(_actualState);
				
				_actualState = state;
			}
			
			_context.present();
			
			_drawingTime += getTimer() - time;
			++_frame;
		}
		
		public function drawToBitmapData(bitmapData : BitmapData) : void
		{
			_context.drawToBitmapData(bitmapData);
		}
		
		private function compareRenderStates(rs1 : RenderSession, rs2 : RenderSession) : Number
		{
			return 1000 * (rs2.renderState.priority - rs1.renderState.priority);
		}
	}
}