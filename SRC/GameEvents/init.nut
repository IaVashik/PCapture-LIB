::AllGameEvents <- {}

dev["VSEvent"] <- function(msg) if(VSEventLogs) printl("VScript Event Fired: " + msg)

// TODO add support real game event

IncludeScript("SRC/GameEvents/event_listener")
IncludeScript("SRC/GameEvents/game_event")