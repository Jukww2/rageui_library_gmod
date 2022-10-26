if not CLIENT then return end

RageUI = {}

RageUI.ScrW, RageUI.ScrH = ScrW(), ScrH()

RageUI.Colors = {
    ["black"] = Color(0, 0, 0, 255),
    ["blue"] = Color(0, 136, 255, 255),
}

RageUI.Sounds = {
    ["click"] = Sound("rageui_gmod/click.wav"),
    ["accept"] = Sound("rageui_gmod/accept.wav")
}

surface.CreateFont("RageUI::Font::Italic", {
    font = "SignPainter",
    size = 75,
})

surface.CreateFont("RageUI::Font::1", {
    font = "Chalet LondonNineteenSixty",
    size = 20,
})

surface.CreateFont("RageUI::Font::2", {
    font = "Chalet LondonNineteenSixty",
    size = 22,
})

/***********************
******** Exemple *******
************************/

function drawPersonnalMenu()
    if ( IsValid(frame) ) then 
        if ( frame:IsVisible() ) then
            frame:SetVisible(false)
        else
            frame:SetVisible(true)
        end
        return 
    end

    frame = vgui.Create("RageUI::Frame")
    frame:SetSize(500, 300)
    frame:SetPos(20, 20)
    frame:SetTitle("Personal Menu")
    frame:SetHeaderColor(RageUI.Colors["blue"])
    frame:SetDescription("This is ur personnal menu !")
    frame:SetButtonsCount(true)

    frame:NewButton("Get my steamid", "Get your steamid and it will apeard in the console.", function(button)
        chat.AddText("Your sId : "..LocalPlayer():SteamID())
    end)
    frame:NewButton("Say yeah", "You will say yeah !!!", function(button)
        RunConsoleCommand("say", "yeah")
    end)
    frame:NewButton("Buy Shield for 2€", "Buy a kevlar for no money", function(button)
        chat.AddText("You bought a kevlar")
    end)
end

hook.Add("PlayerButtonDown", "RageUI::Hook::OpenPersonnalMenu", function(ply, button)
    if not IsFirstTimePredicted() then return end
    if ( ply ~= LocalPlayer() ) then return end

    if ( button == KEY_COMMA ) then
        drawPersonnalMenu()
    end
end)