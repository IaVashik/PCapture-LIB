// todo нейминг и ещё одна user filter func!
TracePlus["Settings"] <- class {
    ignoreClasses = arrayLib.new("viewmodel", "weapon_", "beam"
        "trigger_", "phys_", "env_", "point_", "info_", "vgui_", "logic_"
        "clone", "prop_portal", "portal_base2D"
    );
    priorityClasses = arrayLib.new();
    ignoredModels = arrayLib.new();

    errorTolerance = 500; // units
    useCostlyNormalComputation = false; // UNSTABLE!

    shouldRayHitEntity = null;
    shouldIgnoreEntity = null;


    constructor(ignoreClasses, priorityClasses, ignoredModels, errorTolerance, shouldRayHitEntity, shouldIgnoreEntity) {
        this.ignoreClasses = ignoreClasses
        this.priorityClasses = priorityClasses
        this.ignoredModels = ignoredModels
        this.errorTolerance = errorTolerance
        this.shouldRayHitEntity = shouldRayHitEntity
        this.shouldIgnoreEntity = shouldRayHitEntity
    }

    function new(table) Self

    function SetIgnoredClasses(array) null
    function SetPriorityClasses(array) null
    function SetIgnoredModels(array) null
    function SetErrorTolerance(int) null

    function AppendIgnoredClass(string) null
    function AppendPriorityClasses(string) null
    function AppendIgnoredModel(string) null

    function GetIgnoreClasses() array
    function GetPriorityClasses() array
    function GetIgnoredModels() array
    function GetErrorTolerance() int

    function SetCollisionFilter(func) null
    function SetIgnoreFilter(func) null
    function GetCollisionFilter() func
    function GetIgnoreFilter() func
    function ApplyCollisionFilter(entity, note) bool
    function ApplyIgnoreFilter(entity, note) bool

    function ToggleUseCostlyNormal(bool) null

    function UpdateIgnoreEnts(ignoreEnts, newEnt) array

    function _typeof() return "TraceSettings"
    function _cloned() {
        return Settings(
            clone this.ignoreClasses, clone this.priorityClasses, clone this.ignoredModels, 
            this.errorTolerance, this.shouldRayHitEntity, this.shouldIgnoreEntity
        )
    }
}


// TODO
function TracePlus::Settings::new(settings = {}) {
    local _ignoreClasses = arrayLib(macros.GetFromTable(settings, "ignoreClasses", clone(TracePlus.Settings.ignoreClasses)))
    local _priorityClasses = arrayLib(macros.GetFromTable(settings, "priorityClasses", clone(TracePlus.Settings.priorityClasses)))
    local _ignoredModels = arrayLib(macros.GetFromTable(settings, "ignoredModels", clone(TracePlus.Settings.ignoredModels)))
    
    local _errorTolerance = macros.GetFromTable(settings, "errorTolerance", TracePlus.Settings.errorTolerance)
    local _shouldRayHitEntity = macros.GetFromTable(settings, "shouldRayHitEntity", null)
    local _shouldIgnoreEntity = macros.GetFromTable(settings, "shouldIgnoreEntity", null)
    
    return TracePlus.Settings(
        _ignoreClasses, _priorityClasses, _ignoredModels, 
        _errorTolerance, _shouldRayHitEntity, _shouldIgnoreEntity
    )
}


// TODO
function TracePlus::Settings::SetIgnoredClasses(array) {
    this.ignoreClasses = arrayLib(array)
}

function TracePlus::Settings::SetPriorityClasses(array) {
    this.priorityClasses = arrayLib(array)
}

function TracePlus::Settings::SetIgnoredModels(array) {
    this.ignoredModels = arrayLib(array)
}

function TracePlus::Settings::SetErrorTolerance(units) {
    this.errorTolerance = units
}


// TODO
function TracePlus::Settings::AppendIgnoredClass(string) {
    this.ignoreClasses.append(string)
}

function TracePlus::Settings::AppendPriorityClasses(string) {
    this.priorityClasses.append(string)
}

function TracePlus::Settings::AppendIgnoredModel(string) {
    this.ignoredModels.append(string)
}



// TODO
function TracePlus::Settings::GetIgnoreClasses() {
    return this.ignoreClasses
}

function TracePlus::Settings::GetPriorityClasses() {
    return this.priorityClasses
}

function TracePlus::Settings::GetIgnoredModels() {
    return this.ignoredModels
}

function TracePlus::Settings::GetErrorTolerance() {
    return this.errorTolerance
}


// TODO
function TracePlus::Settings::SetCollisionFilter(func) {
    this.shouldRayHitEntity = func
}

function TracePlus::Settings::SetIgnoreFilter(func) {
    this.shouldIgnoreEntity = func
}

function TracePlus::Settings::GetCollisionFilter() {
    return this.shouldRayHitEntity
}

function TracePlus::Settings::GetIgnoreFilter() {
    return this.shouldIgnoreEntity
}

function TracePlus::Settings::ApplyCollisionFilter(entity, note) {
    return this.shouldRayHitEntity ? this.shouldRayHitEntity(entity, note) : false
}

function TracePlus::Settings::ApplyIgnoreFilter(entity, note) {
    return this.shouldIgnoreEntity ? this.shouldIgnoreEntity(entity, note) : false
}


//TODO
function TracePlus::Settings::ToggleUseCostlyNormal(bool) {
    this.useCostlyNormalComputation = bool
}

 function TracePlus::Settings::UpdateIgnoreEnts(ignoreEnts, newEnt) {
    // Check if any entities should be ignored during the trace
    if (ignoreEnts) {
        // If ignoreEnts is an array, append the player entity to it
        if (typeof ignoreEnts == "array" || typeof ignoreEnts == "arrayLib") {
            ignoreEnts.append(newEnt)
        }
        // If ignoreEnts is a single entity, create a new array with both the player and ignoreEnts
        else {
            ignoreEnts = [newEnt, ignoreEnts]
        }
    }
    // If no ignoreEnts is provided, ignore the player only
    else {
        ignoreEnts = newEnt
    }

    return ignoreEnts
}