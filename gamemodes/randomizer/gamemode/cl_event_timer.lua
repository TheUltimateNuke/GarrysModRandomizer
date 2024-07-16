if not CLIENT then return end
local PANEL = {}
local timerText
function PANEL:Init()
    self:Dock(TOP)
    self.TimerValue = math.huge
    self.TimerText = vgui.Create("DLabel", self)
    timerText = self.TimerText
    self.TimerText:SetContentAlignment(5)
    self.TimerText:SetFont("DermaLarge")
    self.TimerText:Dock(FILL)
end

net.Receive(
    "nrm_timer",
    function()
        local timerVal = net.ReadFloat()
        if not timerVal then return end
        PANEL.TimerValue = timerVal
        timerText:SetText(math.floor(PANEL.TimerValue))
    end
)

vgui.Register("EventTimerPanel", PANEL, "DPanel")