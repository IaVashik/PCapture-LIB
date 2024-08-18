// TODO описание feature, про накладные рассходы, про более дешевый bboxcast

::_ents <- {}
::_sorted_ents <- class {
    classnames = {}
    targetnames = {}
}

_ignoreEnts <- {
    func_instance_io_proxy = null,
    bodyque = null,
    player_pickup = null
}

::CheapEntities <- class {
    function FindByClassname(previous, classname) {
        if(!(classname in _sorted_ents.classnames)) return null
        foreach(ent in _sorted_ents.classnames[classname]) {
            if(ent.IsValid() && (!previous || previous.entindex() != ent.entindex())) return ent
        }
    }

    function FindByName(previous, targetname) {
        if(!(targetname in _sorted_ents.targetnames)) return null
        foreach(ent in _sorted_ents.targetnames[targetname]) {
            if(ent.IsValid() && (!previous || previous.entindex() != ent.entindex())) return ent
        }
    }

    function FindByClassnameWithin(previous, classname, origin, radius) {
        if(!(classname in _sorted_ents.classnames)) return null
        foreach(ent in _sorted_ents.classnames) {

        }
    }
}


class GlobalEntitiesSearcher {
    constructor() {
        ScheduleEvent.AddInterval("global", SearchNewEntity, 0.1, 0, null, this)
        ScheduleEvent.AddInterval("global", FindKilled, 0.5, 0, null, this)
    }

    // async func
    function SearchNewEntity() {
        local loop = 0
        for(local ent = null; ent = Entities.FindByClassname(ent, "*");) {
            loop++
            if(loop % 5 == 0) yield 0.15
            
            if(ent.GetClassname() in _ignoreEnts || ent in _ents) continue
            dev.info("NewEntity: " + ent)
            _ents[ent] <- null
            this.EntitySorting(ent)
        }

        return null
    }

    function EntitySorting(ent) {
        local classname = ent.GetClassname()
        local targetname = ent.GetName()

        if(!(classname in _sorted_ents.classnames)) {
            _sorted_ents.classnames[classname] <- List()
        }
        _sorted_ents.classnames[classname].append(ent.weakref())

        if(targetname == "") return
        if(!(targetname in _sorted_ents.targetnames)) {
            _sorted_ents.targetnames[targetname] <- List()
        }
        _sorted_ents.targetnames[targetname].append(ent.weakref())
    }

    // async func
    function FindKilled() {
        local loop = 0
        foreach(ent, _ in _ents) {
            if(!ent || !ent.IsValid()) {
                printl("Kiled entity finded! " + ent)
                delete _ents[ent]
            }
            loop++
            if(loop % 10 == 0) yield 0.5
        }
        return null
    }
}