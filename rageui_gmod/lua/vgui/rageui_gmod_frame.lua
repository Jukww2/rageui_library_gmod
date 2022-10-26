local PANEL = {}

AccessorFunc(PANEL, "m_headerColor", "HeaderColor", FORCE_COLOR)
AccessorFunc(PANEL, "m_description", "Description", FORCE_STRING)
AccessorFunc(PANEL, "m_buttonsCount", "ButtonsCount", FORCE_BOOL)

function PANEL:Init()
    self:ShowCloseButton(false)
    self:SetDraggable(false)

    self.lblTitle:SetVisible(false)

    self.selectedButton = 1
    self.panelButtons = {}
    self.clickCooldown = 0

    timer.Simple(0.1, function()
        self.buttonsPanel = vgui.Create("DPanel", self)
        self.buttonsPanel:SetPos(0, RageUI.ScrH*0.15)
        self.buttonsPanel:SetSize(self:GetWide(), self:GetTall() - RageUI.ScrH*0.125)
        self.buttonsPanel:SetPaintBackground(false)
    end)

    timer.Simple(0.3, function()
        self.panelButtons[self.selectedButton].selected = true
        self:SetTall(RageUI.ScrH*0.189 + (RageUI.ScrH*0.035 * #self.panelButtons))
    end)
end

local gradientDown = Material("vgui/gradient_down")

function PANEL:Paint(w, h)
    local panelColor = ( self.m_headerColor or RageUI.Colors["black"] )

    surface.SetDrawColor(RageUI.Colors["black"])
    surface.SetMaterial(gradientDown)
    surface.DrawTexturedRect(0, RageUI.ScrH*0.148, w, (RageUI.ScrH*0.035 * #self.panelButtons))
    surface.DrawTexturedRect(0, h - RageUI.ScrH*0.03, w, RageUI.ScrH*0.05)

    surface.DrawRect(0, RageUI.ScrH*0.12, w, RageUI.ScrH*0.03)
    surface.DrawRect(0, h - RageUI.ScrH*0.035, w, RageUI.ScrH*0.005)

    surface.SetDrawColor(panelColor)
    surface.DrawRect(0, 0, w, RageUI.ScrH*0.12)

    draw.SimpleText(self:GetTitle(), "RageUI::Font::Italic", w / 2, RageUI.ScrH*0.125 / 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    draw.SimpleText(self.m_description or "Made by Jukww2", "RageUI::Font::1", RageUI.ScrW*0.005, RageUI.ScrH*0.135, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    if ( self.m_buttonsCount ) then
        draw.SimpleText(self.selectedButton.."/"..#self.panelButtons, "RageUI::Font::1", w - RageUI.ScrW*0.005, RageUI.ScrH*0.135, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
    end

    local currentButton = self.panelButtons[self.selectedButton]
    if ( currentButton ) then
        draw.SimpleText(currentButton.desc, "RageUI::Font::1", RageUI.ScrW*0.005, h - RageUI.ScrH*0.035 / 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
end

function PANEL:Think()
    if ( self.clickCooldown > CurTime() ) then return end
    if ( #self.panelButtons == 0 ) then return end
    if ( !input.IsButtonDown(KEY_DOWN) && !input.IsButtonDown(KEY_UP) && !input.IsButtonDown(KEY_ENTER) && !input.IsButtonDown(KEY_BACKSPACE) ) then return end

    local currentButton = self.panelButtons[self.selectedButton]
    self.panelButtons[self.selectedButton].selected = false

    --[[ Switch button ]]
    if ( input.IsButtonDown(KEY_DOWN) ) then

        if ( (self.selectedButton + 1) > #self.panelButtons ) then
            self.selectedButton = 1
        else
            self.selectedButton = self.selectedButton + 1
        end
        surface.PlaySound(RageUI.Sounds["click"])
    --[[ Switch button ]]
    elseif ( input.IsButtonDown(KEY_UP) ) then

        if ( (self.selectedButton - 1) < 1 ) then
            self.selectedButton = #self.panelButtons
        else
            self.selectedButton = self.selectedButton - 1
        end
        surface.PlaySound(RageUI.Sounds["click"])
    --[[ Click on a button ]]
    elseif ( input.IsButtonDown(KEY_ENTER) ) then

        if (isfunction(currentButton.m_clickFunction)) then
            currentButton.m_clickFunction(currentButton)
        end
        surface.PlaySound(RageUI.Sounds["accept"])
    --[[ Close menu ]]
    elseif ( input.IsButtonDown(KEY_BACKSPACE) ) then
        
        self:SetVisible(false)
        surface.PlaySound(RageUI.Sounds["accept"])
    end

    self.panelButtons[self.selectedButton].selected = true
    self.clickCooldown = CurTime() + 0.2
end

function PANEL:NewButton(title, desc, fcClick)
    timer.Simple(0.2, function()
        local parent = self.buttonsPanel
        if ( !IsValid(parent) ) then return end

        local button = vgui.Create("RageUI::Button", parent)
        button:SetButtonText(title)
        button:SetClickFunction(fcClick)
        button.desc = desc
        
        self.panelButtons[#self.panelButtons + 1] = button
    end)
end

vgui.Register("RageUI::Frame", PANEL, "DFrame")