local PANEL = {}

AccessorFunc(PANEL, "m_buttonText", "ButtonText", FORCE_STRING)
AccessorFunc(PANEL, "m_clickFunction", "ClickFunction")

function PANEL:Init()
    local parent = self:GetParent()

    self:SetSize(parent:GetWide(), RageUI.ScrH*0.035)
    self:SetText("")
    self:Dock(TOP)

    self.selected = false
end

function PANEL:Paint(w, h)
    local textColor = color_white

    if ( self.selected || self:IsHovered() ) then
        surface.SetDrawColor(color_white)
        surface.DrawRect(0, 0, w, h)
    
        textColor = RageUI.Colors["black"]
    end

    draw.SimpleText(self.m_buttonText or "Button", "RageUI::Font::2", RageUI.ScrW*0.005, h / 2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:DoClick()
    if ( isfunction(self.m_clickFunction) ) then self.m_clickFunction(self) end
end

vgui.Register("RageUI::Button", PANEL, "DButton")