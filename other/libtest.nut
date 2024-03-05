IncludeScript("pcapture-lib/SRC/PCapture-Lib.nut")

::assertEq <- function(a, b) {
    if (a != b) {
        return dev.error("TEST ERROR: Expected `" + b + "` but got `" + a + "`")
    }
}

// PCapture-Utils Tests:
function testUtils() {
    // RunScriptCode Tests:
    // Note: Actual execution of scripts is context-dependent and may not be directly testable.
    // We'll skip testing those functions here, but you should ensure they work in your game environment.

    RunScriptCode.fromStr("assertEq(1, 1)")

    // Other Functions Tests:
    local vectorString = "255 31 10";
    local vec = StrToVec(vectorString);
    assertEq(vec.x, 255)
    assertEq(vec.y, 31)
    assertEq(vec.z, 10)
    
    // Test Precache with a fake sound path (won't actually precache in this test environment)
    Precache("sound/test.wav");
}

// PCapture-Entities Tests:
function testEntities() {
    // CreateByClassname Test:
    // Assuming there's a function to create an entity, which is not actually present in this script.
    local ent = entLib.CreateByClassname("info_target");
    assertEq(ent.GetClassname(), "info_target");
    
    // Test GetPlayerEx
    local player = GetPlayerEx()
    assertEq(player.GetClassname(), "player")

    assertEq(player.IsValid(), true)

    player.SetName("test-name")
    assertEq(player.GetName(), "test-name")
    assertEq(player.GetNamePostfix(), "-name")
    assertEq(player.GetNamePrefix(), "test-")

    // Пример теста для pcapEntity.SetKeyValue и pcapEntity.GetKeyValue
    player.SetKeyValue("testKey", "testValue")
    assertEq(player.GetKeyValue("testKey"), "testValue")
}

// PCapture-Math Tests:
function testMath() {
    // Quaternions object Tests:
    local angles = Vector(0, 90, 0);
    local quaternion = math.Quaternion.new(angles);
    // We'll assume quaternion operations work as intended, since there's no straightforward way to test them here.

    // Test Others math functions
    assertEq(math.min(0, 10), 0)
    assertEq(math.max(0, 10), 10)
    assertEq(math.clamp(0, -10, 10), 0)

    // local roundVec = math.roundVector(Vector(10, 90, 0), 45) TODO
    // assertEq(roundVec.x, 2) 
    // assertEq(roundVec.y, 3)
    // assertEq(roundVec.z, 4)

    assertEq(math.Sign(0), 0)
    assertEq(math.copysign(10, -10), -10)
    assertEq(math.RemapVal(5, 10, 10, 5, 1), 5) // todo ???
}

// PCapture-EventHandler Tests:
function testEventHandler() {
    // Test CreateScheduleEvent
    CreateScheduleEvent("my_event", function() {
        dev.log("Scheduled event executed!")
    }, 5)
    assertEq(eventIsValid("my_event"), true)

    // Test cancelScheduledEvent
    cancelScheduledEvent("my_event")
    assertEq(eventIsValid("my_event"), false)
}

// PCapture-Array Tests:
function testArray() {
    // Test array functions
    local myArr = arrayLib.new(1, 2, 3)

    assertEq(myArr.get(0), 1)
    assertEq(myArr.get(7), null)

    myArr.append(15)
    assertEq(myArr.top(), 15)
    myArr.clear()   
    assertEq(myArr.len(), 0)
}

// Running all tests
function runAllTests() {
    testUtils();
    testEntities();
    testMath();
    testEventHandler();
    testArray();
    printl("Test's done!")
}

runAllTests();