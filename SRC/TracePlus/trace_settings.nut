/*
 * Settings for ray traces.
*/
 TracePlus["Settings"] <- class {
    // An array of entity classnames to ignore during traces. 
    ignoreClasses = arrayLib.new("viewmodel", "weapon_", "beam",
        "trigger_", "phys_", "env_", "point_", "info_", "vgui_", "logic_",
        "clone", "prop_portal", "portal_base2D"
    );
    // An array of entity classnames to prioritize during traces.  
    priorityClasses = arrayLib.new();
    // An array of entity model names to ignore during traces. 
    ignoredModels = arrayLib.new();

    // The maximum allowed distance between a trace's start and hit positions. 
    errorTolerance = 500; 

    // A custom function to determine if a ray should hit an entity. 
    shouldRayHitEntity = null;
    // A custom function to determine if an entity should be ignored during a trace. 
    shouldIgnoreEntity = null;


    /*
     * Constructor for TraceSettings.
     *
     * @param {arrayLib} ignoreClasses - An array of entity classnames to ignore.
     * @param {arrayLib} priorityClasses - An array of entity classnames to prioritize. 
     * @param {arrayLib} ignoredModels - An array of entity model names to ignore.
     * @param {number} errorTolerance - The maximum allowed distance between trace start and hit positions.
     * @param {function} shouldRayHitEntity - A custom function to determine if a ray should hit an entity.
     * @param {function} shouldIgnoreEntity - A custom function to determine if an entity should be ignored. 
    */
    constructor(ignoreClasses, priorityClasses, ignoredModels, errorTolerance, shouldRayHitEntity, shouldIgnoreEntity) {
        this.ignoreClasses = ignoreClasses
        this.priorityClasses = priorityClasses
        this.priorityClasses = priorityClasses
        this.ignoredModels = ignoredModels
        this.errorTolerance = errorTolerance
        this.shouldRayHitEntity = shouldRayHitEntity
        this.shouldIgnoreEntity = shouldIgnoreEntity
    }

    /*
     * Creates a new TraceSettings object with default values or from a table of settings. 
     * 
     * @param {table} settingsTable - A table containing settings to override the defaults. (optional)
     * @returns {TraceSettings} - A new TraceSettings object.
    */
    function new(settingsTable = {}) {
        // Get the ignoreClasses setting from the settings table or use the default. 
        local ignoreClasses = arrayLib(macros.GetFromTable(settingsTable, "ignoreClasses", clone(TracePlus.Settings.ignoreClasses)))
        // Get the priorityClasses setting from the settings table or use the default. 
        local priorityClasses = arrayLib(macros.GetFromTable(settingsTable, "priorityClasses", clone(TracePlus.Settings.priorityClasses)))
        // Get the ignoredModels setting from the settings table or use the default. 
        local ignoredModels = arrayLib(macros.GetFromTable(settingsTable, "ignoredModels", clone(TracePlus.Settings.ignoredModels)))
        
        // Get the errorTolerance setting from the settings table or use the default. 
        local errorTolerance = macros.GetFromTable(settingsTable, "errorTolerance", TracePlus.Settings.errorTolerance)
        // Get the shouldRayHitEntity setting from the settings table or use the default.  
        local shouldRayHitEntity = macros.GetFromTable(settingsTable, "shouldRayHitEntity", null)
        // Get the shouldIgnoreEntity setting from the settings table or use the default. 
        local shouldIgnoreEntity = macros.GetFromTable(settingsTable, "shouldIgnoreEntity", null)
        
        // Create and return a new TraceSettings object with the specified or default settings. 
        return TracePlus.Settings(
            ignoreClasses, priorityClasses, ignoredModels, 
            errorTolerance, shouldRayHitEntity, shouldIgnoreEntity
        )
    }


    /*
     * Sets the list of entity classnames to ignore during traces.
     *
     * @param {array|arrayLib} ignoreClassesArray - An array or arrayLib containing entity classnames to ignore. 
    */
    function SetIgnoredClasses(ignoreClassesArray) {
        this.ignoreClasses = arrayLib(ignoreClassesArray)
    }

    /*
     * Sets the list of entity classnames to prioritize during traces.
     *
     * @param {array|arrayLib} priorityClassesArray - An array or arrayLib containing entity classnames to prioritize. 
    */
    function SetPriorityClasses(priorityClassesArray) {
        this.priorityClasses = arrayLib(priorityClassesArray)
    }

    /*
     * Sets the list of entity model names to ignore during traces.
     *
     * @param {array|arrayLib} ignoredModelsArray - An array or arrayLib containing entity model names to ignore. 
    */
    function SetIgnoredModels(ignoredModelsArray) {
        this.ignoredModels = arrayLib(ignoredModelsArray)
    }

    /*
     * Sets the maximum allowed distance between trace start and hit positions. 
     *
     * @param {number} tolerance - The maximum allowed distance in units. 
    */
    function SetErrorTolerance(tolerance) {
        this.errorTolerance = tolerance
    }


    /*
     * Appends an entity classname to the list of ignored classes. 
     *
     * @param {string} className - The classname to append. 
    */
    function AppendIgnoredClass(className) {
        this.ignoreClasses.append(className)
    }

    /*
     * Appends an entity classname to the list of priority classes. 
     *
     * @param {string} className - The classname to append. 
    */
    function AppendPriorityClasses(className) {
        this.priorityClasses.append(className)
    }

    /*
     * Appends an entity model name to the list of ignored models. 
     *
     * @param {string} modelName - The model name to append. 
    */
    function AppendIgnoredModel(modelName) {
        this.ignoredModels.append(modelName)
    }



    /* 
     * Gets the list of entity classnames to ignore during traces. 
     *
     * @returns {arrayLib} - An arrayLib containing the ignored classnames. 
    */
    function GetIgnoreClasses() {
        return this.ignoreClasses
    }

    /*
     * Gets the list of entity classnames to prioritize during traces. 
     *
     * @returns {arrayLib} - An arrayLib containing the priority classnames. 
    */
    function GetPriorityClasses() {
        return this.priorityClasses
    }

    /*
     * Gets the list of entity model names to ignore during traces. 
     *
     * @returns {arrayLib} - An arrayLib containing the ignored model names. 
    */
    function GetIgnoredModels() {
        return this.ignoredModels
    }

    /*
     * Gets the maximum allowed distance between trace start and hit positions. 
     *
     * @returns {number} - The maximum allowed distance in units. 
    */
    function GetErrorTolerance() {
        return this.errorTolerance
    }


    /*
     * Sets a custom function to determine if a ray should hit an entity. 
     *
     * @param {function} filterFunction - The filter function to set. 
    */
    function SetCollisionFilter(filterFunction) { // aka. SetHitFilter
        this.shouldRayHitEntity = filterFunction
    }

    /*
     * Sets a custom function to determine if an entity should be ignored during a trace. 
     *
     * @param {function} filterFunction - The filter function to set. 
    */
    function SetIgnoreFilter(filterFunction) {
        this.shouldIgnoreEntity = filterFunction
    }

    /*
     * Gets the custom collision filter function. 
     *
     * @returns {function|null} - The collision filter function, or null if not set. 
    */
    function GetCollisionFilter() {
        return this.shouldRayHitEntity
    }

    /*
     * Gets the custom ignore filter function. 
     *
     * @returns {function|null} - The ignore filter function, or null if not set. 
    */
    function GetIgnoreFilter() {
        return this.shouldIgnoreEntity
    }

    /*
     * Applies the custom collision filter function to an entity. 
     *
     * @param {CBaseEntity|pcapEntity} entity - The entity to check.
     * @param {string|null} note - An optional note associated with the trace.
     * @returns {boolean} - True if the ray should hit the entity, false otherwise. 
    */
    function ApplyCollisionFilter(entity, note) {
        return this.shouldRayHitEntity ? this.shouldRayHitEntity(entity, note) : false
    }

    /*
     * Applies the custom ignore filter function to an entity. 
     *
     * @param {CBaseEntity|pcapEntity} entity - The entity to check.
     * @param {string|null} note - An optional note associated with the trace.
     * @returns {boolean} - True if the entity should be ignored, false otherwise. 
    */
    function ApplyIgnoreFilter(entity, note) {
        return this.shouldIgnoreEntity ? this.shouldIgnoreEntity(entity, note) : false
    }

    /*
     * Updates the list of entities to ignore during a trace, including the player entity.
     *
     * @param {array|CBaseEntity|null} ignoreEntities - The current list of entities to ignore.
     * @param {CBaseEntity|pcapEntity} newEnt - The new entity to add to the ignore list.
     * @returns {array} - The updated list of entities to ignore. 
    */
    function UpdateIgnoreEntities(ignoreEntities, newEnt) {
        // Check if any entities should be ignored during the trace 
        if (ignoreEntities) {
            // If ignoreEntities is an array, append the player entity to it 
            if (typeof ignoreEntities == "array" || typeof ignoreEntities == "arrayLib") {
                ignoreEntities.append(newEnt)
            }
            // If ignoreEntities is a single entity, create a new array with both the player and ignoreEntities 
            else {
                ignoreEntities = [newEnt, ignoreEntities]
            }
        }
        // If no ignoreEntities is provided, ignore the player only 
        else {
            ignoreEntities = newEnt
        }

        return ignoreEntities
    }

    function _typeof() return "TraceSettings"
    function _cloned() {
        return Settings(
            clone this.ignoreClasses, clone this.priorityClasses, clone this.ignoredModels, 
            this.errorTolerance, this.shouldRayHitEntity, this.shouldIgnoreEntity
        )
    }
}