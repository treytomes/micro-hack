// Load a module into a local variable, allowing it to be reassigned at will.
// e.g. player = import("playerBehaviors")
globals.require = function(moduleName)
	import moduleName
	return locals[moduleName]
end function

// ensureImport: check whether the given module has been imported already
// (or is in the process of being imported).  If so, return immediately.
// If not, then import that module into the global namespace.
globals.ensureImport = function(moduleName)
	if globals.hasIndex(moduleName) then return
	globals[moduleName] = "PENDING"	// (module is being imported now)
	globals[moduleName] = require(moduleName)
end function

