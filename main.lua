-- Multimodule protocols
--
-- Updated for ETHOS to cover the protocols added to the DIY-Multiprotocol-TX-Module
-- firmware (pascallanger) since FrSky's 1.6 release.
--
-- Protocol numbers and sub-protocol (variant) order are taken from the firmware's
-- Multiprotocol.h enum and Multi.txt list:
--   https://github.com/pascallanger/DIY-Multiprotocol-TX-Module
--
-- Changes vs the FrSky 1.6 main.lua are tagged below with -- [NEW] (added protocol)
-- or -- [UPD] (variant/option list brought up to date with current firmware).

local FAILSAFE = 1

-- options sent on byte 26
local DISABLE_TELEMETRY_OPTION = {name="Disable telemetry", type="checkbox", min=0, max=0x02000000}
local DISABLE_CH_MAPPING_OPTION = {name="Disable channel mapping", type="checkbox", min=0, max=0x01000000}

-- options sent on byte 1
local BIND_ON_CHANNEL_OPTION = {name="Bind on channel", type="checkbox", min=0, max=0x400000}

-- options sent on byte 2
local LOW_POWER_OPTION = {name="Low power", type="checkbox", min=0, max=0x8000}

-- options sent on byte 3
local RF_TUNE_OPTION = {name="RF tune", min=-128, max=127}
local DSM2_ENABLE_MAX_THROW_OPTION = {name="Enable max throw", type="checkbox", min=0, max=0x80}
local DSM2_SERVO_REFRESH_RATE_OPTION = {name="Servo refresh rate", type="choice", max=0x40, values={{"22ms", 0x00}, {"11ms", 0x40}}}
local FLYSKY_SERVO_REFRESH_RATE_OPTION = {name="Servo refresh rate", min=0, max=70, display=function(value) return (value * 5 + 50) .. "Hz" end}
local FIXED_ID = {name="Fixed ID", type="checkbox", min=0, max=0x00000001}

local function init()
    system.registerMultimoduleProtocol("Assan", 24, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Bayang", 14, {variants={"Bayang", "H8S3D", "X16_AH", "IRDRONE", "DHD_D4", "QX100"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Bayang RX", 59, {variants={"Multi", "CPPM"}})
    system.registerMultimoduleProtocol("BlueFly", 95, {maxChannels=8, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("Bugs", 41, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("BugsMini", 42, {variants={"BUGSMINI", "BUGS3H"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("BumbleB", 96, {maxChannels=5, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("Cabell", 34, {variants={"Cabell_V3", "C_TELEM", "0", "0", "0", "0", "F_SAFE", "UNBIND"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("CFlie", 38, {variants={"CFlie"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("CG023", 13, {variants={"CG023", "YD829"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Corona", 37, {variants={"COR_V1", "COR_V2", "FD_V3"}, options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("CX10", 12, {variants={"GREEN", "BLUE", "DM007", "0", "J3015_1", "J3015_2", "MK33041"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Devo", 7, {variants={"8CH", "10CH", "12CH", "6CH", "7CH"}, options={FIXED_ID, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("DM002", 33, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("DSM_RX", 70, {variants={"Multi", "CPPM"}})
    system.registerMultimoduleProtocol("E010R5", 81, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("E016H", 85, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("E016HV2", 80, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("E01X", 45, {variants={"E012", "E015"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("E129", 83, {variants={"E129", "C186"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("ESky", 16, {variants={"ESky", "ET4"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("ESky150", 35, {variants={"4CH", "7CH"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] variants added
    system.registerMultimoduleProtocol("ESky150V2", 69, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FlySky", 1, {variants={"Default", "V9X9", "V6X6", "V912", "CX20"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FlySky AFHDS 2A", 28, {variants={"PWM+IBUS", "PPM+IBUS", "PWM+SBUS", "PPM+SBUS", "Gyro_Off", "Gyro_On", "Gyro_On_Rev"}, features=FAILSAFE, options={FLYSKY_SERVO_REFRESH_RATE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] subs 4..6 are now Gyro modes
    system.registerMultimoduleProtocol("Flysky AFHDS2A RX", 56, {variants={"Multi", "CPPM"}})
    system.registerMultimoduleProtocol("FQ777", 23, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FrSky D8", 3, {variants={"D8", "Cloned"}, options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}, minChannels=8, maxChannels=8})
    system.registerMultimoduleProtocol("FrSky R9", 65, {variants={"915MHz", "868MHz", "915_8ch", "868_8ch", "FCC", "--", "FCC_8ch", "--_8ch"}, features=FAILSAFE, maxChannels=16, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW] failsafe + full telemetry
    system.registerMultimoduleProtocol("FrskyL", 67, {variants={"LR12", "LR12 6CH"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FrSky V", 25, {options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FrskyX", 15, {variants={"CH_16", "CH_8", "EU_16", "EU_8", "Cloned", "Cloned_8"}, options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FrskyX2", 64, {variants={"CH_16", "CH_8", "EU_16", "EU_8", "Cloned", "Cloned_8"}, features=FAILSAFE, options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Frsky_RX", 55, {variants={"Multi", "CloneTX", "EraseTX", "CPPM"}})
    system.registerMultimoduleProtocol("Futaba/SFHSS", 21, {variants={"SFHSS"}, features=FAILSAFE, options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FX", 58, {variants={"816", "620", "9630", "Q560", "QF012"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("FY326", 20, {variants={"FY326", "FY319"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("GD00X", 47, {variants={"GD_V1*", "GD_V2*"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Graupner HoTT", 57, {variants={"Sync", "No_Sync"}, options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("GW008", 32, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("H36", 103, {maxChannels=7, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("H8_3D", 36, {variants={"H8_3D", "H20H", "H20Mini", "H30Mini"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Height", 53, {variants={"5ch", "8ch"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Hisky", 4, {variants={"Hisky", "HK310"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Hitec", 39, {variants={"OPT_FW", "OPT_HUB", "MINIMA"}, options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Hontai", 26, {variants={"HONTAI", "JJRCX1", "X5C1", "FQ777_951", "XKK170"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] XKK170 added
    system.registerMultimoduleProtocol("Hubsan", 2, {variants={"H107", "H301", "H501"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Ikea Ansluta", 87, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("J6Pro", 22, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("JIABAILE", 102, {variants={"Std", "Gyro"}, maxChannels=7, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("JJRC345", 71, {variants={"JJRC345", "SkyTmblr"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("JOYSWAY", 84, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("KAMTOM", 104, {maxChannels=7, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("KF606", 49, {variants={"KF606", "MIG320", "ZCZ50"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] ZCZ50 added
    system.registerMultimoduleProtocol("KN", 9, {variants={"WLTOYS", "FEILUN"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Kyosho", 73, {variants={"FHSS", "Hype"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Kyosho2", 93, {variants={"KT-17"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Kyosho3", 98, {variants={"ASF"}, maxChannels=4, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("LOLI", 82, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Losi", 89, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("MJXq", 18, {variants={"WLH08", "X600", "X800", "H26D", "E010*", "H26WH", "PHOENIX*"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("MPX MLINK", 78, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}, features=FAILSAFE})
    system.registerMultimoduleProtocol("MouldKg", 90, {variants={"A4444", "D4444", "A664"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] variants updated to current firmware
    system.registerMultimoduleProtocol("MT99xx", 17, {variants={"MT", "H7", "YZ", "LS", "FY805", "A180", "DRAGON", "F949G"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("MT99xx2", 92, {variants={"PA18", "SU35"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] SU35 added
    system.registerMultimoduleProtocol("NCC1701", 44, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("OMP", 77, {options={RF_TUNE_OPTION, BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("OpenLRS", 27, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Pelikan", 60, {variants={"Pro", "Lite", "SCX24"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Potensic", 51, {variants={"A20"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("PROPEL", 66, {variants={"74-Z"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Q2X2", 29, {variants={"Q222", "Q242", "Q282"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Q303", 31, {variants={"Q303", "CX35", "CX10D", "CX10WD"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Q90C", 72, {variants={"Q90C*"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("RadioLink", 74, {variants={"Surface", "Air", "DumboRC", "RC4G"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] RC4G added
    system.registerMultimoduleProtocol("Realacc", 76, {variants={"R11"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Redpine", 50, {variants={"FAST", "SLOW"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Scanner", 54)
    system.registerMultimoduleProtocol("Scorpio", 94, {maxChannels=4, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("SGF22", 97, {variants={"F22", "F22S", "J20", "CX10"}, maxChannels=12, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("Shenqi", 19, {variants={"Shenqi"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Shenqi2", 105, {variants={"Shenqi2"}, maxChannels=2, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("Skyartec", 68, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("SLT", 11, {variants={"SLT_V1", "SLT_V2", "Q100", "Q200", "MR100"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Spektrum", 6, {variants={"DSM2-1F", "DSM2-2F", "DSMX-1F", "DSMX-2F", "AUTO", "DSMR-1F", "DSMR", "DSM2-SFC"}, minChannels=3, maxChannels=12, options={DSM2_ENABLE_MAX_THROW_OPTION, DSM2_SERVO_REFRESH_RATE_OPTION, DISABLE_TELEMETRY_OPTION, DISABLE_CH_MAPPING_OPTION, LOW_POWER_OPTION, BIND_ON_CHANNEL_OPTION}}) -- [UPD] DSMR, DSM2-SFC added
    system.registerMultimoduleProtocol("SymaX", 10, {variants={"SYMAX", "SYMAX5C"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Tiger", 61, {options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("Traxxas", 43, {variants={"TQ2", "TQ1"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] subs are TQ2/TQ1 (6519 RX is TQ2)
    system.registerMultimoduleProtocol("UDIRC", 101, {maxChannels=11, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("V2x2", 5, {variants={"V2x2", "JXD506", "MR101"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("V761", 48, {variants={"3CH", "4CH", "TOPRC"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("V911S", 46, {variants={"V911S*", "E119*"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("WFLY", 40, {variants={"WFR0x"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("WFLY2", 79, {variants={"RF20x"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("WK2x01", 30, {variants={"WK2801", "WK2401", "W6_5_1", "W6_6_1", "W6_HEL", "W6_HEL_I"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("WL91X", 106, {maxChannels=4, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("WPL", 107, {maxChannels=7, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("XERALL", 91, {variants={"Tank"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("XK", 62, {variants={"X450", "X420", "Cars"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [UPD] Cars added
    system.registerMultimoduleProtocol("XK2", 99, {variants={"X4", "P10"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("YD717", 8, {variants={"YD717", "SKYWLKR", "SYMAX4", "XINXUN", "NIHUI"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
    system.registerMultimoduleProtocol("YuXiang", 100, {maxChannels=11, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}}) -- [NEW]
    system.registerMultimoduleProtocol("ZSX", 52, {variants={"280"}, options={BIND_ON_CHANNEL_OPTION, DISABLE_TELEMETRY_OPTION, LOW_POWER_OPTION}})
end

return {init=init}
