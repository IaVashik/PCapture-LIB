// todo нейминг и ещё одна user filter func!
::TraceSettings <- class {
    ignoreClass = arrayLib.new("viewmodel", "weapon_", "info_particle_system",
    "trigger_", "phys_", "env_", "point_", "info_", "vgui_", "physicsclonearea");
    priorityClass = arrayLib.new();
    errorCoefficient = 500;
    customFilter = null;
    portalTracing = false;

    constructor(ignoreClass, priorityClass, errorCoefficient, customFilter, portalTracing) {
        this.ignoreClass = ignoreClass
        this.priorityClass = priorityClass
        this.errorCoefficient = errorCoefficient
        this.customFilter = customFilter
        this.portalTracing = portalTracing
    }

    function new(table) TraceSettings

    function SetIgnoreClass(array) null
    function SetPriorityClass(array) null
    function SetErrorCoefficient(int) null
    function SetCustomFilter(func) null

    function GetIgnoreClass() array
    function GetPriorityClass() array
    function GetErrorCoefficient() int
    function GetCustomFilter() func

    function EnablePortalTracing() null
    function DisablePortalTracing() null
    function TogglePortalTracing() null

    function RunUserFilter() bool

    function _toArrayLib(array) arrayLib
}


// TODO
function TraceSettings::new(settings = {}) {
    local _ignoreClass = toArrayLib(GetFromTable(settings, "ignoreClass", TraceSettings.ignoreClass))
    local _priorityClass = toArrayLib(GetFromTable(settings, "priorityClass", TraceSettings.priorityClass))
    local _errorCoefficient = GetFromTable(settings, "errorCoefficient", TraceSettings.errorCoefficient)
    local _customFilter = GetFromTable(settings, "customFilter", TraceSettings.customFilter)
    local _portalTracing = GetFromTable(settings, "portalTracing", TraceSettings.portalTracing)

    return TraceSettings(_ignoreClass, _priorityClass, _errorCoefficient, _customFilter, _portalTracing)
}


// TODO
function TraceSettings::SetIgnoreClass(array) {
    this.ignoreClass = this._toArrayLib(array)
}

function TraceSettings::SetPriorityClass(array) {
    this.priorityClass = this._toArrayLib(array)
}

function TraceSettings::SetErrorCoefficient(units) {
    this.errorCoefficient = units
}

function TraceSettings::SetCustomFilter(func) {
    this.ignoreClass = func
}


// TODO
function TraceSettings::GetIgnoreClass() {
    return this.ignoreClass
}

function TraceSettings::GetPriorityClass() {
    return this.priorityClass
}

function TraceSettings::GetErrorCoefficient() {
    return this.errorCoefficient
}

function TraceSettings::GetCustomFilter() {
    return this.customFilter
}


// TODO
function TraceSettings::EnablePortalTracing() {
    this.portalTracing = true
}

function TraceSettings::DisablePortalTracing() {
    this.portalTracing = false
}

function TraceSettings::TogglePortalTracing() {
    this.portalTracing = !this.portalTracing
}


//! BIG TODO
::toArrayLib <- function(array) {
    if(typeof array == "array")
        return arrayLib(array)
    return array
}