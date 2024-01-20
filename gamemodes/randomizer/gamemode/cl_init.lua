include("shared.lua")
include ("cl_event_timer.lua")

DEFINE_BASECLASS("sandbox")

hook.Add("OnGamemodeLoaded", "nrm_load_hud", function()
    vgui.Create("EventTimerPanel")
end)