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
        return arr.reverse();
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
            printl("� " + msg)
    },
        warning = function(msg) {
        _more_info("? Warning (%s [%d]): %s", msg)
    },
        error = function(msg) {
        _more_info("?? *ERROR*: [func = %s; line = %d] | %s", msg)
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
if("entLib" in getroottable()) {
    dev.warning("entLib module initialization skipped. Module already initialized.")
    return
}
::entLib <- class {
        function CreateByClassname(classname, keyvalues = {}) {
        local new_entity = pcapEntity(Entities.CreateByClassname(classname))
        foreach(key, value in keyvalues) {
            new_entity.SetKeyValue(key, value)
        }
        return new_entity
    }
    function CreateProp(classname, origin, modelname, activity = 1, keyvalues = {}) {
        local new_entity = pcapEntity(CreateProp(classname, origin, modelname, activity))
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
        return pcapEntity(CBaseEntity)
    }
}
::pcapEntity <- class {
    CBaseEntity = null;
    Scope = {}
        constructor(entity = null) {
        if(typeof entity == "pcapEntity")
            entity = entity.CBaseEntity
        if(entity == null) return null
        this.CBaseEntity = entity
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
        return this.CBaseEntity && this.CBaseEntity.IsValid() && this.GetUserData("Dissolved") != true
    }
        function IsPlayer() {
        return this.CBaseEntity == GetPlayer()  
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
        this.CBaseEntity.GetScriptScope()[name.tolower()] <- value
    }
        function GetUserData(name) {
        local Scope = this.CBaseEntity.GetScriptScope()
        name = name.tolower()
        if(name in Scope)
            return Scope[name]
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
::scheduledEventsList <- {global = []}
::isEventLoopRunning <- false
::CreateScheduleEvent <- function(eventName, action, timeDelay, note = null)
{
    if ( !(eventName in scheduledEventsList) )
    {
        scheduledEventsList[eventName] <- []
    }
    local newScheduledEvent = {action = action, timeDelay = (Time() + timeDelay), note = note}
    local currentEventList = scheduledEventsList[eventName]
    local lastIndex = currentEventList.len() - 1
    while (lastIndex >= 0 && currentEventList[lastIndex].timeDelay > newScheduledEvent.timeDelay)
    {
        lastIndex--
    }
    currentEventList.insert(lastIndex + 1, newScheduledEvent)
    if(!isEventLoopRunning)
    {
        isEventLoopRunning = true
        ExecuteScheduledEvents()
    }
}
::ExecuteScheduledEvents <- function() {
    if(scheduledEventsList.len() == 1 && scheduledEventsList.global.len() == 0)
        return isEventLoopRunning = false
    foreach(eventName, eventInfo in scheduledEventsList)
    {
        if(eventInfo.len() == 0 && eventName != "global")
            cancelScheduledEvent(eventName)
        while (eventInfo.len() > 0 && Time() >= eventInfo[0].timeDelay) 
        {
            local event = eventInfo[0]
            if(typeof event.action == "string") {
                    compilestring( event.action )()
            }
            else if(typeof event.action == "function" || typeof event.action == "native function"){
                event.action() 
            }
            else {
                dev.warning("Unable to process event " + event.action + " in event " + eventName)
            }
            eventInfo.remove(0) 
        }
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
if("bboxcast" in getroottable()) {
    dev.warning("Animate module initialization skipped. Module already initialized.")
    return
}
::defaultSettings <- {  
    ignoreClass = arrayLib.new("info_target", "viewmodel", "weapon_", "func_illusionary", "info_particle_system",
    "trigger_", "phys_", "env_sprite", "point_", "vgui_", "physicsclonearea", "env_beam", "func_breakable"),
    priorityClass = arrayLib.new("linked_portal_door"),
    customFilter = null,      
    ErrorCoefficient = 500,
}
::bboxcast <- class {
    startpos = null;
    endpos = null;
    hitpos = null;
    hitent = null;
    surfaceNormal = null;
    ignoreEnt = null;
    traceSettings = null;
    PortalFound = [];
        constructor(startpos, endpos, ignoreEnt = null, settings = ::defaultSettings, note = null) {
        this.startpos = startpos;
        this.endpos = endpos;
        this.ignoreEnt = ignoreEnt
        this.traceSettings = _checkSettings(settings)
        local result = this.Trace(startpos, endpos, ignoreEnt, note)
        this.hitpos = result.hit
        this.hitent = result.ent
    }
        function GetStartPos() {
        return startpos
    }
        function GetEndPos() {
        return endpos
    }
         function GetHitpos() {
        return hitpos
    }
        function GetEntity() {
        return entLib.FromEntity(this.hitent)
    }
        function GetEntityClassname() {
        return this.hitent ? this.GetEntity().GetClassname() : null 
    }
        function GetIngoreEntities() {
        return ignoreEnt
    }
        function DidHit() {
        return GetFraction() != 1
    }
        function DidHitWorld() {
        return (!hitent && DidHit())
    }
        function GetFraction() {
        return _GetDist(startpos, hitpos) / _GetDist(startpos, endpos)
    }
        function GetDir() {
        return this.endpos - this.startpos
    }
        function GetImpactNormal() { 
        if(surfaceNormal)
            return surfaceNormal
        local intersectionPoint = this.hitpos
        local dir = (this.hitpos - this.startpos)
        dir.Norm()
        local perpDir = Vector(-dir.y, dir.x, 0)
        local offset1 = perpDir
        local offset2 = dir.Cross(offset1)
        local newStart1 = this.startpos + offset1
        local newStart2 = this.startpos + offset2
        local intersectionPoint1
        local intersectionPoint2
        if(this.GetEntity()) {
            local normalSetting = {
                ignoreClass = ["*"],
                priorityClass = [this.GetEntity().GetClassname()],
                ErrorCoefficient = 3000,
            }
            intersectionPoint1 = bboxcast(newStart1, newStart1 + dir * 8000, this.ignoreEnt, normalSetting).GetHitpos()
            intersectionPoint2 = bboxcast(newStart2, newStart2 + dir * 8000, this.ignoreEnt, normalSetting).GetHitpos()
        }
        else {
            intersectionPoint1 = _TraceEnd(newStart1, newStart1 + dir * 8000)
            intersectionPoint2 = _TraceEnd(newStart2, newStart2 + dir * 8000)
        }
        local edge1 = intersectionPoint1 - intersectionPoint;
        local edge2 = intersectionPoint2 - intersectionPoint;
        local normal = edge2.Cross(edge1)
        normal.Norm()
        this.surfaceNormal = normal
        return this.surfaceNormal
    }
        function Trace(startpos, endpos, ignoreEnt, note) {
        local hitpos = _TraceEnd(startpos, endpos)
        local dist = hitpos - startpos
        local dist_coeff = abs(dist.Length() / traceSettings.ErrorCoefficient) + 1
        local step = dist.Length() / 14 / dist_coeff
        for (local i = 0.0; i < step; i++) {
            local Ray_part = startpos + dist * (i / step)
            for (local ent;ent = Entities.FindByClassnameWithin(ent, "*", Ray_part, 5 * dist_coeff);) {
                if (ent && _checkEntityIsIgnored(ent, ignoreEnt, note)) {
                    return {hit = Ray_part, ent = ent}
                }
            }
        }
        return {hit = hitpos, ent = null}
    }
        function _isPriorityEntity(entityClass) {
        return traceSettings.priorityClass.find(entityClass)
    }
        function _isIgnoredEntity(entityClass) {
        return traceSettings.ignoreClass.find(entityClass) && !_isPriorityEntity(entityClass)
    }
        function _checkEntityIsIgnored(ent, ignoreEnt, note) {
        if(typeof ignoreEnt == "pcapEntity")
            ignoreEnt = ignoreEnt.CBaseEntity
        local classname = ent.GetClassname()
        if(traceSettings.customFilter && traceSettings.customFilter(ent, note))
            return true
        if (typeof ignoreEnt == "array" || typeof ignoreEnt == "arrayLib") {
            foreach (mask in ignoreEnt) {
                if(typeof mask == "pcapEntity")
                    mask = mask.CBaseEntity
                if (mask == ent) {
                    return false;
                }
            }
        } 
        else if (ent == ignoreEnt) {
            return false;
        }
        if (traceSettings.ignoreClass.find("*")) {
            if(!_isPriorityEntity(classname))
                return false
        }
        else {
            if (_isIgnoredEntity(classname)) {
                return false
            }
            else {
                local classType = split(classname, "_")[0] + "_"    
                if(_isIgnoredEntity(classType) && !_isPriorityEntity(classname))
                    return false
            }
        }
        return true
    }
    function _GetDist(start, end) {
        return (start - end).Length()
    }
    function _TraceEnd(startpos,endpos) {
        return startpos + (endpos - startpos) * (TraceLine(startpos, endpos, null))
    }
    function _checkSettings(inputSettings) {
        if (inputSettings.len() == 4)  
            return inputSettings
        if (!("ignoreClass" in inputSettings)) {
            inputSettings["ignoreClass"] <- ::defaultSettings["ignoreClass"]
        }
        if (!("priorityClass" in inputSettings)) {
            inputSettings["priorityClass"] <- ::defaultSettings["priorityClass"]
        }   
        if (!("ErrorCoefficient" in inputSettings)) {
            inputSettings["ErrorCoefficient"] <- ::defaultSettings["ErrorCoefficient"]
        }
        if (!("customFilter" in inputSettings)) {
            inputSettings["customFilter"] <- ::defaultSettings["customFilter"]
        }
        if(typeof inputSettings["ignoreClass"] == "array")
            inputSettings["ignoreClass"] = arrayLib(inputSettings["ignoreClass"])
        if(typeof inputSettings["priorityClass"] == "array")
            inputSettings["priorityClass"] = arrayLib(inputSettings["priorityClass"]) 
        return inputSettings
    }
    function _tostring() {
        return "Bboxcast 2.0 | \nstartpos: " + startpos + ", \nendpos: " + endpos + ", \nhitpos: " + hitpos + ", \nent: " + hitent + "\n========================================================="
    }
}
function bboxcast::TracePlayerEyes(distance, ignoreEnt = null, settings = ::defaultSettings, player = null, note = null) {
    if(player == null) 
        player = GetPlayerEx()
    if(!player) 
        return bboxcast(Vector(), Vector())
    if(typeof player != "pcapEntity") 
        player = entLib.FromEntity(player)
    local eyePointEntity = player.GetUserData("Eye")
    local eyePosition = eyePointEntity.GetOrigin()
    local eyeDirection = eyePointEntity.GetForwardVector()
    local startpos = eyePosition
    local endpos = eyePosition + eyeDirection * distance
    if (ignoreEnt) {
        if (type(ignoreEnt) == "array" || typeof ignoreEnt == "arrayLib") {
            ignoreEnt.append(player)
        }
        else {
            ignoreEnt = [player, ignoreEnt]
        }
    }
    else {
        ignoreEnt = player
    }
    return bboxcast(startpos, endpos, ignoreEnt, settings, note)
}
__disabled_entity <- {}
function CorrectDisable(ent = null) : (__disabled_entity) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)
    EntFireByHandle(ent, "Disable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( !(entIndex in __disabled_entity)) {
        __disabled_entity[entIndex] <- {min = ent.GetBoundingMins(), max = ent.GetBoundingMaxs()}
    }
    ent.SetSize(Vector(), Vector())
}
function CorrectEnable(ent = null) : (__disabled_entity) {
    if(!ent)
        ent = caller
    if(typeof ent == "string")
        ent = Entities.FindByName(null, ent)
    EntFireByHandle(ent, "Enable", "", 0, null, null)
    local entIndex = ent.entindex.tostring()
    if( entIndex in __disabled_entity ) {
        local BBox = __disabled_entity[entIndex]
        ent.SetSize(BBox.min, BBox.max)
    }
}
for(local player; player = entLib.FindByClassname("player", player);) {
    if(player.GetUserData("Eye")) return
    eyeControlEntity <- Entities.CreateByClassname( "logic_measure_movement" )
    local controlName = "eyeControl" + UniqueString()
    eyeControlEntity.__KeyValueFromString("targetname", controlName)
    eyeControlEntity.__KeyValueFromInt("measuretype", 1)
    eyePointEntity <- Entities.CreateByClassname( "info_target" )
    local eyeName = "eyePoint" + UniqueString()
    eyePointEntity.__KeyValueFromString("targetname", eyeName)
    local playerName = player.GetName() == "" ? "!player" : player.GetName()
    EntFireByHandle(eyeControlEntity, "setmeasuretarget", playerName, 0, null, null)
    EntFireByHandle(eyeControlEntity, "setmeasurereference", controlName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "SetTargetReference", controlName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "Settarget", eyeName, 0, null, null);
    EntFireByHandle(eyeControlEntity, "Enable", "", 0, null, null)
    player.SetUserData("Eye", eyePointEntity)
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
            return [pcapEntity(entities)]
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
        local coordStep = (endPos - startPos) / steps
        for (local tick = 1; tick <= steps; tick++) {
            local newPosition = startPos + (coordStep * tick)
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
    return pcapPlayer(GetPlayer())
}
::pcapPlayer <- class extends pcapEntity {
    function EyePosition() {
        return this.CBaseEntity.EyePosition()
    }
    function EyeAngles() {
        return this.GetUserData("Eye").GetAngles()
    }
    function EyeForwardVector() {
        return this.GetUserData("Eye").GetForwardVector()
    }
}
if(("dissolver" in getroottable()) == false) {
    ::dissolver <- entLib.CreateByClassname("env_entity_dissolver", {targetname = "@dissolver"})
} 