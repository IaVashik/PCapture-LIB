HUD["HintInstructor"] <- class {
    CPcapEntity = null;

    constructor(message, holdtime = 5, icon = "icon_tip", showOnHud = 1, targetname = "hint") {
        this.CPcapEntity = entLib.CreateByClassname("env_instructor_hint", {
            // The text of your hint. 100 character limit.
            hint_caption = message,
            // Either show at the position of the Target Entity, or show the hint directly on the HUD at a fixed position.
            hint_static = showOnHud,
            hint_allow_nodraw_target = showOnHud,
            // The color of the caption text.
            hint_color = "255, 255, 255",
            // The icon to use when the hint is within the player's view.
            hint_icon_onscreen = icon,
            hint_icon_offscreen = icon,
            // The automatic timeout for the hint. 0 will persist until stopped with EndHint.
            hint_timeout = holdtime,
            hint_forcecaption = 1
            hint_nooffscreen = 0,
            hint_range = 0,
            targetname = targetname
        })
    }

    function Enable() null
    function Disable() null
    function Update() null
    
    function SetText(message) null // Changes the message of the text display
    function SetBind(bind) null
    function SetPositioning(value, ent) null
    function SetColor(string_color) null
    function SetIconOnScreen(icon) null
    function SetIconOffScreen(bind) null
    function SetHoldTime(time) null
    function SetDistance(value) null
    function SetEffects(sizePulsing, alphaPulsing, shaking) null
}

// Implementation of 'enable' to display the on-screen text
function HUD::HintInstructor::Enable() {
    EntFireByHandle(this.CPcapEntity, "ShowHint")
}

// Implementation of 'disable' to hide the on-screen text
function HUD::HintInstructor::Disable() {
    EntFireByHandle(this.CPcapEntity, "EndHint")
}

function HUD::HintInstructor::Update() {
    this.CPcapEntity.Enable()
}

// TODO comments
function HUD::HintInstructor::SetText(message) {
    this.CPcapEntity.SetKeyValue("hint_caption", message)
}
 
function HUD::HintInstructor::SetBind(bind) {
    this.CPcapEntity.SetKeyValue("hint_binding", bind)
    this.CPcapEntity.SetKeyValue("hint_icon_onscreen", "use_binding")
}

function HUD::HintInstructor::SetPositioning(value, ent = null) { // showOnHud
    this.CPcapEntity.SetKeyValue("hint_static", value)
    this.CPcapEntity.SetKeyValue("hint_target", ent)
}

function HUD::HintInstructor::SetColor(color) {
    this.CPcapEntity.SetKeyValue("hint_color", color)
}

function HUD::HintInstructor::SetIconOnScreen(icon) {
    this.CPcapEntity.SetKeyValue("hint_icon_onscreen", icon)
}

function HUD::HintInstructor::SetIconOffScreen(bind) {
    this.CPcapEntity.SetKeyValue("hint_icon_offscreen", icon)
}   

function HUD::HintInstructor::SetHoldTime(time) {
    this.CPcapEntity.SetKeyValue("hint_timeout", time)
}

function HUD::HintInstructor::SetDistance(value) {
    this.CPcapEntity.SetKeyValue("hint_range", value)
}

function HUD::HintInstructor::SetEffects(sizePulsing, alphaPulsing, shaking) {
    this.CPcapEntity.SetKeyValue("hint_pulseoption", sizePulsing)
    this.CPcapEntity.SetKeyValue("hint_alphaoption", alphaPulsing)
    this.CPcapEntity.SetKeyValue("hint_shakeoption", shaking)
}