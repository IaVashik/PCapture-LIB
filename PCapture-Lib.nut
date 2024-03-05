/*+--------------------------------------------------------------------------------+
|                           PCapture Vscripts Library                               |
 +---------------------------------------------------------------------------------+
|  Author:                                                                          |
|     One-of-a-Kind - laVashik :D                                                   |
|  Don't forgot about credits! ^-^                                                  |
 +---------------------------------------------------------------------------------+
|    VScripts library for Portal 2 that provides various features and enhancements. |
|    It aims to help modders build advanced custom mechanics more easily!!          |
|    GitHud repo: https://github.com/IaVashik/PCapture-LIB                          |
+----------------------------------------------------------------------------------+ */

if (!("self" in this)) {
    self <- Entities.FindByClassname(null, "worldspawn")
} else {
    getroottable()["self"] <- self
}
if("math" in getroottable()) {
    dev.warning("Math module initialization skipped. Module already initialized.")
    return
}
::math <- {
    
    Quaternion = class {    
        quaternion = null 
        
        constructor(quaternion = null) {
            this.quaternion = quaternion
        }
        
        function new(angles) {
            
            local pitch = angles.z * 0.5 / 180 * PI
            local yaw = angles.y * 0.5 / 180 * PI
            local roll = angles.x * 0.5 / 180 * PI
            
            local sRoll = sin(roll);
            local cRoll = cos(roll);
            local sPitch = sin(pitch);
            local cPitch = cos(pitch);
            local sYaw = sin(yaw);
            local cYaw = cos(yaw);
            
            local quaternion = {  
                x = cYaw * cRoll * sPitch - sYaw * sRoll * cPitch,
                y = cYaw * sRoll * cPitch + sYaw * cRoll * sPitch,
                z = sYaw * cRoll * cPitch - cYaw * sRoll * sPitch,
                w = cYaw * cRoll * cPitch + sYaw * sRoll * sPitch
            }
            return math.Quaternion(quaternion)
        }
        
        function multiplyQuaternions(q1, q2) {
            return {
                x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
                y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x,
                z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w,
                w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z
            }
        }
        
        function rotate(vector) {
            
            local vecQuaternion = { x = vector.x, y = vector.y, z = vector.z, w = 0 };
        
            
            local inverse = {
                x = -this.quaternion.x,
                y = -this.quaternion.y,
                z = -this.quaternion.z,
                w = this.quaternion.w
            };
        
            
            local rotatedQuaternion = multiplyQuaternions(multiplyQuaternions(this.quaternion, vecQuaternion), inverse);
        
            
            return Vector(rotatedQuaternion.x, rotatedQuaternion.y, rotatedQuaternion.z);
        }
        
        
        function unrotate(vector) {
            
            local conjugateQuaternion = {
                x = -this.quaternion.x,
                y = -this.quaternion.y,
                z = -this.quaternion.z,
                w = this.quaternion.w
            };
        
            
            local vecQuaternion = { x = vector.x, y = vector.y, z = vector.z, w = 0 };
        
            
            local unrotatedQuaternion = multiplyQuaternions(multiplyQuaternions(conjugateQuaternion, vecQuaternion), this.quaternion);
        
            
            return Vector(unrotatedQuaternion.x, unrotatedQuaternion.y, unrotatedQuaternion.z);
        }
        
        function slerp(targetQuaternion, t) {
            local quaternion1 = this.quaternion
            local quaternion2 = targetQuaternion.get_table()
            
            quaternion1 = _normalizeQuaternion(quaternion1);
            quaternion2 = _normalizeQuaternion(quaternion2);
            
            local cosTheta = quaternion1.x * quaternion2.x + quaternion1.y * quaternion2.y + quaternion1.z * quaternion2.z + quaternion1.w * quaternion2.w;
            
            if (cosTheta < 0) {
                quaternion2.x *= -1;
                quaternion2.y *= -1;
                quaternion2.z *= -1;
                quaternion2.w *= -1;
                cosTheta *= -1;
            }
            
            local theta = acos(cosTheta);
            local sinTheta = sin(theta);
            local weight1 = sin((1 - t) * theta) / sinTheta;
            local weight2 = sin(t * theta) / sinTheta;
            
            local resultQuaternion = {
                x = weight1 * quaternion1.x + weight2 * quaternion2.x,
                y = weight1 * quaternion1.y + weight2 * quaternion2.y,
                z = weight1 * quaternion1.z + weight2 * quaternion2.z,
                w = weight1 * quaternion1.w + weight2 * quaternion2.w
            };
            
            local result = _normalizeQuaternion(resultQuaternion)
            return math.Quaternion(result);
        }
        
        function _normalizeQuaternion(quaternion) {
            local magnitude = sqrt(quaternion.x * quaternion.x + quaternion.y 
                * quaternion.y + quaternion.z * quaternion.z + quaternion.w * quaternion.w);
            return {
                x = quaternion.x / magnitude,
                y = quaternion.y / magnitude,
                z = quaternion.z / magnitude,
                w = quaternion.w / magnitude
            }
        }
        
        function Norm() {
            return _normalizeQuaternion(this.quaternion)
        }
        
        function toVector() {
            local sinr_cosp = 2 * (quaternion.w * quaternion.x + quaternion.y * quaternion.z);
            local cosr_cosp = 1 - 2 * (quaternion.x * quaternion.x + quaternion.y * quaternion.y);
            local roll = atan2(sinr_cosp, cosr_cosp);
            local sinp = 2 * (quaternion.w * quaternion.y - quaternion.z * quaternion.x);
            local pitch;
            if (abs(sinp) >= 1) {
                pitch = math.copysign(PI / 2, sinp); 
            } else {
                pitch = asin(sinp);
            }
            local siny_cosp = 2 * (quaternion.w * quaternion.z + quaternion.x * quaternion.y);
            local cosy_cosp = 1 - 2 * (quaternion.y * quaternion.y + quaternion.z * quaternion.z);
            local yaw = atan2(siny_cosp, cosy_cosp);
            
            local x = pitch * 180 / PI;
            local y = yaw * 180 / PI;
            local z = roll * 180 / PI;
            return Vector( x, y, z )
        }
        function _mul(other) {
            return math.Quaternion(multiplyQuaternions(this.quaternion, other))
        }
        function _tostring() {
            local x = this.quaternion.x;
            local y = this.quaternion.y;
            local z = this.quaternion.z;
            local w = this.quaternion.w;
            return "Quaternion: (" + x + ", " + y + ", " + z + ", " + w + ")"
        }
        function _typeof() {
            return "PCapLib-Quaternion"
        }
        
        function IsValid() {
            return quaternion
        }
        function x() {
            return this.quaternion.x;
        }
        function y() {
            return this.quaternion.y;
        }
        function z() {
            return this.quaternion.z;
        }
        function w() {
            return this.quaternion.w;
        }
        
        function get_table() {
            return {
                x = this.quaternion.x,
                y = this.quaternion.y,
                z = this.quaternion.z,
                w = this.quaternion.w
            }
        }
    },
    
    lerp = {
        
        int = function(start, end, t) {
            return start * (1 - t) + end * t;
        },
        
        vector = function(start, end, t) {
            return Vector(int(start.x, end.x, t), int(start.y, end.y, t), int(start.z, end.z, t));
        },
        
        color = function(start, end, t) {
            if (type(start) == "string") {
                start = StrToVec(start)
            }
            if (type(end) == "string") {
                end = StrToVec(end)
            }
            return abs(int(start.x, end.x, t)) + " " + abs(int(start.y, end.y, t)) + " " + abs(int(start.z, end.z, t))
        },
        
        sVector = function(start, end, t) {
            local q1 = math.Quaternion().new(start)
            local q2 = math.Quaternion().new(end)
            return q1.slerp(q2, t).toVector()
        }
        
        spline = function( f )
        {
            local fSquared = f * f;
            return 3.0 * fSquared  - 2.0 * fSquared  * f;
        },
        
        SmoothStep = function(edge0, edge1, value) {
            local t = math.clamp((value - edge0) / (edge1 - edge0), 0.0, 1.0);
            return t * t * (3.0 - 2.0 * t)
        },
        
        
        FLerp = function( f1, f2, i1, i2, value )
        {
            return f1 + (f2 - f1) * (value - i1) / (i2 - i1);
        }
        
        
        
        
        
        
        
        
        
    },
    min = function(...) {
        local min = vargv[0]
        for(local i = 0; i< vargc; i++) {
            if(min > vargv[i])
                min = vargv[i]
        }
        
        return min
    },
    max = function(...) {
        local max = vargv[0]
        for(local i = 0; i< vargc; i++) {
            if(vargv[i] > max)
                max = vargv[i]
        }
        return max
    },
    
    clamp = function(int, min, max = 99999) { 
        if ( int < min ) return min;
        if ( int > max ) return max;
        return int
    },
    
    roundVector = function(vec, int = 1000) {
        vec.x = floor(vec.x * int + 0.5) / int
        vec.y = floor(vec.y * int + 0.5) / int
        vec.z = floor(vec.z * int + 0.5) / int
        return vec
    },
    
    Sign = function(x) {
        if (x > 0) {
            return 1;
        } else if (x < 0) {
            return -1;
        } else {
            return 0;
        }
    },
    
    copysign = function(value, sign) {
        if (sign < 0) {
            return -value;
        } else {
            return value;
        }
    },
    
    RemapVal = function( val, A, B, C, D )
    {
        if ( A == B )
        {
            if ( val >= B )
                return D;
            return C;
        };
        return C + (D - C) * (val - A) / (B - A);
    },
    rotateVector = function(vector, angle) {
        return math.Quaternion.new(angle).rotate(vector)
    },
    unrotateVector = function(vector, angle) {
        return math.Quaternion.new(angle).unrotate(vector)
    },
    randomVector = function(min, max) {
        if(typeof min == "Vector" && typeof max == "Vector") 
            return Vector(RandomFloat(min.x, max.x), RandomFloat(min.y, max.y), RandomFloat(min.z, max.z))
        return Vector(RandomFloat(min, max), RandomFloat(min, max), RandomFloat(min, max))
    },
    reflectVector = function(dir, normal) {
        return dir - normal * (dir.Dot(normal) * 2)
    },
    clampVector = function(vector, min = 0, max = 255) { 
        return Vector(this.clamp(vector.x, min, max), this.clamp(vector.y, min, max), this.clamp(vector.z, min, max)) 
    },
    resizeVector = function(vector, element) {
        local tx = sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z))
        return vector * (element / tx)
    }
}
if("arrayLib" in getroottable()) {
    dev.warning("Enhanced arrays module initialization skipped. Module already initialized.")
    return
}
::arrayLib <- class {
    
    arr = null
    
    
    table = null;
    
    
    tableIsValid = false
    
    
    constructor(array = []) {
        this.arr = array
        this.table = {}
    }
    
    function new(...) {
        local arr = array(vargc)
        for(local i = 0; i< vargc; i++) {
            arr[i] = vargv[i]
        }
        return arrayLib(arr)
    }
    
    function append(val) {
        this._pushToTable(val)
        arr.append(val);
        return this
    }
    
    function apply(func) {
        foreach(idx, value in arr) {
            arr[idx] = func(value)
        }
        this.totable(true)
        return this
    }
    
    function clear() {
        this.arr.clear()
        this.table.clear()
        this.tableIsValid = false
        return this
    }
    
    function extend(other) {
        if(typeof other == "arrayLib") {
            other = other.arr
        }
        arr.extend(other);
        this.totable(true)
        return this
    }
    
    function filter(func) {
        local newArray = arrayLib([])
        foreach(idx, val in arr) {
            if(func(idx, val, newArray))
                newArray.append(val)
        }
        return newArray
    }
    
    function find(match) {
        if(!this.tableIsValid) this.totable()
        return match in this.table
    }
    
    function search(match) {
        if(typeof match == "function") {
            foreach(idx, val in arr) {
                if(match(val))
                    return idx
            }
        }
        else {
            foreach(idx, val in arr) {
                if(val == match)
                    return idx
            }
        }
        return null
    }
    
    function insert(idx, val) {
        this._pushToTable(val)
        return arr.insert(idx, val)
    }
    
    function len() {
        return arr.len()
    }
    
    function map(func) {
        local newArray = array(this.len())
        foreach(idx, value in arr) {
            newArray[idx] = func(value)
        }
        return arrayLib(newArray)
    }
    
    function pop() {
        local pop = arr.pop()
        this._deleteFromTable(pop)
        return pop
    }
    
    function push(val) {
        this.append(val)
    }
    
    
    
    function remove(idx) {
        this._deleteFromTable(arr[idx])
        arr.remove(idx);
    }
    
    function resize(size, fill = null) {
        arr.resize(size, fill);
        this.totable(true)
    }
    
    function reverse() {
        arr.reverse();
        return this
    }
    
    function slice(start, end = null) {
        return arrayLib(arr.slice(start, end || this.len()))
    }
    
    function sort(func = null) {
        func ? arr.sort(func) : arr.sort()
        return this
    }
    
    function top() {
        return arr.top();
    }
    
    function join(joinstr = "") {
        if(this.len() == 0) return ""
        
        local string = ""
        foreach(elem in this.arr) {
            string += elem + joinstr
        }
        return joinstr.len() != 0 ? string.slice(0, joinstr.len() * -1) : string
    }
    
    function get(idx, defaultVal = null) {
        if(this.len() > idx)
            return this.arr[idx]
        return defaultVal
    }
    
    function totable(reacreate = false) {
        if(this.table.len() > 0 && !reacreate) return this.table
        tableIsValid = true
        this.table.clear()
        foreach(element in arr) {
            this.table[element] <- null
        }
        return this.table
    }
    
    function _deleteFromTable(val) {
        if(val in this.table)
            this.table.rawdelete(val)
    }
    
    function _pushToTable(val) {
        if(this.table.len() != 0)
            this.table[val] <- null
    }
    function _cloned() {
        return arrayLib(clone this.arr)
    }
    
    function _tostring() return format("Array: [%s]", this.join(", "))
    
    
    function _typeof () return "arrayLib";
    
    
    function _get(idx) return arr[idx];
    
    
    function _set(idx, val) return arr[idx] = val;
    function _nexti(previdx) {
        if(this.len() == 0) return null
        if (previdx == null) return 0;
		return previdx < this.len() - 1 ? previdx + 1 : null;
	}
}
::RunScriptCode <- {
    
    delay = function(script, runDelay, activator = null, caller = null) {
        if (typeof script == "function")
            return CreateScheduleEvent("global", script, runDelay)
        EntFireByHandle(self, "runscriptcode", script, runDelay, activator, caller)
    },  
    
    loopy = function(func, runDelay, loop, outputs = null) {
        if (loop > 0) {
            this.delay(func, runDelay)
            this.delay("loopy(\"" + func + "\"," + runDelay + "," + (loop - 1) + ",\"" + outputs + "\")", runDelay)
        } else if (outputs)
            this.delay(outputs, 0)
    },
    
    setInterval = function(script, interval = FrameTime(), runDelay = 0, eventName = "global") {
        local runAgain = function() : (script, interval, eventName) {
            RunScriptCode.setInterval(script, interval, 0, eventName)
        }
        
        CreateScheduleEvent(eventName, script, runDelay)
        CreateScheduleEvent(eventName, runAgain, interval + runDelay)
    },
    
    fromStr = function(str) {
        compilestring(str)()
    }
}
::dev <- {
    
    DrawEntityBBox = function(ent, time) {
        DebugDrawBox(ent.GetOrigin(), ent.GetBoundingMins(), ent.GetBoundingMaxs(), 255, 165, 0, 9, time)
    },
    
    drawbox = function(vector, color, time = 0.05) {
        DebugDrawBox(vector, Vector(-1,-1,-1), Vector(1,1,1), color.x, color.y, color.z, 100, time)
    },
    
    log = function(msg) {
        if (developer() != 0)
            printl("• " + msg)
    },
    
    warning = function(msg) {
        _more_info("► Warning (%s [%d]): %s", msg)
    },
    
    error = function(msg) {
        _more_info("▄▀ *ERROR*: [func = %s; line = %d] | %s", msg)
        SendToConsole("playvol resource/warning.wav 1")
    },
      
    _more_info = function(pattern, msg) {
        if (developer() == 0)
            return
        local info = getstackinfos(3)
        local func_name = info.func
        if (func_name == "main" || func_name == "unknown")
            func_name = "file " + info.src
        printl(format(pattern, func_name, info.line, msg))
    }
}
::fprint <- function(msg, ...) {
    
    local subst_count = 0;
    for (local i = 0; i < msg.len() - 1; i++) {
        if (msg.slice(i, i+2) == "{}") {
            subst_count++; 
        }
    }
    if (subst_count != vargc) {
        throw("Discrepancy between the number of arguments and substitutions")
    }
    local args = array(vargc)
    for(local i = 0; i< vargc; i++) {
        args[i] = vargv[i]
    }
    if (msg.slice(0, 2) == "{}") {
        msg = args[0] + msg.slice(2); 
        args.remove(0); 
    }
    local parts = split(msg, "{}");
    local result = "";
    for (local i = 0; i < parts.len(); i++) {
        result += parts[i];
        if (i < args.len()) {
            result += args[i].tostring();
        }
    }
    printl(result)
}
::StrToVec <- function(str) {
    local str_arr = split(str, " ")
    local vec = Vector(str_arr[0].tointeger(), str_arr[1].tointeger(), str_arr[2].tointeger())
    return vec
}
::GetPrefix <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name
    
    local lastPartLength = parts.pop().len()
    local prefix = name.slice(0, -lastPartLength)
    return prefix;
}
::GetPostfix <- function(name) {
    local parts = split(name, "-")
    if(parts.len() == 0)
        return name
    local lastPartLength = parts[0].len();
    local prefix = name.slice(lastPartLength);
    return prefix;
}
::Precache <- function(sound_path) {
    if(typeof sound_path == "string")
        return self.PrecacheSoundScript(sound_path)
    foreach(path in sound_path)
        self.PrecacheSoundScript(path)
}
::GetFromTable <- function(table, key, defaultValue = null) {
    if(key in table) 
        return table[key]
    return defaultValue
}
::GetDist <- function(vec1, vec2) {
    return (vec2 - vec1).Length()
}
if("entLib" in getroottable()) {
    dev.warning("entLib module initialization skipped. Module already initialized.")
    return
}
::pcapEntityCache <- {}
::entLib <- class {
    
    function CreateByClassname(classname, keyvalues = {}) {
        local new_entity = entLib.FromEntity(Entities.CreateByClassname(classname))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        pcapEntityCache[CBaseEntity] <- new_entity
        return new_entity
    }
    function CreateProp(classname, origin, modelname, activity = 1, keyvalues = {}) {
        local new_entity = entLib.FromEntity(CreateProp(classname, origin, modelname, activity))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        return new_entity
    }
    
    function FindByClassname(classname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassname(start_ent, classname)
        return entLib.__init(new_entity)
    }
    
    function FindByClassnameWithin(classname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByClassnameWithin(start_ent, classname, origin, radius)
        return entLib.__init(new_entity)
    }
    
    function FindByName(targetname, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByName(start_ent, targetname)
        return entLib.__init(new_entity)
    }
    
    function FindByNameWithin(targetname, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByNameWithin(start_ent, targetname, origin, radius)
        return entLib.__init(new_entity)
    }
    
    function FindByModel(model, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindByModel(start_ent, model)
        return entLib.__init(new_entity)
    }
    
    function FindByModelWithin(model, origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = null
        for(local ent; ent = Entities.FindByClassnameWithin(ent, "*", origin, radius);) {
            if(ent.GetModelName() == model && ent != start_ent) {
                new_entity = ent;
                break;
            }
        }
        return entLib.__init(new_entity)
    }
    
    function FindInSphere(origin, radius, start_ent = null) {
        if(start_ent && typeof start_ent == "pcapEntity")
            start_ent = start_ent.CBaseEntity
        local new_entity = Entities.FindInSphere(start_ent, origin, radius)
        return entLib.__init(new_entity)
    }
    function FromEntity(CBaseEntity) {
        if(typeof CBaseEntity == "pcapEntity")
            return CBaseEntity
        return entLib.__init(CBaseEntity)
    }
    
    function __init(CBaseEntity) {
        if(!CBaseEntity)
            return null
        if(CBaseEntity in pcapEntityCache) {
            return pcapEntityCache[CBaseEntity]
        } else {
            local pcapEnt = pcapEntity(CBaseEntity)
            pcapEntityCache[CBaseEntity] <- pcapEnt
            return pcapEnt
        }
    }
}
::pcapEntity <- class {
    CBaseEntity = null;
    EntityScope = null;
    
    constructor(entity = null) { 
        if(entity == null) return null
        if(typeof entity == "pcapEntity")
            entity = entity.CBaseEntity
        this.CBaseEntity = entity
        this.EntityScope = {}
        entity.ValidateScriptScope() 
    }
    function SetAngles(x, y, z) {
        x = x >= 360 ? 0 : x
        y = y >= 360 ? 0 : y
        z = z >= 360 ? 0 : z
        this.CBaseEntity.SetAngles(x, y, z)
    }
    
    function SetAbsAngles(vector) {
        this.CBaseEntity.SetAngles(vector.x, vector.y, vector.z)
    }
    
    function Destroy() {
        this.CBaseEntity.Destroy()
        this.CBaseEntity = null
    }
    
    function Kill(fireDelay = 0) {
        EntFireByHandle(CBaseEntity, "kill", "", fireDelay)
        this.CBaseEntity = null 
    }
    function Dissolve() {
        if(this.GetName() == "")
            this.SetName(UniqueString("targetname"))
        dissolver.SetKeyValue("target", this.GetName())
        EntFireByHandle(dissolver, "dissolve")
        this.SetUserData("Dissolved", true)
    }
    
    function IsValid() {
        return this.CBaseEntity && this.CBaseEntity.IsValid() && !this.GetUserData("Dissolved")
    }
    
    function IsPlayer() {
        return this.CBaseEntity.GetClassname() == "player"  
    }
    function EyePosition() {
        if(this.IsPlayer()) return this.CBaseEntity.EyePosition()
    }
    function EyeAngles() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetAngles()
    }
    function EyeForwardVector() {
        if(this.IsPlayer()) return this.GetUserData("Eye").GetForwardVector()
    }
    
    function SetKeyValue(key, value) {
        switch (typeof value) {
            case "integer":
                this.CBaseEntity.__KeyValueFromInt(key, value);
                break;
            case "float":
                this.CBaseEntity.__KeyValueFromFloat(key, value);
                break;
            case "Vector":
                this.CBaseEntity.__KeyValueFromVector(key, value);
                break;
            default:
                this.CBaseEntity.__KeyValueFromString(key, value.tostring());
        }
        this.SetUserData(key, value)
    }
    
    function addOutput(outputName, target, input, param = "", delay = 0, fires = -1) {
        if(typeof target == "instance" || typeof target == "pcapEntity")
            target = target.GetName()
        this.SetKeyValue(outputName, target + "\x001B" + input + "\x001B" + param + "\x001B" + delay + "\x001B" + fires)
    }
    
    function ConnectOutputEx(outputName, script, delay = 0, fires = -1) {
        if(typeof script == "function") {
            local funcName = "OutputFunc" + UniqueString()
            getroottable()[funcName] <- script
            script = funcName + "()"
        } 
        this.addOutput(outputName, self, "RunScriptCode", script, delay, fires)
    }
    function EmitSoundEx(sound_name, timeDelay = 0, eventName = this) {
        if(timeDelay == 0)
            return this.CBaseEntity.EmitSound(sound_name)
        CreateScheduleEvent(eventName, function():(CBaseEntity, sound_name) {
            CBaseEntity.EmitSound(sound_name)
        }, timeDelay)
    }
    
    function SetName(name) {
        this.SetKeyValue("targetname", name)
    }
    
    function SetUniqueName(prefix = "a") {
        this.SetKeyValue("targetname", prefix + UniqueString())
    }
    
    function SetParent(parentEnt, fireDelay = 0) {
        this.SetUserData("parent", parentEnt)
        if(typeof parentEnt == "pcapEntity" || typeof parentEnt == "instance") {
            if(parentEnt.GetName() == "") {
                parentEnt.SetName(UniqueString("parent"))
            }
            parentEnt = parentEnt.GetName()
        }
        
        EntFireByHandle(this.CBaseEntity, "SetParent", parentEnt, fireDelay)
    }
    
    function SetCollision(solid, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "SetSolidtype", solid.tostring(), fireDelay, null, null)
        this.SetUserData("Solidtype", solid)
    }
    
    function SetCollisionGroup(collisionGroup) {
        this.SetKeyValue("CollisionGroup", collisionGroup)
        this.SetUserData("CollisionGroup", collisionGroup)
    }
    
    
    function SetAnimation(animationName, fireDelay) {
        EntFireByHandle(this.CBaseEntity, "SetAnimation", animationName, fireDelay)
        this.SetUserData("animation", animationName)
    }
    
    function SetAlpha(opacity, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "Alpha", opacity.tostring(), fireDelay, null, null)
        this.SetUserData("alpha", opacity)
    }
    
    function SetColor(colorValue, fireDelay = 0) {
        if(typeof colorValue == "Vector") 
            colorValue = colorValue.toString()
        EntFireByHandle(this.CBaseEntity, "Color", colorValue, fireDelay, null, null)
        this.SetUserData("color", colorValue)
    }
    
    function SetSkin(skin, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "skin", skin.tostring(), fireDelay, null, null)
        this.SetUserData("skin", skin)
    }
    
    function SetDrawEnabled(isEnabled, fireDelay = 0) {
        if(isEnabled) {
            EntFireByHandle(this.CBaseEntity, "EnableDraw", "", fireDelay)
        }
        else {
            EntFireByHandle(this.CBaseEntity, "DisableDraw", "", fireDelay)
        }
        
    }
    
    function SetSpawnflags(flag) {
        this.SetKeyValue("CollisionGroup", flag)
        this.SetUserData("spawnflags", flag)
    }
    
    function SetModelScale(scaleValue, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "addoutput", "ModelScale " + scaleValue, fireDelay, null, null)
        this.SetUserData("ModelScale", scaleValue)
    }
    
    function SetCenter(vector) {
        local offset = this.CBaseEntity.GetCenter() - this.CBaseEntity.GetOrigin()
        this.CBaseEntity.SetAbsOrigin( vector - offset )
    }
    
    function SetBBox(minBounds, maxBounds) {
        
        if (type(minBounds) == "string") {
            minBounds = StrToVec(minBounds)
        }
        if (type(maxBounds) == "string") {
            maxBounds = StrToVec(maxBounds)
        }
        this.CBaseEntity.SetSize(minBounds, maxBounds)
    }
    function SetContext(name, value, fireDelay = 0) {
        EntFireByHandle(this.CBaseEntity, "AddContext", (name + ":" + value), fireDelay)
        this.SetUserData(name, value)
    }
    
    
    function SetUserData(name, value) {
        this.EntityScope[name.tolower()] <- value
    }
     
    function GetUserData(name) {
        name = name.tolower()
        if(name in this.EntityScope)
            return this.EntityScope[name]
        return null
    }
    
    function GetBBox() {
        local max = GetBoundingMaxs()
        local min = GetBoundingMins()
        return {min = min, max = max}
    }
     
    function GetAABB() {
        local max = CreateAABB(7)
        local min = CreateAABB(0)
        local center = CreateAABB( 4)
        return {min = min, center = center, max = max}
    }
    
    function GetIndex() {
        return this.CBaseEntity.entindex()
    }
    
    function GetKeyValue(key) {
        local value = this.GetUserData(key)
        if(value != null)
            return value
        switch(key) {
            case "model":
                return this.GetModelName()
                break
            case "health":
                return this.GetHealth()
                break
            case "targetname":
                return this.GetName()
                break
        }
        return null
    }
     
    function GetSpawnflags() {
        return this.GetUserData("spawnflags")
    }
    
    function GetAlpha() {
        local alpha = this.GetUserData("alpha")
        return alpha != null ? alpha : 255
    }
    
    function GetColor() {
        local color = this.GetUserData("color")
        return color ? color : "255 255 255"
    }
    function GetSkin() {
        local skin = this.GetUserData("skin")
        return skin ? skin : 0
    }
    
    function GetNamePrefix() {
        return GetPrefix(this.GetName())
    }
    
    function GetNamePostfix() {
        return GetPostfix(this.GetName())
    }
    
    function _tostring() {
        return "pcapEntity: " + this.CBaseEntity + ""
    }
    
    function _typeof() {
        return "pcapEntity"
    }
    
    function CreateAABB(stat) { 
        local angles = this.GetAngles()
        if(stat == 4) 
            angles = Vector(45, 45, 45)
        local all_vertex = {
            v = this.getBBoxPoints()
            x = []
            y = []
            z = []
        }
        foreach(v in all_vertex.v)
        {
            all_vertex.x.append(v.x)
            all_vertex.y.append(v.y)
            all_vertex.z.append(v.z)
        }
        all_vertex.x.sort()
        all_vertex.y.sort()
        all_vertex.z.sort()
        
        if(stat == 4)
            return ( Vector(all_vertex.x[7], all_vertex.y[7], all_vertex.z[7]) - Vector(all_vertex.x[0], all_vertex.y[0], all_vertex.z[0]) ) * 0.5
        return Vector(all_vertex.x[stat], all_vertex.y[stat], all_vertex.z[stat])
    }
    
    function getBBoxPoints() {
        local BBmax = this.GetBoundingMaxs();
        local BBmin = this.GetBoundingMins();
        local angles = this.GetAngles()
    
        return [
            _GetVertex(BBmin, BBmin, BBmin, angles), _GetVertex(BBmin, BBmin, BBmax, angles),
            _GetVertex(BBmin, BBmax, BBmin, angles), _GetVertex(BBmin, BBmax, BBmax, angles),
            _GetVertex(BBmax, BBmin, BBmin, angles), _GetVertex(BBmax, BBmin, BBmax, angles),
            _GetVertex(BBmax, BBmax, BBmin, angles), _GetVertex(BBmax, BBmax, BBmax, angles)
        ]
    }
    
    function _GetVertex(x, y, z, ang) {
        
        return math.rotateVector(Vector(x.x, y.y, z.z), ang)
    }
}
function pcapEntity::ConnectOutput(output, funcName) this.CBaseEntity.ConnectOutput(output, funcName)
function pcapEntity::DisconnectOutput(output, funcName) this.CBaseEntity.DisconnectOutput(output, funcName)
function pcapEntity::EmitSound(sound_name) this.CBaseEntity.EmitSound(sound_name)
function pcapEntity::PrecacheSoundScript(sound_name) this.CBaseEntity.PrecacheSoundScript(sound_name)
function pcapEntity::IsSequenceFinished() return this.CBaseEntity.IsSequenceFinished()
function pcapEntity::SpawnEntity() this.CBaseEntity.SpawnEntity()
function pcapEntity::GetAngles() return this.CBaseEntity.GetAngles()
function pcapEntity::GetAngularVelocity() return this.CBaseEntity.GetAngularVelocity()
function pcapEntity::GetBoundingMaxs() return this.CBaseEntity.GetBoundingMaxs()
function pcapEntity::GetBoundingMins() return this.CBaseEntity.GetBoundingMins()
function pcapEntity::GetCenter() return this.CBaseEntity.GetCenter()
function pcapEntity::GetClassname() return this.CBaseEntity.GetClassname()
function pcapEntity::GetForwardVector() return this.CBaseEntity.GetForwardVector()
function pcapEntity::GetHealth() return this.CBaseEntity.GetHealth()
function pcapEntity::GetLeftVector() return this.CBaseEntity.GetLeftVector()
function pcapEntity::GetMaxHealth() return this.CBaseEntity.GetMaxHealth()
function pcapEntity::GetModelKeyValues() return this.CBaseEntity.GetModelKeyValues()
function pcapEntity::GetModelName() return this.CBaseEntity.GetModelName()
function pcapEntity::GetName() return this.CBaseEntity.GetName()
function pcapEntity::GetOrigin() return this.CBaseEntity.GetOrigin()
function pcapEntity::GetScriptId() return this.CBaseEntity.GetScriptId()
function pcapEntity::GetUpVector() return this.CBaseEntity.GetUpVector()
function pcapEntity::GetPartnername() return this.CBaseEntity.GetPartnername()
function pcapEntity::GetPartnerInstance() return this.CBaseEntity.GetPartnerInstance()
function pcapEntity::ValidateScriptScope() return this.CBaseEntity.ValidateScriptScope()
function pcapEntity::EyePosition() return this.CBaseEntity.EyePosition()
function pcapEntity::SetAbsOrigin(vector) this.CBaseEntity.SetAbsOrigin(vector)
function pcapEntity::SetForwardVector(vector) this.CBaseEntity.SetForwardVector(vector)
function pcapEntity::SetHealth(health) this.CBaseEntity.SetHealth(health)
function pcapEntity::SetMaxHealth(health) this.CBaseEntity.SetMaxHealth(health)
function pcapEntity::SetModel(model_name) this.CBaseEntity.SetModel(model_name)
function pcapEntity::SetOrigin(vector) this.CBaseEntity.SetOrigin(vector)
if("CreateScheduleEvent" in getroottable()) {
    dev.warning("EventHandler module initialization skipped. Module already initialized.")
    return
}
::ScheduleEvent <- class {
    caller = null;
    action = null;
    timeDelay = null;
    note = null;
    args = null;
    constructor(caller, action, timeDelay, note = null, args = null) {
        this.caller = caller
        this.action = action
        this.timeDelay = timeDelay
        this.note = note
        this.args = args
    }
    function run() {
        if(type(action) == "string")
            action = compilestring(action)
        if(!args) {
            return action.call(caller)
        }
        local actionArgs = [caller]
        actionArgs.extend(args)
        return action.acall(actionArgs)
    }
    function _typeof() return "ScheduleEvent"
    function _tostring() return "[Caller] " + caller + "\n[Action] " + action + "\n[TimeDelay] " + timeDelay + "\n[Note] " + note 
}
::scheduledEventsList <- {global = []}
::isEventLoopRunning <- false
::CreateScheduleEvent <- function(eventName, action, timeDelay, note = null, args = null) {
    if ( !(eventName in scheduledEventsList) ) {
        scheduledEventsList[eventName] <- [[]]
        
    }
    if(!isEventLoopRunning) {
        isEventLoopRunning = true
        ExecuteScheduledEvents()
    }
    local eventList = scheduledEventsList[eventName]
    if(eventList.len() == 0 || eventList.top().len() > 300) {
        eventList.append([])
    }
    timeDelay += Time()
    local newScheduledEvent = ScheduleEvent(this, action, timeDelay, note, args)
    local currentEventList = eventList.top()
    
    if(currentEventList.len() == 0 || timeDelay >= currentEventList.top().timeDelay) {
        return currentEventList.append(newScheduledEvent)
    }
    
    
    local low = 0
    local high = currentEventList.len() - 1
    local mid
    while (low <= high) {
        mid = (low + high) / 2
        if (currentEventList[mid].timeDelay < newScheduledEvent.timeDelay) {
            low = mid + 1
        }
        else if (currentEventList[mid].timeDelay > newScheduledEvent.timeDelay) {
            high = mid - 1
        }
        else {
            low = mid
            break
        }
    }
    
    currentEventList.insert(low, newScheduledEvent)
    
}
::ExecuteScheduledEvents <- function() {
    if(scheduledEventsList.len() == 1 && scheduledEventsList.global.len() == 0) {
        return isEventLoopRunning = false
    }
    foreach(eventName, eventArray in scheduledEventsList) {
        foreach(idx, eventInfo in eventArray) {
            while (eventInfo.len() > 0 && Time() >= eventInfo[0].timeDelay) {
                local event = eventInfo[0]
                
                try {
                    event.run() 
                }
                catch(exception) {
                    SendToConsole("playvol resource/warning.wav 1")
                    printl("\nSCHEDULED EVENT\n[Name] " + eventName + "\n" + event)
                    if(type(event.action) == "function") {
                        local info = ""
                        foreach(key, val in event.action.getinfos()) {
                            if(type(val) == "array") val = arrayLib(val)
                            info += "[" + key.toupper() + "] " + val + "\n"
                        }
                        printl("\nFUNCTION INFO\n" + info)
                    }
                }
                eventInfo.remove(0) 
                if(eventInfo.len() == 0) 
                    eventArray.remove(idx)
            }
        }
        if(eventArray.len() == 0 && eventName != "global" && eventName in scheduledEventsList) 
            cancelScheduledEvent(eventName)
    }
    RunScriptCode.delay("ExecuteScheduledEvents()", FrameTime())
}
::cancelScheduledEvent <- function(eventName, delay = 0) 
{
    if(eventName == "global")
        return dev.warning("The global event cannot be closed!")
    if(!(eventName in scheduledEventsList))
        return dev.error("There is no event named " + eventName)
    if(delay == 0)
        scheduledEventsList.rawdelete(eventName)
    else {
        return CreateScheduleEvent("global", format("cancelScheduledEvent(\"%s\")", eventName), delay)
    }
        
    
    
    
    
    
    
    
    
}
::getEventInfo <- function(eventName)
{
    local event = null
    if(eventName in scheduledEventsList)
        event = scheduledEventsList[eventName]
    return event
}
::eventIsValid <- function(eventName) {
    return eventName in scheduledEventsList && scheduledEventsList[eventName].len() != 0
}
::getEventNote <- function(eventName) {
    local info = getEventInfo(eventName)
    if(!info || info.len() == 0) 
        return null
    
    foreach(event in info) {
        if(event.note)
            return event.note
    }
    
    return null
}
if("animate" in getroottable()) {
    dev.warning("Animate module initialization skipped. Module already initialized.")
    return
}
local _GetValidEventName = function(entities, EventSetting) {
    if (!("eventName" in EventSetting && EventSetting.eventName)) {
        if(typeof entities == "array")
            return entities[0].GetClassname() 
    }
    
    
    
    return EventSetting.eventName
}
 
local _GetValidEntitiy = function(entities) {
    if (typeof entities == "string") {
        if(entities.find("*") == null)
            return [entLib.FindByName(entities)]
        else {
            local ents = []
            for(local ent; ent = entLib.FindByName(entities, ent);)
                ents.append(ent)
            return ents
        }
    }
            
    if (typeof entities != "pcapEntity")
            return [entLib.FromEntity(entities)]
    
    return [entities]
}
::animate <- {
     
    AlphaTransition = function(entities, startOpacity, endOpacity, time, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        entities = _GetValidEntitiy(entities)
        
        
        
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null
        local transitionFrames = time / FrameTime();
        local alphaStep = (endOpacity - startOpacity) / transitionFrames;    
        
        for (local step = 0; step < transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay
            
            local newAlpha = startOpacity + alphaStep * (step + 1);
            
            foreach(ent in entities) {
                local action = function() : (ent, newAlpha) {
                    ent.SetAlpha(newAlpha)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }
        
        
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },
    
    ColorTransition = function(entities, startColor, endColor, time,
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        entities = _GetValidEntitiy(entities)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null
        local transitionFrames = abs(time / FrameTime())
        for (local step = 0.0; step <= transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay
            local newColor = math.lerp.color(startColor, endColor, step / transitionFrames) 
            foreach(ent in entities) {
                local action = function() : (ent, newColor) {
                    ent.SetColor(newColor)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }
        
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },
     
    PositionTransitionByTime = function(entities, startPos, endPos, time, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        
        entities = _GetValidEntitiy(entities)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local steps = abs(time / FrameTime())
        local dist = endPos - startPos
        local coordStep = dist.Length() / steps
        for (local tick = 1; tick <= steps; tick++) {
            local newPosition = startPos + dist * (tick / coordStep)
            local elapsed = (FrameTime() * tick) + globalDelay
            local note = "note" in EventSetting ? EventSetting.note : newPosition
            foreach(ent in entities) {
                local action = function() : (ent, newPosition) {
                    ent.SetOrigin(newPosition)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
            
        }
        
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    },
    
    
     
    PositionTransitionBySpeed = function(entity, startPos, endPos, speed, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        
        local entities = _GetValidEntitiy(entity)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local distance = endPos - startPos
        local dir = (endPos - startPos)
        dir.Norm()
        local steps = abs(distance.Length() / speed)
        for (local tick = 1; tick <= steps; tick++) {
            local newPosition = startPos + (dir * speed * tick)
            local elapsed = (FrameTime() * tick) + globalDelay
            local note = "note" in EventSetting ? EventSetting.note : newPosition
        
            foreach(ent in entities) {
                local action = function() : (ent, newPosition) {
                    ent.SetOrigin(newPosition)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }
        
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
        return steps * FrameTime()
    },
      
    AnglesTransitionByTime = function(entity, startAngles, endAngles, time, 
        EventSetting = {eventName = null, globalDelay = 0, note = null, outputs = null}) : (_GetValidEventName, _GetValidEntitiy) {
        
        local entities = _GetValidEntitiy(entity)
        local eventName = _GetValidEventName(entities, EventSetting)
        local globalDelay = "globalDelay" in EventSetting ? EventSetting.globalDelay : 0
        local note = "note" in EventSetting ? EventSetting.note : null
    
        local transitionFrames = abs(time / FrameTime())
        for(local step = 0.0; step <= transitionFrames; step++) {
            local elapsed = (FrameTime() * step) + globalDelay
    
            local newAngle = math.lerp.sVector(startAngles, endAngles, step / transitionFrames) 
    
            foreach(ent in entities) {
                local action = function() : (ent, newAngle) {
                    ent.SetAbsAngles(newAngle)
                }
                CreateScheduleEvent(eventName, action, elapsed, note)
            }
        }
    
        
        if ("outputs" in EventSetting && EventSetting.outputs) {
            CreateScheduleEvent(eventName, EventSetting.outputs, time)
        }
    }
}
if("_EntFireByHandle" in getroottable()) {
    dev.warning("Improvements module initialization skipped. Module already initialized.")
    return
}
local _frametime = FrameTime
::FrameTime <- function() : (_frametime) {
    local tick = _frametime()
    if(tick == 0) 
        return 0.016
    return tick
}
local _EntFireByHandle = EntFireByHandle
::EntFireByHandle <- function(target, action, value = "", delay = 0, activator = null, caller = null) : (_EntFireByHandle) {
    
    if (typeof target == "pcapEntity")
        target = target.CBaseEntity 
    if (typeof activator == "pcapEntity")
        activator = activator.CBaseEntity 
    if (typeof caller == "pcapEntity")
        caller = target.CBaseEntity 
    _EntFireByHandle(target, action, value, delay, activator, caller)
}
::GetPlayerEx <- function(index = 1) {
    if(IsMultiplayer()) {
        local idx = 1
        for(local player; player = Entities.FindByClassname(player, "player"); idx++) {
            if(idx == index) return player
        }
        return null
    }
    return entLib.FromEntity(GetPlayer()) 
}
::TraceSettings <- class {
    ignoreClasses = arrayLib.new("viewmodel", "weapon_", "beam"
        "trigger_", "phys_", "env_", "point_", "info_", "vgui_", "logic_"
        "clone", "prop_portal", "portal_base2D"
    );
    priorityClasses = arrayLib.new();
    ignoredModels = arrayLib.new();
    errorTolerance = 500; 
    useCostlyNormalComputation = false; 
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
function TraceSettings::AppendIgnoredClass(string) {
    this.ignoreClasses.append(string)
}
function TraceSettings::AppendPriorityClasses(string) {
    this.priorityClasses.append(string)
}
function TraceSettings::AppendIgnoredModel(string) {
    this.ignoredModels.append(string)
}
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
function TraceSettings::ToggleUseCostlyNormal(bool) {
    this.useCostlyNormalComputation = bool
}
::toArrayLib <- function(array) {
    if(typeof array == "array")
        return arrayLib(array)
    return array
}
::TraceResult <- class {
    traceHandler = null;
    hitpos = null;
    surfaceNormal = null;
    portalEntryInfo = null;
    constructor(traceHandler, hitpos) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
    }
    function GetStartPos() {
        return this.traceHandler.startpos
    }
    function GetEndPos() {
        return this.traceHandler.endpos
    }
    function GetHitpos() {
        return this.hitpos
    }
    function GetFraction() {
        return this.traceHandler.fraction
    }
    function DidHit() {
        return this.traceHandler.fraction != 1
    }
    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }
    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }
    function GetAggregatedPortalEntryInfo() {
        local arr = arrayLib([])
        arr.append(trace)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            arr.append(trace)
        }
        return arr
    }
    function GetImpactNormal() {
        
        if(this.surfaceNormal)
            return this.surfaceNormal
        
        this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos, this)
        return this.surfaceNormal 
    } 
    function _typeof() return "TraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", fraction: " + GetFraction() + ", hitpos: " + GetHitpos()
    }
}
::BboxTraceResult <- class {
    traceHandler = null;
    hitpos = null;
    hitent = null;
    surfaceNormal = null;
    portalEntryInfo = null;
    constructor(traceHandler, hitpos, hitent) {
        this.traceHandler = traceHandler
        this.hitpos = hitpos
        this.hitent = hitent
    }
    function GetStartPos() {
        return this.traceHandler.startpos
    }
    function GetEndPos() {
        return this.traceHandler.endpos
    }
    function GetHitpos() {
        return this.hitpos
    }
    function GetEntity() {
        if(this.hitent && this.hitent.IsValid())
            return entLib.FromEntity(this.hitent)
    }
    function GetEntityClassname() {
        return this.hitent ? this.GetEntity().GetClassname() : null 
    }
    function GetIngoreEntities() {
        return this.traceHandler.ignoreEnts
    }
    function GetTraceSettings() {
        return this.traceHandler.settings
    }
    function GetNote() {
        return this.traceHandler.note
    }
    function DidHit() {
        return this.GetFraction() != 1
    }
    function DidHitWorld() {
        return !this.hitent && DidHit()
    }
    function GetFraction() {
        return GetDist(this.GetStartPos(), this.GetHitpos()) / GetDist(this.GetStartPos(), this.GetEndPos())
    }
    function GetDir() {
        return (this.GetEndPos() - this.GetStartPos())
    }
    function GetPortalEntryInfo() {
        return this.portalEntryInfo
    }
    function GetAggregatedPortalEntryInfo() {
        local arr = arrayLib([])
        arr.append(this)
        for(local trace = this; trace = trace.portalEntryInfo;) {
            arr.append(trace)
        }
        return arr.reverse()
    }
    
    function GetImpactNormal() {
        
        if(this.surfaceNormal)
            return this.surfaceNormal
        this.surfaceNormal = CalculateImpactNormal(this.GetStartPos(), this.hitpos, this)
        return this.surfaceNormal
    } 
    function _typeof() return "BboxTraceResult"
    function _tostring() {
        return "TraceResult | startpos: " + GetStartPos() + ", endpos: " + GetEndPos() + ", hitpos: " + GetHitpos() + ", entity: " + GetEntity()
    }
} 
::CheapTrace <- function(startpos, endpos) {
    local SCOPE = {}
    SCOPE.startpos <- startpos
    SCOPE.endpos <- endpos
    SCOPE.type <- "CheapTrace"
    SCOPE.fraction <- TraceLine(startpos, endpos, null)
    local hitpos = startpos + (endpos - startpos) * SCOPE.fraction
    return TraceResult(SCOPE, hitpos)
}
::TraceLineAnalyzer <- class {
    settings = null;
    hitpos = null;
    hitent = null;
    constructor(startpos, endpos, ignoreEnts, settings, note) {
        this.settings = settings 
        
        local result = this.Trace(startpos, endpos, ignoreEnts, note)
        this.hitpos = result[0]
        this.hitent = result[1]
    }
    function GetHitpos() {
        return this.hitpos
    }
    function GetEntity() {
        return this.hitent
    }
    
    function Trace(startpos, endpos, ignoreEnts, note) array(hitpos, hitent) 
    function _isPriorityEntity() bool
    function _isIgnoredEntity() bool
    function _hitEntity() bool
}
function TraceLineAnalyzer::Trace(startpos, endpos, ignoreEnts, note) {
    
    local hitpos = CheapTrace(startpos, endpos).GetHitpos()
    
    local dist = hitpos - startpos
    
    local dist_coeff = abs(dist.Length() / settings.GetErrorTolerance()) + 1
    
    local step = dist.Length() / 14 / dist_coeff
    
    for (local i = 0.0; i < step; i++) {
        
        local rayPart = startpos + dist * (i / step)
        
        
        for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", rayPart, 5 * dist_coeff);) { 
            if (ent && this._hitEntity(ent, ignoreEnts, note)) {
                return [rayPart, ent] 
            }
        }
    }
    return [hitpos, null]
}
function TraceLineAnalyzer::_isPriorityEntity(entityClass) {
    if(settings.GetPriorityClasses().len() == 0) 
        return false
    return settings.GetPriorityClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}
function TraceLineAnalyzer::_isIgnoredEntity(entityClass) {
    if(settings.GetIgnoreClasses().len() == 0) 
        return false
    return settings.GetIgnoreClasses().search(function(val):(entityClass) {
        return entityClass.find(val) >= 0
    }) != null
}
function TraceLineAnalyzer::_isIgnoredModels(entityModel) {
    if(settings.GetIgnoredModels().len() == 0 || entityModel == "") 
        return false
    return settings.GetIgnoredModels().search(function(val):(entityModel) {
        return entityModel.find(val) >= 0
    }) != null
}
function TraceLineAnalyzer::_hitEntity(ent, ignoreEnts, note) { 
    
    if(settings.ApplyIgnoreFilter(ent, note))
        return false
    if(settings.ApplyCollisionFilter(ent, note))
        return true
    if(ignoreEnts) { 
        
        local type = typeof ignoreEnts
        if (type == "array" || type == "arrayLib") {
            foreach (mask in ignoreEnts) {
                if(this._eqEnts(mask, ent)) return false
            }
        } 
        
        else if(this._eqEnts(ignoreEnts, ent)) return false
    }
    local classname = ent.GetClassname()
    if (_isIgnoredEntity(classname) && !_isPriorityEntity(classname)) {
        return false
    }
    
    if(_isIgnoredModels(ent.GetModelName())) {
        return false
    }
    return true
}
function TraceLineAnalyzer::_eqEnts(ent1, ent2) {
    if(typeof ent1 == "pcapEntity")
        ent1 = ent1.CBaseEntity
    return ent1 == ent2
}
::BboxCast <- function(startpos, endpos, ignoreEnts = null, settings = defaultSettings, note = null) {
    local SCOPE = {}
    
    SCOPE.startpos <- startpos;
    SCOPE.endpos <- endpos;
    SCOPE.ignoreEnts <- ignoreEnts
    SCOPE.settings <- settings
    SCOPE.note <- note
    SCOPE.type <- "BboxCast"
    local result = TraceLineAnalyzer(startpos, endpos, ignoreEnts, settings, note)
    
    return BboxTraceResult(SCOPE, result.GetHitpos(), result.GetEntity())
}
local applyPortal = function (startPos, hitPos, portal, partner) {
    local portalAngles = portal.GetAngles();
    local partnerAngles = partner.GetAngles();
    local offset = math.unrotateVector(hitPos - portal.GetOrigin(), portalAngles);
    local dir = math.unrotateVector(hitPos - startPos, portalAngles);
    offset = Vector(offset.x * -1, offset.y * -1, offset.z)
    dir = Vector(dir.x * -1, dir.y * -1, dir.z)
    dir = math.rotateVector(dir, partnerAngles)
    dir.Norm()
    local newStart = partner.GetOrigin() + math.rotateVector(offset, partnerAngles)
    return {
        startPos = newStart,
        endPos = newStart + dir * 4096
    }
}
::PortalTrace <- function(startPos, endPos) : (applyPortal) {
    local previousTracedata
    
    for (local i = 0; i < 10; i++) { 
        local tracedata = CheapTrace(startPos, endPos)
        tracedata.portalEntryInfo = previousTracedata
        local hitPos = tracedata.GetHitpos()
        local portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) 
        if(!portal)
            portal = entLib.FindByClassnameWithin("linked_portal_door", hitPos, 1)
        if(!portal)
            return tracedata
        local normal = tracedata.GetImpactNormal()
        if(normal.Dot(portal.GetForwardVector()) < 0.8)
            return tracedata
        
        local partner = portal.GetUserData("partner")
        if (partner == null) {
            return tracedata
        }
        local ray = applyPortal(startPos, hitPos, portal, partner);
        startPos = ray.startPos + partner.GetForwardVector() 
        endPos = ray.endPos
        previousTracedata = tracedata
    }
    return previousTracedata
}
::PortalBboxCast <- function(startPos, endPos, ignoreEnts = null, settings = defaultSettings, note = null) : (applyPortal) {
    local previousTracedata
    
    for (local i = 0; i < 10; i++) { 
        local tracedata = BboxCast(startPos, endPos, ignoreEnts, settings, note)
        tracedata.portalEntryInfo = previousTracedata
        local hitPos = tracedata.GetHitpos()
        local portal = tracedata.GetEntity()
        if(!portal || portal.GetClassname() != "linked_portal_door")
            portal = entLib.FindByClassnameWithin("prop_portal", hitPos, 1) 
        if(!portal)
            return tracedata
        
        local partner = portal.GetUserData("partner")
        if (partner == null) 
            return tracedata
        if(portal.GetClassname() == "prop_portal") {
            local normal = tracedata.GetImpactNormal()
            if(normal.Dot(portal.GetForwardVector()) < 0.8)
                return tracedata
        } else { 
            ignoreEnts = addInIgnoreList(ignoreEnts, partner)
        }
        local ray = applyPortal(startPos, hitPos, portal, partner);
        startPos = ray.startPos + partner.GetForwardVector() 
        endPos = ray.endPos
        previousTracedata = tracedata
    }
    return previousTracedata
}
::FindPartnersForPortals <- function() {
    for(local portal; portal = entLib.FindByClassname("linked_portal_door", portal);) {
        if(portal.GetUserData("partner"))
            continue
    
        local partner = entLib.FromEntity(portal.GetPartnerInstance())
        portal.SetUserData("partner", partner)
    
        if(portal.GetModelName() == "")
            continue
        
        local wpInfo = split(portal.GetModelName(), " ")
        local wpBBox = math.rotateVector(Vector(5, wpInfo[0].tointeger(), wpInfo[1].tointeger()), portal.GetAngles())
        wpBBox.x = abs(wpBBox.x); 
        wpBBox.y = abs(wpBBox.y);
        wpBBox.z = abs(wpBBox.z);
        portal.SetBBox(wpBBox * -1, wpBBox) 
    }
    
    for(local portal; portal = entLib.FindByClassname("prop_portal", portal);) { 
        if(portal.GetUserData("partner"))
            continue
    
        local mdl = "models/portals/portal1.mdl"
        if(portal.GetModelName().find("portal2") == null) 
            mdl = "models/portals/portal2.mdl"
        
        local partner = entLib.FindByModel(mdl)
        portal.SetUserData("partner", partner) 
    }
}
FindPartnersForPortals() 
::TracePresets <- {}
local GetEyeEndpos = function(player, distance) {
    if(typeof player != "pcapEntity") 
        player = entLib.FromEntity(player)
    return player.EyePosition() + player.EyeForwardVector() * distance
}
::addInIgnoreList <- function(ignoreEnts, newEnt) {
    
    if (ignoreEnts) {
        
        if (typeof ignoreEnts == "array" || typeof ignoreEnts == "arrayLib") {
            ignoreEnts.append(newEnt)
        }
        
        else {
            ignoreEnts = [newEnt, ignoreEnts]
        }
    }
    
    else {
        ignoreEnts = newEnt
    }
    return ignoreEnts
}
TracePresets["TracePlayerEyes"] <- function(distance, player, ignoreEnts = null, settings = ::defaultSettings) : (GetEyeEndpos, addInIgnoreList) {
    
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)
    ignoreEnts = addInIgnoreList(ignoreEnts, player)
    
    return BboxCast(startpos, endpos, ignoreEnts, settings)
}
TracePresets["CheapTracePlayerEyes"] <- function(distance, player) : (GetEyeEndpos) {
    
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)
    return CheapTrace(startpos, endpos)
}
TracePresets["CheapPortalTracePlayerEyes"] <- function(distance, player) : (GetEyeEndpos) {
    
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)
    return PortalTrace(startpos, endpos)
}
TracePresets["PortalTracePlayerEyes"] <- function(distance, player, ignoreEnts = null, settings = ::defaultSettings) : (GetEyeEndpos, addInIgnoreList) {
    
    local startpos = player.EyePosition()
    local endpos = GetEyeEndpos(player, distance)
    ignoreEnts = addInIgnoreList(ignoreEnts, player)
    
    return PortalBboxCast(startpos, endpos, ignoreEnts, settings)
}
local GetImpactNormal = function(intersectionPoints, hitpos) { 
    
    local edge1 = intersectionPoints.point1 - hitpos;
    local edge2 = intersectionPoints.point2 - hitpos;
    
    local normal = edge2.Cross(edge1)
    normal.Norm()
    return normal
}
local GetNewStartsPos = function(startpos, dir) {
    
    local perpDir = Vector(-dir.y, dir.x, 0)
    local offset1 = perpDir
    local offset2 = dir.Cross(offset1)
    
    local newStart1 = startpos + offset1
    local newStart2 = startpos + offset2
    return [
        newStart1, 
        newStart2
    ]
}
local _getIntPoint = function(newStart, dir) {    
    return CheapTrace(newStart, (newStart + dir * 8000)).GetHitpos()
}
local _getIntPointCostly = function(newStart, dir, traceResult) {  
    
    local endpos = newStart + dir * 8000   
    local trace = TraceLineAnalyzer(newStart, endpos, traceResult.GetIngoreEntities(), traceResult.GetTraceSettings(), traceResult.GetNote())
    return trace.GetHitpos()
}
::CalculateImpactNormal <- function(startpos, hitpos, traceResult) 
                        : (GetImpactNormal, GetNewStartsPos, _getIntPoint, _getIntPointCostly) 
{
    
    local dir = hitpos - startpos
    dir.Norm()
    local newStartsPos = GetNewStartsPos(startpos, dir)
    local intersectionPoints
    if(typeof traceResult == "BboxTraceResult" && traceResult.GetEntity() && traceResult.GetTraceSettings().useCostlyNormalComputation) {
        intersectionPoints = {
            point1 = _getIntPointCostly(newStartsPos[0], dir, traceResult),
            point2 = _getIntPointCostly(newStartsPos[1], dir, traceResult)
        }
    } else {
        intersectionPoints = {
            point1 = _getIntPoint(newStartsPos[0], dir),
            point2 = _getIntPoint(newStartsPos[1], dir)
        }
    }
    return GetImpactNormal(intersectionPoints, hitpos)
}
function CorrectDisable(ent = null) {
    if(ent == null)
        ent = caller
    if(typeof ent != "pcapEntity")
        ent = entLib.FromEntity(ent)
    EntFireByHandle(ent, "Disable")
    ent.SetUserData("bboxInfo", ent.GetBBox())
    ent.SetBBox(Vector(), Vector())
}
function CorrectEnable(ent = null) {
    if(ent == null)
        ent = caller
    if(typeof ent != "pcapEntity")
        ent = entLib.FromEntity(ent)
    EntFireByHandle(ent, "Enable")
    local bbox = ent.GetUserData("bboxInfo")
    ent.SetBBox(bbox.min, bbox.max)
}
::defaultSettings <- TraceSettings.new()
if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 
function AttachEyeControlToPlayers() {
    for(local player; player = entLib.FindByClassname("player", player);) {
        if(player.GetUserData("Eye")) return
    
        local controlName = "eyeControl" + UniqueString()
        local eyeControlEntity = entLib.CreateByClassname("logic_measure_movement", {
            targetname = controlName, measuretype = 1}
        )
    
        local eyeName = "eyePoint" + UniqueString()
        local eyePointEntity = entLib.CreateByClassname("info_target", {targetname = eyeName})
    
        local playerName = player.GetName() == "" ? "!player" : player.GetName()
    
        EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName)
        EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName);
        EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName);
        EntFireByHandle(eyeControlEntity, "Settarget", eyeName);
        EntFireByHandle(eyeControlEntity, "Enable")
    
        player.SetUserData("Eye", eyePointEntity)
    }
}
AttachEyeControlToPlayers()
if(IsMultiplayer()) {
    RunScriptCode.setInterval(AttachEyeControlToPlayers, 5)
} 
