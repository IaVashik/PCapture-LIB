// todo нейминг и ещё одна user filter func!
::TraceSettings <- class {
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

    function new(table) TraceSettings

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

    function _typeof() return "TraceSettings"
    function _cloned() {
        return TraceSettings(
            clone this.ignoreClasses, clone this.priorityClasses, clone this.ignoredModels, 
            this.errorTolerance, this.shouldRayHitEntity, this.shouldIgnoreEntity
        )
    }
}


// TODO
function TraceSettings::new(settings = {}) {
    local _ignoreClasses = toArrayLib(GetFromTable(settings, "ignoreClasses", clone TraceSettings.ignoreClasses))
    local _priorityClasses = toArrayLib(GetFromTable(settings, "priorityClasses", clone TraceSettings.priorityClasses))
    local _ignoredModels = toArrayLib(GetFromTable(settings, "ignoredModels", clone TraceSettings.ignoredModels))
    local _errorTolerance = GetFromTable(settings, "errorTolerance", TraceSettings.errorTolerance)
    local _shouldRayHitEntity = GetFromTable(settings, "shouldRayHitEntity", null)
    local _shouldIgnoreEntity = GetFromTable(settings, "shouldIgnoreEntity", null)
    
    return TraceSettings(
        _ignoreClasses, _priorityClasses, _ignoredModels, 
        _errorTolerance, _shouldRayHitEntity, _shouldIgnoreEntity
    )
}


// TODO
function TraceSettings::SetIgnoredClasses(array) {
    this.ignoreClasses = this.toArrayLib(array)
}

function TraceSettings::SetPriorityClasses(array) {
    this.priorityClasses = this.toArrayLib(array)
}

function TraceSettings::SetIgnoredModels(array) {
    this.ignoredModels = this.toArrayLib(array)
}

function TraceSettings::SetErrorTolerance(units) {
    this.errorTolerance = units
}


// TODO
function TraceSettings::AppendIgnoredClass(string) {
    this.ignoreClasses.append(string)
}

function TraceSettings::AppendPriorityClasses(string) {
    this.priorityClasses.append(string)
}

function TraceSettings::AppendIgnoredModel(string) {
    this.ignoredModels.append(string)
}



// TODO
function TraceSettings::GetIgnoreClasses() {
    return this.ignoreClasses
}

function TraceSettings::GetPriorityClasses() {
    return this.priorityClasses
}

function TraceSettings::GetIgnoredModels() {
    return this.ignoredModels
}

function TraceSettings::GetErrorTolerance() {
    return this.errorTolerance
}


// TODO
function TraceSettings::SetCollisionFilter(func) {
    this.shouldRayHitEntity = func
}

function TraceSettings::SetIgnoreFilter(func) {
    this.shouldIgnoreEntity = func
}

function TraceSettings::GetCollisionFilter() {
    return this.shouldRayHitEntity
}

function TraceSettings::GetIgnoreFilter() {
    return this.shouldIgnoreEntity
}

function TraceSettings::ApplyCollisionFilter(entity, note) {
    return this.shouldRayHitEntity ? this.shouldRayHitEntity(entity, note) : false
}

function TraceSettings::ApplyIgnoreFilter(entity, note) {
    return this.shouldIgnoreEntity ? this.shouldIgnoreEntity(entity, note) : false
}


//TODO
function TraceSettings::ToggleUseCostlyNormal(bool) {
    this.useCostlyNormalComputation = bool
}


//! BIG TODO
::toArrayLib <- function(array) {
    if(typeof array == "array")
        return arrayLib(array)
    return array
}