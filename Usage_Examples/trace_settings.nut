// method 1:
settings <- TraceSettings(
    arrayLib.new("player", "viewmodel", "func_"),
    arrayLib.new(""),
    150,
    function(ent, note) {return ent.GetHealth() == 17},
    false
)

// method 2:
settings <- TraceSettings.new({
    ignoreClass = arrayLib.new("player", "viewmodel", "func_"),
    errorCoefficient = 150,
    customFilter = function(ent, note) {return ent.GetHealth() == 17}
})


// method 3:
settings <- TraceSettings.new()
settings.SetIgnoreClass(arrayLib.new("player", "viewmodel", "func_"))
settings.SetErrorCoefficient(150)
settings.SetCustomFilter(function(ent, note) {return ent.GetHealth() == 17})

