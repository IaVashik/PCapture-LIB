HUD["ScreenText"] <- class {
    CPcapEntity = null;
    
    constructor(position, message, holdtime = 10, targetname = "") {
        this.CPcapEntity = entLib.CreateByClassname("game_text", {
            // Set initial properties for the text display entity
            channel = 2,
            color = "170 170 170",
            color2 = "0 0 0",
            effect = 0,
            fadein = 0,
            fadeout = 0,
            fxtime = 0,
            holdtime = holdtime,
            x = position.x,
            y = position.y,
            spawnflags = 0,
            message = message,
            targetname = targetname
        })
    }

    function Enable() null
    function Disable() null
    function Update() null

    function SetText(message) null // Changes the message of the text display
    function SetChannel(value) null
    function SetColor(string_color) null
    function SetColor2(string_color) null
    function SetEffect(value) null
    function SetFadeIn(value) null
    function SetFadeOut(value) null
    function SetHoldTime(time) null
    function SetPos(Vector) null
}


// Implementation of 'enable' to display the on-screen text
function HUD::ScreenText::Enable() {
    EntFireByHandle(this.CPcapEntity, "Display")
}

// Implementation of 'disable' to hide the on-screen text
function HUD::ScreenText::Disable() {
    EntFireByHandle(this.CPcapEntity, "Disable")
}

function HUD::ScreenText::Update() {
    this.CPcapEntity.Enable()
}

// TODO comments

// Implementation of 'SetText' to change the message and re-enable the text display
function HUD::ScreenText::SetText(message) {
    this.CPcapEntity.SetKeyValue("message", message)
}

function HUD::ScreenText::SetChannel(channel) {
    this.CPcapEntity.SetKeyValue("channel", channel)
}

function HUD::ScreenText::SetColor(color) {
    this.CPcapEntity.SetKeyValue("color", color)
}

function HUD::ScreenText::SetColor2(color) {
    this.CPcapEntity.SetKeyValue("color2", color)
}

function HUD::ScreenText::SetEffect(idx) {
    this.CPcapEntity.SetKeyValue("effect", idx)
}

function HUD::ScreenText::SetFadeIn(value) {
    this.CPcapEntity.SetKeyValue("fadein", value)
}

function HUD::ScreenText::SetFadeOut(value) {
    this.CPcapEntity.SetKeyValue("fadeout", value)
}

function HUD::ScreenText::SetHoldTime(time) {
    this.CPcapEntity.SetKeyValue("holdtime", time)
}

function HUD::ScreenText::SetPos(position) {
    this.CPcapEntity.SetKeyValue("x", position.x)
    this.CPcapEntity.SetKeyValue("y", position.y)
}