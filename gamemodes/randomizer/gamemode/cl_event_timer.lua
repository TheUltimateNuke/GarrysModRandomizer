if not CLIENT then return end


local PANEL = {}

function PANEL:Init()
    self:Dock(TOP)

    self.TimerValue = math.huge
    self.TimerText = vgui.Create("DLabel", self)
    hook.Add("NRM_EventTimerTick", "nrm_receive_timer_tick", function(timerVal)
        self.TimerValue = timerVal
        self.TimerText:SetText(math.floor(self.TimerValue))
    end)
    self.TimerText:SetContentAlignment(5)
    self.TimerText:SetFont("DermaLarge")
    self.TimerText:Dock(FILL)
end

vgui.Register("EventTimerPanel", PANEL, "DPanel")