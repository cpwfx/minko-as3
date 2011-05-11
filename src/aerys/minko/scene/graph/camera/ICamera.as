﻿package aerys.minko.scene.graph.camera 
{
	import aerys.common.IVersionnable;
	import aerys.minko.scene.graph.IScene;
	import aerys.minko.scene.graph.IWorldObject;
	import aerys.minko.type.math.Vector4;
	
	/**
	 * ...
	 * @author Jean-Marc Le Roux
	 */
	public interface ICamera extends IScene, IVersionnable, IWorldObject
	{
		function get enabled() 		: Boolean;
		
		function get position()		: Vector4;
		function get lookAt()		: Vector4;
		function get up()			: Vector4;
		
		function get fieldOfView()	: Number;
		function get nearClipping()	: Number;
		function get farClipping()	: Number;
		
	}
}