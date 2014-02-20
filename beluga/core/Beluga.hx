package beluga.core;

import beluga.core.module.Module;
import beluga.core.module.ModuleInternal;
import haxe.Resource;
import haxe.xml.Fast;
import php.Web;
import sys.io.File;
import beluga.core.Database;
import beluga.core.api.BelugaApi;

//Enable or disable this line to check module compilations
/**import beluga.core.module.ManualBuildModule;/**/

/**
 * ...
 * @author Masadow
 */
class Beluga
{

	//No singleton pattern allows multiple instance of Beluga
	public var triggerDispatcher(default, null) : TriggerDispatcher;
	// Keep an instance of beluga's database, read only
	public var db(default, null) : Database;
	//Instance of beluga API, read only
	public var api : BelugaApi;

	public function new()
	{
		triggerDispatcher = new TriggerDispatcher();

		//Load configuration
//		var file = File.getContent("beluga.xml"); //Problem, where should we put this configuration file ?
//		var xml = Xml.parse(file);                //Is it necessary to let user edit it without recompile its project ?
//		var fast = new Fast(xml);

		// Look for active modules
		var config = MacroHelper.importConfig();
		var xml = Xml.parse(Resource.getString("beluga_config.xml"));
		var fast = new Fast(xml);

		// Load beluga general configuration
		// Not used anymore => It has no sense if you move the bin folder whereas it should not be dependant of haxe installation after compilation
//		installPath = Resource.getString("beluga_installPath");
//		installPath = fast.node.install.att.path;

		db = null;
		//Connect to database
		if (fast.hasNode.database) {
			db = new Database(fast.node.database.elements);
		}

		// Look for triggers
		for (trigger in fast.nodes.trigger) {
			var trig = new Trigger(trigger);
			triggerDispatcher.register(trig);
		}

		//Init every modules
		for (moduleName in Reflect.fields(config.modules)) {
			var module = Reflect.field(config.modules, moduleName);
			var moduleInstance : ModuleInternal = cast MacroHelper.getModuleInstanceByName(moduleName);
			if (moduleInstance != null) {
				moduleInstance._loadConfig(this, module);
			}
		}
		
		//Create beluga API
		api = new BelugaApi(this);
	}
	
	public function dispatch(defaultTrigger : String = "index") {
		var trigger = Web.getParams().get("trigger");
		triggerDispatcher.dispatch(trigger != null ? trigger : defaultTrigger);
	}
	
	public function cleanup() {
		db.close();
	}

	public function getModuleInstance<T : Module>(clazz : Class<T>, key : String = "") : T
	{
		return cast MacroHelper.getModuleInstanceByName(Type.getClassName(clazz), key);
//		return T.getInstance();
	}
	
}