-- GogHub Anime TD v1.0.0 (anime-td). Built by AnimeTD/build.py; edit sources, not this file.
-- Key gate (release builds only; build.py --release puts this before everything else).
-- Asks for the key once, remembers it in workspace/GogHub/AnimeTD/key.txt, and stops the script if closed.
-- Note: a key inside the script is readable by anyone who opens the file; this keeps casual users out only.
local __gogKeyOk = (function()
    local KEY, SAVED = "spooky", "GogHub/AnimeTD/key.txt"
    local function normal(text) return (tostring(text or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")) end
    local canFiles = type(isfile) == "function" and type(readfile) == "function" and type(writefile) == "function"
    if canFiles then
        local ok, saved = pcall(function() return isfile(SAVED) and readfile(SAVED) end)
        if ok and saved and normal(saved) == KEY then return true end
    end

    if not game:IsLoaded() then game.Loaded:Wait() end
    local Players = game:GetService("Players")
    while not Players.LocalPlayer do Players:GetPropertyChangedSignal("LocalPlayer"):Wait() end
    local TweenService = game:GetService("TweenService")
    local parent = (type(gethui) == "function" and gethui()) or game:GetService("CoreGui")

    local function make(class, props)
        local object = Instance.new(class)
        for k, v in pairs(props) do if k ~= "Parent" then object[k] = v end end
        object.Parent = props.Parent
        return object
    end
    local function round(object, r) make("UICorner", { CornerRadius = UDim.new(0, r), Parent = object }) end
    local BG, PANEL, TEXT, MUTED = Color3.fromRGB(14, 17, 24), Color3.fromRGB(21, 25, 34), Color3.fromRGB(233, 239, 245), Color3.fromRGB(128, 138, 152)
    local ACCENT, DANGER = Color3.fromRGB(122, 0, 255), Color3.fromRGB(240, 90, 90)

    local gui = make("ScreenGui", { Name = "GogHubKey", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999, Parent = parent })
    local frame = make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(340, 178),
        BackgroundColor3 = BG, BorderSizePixel = 0, Parent = gui })
    round(frame, 14)
    make("UIStroke", { Color = Color3.fromRGB(44, 50, 64), Thickness = 1, Parent = frame })
    local scale = make("UIScale", { Scale = 0.92, Parent = frame })
    make("TextLabel", { BackgroundTransparency = 1, Position = UDim2.fromOffset(22, 18), Size = UDim2.new(1, -60, 0, 24),
        Font = Enum.Font.GothamBold, Text = "goghub", TextColor3 = TEXT, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
    make("TextLabel", { BackgroundTransparency = 1, Position = UDim2.fromOffset(22, 42), Size = UDim2.new(1, -44, 0, 18),
        Font = Enum.Font.Gotham, Text = "Enter the key to continue", TextColor3 = MUTED, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
    local close = make("TextButton", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(1, -24, 0, 30), Size = UDim2.fromOffset(12, 12),
        BackgroundColor3 = DANGER, BorderSizePixel = 0, Text = "", AutoButtonColor = false, Parent = frame })
    round(close, 6)
    local box = make("TextBox", { Position = UDim2.fromOffset(22, 74), Size = UDim2.new(1, -44, 0, 34), BackgroundColor3 = PANEL,
        BorderSizePixel = 0, ClearTextOnFocus = false, Font = Enum.Font.Gotham, PlaceholderText = "Key...", PlaceholderColor3 = MUTED,
        Text = "", TextColor3 = TEXT, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
    round(box, 8)
    local boxStroke = make("UIStroke", { Color = Color3.fromRGB(44, 50, 64), Thickness = 1, Parent = box })
    make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = box })
    local message = make("TextLabel", { BackgroundTransparency = 1, Position = UDim2.fromOffset(22, 112), Size = UDim2.new(1, -44, 0, 16),
        Font = Enum.Font.Gotham, Text = "", TextColor3 = DANGER, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = frame })
    local unlock = make("TextButton", { Position = UDim2.fromOffset(22, 132), Size = UDim2.new(1, -44, 0, 32), BackgroundColor3 = ACCENT,
        BorderSizePixel = 0, Font = Enum.Font.GothamBold, Text = "Unlock", TextColor3 = Color3.new(1, 1, 1), TextSize = 13,
        AutoButtonColor = true, Parent = frame })
    round(unlock, 8)
    TweenService:Create(scale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = 1 }):Play()

    local result
    local function shake()
        local home = frame.Position
        for _, dx in ipairs({ -8, 7, -5, 4, -2, 0 }) do
            frame.Position = home + UDim2.fromOffset(dx, 0)
            task.wait(0.03)
        end
        frame.Position = home
    end
    local function try()
        if normal(box.Text) == KEY then
            if canFiles then pcall(function()
                if type(isfolder) == "function" and type(makefolder) == "function" then
                    if not isfolder("GogHub") then makefolder("GogHub") end
                    if not isfolder("GogHub/AnimeTD") then makefolder("GogHub/AnimeTD") end
                end
                writefile(SAVED, KEY)
            end) end
            result = true
        else
            message.Text = box.Text == "" and "Enter a key." or "Wrong key."
            boxStroke.Color = DANGER
            task.spawn(shake)
        end
    end
    unlock.MouseButton1Click:Connect(try)
    box.FocusLost:Connect(function(enter) if enter then try() end end)
    box:GetPropertyChangedSignal("Text"):Connect(function() message.Text = ""; boxStroke.Color = Color3.fromRGB(44, 50, 64) end)
    close.MouseButton1Click:Connect(function() result = false end)
    while result == nil and gui.Parent do task.wait(0.05) end
    TweenService:Create(scale, TweenInfo.new(0.15), { Scale = 0.92 }):Play()
    task.wait(0.12)
    gui:Destroy()
    return result == true
end)()
if not __gogKeyOk then return end

-- Embedded UI assets (release build). Written once to workspace/GogHub/AnimeTD/Assets (rewritten when the build changes).
do
    local folder, stamp = "GogHub/AnimeTD/Assets", "37c1256c8e8d78b7"
    local assets = {
        ["about.png"] = "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",
        ["components.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAFZ0lEQVR4nOybf4hUVRTHz5td2pndDTUt/yjEdrWWyISC/tiNkCJKpAxCK4uCfv0RasGCFehf/dEfEf2goF9GhSWYWFRELUrUHxKaZmv9USItVoRhmji7O5uzO32OzK5v79x5zvPetzPDzBfu3jfn/njnnnvOueed9zYlDY6UNDiaApAGR1MA0uBoCkAaHK1xOo+NjfXk8/kHuOwJguDrTCazmXpE6hhBnM7Dw8OfU62YGhwE97W3t38odYy4JnBz+MfExMRyqXNUrAGFQmHOyMjIcakOspSdaNxaNO5P8Yg4GhDLXDyjk3InGne/eEYcJ1iQKgMNuF48I44AqqkBZ4AZfiqe4aQBMHSCalA8gl1uobrB0rSns7PzPfEMVw3YB1O3iEfgaJ9AsKYACq2trY9IAqipSJCFz8XRPWtper2tre2gJICaEgCB1kuYwIVhGkI5xtH3jCSEWKFwkkD1e1lsyTGHQJ6inJSEUDMCYPH9FvLejo6OdyRBOJ0C7MyE+MPlFtqAJIxa8gE7LLR+TGOBJAinUBi19SZAHN0LVH8Z5DT3eEUSRM1oAOY0SllvaVo5Ojp6kySEmjoG0YLt7Pguk05s8Bb0CyQB1FxKrKWl5VGq0wa5C1+wQRJAveQDFDlM5Eq05Ih4RL3kAxTqEB8Wz6irfAC4TjyjZiLBSpBKpV4Uz3ASQBL5gHJg8TtIw+8Sz6i5fMBMo/lqTBocTQHE6Fvy6EtgMi4xgNPMEEytJ/PzCfG99xz/+cDVCcZ9t/gFQlum18T3K7PZ7DGc6JdSRbg+DscJpS+ZXPzUhEGwSaoM14xQCS2Xyy0eHx9fx4KX8HMJff6l3qqLZcdPUM8Jde/FJC4jvv/DnAf6c8yxmjKLn5oRHiQ1/mo6nT4kHuE1IaL2zeI1MFqnu02Zy3U3ZaNmdvhty/qsMgkIsZu5n+ayS+cozqVz/4gZPS4eEUcAkTlBGHsbpl/mMm0bjM1fRfu2kkkLhbtMGgvtETsylNe41xviCV40AIbuoIp6UsuS3d2phTHmI3UfpjE/TMAkBuh3KmK+xxhzm3iAswbA6DzK5jJjDtPneeJ49QV57U/5uISJVOpeY97TJEaWqkZRfikz97u0zRZHOJ8C2PYqGJ5nNP1OuZYdX8RubuAhZig05iPLPCV+gDG/cUQ+SelBGIvo8/M0ZoJgPvcuMZ+4cI4EYWyxSYO5fhb/g60/C/qq+BQZhp4Gl0oZ4PlVkzZa7nOFOMLVBAqULkvf3RKBSk8DY8x+k4Ygu8URThpQDITMXL4mNmefY9x2Cy1SAJwitjmPiiN8PAyVqHo+n787agDmYfPyveZpEAaOco2FvF8c4eMTGZutb+Jo1FdaQyx0iAV/hgr/MzURpwHt6gwfCg9ikfdQaSyhGnExfVbQd6Gquu3NMbR94gjnpCiL28vOfQujNxpND+of6BonnITZi8KBk54G/J4mAA19qfToSzHmEO2zJucoYYYXKDjUA+II17T4JG21xbOf7cRCCG+nffYSZQb0XTa5eBv0ownGR5pZpfASCrMTR1FfjczKvrSA6f/MsZSSmEDNgL45KY8jjFseNikX+Hy7u4dyNcxvsTQfoO07k1guKKLvbuqDlrYteg92/3vxBNdXYwMwc6utL2p8DfVSjq9fo5IeqPxx4xFZhdmhX6HjB27n5wK04ieCoUFoZc3sfOF0CpRLiBQZ/aZYoicNgg+o1tra9PSQhFGxCcCo7r75obLzp2vstmaFDus1Av2b+6yZyf9BiOsD3gxdK5PviyM0Y6QPTdR91AsRyFaZQcR+41v8r5E+GN0G06ekzlH1D6CrjeaLEWlwNAUgDY7/AQAA///GHhDHAAAABklEQVQDAPzQRsYjf3hHAAAAAElFTkSuQmCC",
        ["dashboard.png"] = "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",
        ["logo.png"] = "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",
        ["notifications.png"] = "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",
        ["player.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAEWElEQVR4nOxaWYhOYRh+fvuWPZKQbXAhY8lkSWqUJRLJkqVwY4mQSK4kooii3FiylCgXSCFrkWyZQVkbGdsYxszIlm08r3Nk5nP++c/2nlHnPPX0/fOeb3uf855vnVqIOWoh5kgEQMyRCICYIxEAMUfsBaiDGkBFRUUDJn3JbPmTzCPzU6nUZ0SMFCIEHZ/NZCnZ2+kxeZ9cTyEOICJEIgAdb8RkDznZZRHJuzCKiFAXgM5nMTlOZnkr+TsaxlGEx1CEqgB0vh6TfLIn/OEemU0RvkIJ2rPAeqR3/hG5y+ajNHl6kWuhCLUI4NsfzOSSQxsXySV8q3lGfpkRtpNDzKrIHOa/DgVoRsBy/Ov8CToy3HReIDZyKH+eMh/ZdalAMwKeMulYyVRC9qCTJRnKtYb1STSvZC5gua5QgEoE2E50NMznMzkvYJ63TC4Y5i6ssxkUoPUJDHKw3YZ75LmsMzC0lsIplzYv5etCAVoCOL3BbLhHPwfbLShAcxAsRdWBTJa1WfzGn2co1xnWAqh+JXM5yzWHAjSnQfONNSR3Zi6G3ajqvOAqlKApwEYH20i+4WNkK/OB2OQZfw53KLcZStDeC+xgMs/hUTGsVWIBrMGtAzmMbO2QdxvDfzGUoC2AHHzcJf0uYh7A2gx9gRJUN0N2x8fAeVbIBBlDxmo6L1A/E6QDD5kMhLWr++6iiORZI2W0zwIEUR+J9WFyiOyRJouE/BQ6no+IEKkAAoogbXYiu8E6G5Q3LvO+bIAK6XwFIkTkAvxvSO4FECEY/hL68v23sPlneVtGltq8z8+gEBFBex0gDs6FtcjJIdu6LFoEa/l7jtxHQcqgBBUB7PO9leRUhIP95CYK4eVMwRVCF4DOr2CyDuF/Xt/IVRQh1H1BaALYR1YHydHQhVyyzKAQ7xECQhGAzsuAdhbWhWcmyHwvK7w35Cvb1o5sQ3aHu33DTXJEGGNDYAHsA9AzZJ9qssld317yBjv9EdXX14TJAFIuUmdVk1X2CrmsrxQBEIYA4nxumsdHyAXsZDH81S2zhmypJ6TJcpJ1B/rkAi2E2MGZSO/8fHZukl/nBSz7mpzIn4vSZBnFPkxDAPiOAPu7f0Ka5/Wytp/Ijh9HiGB742FFVG3jkdw1yFnjO/hAkAiQed7psmJ62M4LWOdRJnMcHsnx2jL4hK8IsK+9ZQRvaTw6zI5OgSLYtog71jBLFLRl2z/gEX4jQJw0nZcQnAd9yNK63LBJFLj975MqCCKAiS1BpyQ3sAfVrXDXp8z1wSMYgjIIyRtoXMn8k2zPzhUhArAPsnB6gar9/0A29Xqg4icC5JKysWG7EpXzArYl4881wywLqBx4hB8BnOb904geTm3mwiP8CNDfwXYK0cOpzQHwCD8CmP+7JweZand36cA2LzN5Zpg/wSP8CLCBvGP/fkmuQs1hNf7uKOUofRM8IjkVRsyRCICYIxEAMUciAGKORADEHLEX4BcAAAD//4ye6DoAAAAGSURBVAMAXrwe3uTe1IcAAAAASUVORK5CYII=",
        ["td-auto.png"] = "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",
        ["td-config.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAHO0lEQVR4nO1bT6hVZRD/zbnXP6GhUvqMILSIoEUklRJaLXShUAsNwaTICJcFLSytNAL7h4sEF7VoJyUuqkWBFrUIE6mMNDTBMCmLKCMTSp/v3Xcn5vqb3ng8995z7rvnmr478HHOO9+c+Wbmm5lvZs59QB/60Ic+9GH8ghRBVlXDTwDU7SoiI50urKoV0kEXaTV4ExHtlFY74UujVTb9rhBU1QFVfVtVv1HV9Z0spqoJr0tUdQ/HkjjXAV/ryZPxNtAJXy3BGFPVSaq6Ty+EDcEE89IRVZ2nqsOBzjCfSV4l+JrGQ4on43FyUWXm2bHbA7NDqlpT1cNFtK2qVV43k9Ygh8GLEafA7h8hL0NBqbdF3ltBkmctXv8A8DcAY9AWtx0Y6tDUjpNulXQ0BMS8IIFWJfBktHLzlORZiOb2F4BzF02ej7i5XCDAqRSTnSjR3znd5PnYFaDnd1d5RM0AMCFYhEHDXEXETLCIEnKZeS9oJa2E5+5a4HoOwD4AV4dFbe4WVf1SVe83JRUIPN08p8dEK2kTYGYB+BTAZgDX07zcxIQWcReAD1T1ZRGpF7SESw5Ji2zPdvldAPdZsAuBqhaGPRvhvR1H62gJl40Skqxn9Pl1ABZR+IkBvxqGR94KlfCKHUEF3aFTsODsPKShknf9aobfG/PTADzFHffAZwv9BGAHTwNziUdTJ0CFinukw8ieC8zCLPDyvnFNwSm644RCx6uOZlfLmFCMcBixH1V1dgp/ZcCrc/yqqlM4L00SIX+vFpKXFyJODh5nqOpGrldPjZ2WWRIvvyXqKIMbSGg4MLiOc5ZmVqld+/uLIEydyrg1a/GxKiBkpfeq6jHNBuPBwJK0p6PSsiBp8vyqVLQ3+J7MjdD8bBGbO+b8BZqTUY7Zm3ALAXwC4EYAwyE4+zCeLIaZ0K/xdGoamJMm652Ma/O6lIIbEwnvjejCQEsYH051WXjhutMBvMO4VAvxKQnD/xYqyKx5aTMlJOm1eN0X5r3ZsMZM1whxJ6YC2AbghhBolLn5CQbUovl9M7DdN9pPcr1aSMaMx58BHARwJOQqfpwrLcHrhFwla0VVD9KfzE8jfKeqB1T1RMrn3Jc3NfPlTmMAy+QqKz+PMzYM3uBmINAeDIHZ8e7kfOscRUej7NIQTGKEjeDEXQg7KaaTYemGAkLgmxtK55GwXjVuHO/fDHw5/Sey6CdpJt1XRGS3JTbBzyywSEbAMT+r8rpaRKxqTEroy1kxNilVOu81vkwoupspwXjZ7eKE92fmDoIyqoRnATxD4V1zMeB4PfADgCUispcBsuMGZwsYDIK7YDdR0Z4VeoJ0M+c1XM8WXlFHzc/aVdtpTtEd/mQyMiOPf3XoAl6YTUklPe4GK1P4s+ka6VixLA+PrZiuUODo818HvLaExxAE3be3h/VdEXb/lrXUVPVVCu/B2ZVwkun9RdlptR3T9DGzhMYup8Aic5W9+DLMHilT3gLgofDchLH1H8/Al1DIvS4ip+nWF/CZ5FmdASZLQDvsvSwuDbzPICLfWmJDoUc4NFWie5xw4T83xaU+xPwHCS4TCIF5C08nb6i6Ffjw4GzCfwbgQVdM1smU9FoQ7kRmH6JdHPE+A0+nBwB8FRozDfIcvwB4HsBiEfmd72ZaaYIeAYNPo98A4J8MlDOcy0yiMtzhQxGZD+Aj7rj3Bex+uYi8xPrBe5u4ZApQMiEiFrFXAdiYKmLsfrXNGY7htlGCWYJ3qexbRRoG3dLaJWQJeiS8ql6rqu+xozQ/VbDY1b7m7DAcw22nBJ5O3pJLg0d77WV/vqnZq6r1Fz4GMI+m6kI7g35vUXo5gDmquog72dR/qaSsudynUoJywUzQhNpK4YeC0n33XRng3BBxt3p+XyqDKAm8JuCHyrU8sycG3z8D4ADHmRALJhJ3bS86zElZhANtz9zcxG237avyPBFpDO744VBtaurdy1IBdV7vTj1vdHZE5CibHFbKHmW3J+27/m63Oks9VYDyek1qPesX7KdZN9JZ3u/nXOTJ3y0t1U5QPsQ63ASxbwYDwd89LgxwLgpbvIb/H8aAQ0GoOgXexMToHIfNb+JcbLAeKpvPKsqH9wE8lvoFx8Oqeh2APcS5x/J2zlVC+83eLRWqZREOx9cuANY4uSPVzl7Mka7hHcfe2VVii60BpccA9gvWsKdXDUWLf1a34QK68Ia7xj+AlglJmcRZudkOmi+v4Ben+Fm9mlHXG84Ke4fvlnYE9soCvHw1V1gAYCfL4RjtlVWdzS0wXP8WWDZ/CXrbzTkuIqv42wP/iFnj/TabM5ys3l0r8r0KgvWxJCShhjeBf8tAOcugaZmhFUR5odYrC5jKjyARiirE+nKmyFkZLuD+ntfs/f1pY+EpKWBiM/kzufjjKO/KFIU54cjzM7+oO7qgc0N32Gl1N3XW8fxjaYNx/3P5K/kfJqQDwuPzX2b60Ic+9KEPuPLgX2wxfZ3zMdj7AAAAAElFTkSuQmCC",
        ["td-game.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAE+0lEQVR4nO1bz6scRRD+anZ8IT5/PUEERcWDGIkGc/Ei3sSzoBjIH+BBMPeAIIIgeNRL/gbFW/DkNRcvRiP4AyRIMJCIRkXF+Ha3pHa/Svp1enZmdme2N+58MMy+marq6urq7qrqecCAAQMGDNheSBMiVR0BmJK+jkd5FSIy2QT+bFBVsSsXfxNInQIipoOeBvAagMsA/qqRuQvgIQAfich7lJON3/uAttC5280a1+XxBq9c/KfDvrTyAL05+t8AeIJzsOD8WgQJaC/wfjQT/3cicnSRF5Q1gozpIoAjfBZaUhcYVKjAnwB+BXAsE/+/qEG54J0L+72iwSaL0zjgRwZ+WcUAKRql0BPmXoFL2nUPgLO8u7Ek4Nc18vsUQBcG0MSz8yLy/QEi1UMcsSYjsC7+TgyQwq6qFtEI3JVQeB/A9Yz8vRlgKiJT1ZlzKHeLMOpyRY5xB4kXsD74ze2xLgOkUCQ68ED0zEdLe+BfCkUHMlzZRwHsBTE7qGg4Mr6IlR3yZzeAMl6/zC2riJT2zvjKbDSXyKMd8Oc1gMwjLIu0rgI4CeBKIDfM3gq+OykiP5NHV+VfVf8SHYALkin0qapa2PpIReB0SUR+Ie20K/4cBhgFyZJ47m1bkykIwK4kSHOL8lzJG/OHNQJuiZUJTx8G+C0qNkx8VGiQqv1YF41cU3625e3P90LVa8usCWUDmlCoK3aGDT7M9++IyGfB6C49NzmvtYEHvAjgber0E4BDDIZCPZeH3nTxj5lb7y/Iu+3dcVZwuthZqnQq2MbxGn3MIw1fkK/SIMWC9txVn0wkFxPG3VOGquZJL3P0ejMA1xpr4xW2eT3QZRx5jum2UysQ9e++jfZma2REBXzxiQOWvnGRbZaBLuF09gH7OupLOw/Queu8CeBc0EDKnXotXCZwrUaPkjqfYh+mrRdBmW9LttpeUdUXADxDenO5lwC8v+ZRr9J7Qi84w2vE6XAh6IMutQvIQQFf+XNVfcx/Ig808duCpC8PEDWoCJd1LbkRgiTErHsYm4cd7kCuo4fZqwdCwr3Zcm7uwa1cPwpumlR1Z3QtY30PkmY65qgHJBG4YdPO3KBb+lCjBco+hYcdUNVnAVgW93cN251WCBGR800WsY01gDL6UtUHAXwC4Hkea9XV6ndY8zvHgOdqn0Yo0R88Q/yQnR/z3M6uOozJ84GInGBYPrndDDDl/UjiWMsTprCq46c5CCLPpyNZnaPoS3Ag2w8wwvP9USKMHSUqQLVHW6ui7LuBitEzo/wTPTMDPBUVNuT/YAAJfrvbvyoinqjMX6jeDeDHoDLcp3eu1QBVJTWf8x4j3IEMKJAJQXDkEZ9ulQE2BQW2HAW2HAW2HAW2HGWHsvyjxvi+kNb+4Dl/kjaQdQvfphlgwu3MvuqAf65i+WyCdp+0NxIcq/Mn6OItckajqq0/henaAJJ4ZinsXlCS8gzOTmxi3E/aMBC6LyG3JJ0nTS7bPoTKaoBxQsYpAK8naHcTbZ1NpLfWyXsjWssNfkjI9AMPrwCv3QB7icjtcItiadMRHLGtOui6DfA4R2wcFTvDHD+8x66dCn2b0KVkToJTqtaQNsQsO5sCVt/7PGMyFcMG4jn7fpBfjjQuoEjblqLj6bfozp1uTU1V4fUHgHej4/meW9Z+/4lhnTrJCg36qXCu4zHHzPuy/3vMgAEDBgzA7Yf/AOYSypyJsVH7AAAAAElFTkSuQmCC",
        ["td-lobby.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAE50lEQVR4nO1bTagcRRD+anY04SUqGhMFRfTmH0bwIkQFIRchkEOeCN7Em4gexLMX8ZIc/Ll4yVEkBi+KgphbFH8QjCEIQRAFQfxBnogSk539pDdVeWUzszuzM7Mzb+d9sPS8ft3VVdX1N927wDa2MWhIVwuTDGuP9M9MRIihgJeFn9u3DMiyFySZiMiE5HUAntbu4yLyp/0PqwqSo7DTJHeT/JqbCM/X2hisIqiCkUxJfqCC/0vyoj5/QXKfjcGKCr+P5Mcq8CVnAfZ8juQ9K6UEqiAkbyf5TSTwWD++7xeSD/q5WxYkr9J2P8mfI0EzZwETp5CACyQPeRpbeecPkdyIBLT2OMmXnUImrg1jnvXBE1sBvBzlzeefckHOBDMLeNXNec5Zgo0zq3jJ0ZWtJPwLTigvWMDzLiOYmxx2yho7Kwh4I9QISj9BH0FlUJ9fc/5uwlMFfDLO985dHtEg6N3ElPIeyR3x3D7m+JM5kT7gd5KP2bgcGqaE+0iej2hY+1nvagXOzvHW/hQEmxfVnRICra8KaPWnVuDsHG+mG/pvKcuwU+gayfcjWv2pFTg7x1v7Ick9XrCStBNbg+SbkSt1XyuwXI5/yympcuT2aY/kK72oFVgxx9dNWzo/7UWtwMVyfCPMdF4rsEaOb5CHbmoFzs7xWZkc3xQKaoWstVqB/8/LcY6fVMnxTaGgVsgarxW4ufN5Od58/juSt9ZaqB5va6oE74r1awVu+vuBnBzvNf65Z2iZcEr4MuIprhUO67ikahFyLOegIlbAWR8glwkX8T+awaPxf8zLVkar6xERb2JeAWd0fBcKMF7fzrFQ49mnyXU/z5BEdE2QB8JYABcBTLQ/jO3jmX3s38av6PMllSXIFCCzFDDR3TwBYAxgp15fBUU8A+A3t0hfEF+pBb5fBPC38r5T+06obJOyMeAgydMkPyH5qPZtRObWBxd4x/FkPn8byYeV9yDDQS+bRxp36LWViMgpAKfcgnsX3XlVkClp3iXolXE1LkxvFJHTAB7yPORdu6W5HEgIrlMNe38KZlQZunAQpKwwzJlbFZnutpl8uHPM8gamRRRsAkmzispceAFI3q8x5J8509YA7BWRM7oRCylBeU50bq7wAW3W7VZM3QTgXQAHNDCFgDoLVwPYRfJTAEcA/FrDEuYiRXuYml14TVXhgwvt0s88jHXO6yLyhLpj4S72VQETbe80P3T+PdFncX1Wa8DVHPdGtBpH0hZhR/u8E8gC6kiVb609+2yRlHCX2kjbXqBg94JSLkR9QQF3ue8NBcgqKEDcs5n9uoic84NIXgPgRwDXO5dpHSm6gZ3gWlwIn06uwRN0BFccWcXXydfkEgwcCQaOBANHgoEjwcCRYOBIMHAkGDjSmvPt+np6clFQ7eXV8yOdN60Ede6oQfpLU8BYRIqOyqb94eY2538b8TySf+Sd8C5Iv3UFiLZ7SD4evdcb7BX4jmhOwBGSP0TvArsB7GiIfmVBCmHHUfoDh+8B3ODe6voG42u/iJwt8wOMtARR0/7NukteeJY4rbHTWY+i4604DixCvyie1HYB6oFl5k53yqDKWd4iR++Z4y9R4f9Ck+DmbdFR9h9HPc/zIBWUYLEgBKW7exYHjJdvReRka8fo7PvX1RfgURZYwE5v+4iw9a3cH2xjG1hN/AfRFs6qIJvzswAAAABJRU5ErkJggg==",
        ["td-play.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAADgElEQVR4nO2bv2tUQRDHZ99dsEghKVQsTRHFtBqwEvu0gsHeQqzyD2gpBLGwSi+x08JGEMVKiJVKQAjGSgQRJWBAjbn3kZVdHNa9dz/yctm9ewP3A968PeY737c739k9kcYaa6yxxhqbWDN1Dwi03LilMaaUSTLARMCYDAYAxhgDcFlE5kXkkTHmjQPFjDUbgMJ9rvDPfgDLyqctYx78nAt8D9hVQDwD5r2v9x9HAE4Dv4DSBW4/f7vvO8CNsWQDbuIDjgJfVfAoRnh7DMw6/1Y4aeYOwAzwLQCgVC8PhPW5NjZsoBoAb50IGx4AJ7NnA9UAfFcTop8PNBs+AUs51Q39AuCDfQWcA9ZV8DE23Lf3Z8kGqgF4665NAbdU0DE2vAcWs2MD1QC8dmu/97kIbPRgw6pdUZx/O3k20AMAd63wsz0wDdxRAXvfjgLkHXBJ/UaROwAmpLUNENiKBO/vxQE1nTQbGAAA/12xYcZRPsYGv5LYR+ZCsmxgQADUfZoNi8AHNR+UwTi7bhKdSq54YkgAImw4DqwpNviJ0T8auOX0vLq3yBqALmxYcgVSNzb8TEpmUwMA3scDYUtk4GGEDXvJyWxqAiCWUSuagjHL5GQ2NQPg/VWfYdbJ6Co2aJldZA9AFzYsu4zr4KMye6QgcIAAhM+3feaB5yrzISusrfj76ovyEAFQv9NWgFwHtoOCqaOAmPO+vcYtJB/Dvrn2+qaI7AbXjfcZxApJ3HyxZIzp+NJZRJ6KyDEX9N9dKPeyLLlrjNm02R/JXgQHOwmG5bIWT2GB5MVTS0vwnJfB1gDyecPL55ErRuovhELJvNFDMt/TkvlgohwRAGqmty2025Gs63V/K4kWGvWIId02W+jSRNVZX02mico+AVBZbznN36uNfiWpxinDN0R01m2F90JlONYsXUtyI4UhAKio8WNZt2NeTSrr+2iKFoHKs5q+X5WXTtaHAWBAnb8dbKCmlfUBN0Z03+9UH9resuJMNgcq6GNrTPX6PgdZ1747SfX6agLArucn+uj2vlT9vTS6vfsEwAf3BfjYo99/M8l+f80HJHTWS7V1vqDGySfrAx6R6bbndyTpPb8aD0lFZWvyy1sNx+QqZWvWWe/zoGSZlGw9hKOyacnWER+WPisiT4wx6+5ayzY1ZdyN/1Xf6JqTCf5hgonIemONNdZYY41JtvYHVm5WyG4/bPwAAAAASUVORK5CYII=",
        ["td-shop.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAEz0lEQVR4nO1bz6scRRD+anY0iD+THOJBTY7BBFRM0ChBg3gIKgRBvCpec1RPgpfc8kd4Nzl4UIgHH0bRKDxI8BARBCF40IOJEMTgezuf1EsVFuvOvpntmTe9m/1gmLc93dXV3dVfd1X3A1ZY4Y6G1H0gqd9GM8pWIlJhGcHbjW+Sr8CCQ6Y1XkRI8kEA71ieawC0sTriDwB4FMAnInLF82MZQFLs2UPyMmfjFsmXLP+sqbI4IFna+11r5N8kN0huhmfDGq/4ftGnQtEwn5q4m7l20t32+3GSDysZNuWNZZoCY3u/YmUXchqU8YeRn5LadZIvAngLwENmKTrizwF42ciwsvQXAHw2a0nNGTItsY7ZSR4D8K01Xr/rqH8H4Hn7O/fVQBs2bpaTW1OhtOcue+8leX1iCtwkeT8WBJNcJS0KFkZ2awBOABjbFFAZZwD8EPYKuUDMKlWvgwB+FJGPo4WXLYR54y5aBzB04AdYEJA8KiLv+YBKi4IjnT8ktfFrgQQVzebVsHB9lasOishP2gltLMBN+wqAGwB2BysYhZUhJxRhkJyk/4kZyqaSbIlUs7lBUjvhhDV4NKWyHDE2Xb/x0ReRqo0F1PGAm9Z62A8MbQmu56sAjoRlW3F+Ik9z+G5PeSAsheofKL5AZiC5brqpjpX5No/Zty1rbWsB03jA046RfATAb2H5GQIjM/ejAJ4OeqhOl0Tkmps/2nZADQ/4NLgHwBMi8quvGBgAJFVPHfHXLCnq8T/zL+aow8tc9DqDFahfgIH9Ap2WOrCngi5qFbcAfGpp83MUZ/PAJfs2yGoQdDtic76y+IVibZpuxRz1TPKAb4cVh0nuGzA+4HW+bn/XmX8aaL2ovRpYdvD4QHDgrm7H/kjsjSI3HjDiVT2eNMfHo1hT2T+1A2jvr4Icb/Bxe1dLaf4Kn98kd9fEB/bFfLma/9LwwDzs7ygS6s2JB3bO/HPcD+y4+efEAynmr5i7V6JfYJuiOA3uMzc0qY6mqqSYf5FYeQ48kLT3LxMrn7Yf8LTjZnpb8xP9wL26p9psfiLKRAVmxQcOA7hXRG6iZ5A8ZY3eDMmNIj9lSsUz4gM0HnifZJ/nBR54eTP8LjpzfVseqX9ozOsMPAQ2m7K/o+yiD+z9dTiFcexUVMh9Ebe+xoHPsoPKvYJfQkR4Y4e9wXHofK338wnd+gX/8wvOcnicjTptB+mwE/xy1Rt6c2Ti7LBveF1XReTcYBe3mME1mbY6SA8K6C5Msr8AscJtCHqAEZA+PhqjLq/W9i0/CbOiQF1EiLqWL6kK1VyjUefkbQDP2Ce9UPmRiFzezjkZUn5Xe4HTNdthTTsd8+Ykv6uozElTxqMy8XqtpilOxjI5yE+G9rjF5dZNEXdKIjxOt255i1zkJyGY5gG7RO1xOcVf9vioVZbnQCw7pPwC3WEPgF2ut71/tiem7bK8uclPjg7rLdI/J0YowtM1z95Ydkj5BRJhDpAeTP4B4IItreoOb+kQRsZd5AuaNxxmDiq/EwSS2k/y90BKG4Gtad/2J5BgL/I7QSCrQ3oyNMVENe1QzJuDfGmryHZKhtsh+v8Gz9onvVL/ZQiiVjnK7wSzer8Ls+xavqQqVKOIh6clnhh1RUp9y19hBdw5+Bfq9/K7lxAfzAAAAABJRU5ErkJggg==",
        ["td-webhook.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAADrElEQVR4nO2av2sUQRTHv2/uECHgrz/AwjaFQlRUsFDsJIVFLKOomM5AOitBUGyChV1AsbaxURExWlloJdgJCgqSzihKEHN3X3mXNzJsbi+7t3t7d7n5wDC3uzN779e8md0dIBKJRCKRSCQSGUsk7QJJvVbD9qApIszcmhvKbyvSdJJODdVaJHcDuGxtvlqd3YqDxcu63+r7IvLT65Zs2MlKewEsAziE7cF7AGcAfNeD0Aj1RMOaiDRIXjLl/1ibUR0SqmjTdJkVkbskVZ9GmgHCji27nmzTsjKMOCtJWhbVm6in3OiL3Yg5/mSYcaHXsxhg0urQALSh8BrAUwAT1r8ZDJGqkmT4fzWrfwA4AeCcKZwctpLHAN9SOmkoHQTwUkRuYoggeQHA0bz5qp5yvp0tE4iVfQBukZwFcE1EXpCsBdFQBe0hKCJ/SapD7gE4Wfiu3MiQWp/XhQBJnRE8TSvKenB+keSE79/vRZSX0X4vkPwdyNSyEsrtZb2R7I8uyaxb8lMv1204aLsFAG9JntIp1BZRpS+hSTpbyKhykyR1nbJouSiUKdcS3mVo46e85wA+2M39ObHsqknzlY8GEWmWGQ16LxFpmXHbBgdw2v6bgWNUthUAj3zXMg2wDOCYLiuDaGj0Mxp68PozAFMAHiRkL2QAzy4RWRORKwCmAXwKBCg9GnJ6fRXAnIicFZEVS9SZcDlkUkVUmp0i8gTAEQBLZUdDD15XWQ6LyBLJHWboRj8MAHuIUMH0mWFVRObKjIYevT4tIp8tu7f75tHJ5WkcGMJHQ62MaCjode3rtG8vurheOpkRaIYoGg2FvG59e344c712LDEaKvd6qQYoGA23Sc4DeFel17M8CxSKBlVAo4HkGwB3AFy1JmE0qJLXg+7e615x7/V5U9yv/wt7PcShZHJEA0zZZtVeD3HoExlzg/d038d6Gg59JEM0eCr1eohDBXSJhoaVx3quKq/3LQl2w1Zo/6NBva1rArv2UWu7VtVLlTaVGaDDTCGB4j7DV6r8QAwQRAMDxQf2mr2OATJIxT0OY47DmFPP0Vanp/anMnJoPxJ72Vw/DLBmc3Ml83OPtGUj+auoAaTD7ymSM7Zqq3y6yoiX7bgdb7mnoZ5yPvSyf3MzY2WU0KHgZxrmMcCB4AWGJ3k8zLQfyYNj/6k/Vw5wANYxmvj9DeF7Bl1+b0LGfYuMbLFJ6iKAPRhtdN/Aw7RNUh0Z621ynrHeKBmJRCKRSCQSiWDb8w8yLP3D+7nN3AAAAABJRU5ErkJggg==",
        ["toast-check.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAACiUlEQVR4nOyaPWtUQRSG3w2Cioiign9AkWAjYhorP7Cy8T+ItXsrNRYKilpYJGnS5Q+kCvmAJISkSZpAIGXIH0gVAmlSZfMecjdcNtk799zPuZx54HCWndkw7zvnzk5mdgTGGYFxggEwTjAAxgkGwDjBABgnGADjBANgnGAAjHMNLafX631gesRY7XQ6u1DSQUuh8JtMs4z3ibc/0oQZKGilARR/nWmJ8Wag6ZQxRhN2kJHWrQEp4gXR8wsKWrUGOMT3uQEFrakAihdhi0gXL0xBQSsqIBa/wHjr6PqZz/8cFHhvQFz2WWa+S/Gq2Re8NiDjMy+I+EnkwFsD6hAveGlAXeIF7wyoU7zglQF1ixdy7wM42BeMOyiJeG+fRXxUlnhBbQAH+pxxwJfbjEO+7qIg8czL93yWmZ9Aiaj+GeJAHzLtM24PNP3jwL4hB02UfRJtBfzHZfHCVwr5DSWK7W1UhXhBa8BoStt3CvqBjCi2t1HZZZ9Ea8Cyo/0nhY07+iRnvlHxgnYNkIHLYcOoo+s4B/53yN+Q1T7Lgle5eEFVARzQCdMrxp6j6x8K/TL4ZpOr/TByHYlRyH2mTcYTR9eLlbvp1X4Yuc8EKegB0wbjqaNrxJiGh+KFQoeiNOEe0xrjmaOr7B0eO/pEdZV9ksKnwjThLtM63CakUfvM9yl8JsiBHzG9xvm3Qx6ipsQLpd0LsBJkhyiPw5jiY90mxQulnQpTyDHONzZbGT8SNS1eKP1miJVwi2mF8TKlW+Mz36eSq7F4xyiPw1UmeCNeqORiJN4xvmPMDzR98km8UPnlaNHr66pp7fV4WYSfyMA4wQAYJxgA4wQDYJxgAIwTDIBxggEwjnkDzgAAAP//WGPpVgAAAAZJREFUAwAtLNGVzSswnAAAAABJRU5ErkJggg==",
        ["toast-x.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAADD0lEQVR4nOyaT2sUMRjGny0i1YN404Pg2T+gKAiiCEXabrdlT34JP0DBm6CgN/HqZ/Bi1V3X4h8QRRAR0ZMfQPGmgtjiodvnZTMwnbZJdt5k2pL84CWwk8mb55kkk5nZCSTOBBInG4DEyQYgcbIBSJxsABInG4DEyQYgcbIBCMBwOFxkPGXcYxxHJKRtxn2TaxEBaEEBOzHJ4j3jbOnnVca1VqvVQ0CYa4HFQ8Zk6edPzHMeCrQj4CY2ihekg3KFOgiEaesJNooXzvHYLSjQGtC2HOuxc3NQYsT3avbBidaAz47jfY0JPHcedvE+fbCiXQOOsvjGOGSp9p/R5Vx9jvHanmXxmLHfUu0X4yTb/omaqEaASSxXacVSTQQMKMh7qJpRM4BdvOTsasQL6tsgO/CWxTTjn6PqEoVNOeoUV/6Ro5rkmja5VQTZB7Aj71jMwG6CXM2+zQTPYS85ZkxONao1oAoFXGKxzDhoqSb7hA4FvK6c27h4IagBQh0TzKhwzfng4oXgBggUdJmFrPouE2QBHTL62LzJKRNFvBDFAIEmXMHoqh6ADlnt2xT/BhGIZoBgpsML2K+ujWhXviDq47DpuGxlVzE+0cULUUdAgVnkXPO8TCPihUZeiJjV3rVjLJA6c02IF/ahOXxH2280NDKBPAXiG1BDfMHeXwQV4guim7DTG6EV0wfXLnA2xJPfVuyWrfCOPAcIwW+DZvfnI14ehl6ZW2QXozdH2yFtLZu2g5IfhxEIjfhSG74mTLGNDwhAqC9DavGCeXHqMx1eMucFBEA9AjzFi6C2TXylTZ+R8JdxVTsStK/Fj7H4yjjsqCp7+wHGa9v1QUSQbfNptv0dNdFOgbuIIF7gObKBmndUk9y3oUBrwAnH8VriCzxNcPXBitYA29eejkZ8gTFhAfX64G4fCszn8Y+MU5VDIv4ZAsJccndYqvz8hXnOQEGIu4DMwweMI4w1xo1Q9+gtcl1kcQejfv9gXGeuP1DQ2IuH3Ur+jxASJxuAxMkGIHGyAUicbAASJxuAxMkGIHHWAQAA///WxAkeAAAABklEQVQDACZWOfjm6D4aAAAAAElFTkSuQmCC",
        ["window.png"] = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAFjklEQVR4nOybXWgcVRTHTzZFNsmK9EWJVdtt7YMKvvdBBLGKaYzaqrQWAoJF8QO1rdEqqKCkQqsVaRWsVurHQ0FELWoFP9BiBd8ERRBpYh9Coe1LSbKz2d2kv5POls3mzsednd2ZsPuH4c7ce/bu/f/POffeuZtkpM2RkTZHRwBpc3QEkDZHRwBpc6RWgGKxeNP09PQzjuOskSYilQJMTk6OlMvlv+bm5vZVKpX/pqamHpUmoUtSBsg/39XV9YahaVtfX98HEjNSJYAP+SpiFyE1KQD5FwLIKw4yLzwlMSIVArjkd4exZV54BxGelpiQuACQ3+VFHrJHPOrfRoRnJQYkKoB6EvKjhiY4zg3ncrnN3D8pZoO3WB2ekAaRmAB4fqd60tRG/flMJlPQeya9A4i03aOb/dqPNIBEVgEdNKT2BNlhs6m3t/cLvdeQV6+b7KgfIVoC+zN+h7QYGvZenjegzLWRKDiqD27I7zcZItZOxHpTLNHSFID8Dh/yRw11y7i+hvjd+qDpQGHMe/rdq6uJWKJlArie32toquC9zZAb8mhXfA65O/UGu3cptpmMdDVRkcUCLUkBn7CvcN0PqS+rFRDdo+FssJ2hjyFy/Xt9ICoeoThosLNKh6ZHAOS3e4U9A91SS14BwecoTPuCy7A/hkB36IO7JX7c1K+bDrskBJoaAT6e18ntgXrytfCJBIclcqCnp+dnfXAj4X1ZzGUWu9XY/S8+aFoE6Lu8j+cf9COvcCPhdUNTdnZ29ptCoXCbPriRcMBgl8FuqwSgKREQ4Pl7GPS3EhJ4+BWKVw1NDkKuh+Rayg/FEAHU55kLTvl0H78Aruf3eTQPVdd0G7jvC6Yts8OV9fjYy3zXaxKAWAXw8XyJ614bzxv63uGzTC6Avlbj+dZOgn7ku7u7B7LZ7A/SIMKIYEN+3l5igF/YU38XE9oxiQnMCYcphj2aR4myl8QCDQvAgB6jeM/QVMTzg3F4vgqEfghBPxHD6mXr+SoaWgYZkL6rm8jrWr0hTvJMhMOQ/0zMYx6NQl4ROQIY0MOofsjUBvnb2YD8KDFByfNdhz2adxP2L0pERBIAT+QI/QkGdXldU0E9X92lxYEA8tY5X49IKcAu7GYDecUE4vwrMYHv2dpM8oqoc0C/R/0aBPiFuWGFNAglzy7vU4/mWMgrogqwyqdNRfiNFLlaIkJne8h/bGrTvUZc5BWRBGAQKwNMtP1EFBH8ljolz54iluPwKqJGQJAAVZsTELpOQqLV5EWiC7CIFAM0zfwrNR3I57wEQHPea53XE+RmkBeJKQV4Pkte6pmdact7Dfl83C8SgnKeTc6INAnWAjCgLB5ZXlvH8ymuEgPVg82fDB9bQb0xHZII+1pYCzAzM3O9oXr+2ElFIBIG/ESoTQfIb0qSvEgEAcrl8qIJkMFeOndDhCIibPASoVKp/O44zmqX/BFJkLximdhjURiz/R2vfUYEBxKDLIPfcX9rXdtViPAntzlT5/rzF+StzvYbgXUEQMA3AmrsCm46/GroJhXkFdYRwGy9CnIL6hj4ckJ6I7d57vPVkro8ttkw/SZBXmEtAISuNdQdgkB9nYRFUuQVUeaAwE2NDdwJLxHyiigboX6JCXqM1arZ3gvWEYDHjjPwW0Kan8R+DPsxypOsFnp/2u1nmo3TH5IwrE+EmNjWMXj95XUd14RcJDkOsfmSg9Ax6saCfpNLC1L3l6KthlUKsINbyyZmPbdXSgpBFJ6j+Cro98AFnwlrWCwWb2Qb/LcsATDX5EnB8VC2EhKlUmlQlgiYi+4LaxtaAFR1ZOmgFNYwdArwYtOPsv+QZ1dIisEYz/EOcgPjPBPG3moV0MMQhNhieiFKA/SljI3VRzafaftlsPNPU9Lm6AggbY4LAAAA//8UKKzGAAAABklEQVQDAHqg9sHFHcLrAAAAAElFTkSuQmCC",
    }
    local function luaDecode(data)
        local map, out, bits, count = {}, {}, 0, 0
        local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        for i = 1, 64 do map[chars:byte(i)] = i - 1 end
        for i = 1, #data do
            local v = map[data:byte(i)]
            if v then
                bits, count = bits * 64 + v, count + 6
                if count >= 8 then
                    count = count - 8
                    out[#out + 1] = string.char(math.floor(bits / 2 ^ count) % 256)
                    bits = bits % 2 ^ count
                end
            end
        end
        return table.concat(out)
    end
    local function decode(data)
        local native = type(crypt) == "table" and (crypt.base64decode or (type(crypt.base64) == "table" and crypt.base64.decode))
        if type(native) == "function" then
            local ok, bytes = pcall(native, data)
            if ok and type(bytes) == "string" and #bytes > 0 then return bytes end
        end
        return luaDecode(data)
    end
    if type(writefile) == "function" and type(isfile) == "function" and type(isfolder) == "function" and type(makefolder) == "function" then
        pcall(function()
            local path = ""
            for part in (folder .. "/"):gmatch("([^/]+)/") do
                path = path == "" and part or (path .. "/" .. part)
                if not isfolder(path) then makefolder(path) end
            end
            local stampFile = folder .. "/.build"
            local fresh = not (isfile(stampFile) and readfile(stampFile) == stamp)
            for file, data in pairs(assets) do
                local target = folder .. "/" .. file
                if fresh or not isfile(target) then writefile(target, decode(data)) end
            end
            writefile(stampFile, stamp)
        end)
    end
end


local UI = (function()
-- GogHubUI
-- GogHub Studio: a composed, modern Roblox interface.
-- Load: local GogHubUI = assert(loadfile("GogHubUI/GogHubUI.lua"))()

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local GogHubUI = {
	Version = "2.0.0",
	Flags = {},
	Windows = {},
}

local DEFAULT_THEME = {
	Background = Color3.fromRGB(12, 17, 24),
	Panel = Color3.fromRGB(15, 21, 29),
	Sidebar = Color3.fromRGB(12, 17, 24),
	Card = Color3.fromRGB(21, 28, 37),
	Surface = Color3.fromRGB(29, 38, 49),
	SurfaceHover = Color3.fromRGB(38, 49, 62),
	Border = Color3.fromRGB(40, 51, 64),
	Accent = Color3.fromRGB(155, 227, 201),
	AccentHover = Color3.fromRGB(181, 239, 218),
	AccentSoft = Color3.fromRGB(30, 53, 49),
	Warning = Color3.fromRGB(225, 191, 126),
	Text = Color3.fromRGB(233, 239, 245),
	Muted = Color3.fromRGB(147, 162, 180),
	Success = Color3.fromRGB(155, 227, 201),
	Danger = Color3.fromRGB(237, 139, 148),
}

-- Choose readable foreground text for arbitrary live accent colors.
local function onAccent(color)
	local luminance = color.R * 0.299 + color.G * 0.587 + color.B * 0.114
	return luminance > 0.6 and Color3.fromRGB(12, 24, 22) or Color3.new(1, 1, 1)
end

local function merge(base, custom)
	local result = {}
	for key, value in pairs(base) do result[key] = value end
	if typeof(custom) == "table" then
		for key, value in pairs(custom) do result[key] = value end
	end
	return result
end

local function create(className, properties)
	local object = Instance.new(className)
	local parent
	for key, value in pairs(properties or {}) do
		if key == "Parent" then
			parent = value
		else
			object[key] = value
		end
	end
	object.Parent = parent
	return object
end

local function corner(parent, radius)
	return create("UICorner", {
		CornerRadius = UDim.new(0, radius or 8),
		Parent = parent,
	})
end

local function stroke(parent, color, thickness, transparency)
	return create("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = parent,
	})
end

local function padding(parent, top, right, bottom, left)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, top or 0),
		PaddingRight = UDim.new(0, right or top or 0),
		PaddingBottom = UDim.new(0, bottom or top or 0),
		PaddingLeft = UDim.new(0, left or right or top or 0),
		Parent = parent,
	})
end

local function list(parent, gap)
	return create("UIListLayout", {
		Padding = UDim.new(0, gap or 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = parent,
	})
end

local function tween(object, properties, duration)
	if not object or object.Parent == nil then return end
	local animation = TweenService:Create(
		object,
		TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		properties
	)
	animation:Play()
	return animation
end

local function text(parent, value, size, color, font, alignment)
	return create("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = font or Enum.Font.Gotham,
		Text = tostring(value or ""),
		TextColor3 = color,
		TextSize = size or 13,
		TextXAlignment = alignment or Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = parent,
	})
end

local function getParent()
	local parent = game:GetService("CoreGui")
	pcall(function()
		if gethui then
			local hidden = gethui()
			if typeof(hidden) == "Instance" then parent = hidden end
		end
	end)
	return parent
end

local function resolveFileAsset(paths)
	if not getcustomasset or not isfile then return nil end
	for _, path in ipairs(paths) do
		local ok, exists = pcall(isfile, path)
		if ok and exists then
			local loaded, asset = pcall(getcustomasset, path)
			if loaded then return asset end
		end
	end
	return nil
end

local function resolveLogo(options)
	if typeof(options.Logo) == "string" and options.Logo ~= "" then return options.Logo end
	return resolveFileAsset({
		"GogHub/AnimeTD/Assets/logo.png",
		"GogHubUI/assets/logo.png",
		"scripts/upload/GogHub/AnimeTD/Assets/logo.png",
	})
end

local function resolveTabIcon(icon)
	if typeof(icon) ~= "string" or icon == "" then return nil end
	if string.find(icon, "rbxasset", 1, true) or string.find(icon, "http", 1, true) then return icon end
	local name = string.lower(icon):gsub("[^%w%-_]", "")
	return resolveFileAsset({
		"GogHub/AnimeTD/Assets/" .. name .. ".png",
		"GogHubUI/assets/" .. name .. ".png",
		"scripts/upload/GogHub/AnimeTD/Assets/" .. name .. ".png",
	})
end

function GogHubUI:CreateWindow(options)
	options = merge({
		Name = "GogHubUI",
		Title = "goghub",
		Subtitle = "Roblox tools, homemade.",
		Eyebrow = "WORKSPACE / GOGHUB",
		Size = Vector2.new(1020, 700),
		ToggleKey = Enum.KeyCode.RightShift,
		Theme = {},
		User = "User",
		Status = "Ready",
		StatusPill = "0 tasks active",
		Logo = nil,
	}, options)

	local theme = merge(DEFAULT_THEME, options.Theme)
	local connections = {}
	local tabs = {}
	local accentUpdaters = {}
	local activeToasts = {}
	local toggleKey = typeof(options.ToggleKey) == "EnumItem" and options.ToggleKey or Enum.KeyCode.RightShift
	local capturingKeybind = false
	local activeTab
	local collapsed = false
	local minimized = false
	local destroyed = false
	local animationRevision = 0

	local function connect(signal, callback)
		local connection = signal:Connect(callback)
		table.insert(connections, connection)
		return connection
	end

	local function registerAccentUpdater(callback)
		table.insert(accentUpdaters, callback)
		callback()
	end

	local parent = getParent()
	local previousWindow = self.Windows[options.Name]
	if previousWindow then previousWindow:Destroy() end
	local previous = parent:FindFirstChild(options.Name)
	if previous then previous:Destroy() end

	local gui = create("ScreenGui", {
		Name = options.Name,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		Parent = parent,
	})

	local shadow = create("Frame", {
		Name = "Shadow",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 0.55,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(options.Size.X + 18, options.Size.Y + 18),
		Parent = gui,
	})
	corner(shadow, 20)

	local root = create("Frame", {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(options.Size.X, options.Size.Y),
		Parent = gui,
	})
	corner(root, 16)
	stroke(root, theme.Border, 1)

	local rootScale = create("UIScale", { Parent = root })
	local shadowScale = create("UIScale", { Parent = shadow })
	local fullWindowScale = 1
	local windowAnimating = false
	local function fitViewport()
		local viewport = gui.AbsoluteSize
		if viewport.X <= 0 or viewport.Y <= 0 then return end
		local scale = math.min(1, (viewport.X - 32) / options.Size.X, (viewport.Y - 32) / options.Size.Y)
		fullWindowScale = math.max(0.1, scale)
		if not minimized and not windowAnimating then
			rootScale.Scale = fullWindowScale
			shadowScale.Scale = fullWindowScale
			root.Position = UDim2.fromScale(0.5, 0.5)
			shadow.Position = root.Position
		end
	end
	connect(gui:GetPropertyChangedSignal("AbsoluteSize"), fitViewport)
	fitViewport()

	local titleBar = create("Frame", {
		Name = "TitleBar",
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 48),
		ZIndex = 20,
		Parent = root,
	})
	corner(titleBar, 14)
	local sidebar = create("Frame", {
		Name = "Sidebar",
		BackgroundColor3 = theme.Sidebar,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(0, 48),
		Size = UDim2.new(0, 224, 1, -96),
		Parent = root,
	})
	corner(sidebar, 12)
	sidebar.ClipsDescendants = true

	local brand = create("Frame", {
		Name = "Brand",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 224, 1, 0),
		ZIndex = 22,
		Parent = titleBar,
	})

	local logo = create("TextButton", {
		Name = "Logo",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(12, 7),
		Size = UDim2.fromOffset(34, 34),
		Text = "",
		ZIndex = 23,
		Parent = brand,
	})
	local logoAsset = resolveLogo(options)
	if logoAsset then
		local logoImage = create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = logoAsset,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 24,
			Parent = logo,
		})
		registerAccentUpdater(function() logoImage.ImageColor3 = theme.Accent end)
	else
		local logoText = text(logo, "◆", 28, theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
		logoText.Size = UDim2.fromScale(1, 1)
		logoText.ZIndex = 24
		registerAccentUpdater(function() logoText.TextColor3 = theme.Accent end)
	end

	local brandText = text(brand, options.Title, 16, theme.Text, Enum.Font.GothamBold)
	brandText.Name = "BrandText"
	brandText.Position = UDim2.fromOffset(54, 0)
	brandText.Size = UDim2.new(0, 72, 1, 0)
	brandText.ZIndex = 23

	-- Just after the "goghub" title: its left edge (54) + measured text width + a 6 px gap.
	local function arrowX()
		local width = brandText.TextBounds.X
		if width <= 0 then width = 60 end
		return 54 + math.ceil(width) + 6
	end
	local collapseButton = create("TextButton", {
		Name = "Collapse",
		AutoButtonColor = false,
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Position = UDim2.fromOffset(arrowX(), -2),
		Size = UDim2.new(0, 24, 1, 0),
		Text = "‹",
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextColor3 = theme.Muted,
		TextSize = 22,
		ZIndex = 23,
		Visible = true,
		Parent = brand,
	})
	-- TextBounds is only known once the title renders: re-place the arrow then.
	brandText:GetPropertyChangedSignal("TextBounds"):Connect(function()
		if brandText.Visible then collapseButton.Position = UDim2.fromOffset(arrowX(), -2) end
	end)
	local hideButton = create("TextButton", {
		Name = "Hide",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Warning,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		Position = UDim2.new(1, -43, 0, 24),
		Size = UDim2.fromOffset(12, 12),
		Text = "",
		TextColor3 = Color3.fromRGB(70, 50, 0),
		TextSize = 12,
		ZIndex = 23,
		Parent = titleBar,
	})
	corner(hideButton, 6)
	local closeButton = create("TextButton", {
		Name = "Close",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Danger,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Font = Enum.Font.Gotham,
		Position = UDim2.new(1, -21, 0, 24),
		Size = UDim2.fromOffset(12, 12),
		Text = "",
		ZIndex = 23,
		Parent = titleBar,
	})
	corner(closeButton, 6)

	-- Feature search: every toggle registers itself here (section:AddToggle); the title-bar box lists matches,
	-- and clicking a result flips the real toggle (same callback, so settings, configs and autosave stay in sync).
	local searchIndex = {}
	local searchBox = create("TextBox", {
		Name = "FeatureSearch",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Card,
		BorderSizePixel = 0,
		ClearTextOnFocus = false,
		Font = Enum.Font.Gotham,
		PlaceholderColor3 = theme.Muted,
		PlaceholderText = "Search features...",
		Position = UDim2.new(0.5, 70, 0.5, 0),
		Size = UDim2.fromOffset(300, 30),
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 23,
		Parent = titleBar,
	})
	corner(searchBox, 8)
	local searchStroke = stroke(searchBox, theme.Border, 1)
	padding(searchBox, 0, 10, 0, 30)
	-- Drawn magnifier (Gotham has no search glyph, so a text icon renders as an empty box).
	local searchIcon = create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(-21, 8),
		Size = UDim2.fromOffset(14, 14),
		ZIndex = 24,
		Parent = searchBox,
	})
	local lensRing = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(10, 10),
		ZIndex = 24,
		Parent = searchIcon,
	})
	corner(lensRing, 5)
	local lensStroke = stroke(lensRing, theme.Muted, 1.6)
	local lensHandle = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = theme.Muted,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(11, 11),
		Rotation = 45,
		Size = UDim2.fromOffset(5, 2),
		ZIndex = 24,
		Parent = searchIcon,
	})
	corner(lensHandle, 1)

	local searchResults = create("Frame", {
		Name = "FeatureSearchResults",
		AnchorPoint = Vector2.new(0.5, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 70, 0, 44),
		Size = UDim2.fromOffset(340, 0),
		Visible = false,
		ZIndex = 60,
		Parent = root,
	})
	corner(searchResults, 10)
	stroke(searchResults, theme.Border, 1)
	padding(searchResults, 6, 6, 6, 6)
	list(searchResults, 4)

	local SEARCH_LIMIT = 8
	local function searchScore(entry, query)
		local name = entry.Text:lower()
		if name:sub(1, #query) == query then return 3 end
		if name:find(query, 1, true) then return 2 end
		local haystack = (entry.Text .. " " .. entry.TabTitle .. " " .. entry.SectionTitle .. " " .. (entry.Description or "")):lower()
		for word in query:gmatch("%S+") do
			if not haystack:find(word, 1, true) then return 0 end
		end
		return 1
	end

	local renderSearch
	local topMatch
	local function clearResults()
		for _, child in ipairs(searchResults:GetChildren()) do
			if child:IsA("GuiObject") then child:Destroy() end
		end
	end
	local function resultRow(entry)
		local rowButton = create("TextButton", {
			AutoButtonColor = false,
			BackgroundColor3 = theme.Card,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 40),
			Text = "",
			ZIndex = 61,
			Parent = searchResults,
		})
		corner(rowButton, 8)
		local name = text(rowButton, entry.Text, 12, theme.Text, Enum.Font.GothamMedium)
		name.Position = UDim2.fromOffset(10, 3)
		name.Size = UDim2.new(1, -110, 0, 20)
		name.TextTruncate = Enum.TextTruncate.AtEnd
		name.ZIndex = 62
		local where = text(rowButton, entry.TabTitle .. "  ›  " .. entry.SectionTitle, 10, theme.Muted)
		where.Position = UDim2.fromOffset(10, 21)
		where.Size = UDim2.new(1, -110, 0, 15)
		where.TextTruncate = Enum.TextTruncate.AtEnd
		where.ZIndex = 62
		local on = entry.Control:Get()
		local pill = create("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			BackgroundColor3 = on and theme.Accent or theme.Surface,
			BorderSizePixel = 0,
			Position = UDim2.new(1, -40, 0.5, 0),
			Size = UDim2.fromOffset(34, 18),
			ZIndex = 62,
			Parent = rowButton,
		})
		corner(pill, 9)
		local knob = create("Frame", {
			BackgroundColor3 = theme.Text,
			BorderSizePixel = 0,
			Position = on and UDim2.fromOffset(18, 2) or UDim2.fromOffset(2, 2),
			Size = UDim2.fromOffset(14, 14),
			ZIndex = 63,
			Parent = pill,
		})
		corner(knob, 7)
		local go = create("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			AutoButtonColor = false,
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Position = UDim2.new(1, -6, 0.5, 0),
			Size = UDim2.fromOffset(26, 26),
			Text = "→",
			TextColor3 = theme.Muted,
			TextSize = 14,
			ZIndex = 63,
			Parent = rowButton,
		})
		connect(rowButton.MouseEnter, function() rowButton.BackgroundColor3 = theme.SurfaceHover end)
		connect(rowButton.MouseLeave, function() rowButton.BackgroundColor3 = theme.Card end)
		connect(rowButton.MouseButton1Click, function()
			entry.Control:Set(not entry.Control:Get())
			task.defer(renderSearch)      -- some toggles snap back (validation); show the real state
		end)
		connect(go.MouseButton1Click, function()
			searchResults.Visible = false
			if entry.Tab and entry.Tab.Select then entry.Tab:Select() end
		end)
		return rowButton
	end
	function renderSearch()
		clearResults()
		topMatch = nil
		local query = searchBox.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
		if query == "" then searchResults.Visible = false; return end
		local matches = {}
		for _, entry in ipairs(searchIndex) do
			if entry.Control.Instance and entry.Control.Instance.Parent then
				local score = searchScore(entry, query)
				if score > 0 then table.insert(matches, { Entry = entry, Score = score }) end
			end
		end
		table.sort(matches, function(a, b)
			if a.Score ~= b.Score then return a.Score > b.Score end
			return a.Entry.Text < b.Entry.Text
		end)
		topMatch = matches[1] and matches[1].Entry
		for i = 1, math.min(#matches, SEARCH_LIMIT) do resultRow(matches[i].Entry).LayoutOrder = i end
		if #matches == 0 then
			local none = text(searchResults, "No toggles match \"" .. searchBox.Text .. "\"", 11, theme.Muted)
			none.Size = UDim2.new(1, 0, 0, 28)
			none.ZIndex = 61
		elseif #matches > SEARCH_LIMIT then
			local more = text(searchResults, (#matches - SEARCH_LIMIT) .. " more - keep typing", 10, theme.Muted)
			more.Size = UDim2.new(1, 0, 0, 18)
			more.LayoutOrder = SEARCH_LIMIT + 1
			more.ZIndex = 61
		end
		searchResults.Visible = true
	end
	connect(searchBox:GetPropertyChangedSignal("Text"), renderSearch)
	connect(searchBox.Focused, function()
		searchStroke.Color = theme.Accent
		lensStroke.Color = theme.Accent; lensHandle.BackgroundColor3 = theme.Accent
		if searchBox.Text ~= "" then renderSearch() end
	end)
	connect(searchBox.FocusLost, function(enterPressed)
		searchStroke.Color = theme.Border
		lensStroke.Color = theme.Muted; lensHandle.BackgroundColor3 = theme.Muted
		if enterPressed and topMatch then          -- Enter flips the best match
			topMatch.Control:Set(not topMatch.Control:Get())
			task.defer(renderSearch)
		end
	end)
	-- Close the list when clicking anywhere outside it or the box.
	connect(UserInputService.InputBegan, function(input)
		if not searchResults.Visible then return end
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		local p = input.Position
		local function inside(object)
			local a, s = object.AbsolutePosition, object.AbsoluteSize
			return p.X >= a.X and p.X <= a.X + s.X and p.Y >= a.Y and p.Y <= a.Y + s.Y
		end
		if not inside(searchResults) and not inside(searchBox) then searchResults.Visible = false end
	end)
	connect(UserInputService.InputBegan, function(input)
		if input.KeyCode == Enum.KeyCode.Escape and UserInputService:GetFocusedTextBox() == searchBox then
			searchBox.Text = ""
			searchBox:ReleaseFocus()
		end
	end)

	local nav = create("ScrollingFrame", {
		Name = "Navigation",
		Active = true,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(),
		Position = UDim2.fromOffset(12, 20),
		ScrollBarThickness = 0,
		Size = UDim2.new(1, -24, 1, -100),
		Parent = sidebar,
	})
	local navList = list(nav, 6)
	navList.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local navHeading = text(nav, "WORKSPACE", 10, theme.Muted, Enum.Font.GothamMedium)
	navHeading.Name = "NavigationHeading"
	navHeading.LayoutOrder = -1000
	navHeading.Size = UDim2.new(1, -24, 0, 28)
	navHeading.Visible = false

	local profile = create("Frame", {
		Name = "Profile", BackgroundColor3 = theme.Card, BorderSizePixel = 0,
		Position = UDim2.new(0, 14, 1, -72), Size = UDim2.new(1, -28, 0, 58), Parent = sidebar,
	})
	corner(profile, 10)
	local avatar = text(profile, string.upper(string.sub(options.User, 1, 1)), 16, theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
	avatar.Position = UDim2.fromOffset(10, 12)
	avatar.Size = UDim2.fromOffset(34, 34)
	avatar.BackgroundTransparency = 0
	avatar.BackgroundColor3 = theme.Surface
	corner(avatar, 9)
	local username = text(profile, options.User, 12, theme.Text, Enum.Font.GothamMedium)
	username.Position = UDim2.fromOffset(54, 10)
	username.Size = UDim2.new(1, -62, 0, 20)
	username.TextTruncate = Enum.TextTruncate.AtEnd
	local edition = text(profile, "PERSONAL WORKSPACE", 8, theme.Muted)
	edition.Position = UDim2.fromOffset(54, 30)
	edition.Size = UDim2.new(1, -60, 0, 16)
	registerAccentUpdater(function() avatar.TextColor3 = theme.Accent end)

	local footer = create("Frame", {
		Name = "Footer",
		AnchorPoint = Vector2.new(0, 1),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 48),
		ZIndex = 20,
		Parent = root,
	})
	corner(footer, 14)
	create("Frame", {
		BackgroundColor3 = theme.Border,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		Parent = footer,
	})
	local statusText = text(footer, options.Status, 11, theme.Text)
	statusText.Name = "StatusText"
	statusText.Position = UDim2.fromOffset(60, 0)
	statusText.Size = UDim2.new(1, -212, 1, 0)
	statusText.ZIndex = 21
	statusText.Visible = false   -- the footer stays clean; SetStatus still tracks the state
	local statusPill = create("Frame", {
		Name = "StatusPill",
		AnchorPoint = Vector2.new(1, 0.5),
		BackgroundColor3 = theme.Card,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -18, 0.5, 0),
		Size = UDim2.fromOffset(112, 26),
		ZIndex = 21,
		Parent = footer,
	})
	corner(statusPill, 12)
	local statusPillText = text(statusPill, options.StatusPill, 10, theme.Text, Enum.Font.Gotham)
	statusPillText.Size = UDim2.fromScale(1, 1)
	statusPillText.TextXAlignment = Enum.TextXAlignment.Center
	statusPillText.ZIndex = 22

	local content = create("Frame", {
		Name = "Content",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(224, 48),
		Size = UDim2.new(1, -224, 1, -96),
		Parent = root,
	})

	local contentPanel = create("Frame", {
		Name = "ContentPanel",
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(10, 8),
		Size = UDim2.new(1, -20, 1, -16),
		Parent = content,
	})
	corner(contentPanel, 14)
	contentPanel.BackgroundTransparency = 1

	local header = create("Frame", {
		Name = "Header",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(28, 24),
		Size = UDim2.new(1, -56, 0, 80),
		Parent = content,
	})
	header.Visible = false
	local eyebrow = text(header, options.Eyebrow, 10, theme.Accent, Enum.Font.GothamBold)
	eyebrow.Size = UDim2.new(1, 0, 0, 18)
	eyebrow.Visible = options.Eyebrow ~= ""
	registerAccentUpdater(function() eyebrow.TextColor3 = theme.Accent end)
	local pageTitle = text(header, options.Title, 26, theme.Text, Enum.Font.GothamSemibold)
	pageTitle.Name = "PageTitle"
	pageTitle.Position = UDim2.fromOffset(0, options.Eyebrow ~= "" and 17 or 0)
	pageTitle.Size = UDim2.new(1, 0, 0, 32)
	local pageSubtitle = text(header, options.Subtitle, 13, theme.Muted)
	pageSubtitle.Name = "PageSubtitle"
	pageSubtitle.Position = UDim2.fromOffset(0, options.Eyebrow ~= "" and 47 or 32)
	pageSubtitle.Size = UDim2.new(1, 0, 0, 22)

	local pages = create("Frame", {
		Name = "Pages",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(28, 16),
		Size = UDim2.new(1, -56, 1, -32),
		Parent = content,
	})

	local launcher = create("TextButton", {
		Name = "MinimizedLauncher",
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutoButtonColor = false,
		BackgroundColor3 = theme.Surface,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -53, 1, -53),
		Size = UDim2.fromOffset(58, 58),
		Text = "",
		Visible = false,
		ZIndex = 200,
		Parent = gui,
	})
	corner(launcher, 16)
	local launcherStroke = stroke(launcher, theme.Accent, 1)
	local launcherLogo = create("Frame", {
		Name = "Logo",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(8, 8),
		Size = UDim2.fromOffset(42, 42),
		ZIndex = 201,
		Parent = launcher,
	})
	if logoAsset then
		local launcherImage = create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = logoAsset,
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 202,
			Parent = launcherLogo,
		})
		registerAccentUpdater(function()
			launcherImage.ImageColor3 = theme.Accent
			launcherStroke.Color = theme.Accent
		end)
	else
		local launcherText = text(launcherLogo, "◆", 35, theme.Accent, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
		launcherText.Size = UDim2.fromScale(1, 1)
		launcherText.ZIndex = 202
		registerAccentUpdater(function()
			launcherText.TextColor3 = theme.Accent
			launcherStroke.Color = theme.Accent
		end)
	end

	local window = {
		Gui = gui,
		Root = root,
		Theme = theme,
		Launcher = launcher,
	}

-- Inserted inside CreateWindow, sharing its layout and connection lifecycle.
local restoredPosition = root.Position
local motionProgress = create("NumberValue", {Name="MinimizeProgress", Value=0, Parent=gui})
local motionShell = create("Frame", {
    Name="MinimizeSurface", AnchorPoint=Vector2.new(0.5,0.5),
    BackgroundColor3=theme.Background, BackgroundTransparency=1,
    BorderSizePixel=0, Active=false, Visible=false, ZIndex=190, Parent=gui,
})
corner(motionShell,16)
-- The surface carries the launcher's outline and logo so it can become the launcher exactly.
local motionStroke=stroke(motionShell,theme.Border,1)
local motionLogo
if logoAsset then
    motionLogo=create("ImageLabel",{BackgroundTransparency=1,Image=logoAsset,ScaleType=Enum.ScaleType.Fit,
        AnchorPoint=Vector2.new(0.5,0.5),Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(42,42),
        ImageTransparency=1,ZIndex=191,Parent=motionShell})
    registerAccentUpdater(function() motionLogo.ImageColor3=theme.Accent end)
else
    motionLogo=text(motionShell,"◆",35,theme.Accent,Enum.Font.GothamBold,Enum.TextXAlignment.Center)
    motionLogo.AnchorPoint=Vector2.new(0.5,0.5); motionLogo.Position=UDim2.fromScale(0.5,0.5)
    motionLogo.Size=UDim2.fromOffset(42,42); motionLogo.TextTransparency=1; motionLogo.ZIndex=191
    registerAccentUpdater(function() motionLogo.TextColor3=theme.Accent end)
end
local motionTween
local motionCompletion

local function smooth(x)
    x=math.clamp(x,0,1)
    return x*x*(3-2*x)
end
local COVER=0.3   -- first 30%: contents fade under a window-colored surface; the rest: that surface becomes the launcher
local PARKED=UDim2.new(0.5,0,4,0)   -- where the window waits while minimized (below the screen)

local function renderWindowMotion()
    if destroyed then return end
    local progress=motionProgress.Value
    local cover=smooth(progress/COVER)
    local morph=smooth((progress-COVER)/(1-COVER))
    -- The window itself stays put at full size; only the surface on top of it moves.
    -- Both share the gui parent and centered anchors, so Position lerps avoid inset math.
    -- Park the window off-screen instead of hiding it: making a hidden window visible again re-lays out every
    -- control at once (a hitch). Only write what changed, so idle properties cost nothing per frame.
    local place=progress<COVER and restoredPosition or PARKED
    if root.Position~=place then root.Position=place; shadow.Position=place end
    if rootScale.Scale~=fullWindowScale then rootScale.Scale=fullWindowScale; shadowScale.Scale=fullWindowScale end
    if not root.Visible then root.Visible=true end
    if not shadow.Visible then shadow.Visible=true end
    shadow.BackgroundTransparency=0.55+0.45*cover
    -- The real launcher only appears once the surface matches it exactly.
    launcher.Visible=progress>=1

    local buttonSize=launcher.Size
    local width=gui.AbsoluteSize.X*buttonSize.X.Scale+buttonSize.X.Offset
    local height=gui.AbsoluteSize.Y*buttonSize.Y.Scale+buttonSize.Y.Offset
    local fullWidth,fullHeight=options.Size.X*fullWindowScale,options.Size.Y*fullWindowScale
    motionShell.Position=restoredPosition:Lerp(launcher.Position,morph)
    motionShell.Size=UDim2.fromOffset(fullWidth+(width-fullWidth)*morph,fullHeight+(height-fullHeight)*morph)
    motionShell.BackgroundColor3=theme.Background:Lerp(launcher.BackgroundColor3,morph)
    motionShell.BackgroundTransparency=1-cover
    motionStroke.Color=theme.Border:Lerp(theme.Accent,morph)
    motionStroke.Transparency=1-cover
    local logoFade=1-smooth((progress-0.75)/0.25)
    if motionLogo:IsA("ImageLabel") then motionLogo.ImageTransparency=logoFade else motionLogo.TextTransparency=logoFade end
    motionShell.Visible=progress>0 and progress<1
end
connect(motionProgress.Changed,renderWindowMotion)
connect(launcher:GetPropertyChangedSignal("Position"),function()
    if windowAnimating then renderWindowMotion() end
end)
connect(launcher:GetPropertyChangedSignal("BackgroundColor3"),function()
    if windowAnimating then renderWindowMotion() end
end)
connect(gui:GetPropertyChangedSignal("AbsoluteSize"),function()
    if windowAnimating then renderWindowMotion() end
end)

-- Driven by RenderStepped: exactly one update per rendered frame, sine in-out easing.
local motionRun=game:GetService("RunService")
local function animateWindow(target)
    if motionCompletion then motionCompletion:Disconnect(); motionCompletion=nil end
    if motionTween then motionTween:Cancel(); motionTween=nil end
    windowAnimating=true
    local from=motionProgress.Value
    local duration=math.max(0.12,0.5*math.abs(target-from))
    local started=os.clock()
    renderWindowMotion()
    motionCompletion=motionRun.RenderStepped:Connect(function()
        if destroyed then return end
        local t=math.clamp((os.clock()-started)/duration,0,1)
        motionProgress.Value=from+(target-from)*(0.5-math.cos(math.pi*t)/2)   -- Changed -> renderWindowMotion
        if t>=1 then
            if motionCompletion then motionCompletion:Disconnect(); motionCompletion=nil end
            windowAnimating=false
            renderWindowMotion()
        end
    end)
end
local function minimizeWindow()
    if minimized or destroyed then return end
    if not windowAnimating then restoredPosition=root.Position end
    minimized=true
    animateWindow(1)
end
local function restoreWindow()
    if not minimized or destroyed then return end
    minimized=false
    animateWindow(0)
end
connect(gui.Destroying,function()
    if motionCompletion then motionCompletion:Disconnect(); motionCompletion=nil end
    if motionTween then motionTween:Cancel(); motionTween=nil end
end)

	connect(logo.MouseButton1Click, minimizeWindow)
	connect(logo.MouseEnter, function() tween(logo, { BackgroundTransparency = 0.86, BackgroundColor3 = theme.AccentSoft }, 0.12) end)
	connect(logo.MouseLeave, function() tween(logo, { BackgroundTransparency = 1 }, 0.12) end)
	-- Minimize affordances: the yellow dot minimizes (macOS style) and the logo shows a "Minimize" tip on hover.
	local logoTip = create("TextLabel", {
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = theme.Card,
		BorderSizePixel = 0,
		Font = Enum.Font.GothamMedium,
		Position = UDim2.fromOffset(10, 46),
		Size = UDim2.fromOffset(0, 22),
		Text = "Minimize",
		TextColor3 = theme.Text,
		TextSize = 11,
		Visible = false,
		ZIndex = 70,
		Parent = root,
	})
	corner(logoTip, 6)
	stroke(logoTip, theme.Border, 1)
	padding(logoTip, 0, 8, 0, 8)
	connect(logo.MouseEnter, function() logoTip.Visible = not minimized end)
	connect(logo.MouseLeave, function() logoTip.Visible = false end)
	connect(logo.MouseButton1Click, function() logoTip.Visible = false end)
	connect(hideButton.MouseButton1Click, minimizeWindow)
	connect(hideButton.MouseEnter, function()
		hideButton.Text = "–"
		tween(hideButton, { BackgroundColor3 = Color3.fromRGB(246, 207, 98) }, 0.1)
	end)
	connect(hideButton.MouseLeave, function()
		hideButton.Text = ""
		tween(hideButton, { BackgroundColor3 = theme.Warning }, 0.1)
	end)
	closeButton.TextColor3 = Color3.fromRGB(90, 10, 10)
	closeButton.TextSize = 12
	connect(closeButton.MouseEnter, function()
		closeButton.Text = "×"
		tween(closeButton, { BackgroundColor3 = Color3.fromRGB(255, 120, 110) }, 0.1)
	end)
	connect(closeButton.MouseLeave, function()
		closeButton.Text = ""
		tween(closeButton, { BackgroundColor3 = theme.Danger }, 0.1)
	end)
	connect(closeButton.MouseButton1Click, function() window:Destroy() end)

	-- Sidebar collapse, animated every frame (sine in-out). The bar and the page slide together; tab labels, the
	-- title and the profile card stay put and fade out in the first half while the narrowing edge covers them;
	-- tab icons keep their place on the left; the arrow travels next to the logo and flips halfway.
	local COLLAPSE_TIME = 0.32
	local collapseProgress, collapseConnection = 0, nil
	local collapseRun = game:GetService("RunService")
	local function applyCollapse(e)
		local width = 224 + (64 - 224) * e
		sidebar.Size = UDim2.new(0, width, 1, -96)
		content.Position = UDim2.fromOffset(width, 48)
		content.Size = UDim2.new(1, -width, 1, -96)
		local fade = math.clamp(e * 1.9, 0, 1)            -- text is gone by about the halfway point
		local shown = e < 0.999
		brandText.TextTransparency = fade
		brandText.Visible = shown
		-- The logo stays (it's also the minimize button): it just centres over the narrow bar.
		logo.Position = UDim2.fromOffset(12 + 3 * e, 7)
		profile.BackgroundTransparency = fade
		avatar.BackgroundTransparency = fade
		avatar.TextTransparency = fade
		username.TextTransparency = fade
		edition.TextTransparency = fade
		profile.Visible = shown
		for _, tab in ipairs(tabs) do
			if not tab.Footer then
				tab.Label.TextTransparency = fade        -- icons and buttons stay where they are; only the label goes
				tab.Label.Visible = shown
			end
		end
		-- The feature search slides to the centre of the title bar and widens as the sidebar closes.
		searchBox.Position = UDim2.new(0.5, 70 * (1 - e), 0.5, 0)
		searchBox.Size = UDim2.fromOffset(300 + 120 * e, 30)
		searchResults.Position = UDim2.new(0.5, 70 * (1 - e), 0, 44)
		searchResults.Size = UDim2.fromOffset(340 + 120 * e, 0)
		-- The arrow ends up right after the logo, pointing outward.
		collapseButton.Text = e >= 0.5 and "›" or "‹"
		collapseButton.Position = UDim2.fromOffset(arrowX() + (54 - arrowX()) * e, -2)
	end
	local function setCollapsed(value)
		collapsed = value == true
		navHeading.Visible = false
		if collapseConnection then collapseConnection:Disconnect(); collapseConnection = nil end
		local from, target = collapseProgress, collapsed and 1 or 0
		local duration = COLLAPSE_TIME * math.abs(target - from)
		if duration <= 0 then applyCollapse(0.5 - math.cos(math.pi * target) / 2); return end
		local started = os.clock()
		collapseConnection = collapseRun.RenderStepped:Connect(function()
			if destroyed then return end
			local t = math.clamp((os.clock() - started) / duration, 0, 1)
			collapseProgress = from + (target - from) * t
			applyCollapse(0.5 - math.cos(math.pi * collapseProgress) / 2)
			if t >= 1 and collapseConnection then collapseConnection:Disconnect(); collapseConnection = nil end
		end)
		table.insert(connections, collapseConnection)
	end

	connect(collapseButton.MouseButton1Click, function()
		setCollapsed(not collapsed)
	end)

	connect(collapseButton.MouseEnter, function()
		collapseButton.TextColor3 = theme.Accent
	end)
	connect(collapseButton.MouseLeave, function()
		collapseButton.TextColor3 = theme.Muted
	end)

	local dragging = false
	local dragStart
	local startPosition
	connect(titleBar.InputBegan, function(input)
		if not minimized and not windowAnimating and input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPosition = root.Position
		end
	end)
	connect(UserInputService.InputEnded, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
	connect(UserInputService.InputChanged, function(input)
		if dragging and not windowAnimating and not minimized and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			root.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			shadow.Position = root.Position
		end
	end)

	local launcherDragging = false
	local launcherMoved = false
	local launcherDragStart
	local launcherStartCenter
	local launcherInput
	connect(launcher.InputBegan, function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
		launcherDragging = true
		launcherMoved = false
		launcherDragStart = Vector2.new(input.Position.X, input.Position.Y)
		launcherStartCenter = Vector2.new(gui.AbsoluteSize.X * launcher.Position.X.Scale + launcher.Position.X.Offset, gui.AbsoluteSize.Y * launcher.Position.Y.Scale + launcher.Position.Y.Offset)
		launcherInput = input
	end)
	connect(UserInputService.InputChanged, function(input)
		if not launcherDragging then return end
		local isMouse = input.UserInputType == Enum.UserInputType.MouseMovement
		local isTouch = input.UserInputType == Enum.UserInputType.Touch and input == launcherInput
		if not isMouse and not isTouch then return end
		local pointer = Vector2.new(input.Position.X, input.Position.Y)
		local delta = pointer - launcherDragStart
		if delta.Magnitude > 4 then launcherMoved = true end
		local half = launcher.AbsoluteSize / 2
		local viewport = gui.AbsoluteSize
		local center = launcherStartCenter + delta
		center = Vector2.new(
			math.clamp(center.X, half.X + 8, viewport.X - half.X - 8),
			math.clamp(center.Y, half.Y + 8, viewport.Y - half.Y - 8)
		)
		launcher.Position = UDim2.fromOffset(center.X, center.Y)
	end)
	connect(UserInputService.InputEnded, function(input)
		local matchesMouse = input.UserInputType == Enum.UserInputType.MouseButton1
		local matchesTouch = input == launcherInput
		if not launcherDragging or (not matchesMouse and not matchesTouch) then return end
		launcherDragging = false
		launcherInput = nil
		if launcherMoved then
			tween(launcher, { BackgroundColor3 = theme.Surface }, 0.12)
		else
			restoreWindow()
		end
	end)
	connect(launcher.MouseEnter, function()
		if not launcherDragging then tween(launcher, { BackgroundColor3 = theme.SurfaceHover }, 0.12) end
	end)
	connect(launcher.MouseLeave, function()
		if not launcherDragging then tween(launcher, { BackgroundColor3 = theme.Surface }, 0.12) end
	end)
	connect(UserInputService.InputBegan, function(input)
		if not capturingKeybind and UserInputService:GetFocusedTextBox() == nil and input.KeyCode == toggleKey then
			gui.Enabled = not gui.Enabled
		end
	end)

	local function selectTab(tab)
		activeTab = tab
		for _, candidate in ipairs(tabs) do
			local selected = candidate == tab
			candidate.Page.Visible = selected
			if candidate.UpdateScrollFades then candidate.UpdateScrollFades() end
			tween(candidate.Button, {
				BackgroundTransparency = selected and 0 or 1,
				BackgroundColor3 = selected and theme.AccentSoft or theme.Sidebar,
			}, 0.12)
			candidate.Label.TextColor3 = selected and theme.Text or theme.Muted
			candidate.SetIconColor(selected and theme.Accent or theme.Muted)
			candidate.Indicator.Visible = selected
		end
		pageTitle.Text = tab.Title
		pageSubtitle.Text = tab.Subtitle
	end

-- Shared by the footer and section status bubbles inside CreateWindow.
local statusNames={
    -- Optional short labels for long status strings, e.g. ["Waiting for match"]="Next match".
    ["Waiting for match"]="Next match",
    ["Completed"]="Done",
}
local function statusPresentation(value,color)
    local raw=tostring(value)
    local label=statusNames[raw] or raw
    local lower=raw:lower()
    local tint=color
    if not tint then
        if lower:find("error",1,true) or lower:find("failed",1,true) then tint=theme.Danger
        elseif lower:find("waiting",1,true) or lower:find("loading",1,true) or raw=="Paused" or raw=="Retrying" then tint=theme.Warning
        elseif raw=="Idle" or raw=="Off" or raw=="None" or raw=="Stopped" then tint=theme.Muted
        elseif raw=="Running" or raw=="Completed" or raw=="Ready" or raw=="Connected" or raw=="Supported" then tint=theme.Success
        else tint=theme.Accent end
    end
    return label,tint
end
local textService=game:GetService("TextService")
local function renderStatusPill(pill,label,outline,value,color,maxWidth)
    local display,tint=statusPresentation(value,color)
    label.Text=display
    label.TextColor3=tint
    label.TextTruncate=Enum.TextTruncate.AtEnd
    label.Position=UDim2.fromOffset(10,0)
    label.Size=UDim2.new(1,-20,1,0)
    local measured=textService:GetTextSize(display,label.TextSize,label.Font,Vector2.new(10000,26))
    local width=math.min(math.max(40,measured.X+24),math.max(40,maxWidth))
    pill.Size=UDim2.fromOffset(width,26)
    pill.BackgroundColor3=theme.Background:Lerp(tint,0.16)
    if outline then outline.Color=theme.Border:Lerp(tint,0.55) end
    return width
end
local footerOutline=stroke(statusPill,theme.Border,1)
local footerValue,footerColor=options.StatusPill,nil
local performancePanel
local performanceWidth=170
local function updateFooterPill()
    local width=renderStatusPill(statusPill,statusPillText,footerOutline,footerValue,footerColor,options.Size.X*0.5)
    statusText.Size=UDim2.new(1,-(width+performanceWidth+108),1,0)
    if performancePanel then performancePanel.Position=UDim2.new(1,-(width+30),0.5,0) end
end
registerAccentUpdater(updateFooterPill)

-- Real frame-rate samples and Roblox's Data Ping; shares window cleanup.
performancePanel=create("Frame",{
    Name="Performance",AnchorPoint=Vector2.new(1,0.5),BackgroundTransparency=1,
    Size=UDim2.fromOffset(performanceWidth,22),ZIndex=21,Parent=footer,
})
local fpsLabel=text(performancePanel,"-- fps",10,theme.Muted,Enum.Font.Code)
fpsLabel.Size=UDim2.fromOffset(48,22)
fpsLabel.ZIndex=22
local pingLabel=text(performancePanel,"-- ms",10,theme.Muted,Enum.Font.Code)
pingLabel.Position=UDim2.fromOffset(52,0)
pingLabel.Size=UDim2.fromOffset(52,22)
pingLabel.ZIndex=22
local METER_TOP=-1   -- bar graph bottom (METER_TOP+16) lines up with the fps/ms text baseline
local meter=create("Frame",{Name="PingHistory",BackgroundTransparency=1,
    Position=UDim2.fromOffset(110,METER_TOP),Size=UDim2.fromOffset(42,16),ZIndex=22,Parent=performancePanel})
local function layoutPerformance()
    local fpsWidth=math.ceil(textService:GetTextSize(fpsLabel.Text,10,Enum.Font.Code,Vector2.new(10000,22)).X)
    local pingWidth=math.ceil(textService:GetTextSize(pingLabel.Text,10,Enum.Font.Code,Vector2.new(10000,22)).X)
    fpsLabel.Size=UDim2.fromOffset(fpsWidth,22)
    pingLabel.Position=UDim2.fromOffset(fpsWidth+5,0)
    pingLabel.Size=UDim2.fromOffset(pingWidth,22)
    meter.Position=UDim2.fromOffset(fpsWidth+pingWidth+10,METER_TOP)
    performanceWidth=fpsWidth+pingWidth+10+42
    performancePanel.Size=UDim2.fromOffset(performanceWidth,22)
    updateFooterPill()
end
local samples,bars={},{}
for i=1,14 do
    bars[i]=create("Frame",{Name="Sample"..i,AnchorPoint=Vector2.new(0,1),BorderSizePixel=0,
        BackgroundColor3=theme.Accent,BackgroundTransparency=0.65,
        Position=UDim2.new(0,(i-1)*3,1,0),Size=UDim2.fromOffset(2,2),ZIndex=23,Parent=meter})
end
local function drawSamples()
    local maximum=100
    for _,ping in ipairs(samples) do if ping then maximum=math.max(maximum,ping) end end
    for i,bar in ipairs(bars) do
        local ping=samples[i-(#bars-#samples)]
        bar.BackgroundTransparency=ping and 0 or 0.65
        bar.BackgroundColor3=ping and (ping>=200 and theme.Danger or (ping>=100 and theme.Warning or theme.Accent)) or theme.Muted
        bar.Size=UDim2.fromOffset(2,ping and math.max(2,math.floor(16*ping/maximum+0.5)) or 2)
    end
end
registerAccentUpdater(drawSamples)
local stats=game:GetService("Stats")
local elapsed,frames=0,0
connect(game:GetService("RunService").RenderStepped,function(delta)
    if destroyed or delta<=0 then return end
    elapsed=elapsed+delta
    frames=frames+1
    if elapsed<0.5 then return end
    local fps=frames/elapsed
    elapsed,frames=0,0
    fpsLabel.Text=string.format("%d fps",math.floor(fps+0.5))
    fpsLabel.TextColor3=fps<30 and theme.Warning or theme.Muted
    local ok,ping=pcall(function()
        local network=stats:FindFirstChild("Network")
        local server=network and network:FindFirstChild("ServerStatsItem")
        local value=server and server:FindFirstChild("Data Ping")
        return value and value:GetValue()
    end)
    if ok and type(ping)=="number" and ping==ping and ping>=0 and ping<math.huge then
        pingLabel.Text=string.format("%d ms",math.floor(ping+0.5))
        pingLabel.TextColor3=ping>=200 and theme.Danger or (ping>=100 and theme.Warning or theme.Muted)
        table.insert(samples,ping)
    else
        pingLabel.Text="-- ms"
        pingLabel.TextColor3=theme.Muted
        table.insert(samples,false) -- Keep a gap instead of inventing a ping value.
    end
    if #samples>#bars then table.remove(samples,1) end
    drawSamples()
    layoutPerformance()
end)
layoutPerformance()

	function window:AddTab(tabOptions)
		if typeof(tabOptions) ~= "table" then tabOptions = { Title = tostring(tabOptions) } end
		tabOptions = merge({
			Title = "New Tab",
			Subtitle = options.Subtitle,
			Icon = "dashboard",
		}, tabOptions)

		local button = create("TextButton", {
			Name = tabOptions.Title,
			AutoButtonColor = false,
			BackgroundColor3 = theme.Surface,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 40),
			Text = "",
			Parent = nav,
		})
		corner(button, 9)
		local iconAsset = resolveTabIcon(tabOptions.Icon)
		local icon
		if iconAsset then
			icon = create("ImageLabel", {
				Name = "Icon",
				BackgroundTransparency = 1,
				Image = iconAsset,
				ImageColor3 = theme.Muted,
				Position = UDim2.fromOffset(12, 11),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(18, 18),
				Parent = button,
			})
		else
			icon = text(button, "•", 18, theme.Muted, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
			icon.Name = "Icon"
			icon.Position = UDim2.fromOffset(12, 11)
			icon.Size = UDim2.fromOffset(18, 18)
		end
		local label = text(button, tabOptions.Title, 13, theme.Muted, Enum.Font.GothamMedium)
		label.Name = "Label"
		label.Position = UDim2.fromOffset(40, 0)
		label.Size = UDim2.new(1, -48, 1, 0)

		local page = create("ScrollingFrame", {
			Name = tabOptions.Title,
			Active = true,
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ScrollBarImageColor3 = theme.Accent,
			ScrollBarThickness = 3,
			Size = UDim2.fromScale(1, 1),
			Visible = false,
			Parent = pages,
		})
		registerAccentUpdater(function() page.ScrollBarImageColor3 = theme.Accent end)
		padding(page, 16, 12, 40, 8)
		list(page, 16)

		-- Content remains clipped to its scrolling viewport, but these masks make
		-- the transition into the fixed header and footer feel soft instead of cut off.
		local topFade = create("Frame", {
			Name = "TopScrollFade",
			Active = false,
			BackgroundColor3 = theme.Background,
			BorderSizePixel = 0,
			Size = UDim2.new(1, -4, 0, 32),
			Visible = false,
			ZIndex = 40,
			Parent = pages,
		})
		create("UIGradient", {
			-- UIGradient color multiplies the frame color; white preserves it.
			Color = ColorSequence.new(Color3.new(1, 1, 1)),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.5, 0.5),
				NumberSequenceKeypoint.new(0.8, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Rotation = 90,
			Parent = topFade,
		})
		local bottomFade = create("Frame", {
			Name = "BottomScrollFade",
			Active = false,
			AnchorPoint = Vector2.new(0, 1),
			BackgroundColor3 = theme.Background,
			BorderSizePixel = 0,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.new(1, -4, 0, 32),
			Visible = false,
			ZIndex = 40,
			Parent = pages,
		})
		create("UIGradient", {
			Color = ColorSequence.new(Color3.new(1, 1, 1)),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.2, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.5),
				NumberSequenceKeypoint.new(1, 0),
			}),
			Rotation = 90,
			Parent = bottomFade,
		})

		local indicator = create("Frame", {
			Name = "SelectionIndicator", BackgroundColor3 = theme.Accent,
			BorderSizePixel = 0, Position = UDim2.new(0, 0, 0.5, -8),
			Size = UDim2.fromOffset(3, 16), Visible = false, Parent = button,
		})
		corner(indicator, 2)
		local tab = {
			Indicator = indicator,
			Title = tabOptions.Title,
			Subtitle = tabOptions.Subtitle,
			Button = button,
			Page = page,
			Label = label,
			Icon = icon,
		}
		tab.UpdateScrollFades = function()
			local hasOverflow = page.AbsoluteCanvasSize.Y > page.AbsoluteWindowSize.Y + 2
			local visible = activeTab == tab and page.Visible and hasOverflow
			local remaining = page.AbsoluteCanvasSize.Y - page.AbsoluteWindowSize.Y - page.CanvasPosition.Y
			topFade.Visible = visible and page.CanvasPosition.Y > 1
			bottomFade.Visible = visible and remaining > 1
		end
		connect(page:GetPropertyChangedSignal("CanvasPosition"), tab.UpdateScrollFades)
		connect(page:GetPropertyChangedSignal("AbsoluteCanvasSize"), tab.UpdateScrollFades)
		connect(page:GetPropertyChangedSignal("AbsoluteWindowSize"), tab.UpdateScrollFades)
		connect(page:GetPropertyChangedSignal("Visible"), tab.UpdateScrollFades)
		task.defer(tab.UpdateScrollFades)
		tab.SetIconColor = function(color)
			if icon:IsA("ImageLabel") then icon.ImageColor3 = color else icon.TextColor3 = color end
		end
		table.insert(tabs, tab)
		registerAccentUpdater(function()
			tab.SetIconColor(activeTab == tab and theme.Accent or theme.Muted)
			indicator.BackgroundColor3 = theme.Accent
			if activeTab == tab then button.BackgroundColor3 = theme.AccentSoft end
		end)

		connect(button.MouseButton1Click, function() selectTab(tab) end)
		connect(button.MouseEnter, function()
			if activeTab ~= tab then tween(button, { BackgroundTransparency = 0.45 }, 0.1) end
		end)
		connect(button.MouseLeave, function()
			if activeTab ~= tab then tween(button, { BackgroundTransparency = 1 }, 0.1) end
		end)
		if collapsed then
			label.Visible = false
			button.Size = UDim2.new(1, -12, 0, 40)
			icon.Position = UDim2.new(0.5, -9, 0.5, -9)
		end

		if tabOptions.Footer then
            tab.Footer = true
            button.Parent = footer
            button.Position = UDim2.fromOffset(10, 6)
            button.Size = UDim2.fromOffset(40, 36)
            button.ZIndex = 21
            label.Visible = false
            icon.Position = UDim2.fromOffset(9, 7)
            icon.Size = UDim2.fromOffset(22, 22)
            icon.ZIndex = 22
            if icon:IsA("TextLabel") then icon.Text = "⚙"; icon.TextSize = 24 end
            indicator.ZIndex = 22
        end

		function tab:Select()
			selectTab(self)
		end

		-- A real 3D stage. The source model is cloned; game objects are never moved.
		function tab:AddViewport(viewOptions)
			viewOptions = viewOptions or {}
			local stage = create("Frame", {
				Name = "ModelStage", BackgroundColor3 = theme.Card, BorderSizePixel = 0,
				Size = UDim2.new(1, -2, 0, viewOptions.Height or 360), ClipsDescendants = true, Parent = page,
			})
			corner(stage, 14)
			stroke(stage, theme.Border, 1)
			create("UIGradient", {
				Color = ColorSequence.new(theme.Card, theme.Background), Rotation = 65, Parent = stage,
			})
			local viewport = create("ViewportFrame", {
				Name = "Viewport", BackgroundTransparency = 1, BorderSizePixel = 0,
				Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -66),
				Ambient = Color3.fromRGB(115, 129, 148), LightColor = Color3.fromRGB(240, 247, 255),
				LightDirection = Vector3.new(-1, -0.6, -1), Active = true, Parent = stage,
			})
			local world = create("WorldModel", { Name = "Scene", Parent = viewport })
			local camera = create("Camera", { FieldOfView = 35, Parent = viewport })
			viewport.CurrentCamera = camera
			local caption = text(stage, viewOptions.Title or "GOGHUB / OBJECT 01", 10, theme.Accent, Enum.Font.GothamBold)
			caption.Position = UDim2.fromOffset(20, 14)
			caption.Size = UDim2.new(1, -40, 0, 18)
			local hint = text(stage, "DRAG TO ORBIT", 9, theme.Muted, Enum.Font.GothamMedium)
			hint.Position = UDim2.new(0, 20, 1, -28)
			hint.Size = UDim2.new(1, -40, 0, 16)
			local model, radius = nil, 4
			local yaw, pitch, zoom = math.rad(-16), math.rad(8), 1
			local rotate, speed = viewOptions.AutoRotate ~= false, 10
			local dragging, lastPointer = false, nil
			local tintParts = {}
			local function updateCamera()
				local size = viewport.AbsoluteSize
				local aspect = size.X / math.max(size.Y, 1)
				local halfFov = math.atan(math.tan(math.rad(camera.FieldOfView / 2)) * math.min(aspect, 1))
				local distance = radius / math.sin(halfFov) * 1.08 / zoom
				local position = Vector3.new(math.sin(yaw) * math.cos(pitch), math.sin(pitch), math.cos(yaw) * math.cos(pitch)) * distance
				camera.CFrame = CFrame.lookAt(position, Vector3.zero)
			end
			local control = { Instance = stage, Viewport = viewport, Camera = camera }
			function control:SetModel(source)
				assert(typeof(source) == "Instance" and source:IsA("Model"), "SetModel expects an archivable Model")
				local replacement = assert(source:Clone(), "Model must be archivable")
				local parts = {}
				for _, descendant in ipairs(replacement:GetDescendants()) do
					if descendant:IsA("BasePart") then
						descendant.Anchored = true
						descendant.CanCollide = false
						descendant.CanTouch = false
						if descendant:GetAttribute("GogHubAccent") then table.insert(parts, descendant) end
					elseif descendant:IsA("LuaSourceContainer") then
						descendant:Destroy()
					end
				end
				if not replacement:FindFirstChildWhichIsA("BasePart", true) then
					replacement:Destroy()
					error("Model must contain at least one BasePart")
				end
				local bounds, size = replacement:GetBoundingBox()
				replacement:PivotTo(CFrame.new(-bounds.Position) * replacement:GetPivot())
				if model then model:Destroy() end
				model, tintParts = replacement, parts
				model.Parent = world
				radius = math.max(size.Magnitude / 2, 0.1)
				for _, part in ipairs(tintParts) do part.Color = theme.Accent end
				updateCamera()
			end
			function control:SetAutoRotate(value) rotate = value == true end
			function control:SetRotationSpeed(value) speed = math.clamp(tonumber(value) or 10, 0, 60) end
			function control:SetZoom(value) zoom = math.clamp(tonumber(value) or 1, 0.7, 1.6) updateCamera() end
			function control:ResetCamera() yaw, pitch, zoom = math.rad(-16), math.rad(8), 1 updateCamera() end
			function control:SetLighting(ambient, light)
				viewport.Ambient = ambient
				viewport.LightColor = light
			end
			registerAccentUpdater(function()
				caption.TextColor3 = theme.Accent
				for _, part in ipairs(tintParts) do part.Color = theme.Accent end
			end)
			connect(viewport:GetPropertyChangedSignal("AbsoluteSize"), updateCamera)
			connect(viewport.InputBegan, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging, lastPointer = true, input.Position
					page.ScrollingEnabled = false
				end
			end)
			connect(UserInputService.InputChanged, function(input)
				if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = input.Position - lastPointer
					lastPointer = input.Position
					yaw = yaw - delta.X * 0.008
					pitch = math.clamp(pitch + delta.Y * 0.008, math.rad(-70), math.rad(70))
					updateCamera()
				end
			end)
			connect(UserInputService.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false page.ScrollingEnabled = true end
			end)
			connect(game:GetService("RunService").RenderStepped, function(dt)
				if not model or not gui.Enabled or not page.Visible or not stage.Visible or dragging or not rotate then return end
				local top = stage.AbsolutePosition.Y
				if top + stage.AbsoluteSize.Y < page.AbsolutePosition.Y or top > page.AbsolutePosition.Y + page.AbsoluteSize.Y then return end
				yaw = (yaw + math.rad(speed) * math.min(dt, 0.1)) % (2 * math.pi)
				updateCamera()
			end)
			if viewOptions.Model then control:SetModel(viewOptions.Model) end
			return control
		end


		-- A featured card and a compact metric strip for dashboard-style pages.
		function tab:AddHero(heroOptions)
			heroOptions = heroOptions or {}
			local frame = create("Frame", {
				Name = "Hero", BackgroundColor3 = theme.AccentSoft, BorderSizePixel = 0,
				Size = UDim2.new(1, -2, 0, 154), ClipsDescendants = true, Parent = page,
			})
			corner(frame, 14)
			stroke(frame, theme.Border, 1)
			local gradient = create("UIGradient", { Rotation = 18, Parent = frame })
			local badge = text(frame, heroOptions.Badge or "YOUR NEXT SESSION", 10, theme.Accent, Enum.Font.GothamBold)
			badge.Position = UDim2.fromOffset(22, 18)
			badge.Size = UDim2.new(1, -44, 0, 18)
			local heading = text(frame, heroOptions.Title or "Make time for play.", 28, theme.Text, Enum.Font.GothamBold)
			heading.Position = UDim2.fromOffset(22, 44)
			heading.Size = UDim2.new(1, -44, 0, 38)
			local description = text(frame, heroOptions.Description or "", 12, theme.Muted)
			description.Position = UDim2.fromOffset(22, 90)
			description.Size = UDim2.new(1, -44, 0, 42)
			description.TextWrapped = true
			description.TextYAlignment = Enum.TextYAlignment.Top
			registerAccentUpdater(function()
				frame.BackgroundColor3 = theme.AccentSoft
				badge.TextColor3 = theme.Accent
				gradient.Color = ColorSequence.new(Color3.new(1, 1, 1), theme.Card)
			end)
			return frame
		end

		function tab:AddMetrics(items)
			assert(#items > 0, "AddMetrics expects at least one metric")
			local frame = create("Frame", {
				Name = "Metrics", BackgroundTransparency = 1,
				Size = UDim2.new(1, -2, 0, 88), Parent = page,
			})
			local controls = {}
			for index, item in ipairs(items) do
				local cell = create("Frame", {
					BackgroundColor3 = theme.Card, BorderSizePixel = 0,
					Position = UDim2.new((index - 1) / #items, 4, 0, 0),
					Size = UDim2.new(1 / #items, -8, 1, 0), Parent = frame,
				})
				corner(cell, 12)
				stroke(cell, theme.Border, 1)
				local label = text(cell, item.Title or "METRIC", 9, theme.Muted, Enum.Font.GothamMedium)
				label.Position = UDim2.fromOffset(16, 13)
				label.Size = UDim2.new(1, -32, 0, 16)
				local value = text(cell, item.Value or "--", 23, theme.Text, Enum.Font.GothamSemibold)
				value.Position = UDim2.fromOffset(16, 37)
				value.Size = UDim2.new(1, -32, 0, 32)
				value.TextTruncate = Enum.TextTruncate.AtEnd
				local control = {}
				function control:Set(nextValue) value.Text = tostring(nextValue) end
				function control:Get() return value.Text end
				controls[index] = control
			end
			return controls
		end

		function tab:AddSection(sectionOptions)
			if typeof(sectionOptions) ~= "table" then sectionOptions = { Title = tostring(sectionOptions) } end
			sectionOptions = merge({ Title = "Section", Description = nil }, sectionOptions)

			local card = create("Frame", {
				Name = sectionOptions.Title,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = theme.Card,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -2, 0, 0),
				Parent = page,
			})
			corner(card, 12)
			stroke(card, theme.Border, 1)
			padding(card, 18, 20, 18, 20)
			local cardList = list(card, 12)

			local sectionTitle = text(card, sectionOptions.Title, 16, theme.Text, Enum.Font.GothamSemibold)
			sectionTitle.LayoutOrder = -100
			sectionTitle.Size = UDim2.new(1, 0, 0, 22)
			if sectionOptions.Description then
				local description = text(card, sectionOptions.Description, 11, theme.Muted)
				description.LayoutOrder = -99
				description.Size = UDim2.new(1, 0, 0, 18)
			end

			local section = { Instance = card }

			local function row(height)
				local frame = create("Frame", {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, height or 36),
					Parent = card,
				})
				return frame
			end

-- Injected inside AddSection so it shares the window theme and connection cleanup.
function section:AddPriorityList(options)
    local values,allowed,buttons,labels={},{},{},{}
    for i,value in ipairs(options.Values) do values[i]=value; allowed[value]=true end
    local stride,height=44,38
    local total=#values*stride-(stride-height)
    local frame=row(total)
    frame.Name=options.Text or "Priority"
    local drag
    local control={Instance=frame}
    local function copy(source)
        local result={}; for i,value in ipairs(source) do result[i]=value end; return result
    end
    local function paint(animate)
        for i,value in ipairs(values) do
            local button=buttons[value]
            labels[value].Text=tostring(i)
            local moving=drag and drag.Value==value
            button.ZIndex=moving and 8 or 2
            button.BackgroundColor3=moving and theme.AccentSoft or theme.Surface
            labels[value].TextColor3=i==1 and theme.Accent or theme.Muted
            for _,child in ipairs(button:GetChildren()) do
                if child:IsA("TextLabel") then child.ZIndex=button.ZIndex+1 end
            end
            if not moving then
                local position=UDim2.fromOffset(0,(i-1)*stride)
                tween(button,{Position=position},animate and 0.12 or 0)
            end
        end
    end
    local function finish(commit)
        if not drag then return end
        local previous=drag.Before
        page.ScrollingEnabled=drag.Scrolling
        drag=nil
        if not commit then values=previous end
        paint(false)
        if commit then
            local changed=false
            for i,value in ipairs(values) do if value~=previous[i] then changed=true end end
            if changed and options.Callback then
                local ok,err=pcall(options.Callback,copy(values))
                if not ok then values=previous; paint(false); warn("Join priority: "..tostring(err)) end
            end
        end
    end
    function control:Get() return copy(values) end
    function control:Set(order,silent)
        assert(type(order)=="table" and #order==#values,"Invalid priority order.")
        local seen={}
        local count=0
        for key,value in pairs(order) do
            assert(type(key)=="number" and key%1==0 and key>=1 and key<=#values and allowed[value] and not seen[value],"Invalid priority entry.")
            seen[value]=true; count=count+1
        end
        assert(count==#values,"Missing priority entry.")
        finish(false)
        values=copy(order); paint(false)
        if not silent and options.Callback then options.Callback(copy(values)) end
    end
    local function visible()
        return frame.Parent~=nil and gui.Parent~=nil and page.Visible and not minimized and not windowAnimating
    end
    local function move(input)
        if not drag then return end
        if not visible() then finish(false); return end
        if drag.Touch then
            if input~=drag.Input then return end
        elseif input.UserInputType~=Enum.UserInputType.MouseMovement then return end
        local scale=frame.AbsoluteSize.Y/total
        if scale<=0 then finish(false); return end
        local y=math.clamp((input.Position.Y-frame.AbsolutePosition.Y)/scale-drag.Grab,0,total-height)
        local target=math.clamp(math.floor((y+height/2)/stride)+1,1,#values)
        local from
        for i,value in ipairs(values) do if value==drag.Value then from=i; break end end
        if from~=target then
            table.insert(values,target,table.remove(values,from))
            paint(true)
        end
        buttons[drag.Value].Position=UDim2.fromOffset(0,y)
    end
    for i,value in ipairs(values) do
        local button=create("TextButton",{Name=value,Text="",AutoButtonColor=false,Active=true,
            BackgroundColor3=theme.Surface,BorderSizePixel=0,Size=UDim2.new(1,0,0,height),
            Position=UDim2.fromOffset(0,(i-1)*stride),Parent=frame,ZIndex=2})
        corner(button,8)
        local rank=text(button,tostring(i),12,theme.Muted,Enum.Font.GothamBold)
        rank.Position=UDim2.fromOffset(12,0); rank.Size=UDim2.new(0,22,1,0)
        local label=text(button,(options.Labels or {})[value] or value,13,theme.Text,Enum.Font.GothamMedium)
        label.Position=UDim2.fromOffset(40,0); label.Size=UDim2.new(1,-82,1,0)
        local handle=text(button,"≡",22,theme.Muted,Enum.Font.GothamMedium,Enum.TextXAlignment.Center)
        handle.Position=UDim2.new(1,-34,0,0); handle.Size=UDim2.new(0,24,1,0)
        buttons[value],labels[value]=button,rank
        connect(button.InputBegan,function(input)
            local touch=input.UserInputType==Enum.UserInputType.Touch
            if drag or not visible() or (not touch and input.UserInputType~=Enum.UserInputType.MouseButton1) then return end
            local scale=frame.AbsoluteSize.Y/total
            if scale<=0 then return end
            -- Cancel any position tween before the row starts following the pointer.
            tween(button,{Position=button.Position},0)
            drag={Value=value,Input=input,Touch=touch,Before=copy(values),Scrolling=page.ScrollingEnabled,
                Grab=(input.Position.Y-button.AbsolutePosition.Y)/scale}
            page.ScrollingEnabled=false
            paint(false)
        end)
    end
    connect(UserInputService.InputChanged,move)
    connect(UserInputService.InputEnded,function(input)
        if not drag then return end
        if (drag.Touch and input~=drag.Input) or (not drag.Touch and input.UserInputType~=Enum.UserInputType.MouseButton1) then return end
        local p,s=frame.AbsolutePosition,frame.AbsoluteSize
        local inside=input.Position.X>=p.X and input.Position.X<=p.X+s.X and input.Position.Y>=p.Y and input.Position.Y<=p.Y+s.Y
        finish(visible() and inside)
    end)
    connect(UserInputService.InputBegan,function(input)
        if input.KeyCode==Enum.KeyCode.Escape then finish(false) end
    end)
    connect(UserInputService.WindowFocusReleased,function() finish(false) end)
    connect(page:GetPropertyChangedSignal("Visible"),function() if not page.Visible then finish(false) end end)
    connect(frame.Destroying,function() finish(false) end)
    connect(gui.Destroying,function() finish(false) end)
    registerAccentUpdater(function() paint(false) end)
    paint(false)
    return control
end

			function section:AddLabel(labelOptions)
				if typeof(labelOptions) ~= "table" then labelOptions = { Text = tostring(labelOptions) } end
				local label = text(card, labelOptions.Text or "Label", labelOptions.Size or 12, labelOptions.Color or theme.Muted, labelOptions.Bold and Enum.Font.GothamBold or Enum.Font.Gotham)
				label.Size = UDim2.new(1, 0, 0, labelOptions.Height or 22)
				return label
			end

			function section:AddParagraph(titleValue, bodyValue)
				local frame = row(52)
				local titleLabel = text(frame, titleValue or "Paragraph", 13, theme.Text, Enum.Font.GothamMedium)
				titleLabel.Size = UDim2.new(1, 0, 0, 20)
				local body = text(frame, bodyValue or "", 11, theme.Muted)
				body.Position = UDim2.fromOffset(0, 21)
				body.Size = UDim2.new(1, 0, 0, 29)
				body.TextWrapped = true
				body.TextYAlignment = Enum.TextYAlignment.Top
				return frame
			end

			function section:AddDivider()
				return create("Frame", {
					BackgroundColor3 = theme.Border,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 1),
					Parent = card,
				})
			end

			function section:AddStatus(statusOptions)
				if typeof(statusOptions) ~= "table" then statusOptions = { Title = tostring(statusOptions) } end
				statusOptions = merge({
					Title = "Status",
					Description = "",
					Value = "Ready",
					Color = theme.Accent,
				}, statusOptions)
				local frame = create("Frame", {
					BackgroundColor3 = theme.Surface,
					BackgroundTransparency = 0.18,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 56),
					Parent = card,
				})
				corner(frame, 9)
				local titleLabel = text(frame, statusOptions.Title, 13, theme.Text, Enum.Font.GothamSemibold)
				titleLabel.Position = UDim2.fromOffset(12, 7)
				titleLabel.Size = UDim2.new(1, -140, 0, 20)
				local description = text(frame, statusOptions.Description, 11, theme.Muted)
				description.Position = UDim2.fromOffset(12, 27)
				description.Size = UDim2.new(1, -140, 0, 20)
				local pill = create("Frame", {
					AnchorPoint = Vector2.new(1, 0.5),
					BackgroundColor3 = theme.Card,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -12, 0.5, 0),
					Size = UDim2.fromOffset(108, 26),
					Parent = frame,
				})
				corner(pill, 9)
                local pillOutline = stroke(pill, theme.Border, 1)
                local valueLabel = text(pill, statusOptions.Value, 10, statusOptions.Color, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)
                local currentValue,currentColor = statusOptions.Value,nil
                local rendered=false
                local function refreshPill()
                    local available = frame.AbsoluteSize.X / math.max(rootScale.Scale,0.01)
                    if available <= 0 then available = options.Size.X - 320 end
                    local width = renderStatusPill(pill,valueLabel,pillOutline,currentValue,currentColor,available*0.6)
                    titleLabel.Size = UDim2.new(1,-(width+36),0,20)
                    description.Size = UDim2.new(1,-(width+36),0,20)
                    rendered=true
                end
                local control = {Instance=frame}
                function control:Set(value,color)
                    if rendered and currentValue==value and currentColor==color then return end
                    currentValue,currentColor = value,color
                    refreshPill()
                end
                connect(frame:GetPropertyChangedSignal("AbsoluteSize"),refreshPill)
                registerAccentUpdater(refreshPill)
				return control
			end

			function section:AddButton(buttonOptions, callback)
				if typeof(buttonOptions) ~= "table" then buttonOptions = { Text = tostring(buttonOptions), Callback = callback } end
				local action = buttonOptions.Callback or function() end
				local button = create("TextButton", {
					AutoButtonColor = false,
					BackgroundColor3 = buttonOptions.Secondary and theme.Surface or theme.Accent,
					BorderSizePixel = 0,
					Font = Enum.Font.GothamBold,
					Size = UDim2.new(1, 0, 0, 40),
					Text = buttonOptions.Text or "Button",
					TextColor3 = theme.Text,
					TextSize = 13,
					Parent = card,
				})
				corner(button, 9)
				if not buttonOptions.Secondary then
					registerAccentUpdater(function()
						button.BackgroundColor3 = theme.Accent
						button.TextColor3 = onAccent(theme.Accent)
					end)
				end
				connect(button.MouseEnter, function()
					tween(button, { BackgroundColor3 = buttonOptions.Secondary and theme.SurfaceHover or theme.AccentHover }, 0.1)
				end)
				connect(button.MouseLeave, function()
					tween(button, { BackgroundColor3 = buttonOptions.Secondary and theme.Surface or theme.Accent }, 0.1)
				end)
				connect(button.MouseButton1Click, function() task.spawn(action) end)
				return button
			end

			function section:AddToggle(toggleOptions, callback)
				if typeof(toggleOptions) ~= "table" then toggleOptions = { Text = tostring(toggleOptions), Callback = callback } end
				local flag = toggleOptions.Flag
				local value = toggleOptions.Default == true
				local action = toggleOptions.Callback or function() end
				local hasDescription = typeof(toggleOptions.Description) == "string" and toggleOptions.Description ~= ""
				local frame = row(hasDescription and 56 or 36)
				local labelText = text(frame, toggleOptions.Text or "Toggle", 13, theme.Text, Enum.Font.GothamMedium)
				labelText.Size = UDim2.new(1, -62, 0, hasDescription and 24 or 36)
				if hasDescription then
					local description = text(frame, toggleOptions.Description, 11, theme.Muted)
					description.Position = UDim2.fromOffset(0, 25)
					description.Size = UDim2.new(1, -62, 0, 24)
					description.TextWrapped = true
				end
				local switch = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					AutoButtonColor = false,
					BackgroundColor3 = theme.Surface,
					BorderSizePixel = 0,
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromOffset(42, 22),
					Text = "",
					Parent = frame,
				})
				corner(switch, 11)
				local knob = create("Frame", {
					BackgroundColor3 = theme.Text,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(3, 3),
					Size = UDim2.fromOffset(16, 16),
					Parent = switch,
				})
				corner(knob, 8)

				local control = { Instance = frame }
				function control:Set(nextValue, silent)
					value = nextValue == true
					if flag then GogHubUI.Flags[flag] = value end
					tween(switch, { BackgroundColor3 = value and theme.Accent or theme.Surface }, 0.14)
					tween(knob, { Position = value and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3) }, 0.14)
					if not silent then task.spawn(action, value) end
				end
				function control:Get() return value end
				connect(switch.MouseButton1Click, function() control:Set(not value) end)
				registerAccentUpdater(function()
					switch.BackgroundColor3 = value and theme.Accent or theme.Surface
				end)
				control:Set(value, true)
				table.insert(searchIndex, { Text = toggleOptions.Text or "Toggle", Description = toggleOptions.Description,
					TabTitle = tostring(tab.Title or ""), SectionTitle = tostring(sectionOptions.Title or ""), Tab = tab, Control = control })
				return control
			end

			function section:AddInput(inputOptions, callback)
				if typeof(inputOptions) ~= "table" then inputOptions = { Text = tostring(inputOptions), Callback = callback } end
				local action = inputOptions.Callback or function() end
				local frame = row(58)
				local labelText = text(frame, inputOptions.Text or "Input", 12, theme.Text, Enum.Font.GothamMedium)
				labelText.Size = UDim2.new(1, 0, 0, 18)
				local box = create("TextBox", {
					BackgroundColor3 = theme.Background,
					BorderSizePixel = 0,
					ClearTextOnFocus = inputOptions.Clear == true,
					Font = Enum.Font.Gotham,
					PlaceholderColor3 = theme.Muted,
					PlaceholderText = inputOptions.Placeholder or "Enter a value...",
					Position = UDim2.fromOffset(0, 23),
					Size = UDim2.new(1, 0, 0, 40),
					Text = tostring(inputOptions.Default or ""),
					TextColor3 = theme.Text,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = frame,
				})
				corner(box, 9)
				stroke(box, theme.Border, 1)
				padding(box, 0, 10, 0, 10)
				connect(box.FocusLost, function(enterPressed) task.spawn(action, box.Text, enterPressed) end)
				local control = { Instance = frame }
				function control:Set(value, silent)
					box.Text = tostring(value or "")
					if not silent then task.spawn(action, box.Text, false) end
				end
				function control:Get() return box.Text end
				return control
			end

			function section:AddSlider(sliderOptions, callback)
				if typeof(sliderOptions) ~= "table" then sliderOptions = { Text = tostring(sliderOptions), Callback = callback } end
				local minimum = tonumber(sliderOptions.Min) or 0
				local maximum = tonumber(sliderOptions.Max) or 100
				local step = tonumber(sliderOptions.Step) or 1
				local value = math.clamp(tonumber(sliderOptions.Default) or minimum, minimum, maximum)
				local action = sliderOptions.Callback or function() end
				local flag = sliderOptions.Flag
				local frame = row(55)
				local labelText = text(frame, sliderOptions.Text or "Slider", 12, theme.Text, Enum.Font.GothamMedium)
				labelText.Size = UDim2.new(1, -65, 0, 20)
				local valueText = text(frame, value, 11, theme.Accent, Enum.Font.Code, Enum.TextXAlignment.Right)
				valueText.Position = UDim2.new(1, -65, 0, 0)
				valueText.Size = UDim2.fromOffset(65, 20)
				local track = create("TextButton", {
					AutoButtonColor = false,
					BackgroundColor3 = theme.Surface,
					BorderSizePixel = 0,
					Position = UDim2.fromOffset(0, 32),
					Size = UDim2.new(1, 0, 0, 7),
					Text = "",
					Parent = frame,
				})
				corner(track, 4)
				local fill = create("Frame", {
					BackgroundColor3 = theme.Accent,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 1, 0),
					Parent = track,
				})
				corner(fill, 4)
				registerAccentUpdater(function() fill.BackgroundColor3 = theme.Accent end)
				local knob = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = theme.Text,
					BorderSizePixel = 0,
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromOffset(14, 14),
					Parent = track,
				})
				corner(knob, 7)
				local knobStroke = stroke(knob, theme.Accent, 2)
				registerAccentUpdater(function() knobStroke.Color = theme.Accent end)

				local control = { Instance = frame }
				function control:Set(nextValue, silent)
					nextValue = math.clamp(tonumber(nextValue) or minimum, minimum, maximum)
					if step > 0 then nextValue = math.round(nextValue / step) * step end
					value = math.clamp(nextValue, minimum, maximum)
					local ratio = maximum == minimum and 0 or (value - minimum) / (maximum - minimum)
					fill.Size = UDim2.new(ratio, 0, 1, 0)
					knob.Position = UDim2.fromScale(ratio, 0.5)
					valueText.Text = tostring(value)
					if flag then GogHubUI.Flags[flag] = value end
					if not silent then task.spawn(action, value) end
				end
				function control:Get() return value end
				local sliding = false
				local function updateFromPoint(point)           -- input.Position: same space as AbsolutePosition
					local ratio = math.clamp((point.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
					control:Set(minimum + (maximum - minimum) * ratio)
				end
				local function pressed(input)
					return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
				end
				connect(track.InputBegan, function(input) if pressed(input) then sliding = true updateFromPoint(input.Position) end end)
				connect(UserInputService.InputChanged, function(input)
					if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						updateFromPoint(input.Position)
					end
				end)
				connect(UserInputService.InputEnded, function(input)
					if pressed(input) then sliding = false end
				end)
				control:Set(value, true)
				return control
			end

-- Shared searchable dropdown; typing never changes the committed selection.
function section:AddDropdown(dropdownOptions, callback)
    if typeof(dropdownOptions)~="table" then dropdownOptions={Text=tostring(dropdownOptions),Callback=callback} end
    local action=dropdownOptions.Callback or function() end
    local selected=dropdownOptions.Default
    local multiple=dropdownOptions.MultiSelect==true
    local function copy(values)
        local result={}; for _,value in ipairs(values or {}) do table.insert(result,value) end; return result
    end
    local function normalize(value)
        if type(value)=="string" then return {value} end
        return copy(value)
    end
    if multiple then selected=normalize(selected) end
    local function picked(value)
        if not multiple then return selected==value end
        for _,item in ipairs(selected) do if item==value then return true end end
        return false
    end
    local open,writing=false,false
    local entries,filtered={},{}
    local highlighted=1
    local frame=row(62)
    frame.ClipsDescendants=false
    local label=text(frame,dropdownOptions.Text or "Dropdown",12,theme.Text,Enum.Font.GothamMedium)
    label.Size=UDim2.new(1,0,0,18)
    local header=create("Frame",{BackgroundColor3=theme.Background,BorderSizePixel=0,
        Position=UDim2.fromOffset(0,24),Size=UDim2.new(1,0,0,36),ZIndex=5,Parent=frame})
    corner(header,9)
    local outline=stroke(header,theme.Border,1)
    local search=create("TextBox",{Name="Search",BackgroundTransparency=1,BorderSizePixel=0,
        ClearTextOnFocus=false,MultiLine=false,Font=Enum.Font.Gotham,
        Position=UDim2.fromOffset(10,0),Size=UDim2.new(1,-46,1,0),Text="",
        PlaceholderText=dropdownOptions.Placeholder or "Select...",PlaceholderColor3=theme.Muted,
        TextColor3=theme.Text,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6,Parent=header})
    local arrow=create("TextButton",{Name="Toggle",Text="",AutoButtonColor=false,BackgroundTransparency=1,
        BorderSizePixel=0,Position=UDim2.new(1,-36,0,0),Size=UDim2.new(0,36,1,0),ZIndex=6,Parent=header})
    local chevron=create("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0.5,0.5),
        Position=UDim2.fromScale(0.5,0.5),Size=UDim2.fromOffset(16,16),ZIndex=7,Parent=arrow})
    for _,leg in ipairs({{5,45},{11,-45}}) do
        local line=create("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=theme.Muted,
            BorderSizePixel=0,Position=UDim2.fromOffset(leg[1],8),Rotation=leg[2],
            Size=UDim2.fromOffset(8,2),ZIndex=7,Parent=chevron})
        corner(line,1)
    end
    local menu=create("ScrollingFrame",{Name="Options",Active=true,BackgroundColor3=theme.Background,
        BorderSizePixel=0,CanvasSize=UDim2.new(),ClipsDescendants=true,Position=UDim2.fromOffset(0,64),
        ScrollBarImageColor3=theme.Accent,ScrollBarThickness=2,Size=UDim2.new(1,0,0,0),
        Visible=false,ZIndex=20,Parent=frame})
    corner(menu,9); stroke(menu,theme.Border,1); list(menu,2); padding(menu,4,4,4,4)
    local empty=text(menu,"No matches",12,theme.Muted,Enum.Font.Gotham)
    empty.Size=UDim2.new(1,0,0,30); empty.ZIndex=21; empty.Visible=false
    local control={Instance=frame,SearchBox=search}
    local function write(value)
        writing=true; search.Text=value; writing=false
    end
    local function paint()
        outline.Color=open and theme.Accent or theme.Border
        menu.ScrollBarImageColor3=theme.Accent
        for i,entry in ipairs(filtered) do
            entry.Button.BackgroundTransparency=i==highlighted and 0 or 1
            entry.Button.BackgroundColor3=theme.SurfaceHover
            entry.Button.TextColor3=picked(entry.Value) and theme.Accent or theme.Muted
            if multiple then entry.Button.Text=(picked(entry.Value) and "  ✓ " or "     ")..tostring(entry.Value) end
        end
    end
    local function filter()
        local query=search.Text:lower()
        filtered={}; highlighted=1
        for _,entry in ipairs(entries) do
            local show=query=="" or tostring(entry.Value):lower():find(query,1,true)~=nil
            entry.Button.Visible=show
            if show then table.insert(filtered,entry) end
        end
        empty.Visible=#filtered==0
        local canvas=math.max(#filtered,1)*32+8
        local height=math.min(canvas,136)
        menu.CanvasPosition=Vector2.new(0,0)
        menu.CanvasSize=UDim2.fromOffset(0,canvas)
        if open then
            tween(menu,{Size=UDim2.new(1,0,0,height)},0.12)
            tween(frame,{Size=UDim2.new(1,0,0,height+66)},0.12)
        end
        paint()
    end
    local function close()
        open=false
        if search:IsFocused() then search:ReleaseFocus(false) end
        write(multiple and table.concat(selected,", ") or selected~=nil and tostring(selected) or "")
        search.PlaceholderText=dropdownOptions.Placeholder or "Select..."
        menu.Visible=false
        tween(chevron,{Rotation=0},0.12)
        tween(frame,{Size=UDim2.new(1,0,0,62)},0.12)
        paint()
    end
    local function show()
        if open then return end
        open=true; menu.Visible=true
        search.PlaceholderText="Search..."
        write("")
        tween(chevron,{Rotation=180},0.12)
        filter()
    end
    function control:Get() return multiple and copy(selected) or selected end
    function control:Set(value,silent)
        selected=multiple and normalize(value) or value
        if dropdownOptions.Flag then GogHubUI.Flags[dropdownOptions.Flag]=self:Get() end
        close()
        if not silent then task.spawn(action,self:Get()) end
    end
    local function choose(value)
        if not multiple then control:Set(value); return end
        local wasPicked=picked(value)
        local values={}
        for _,item in ipairs(selected) do
            if item~=value and item~=dropdownOptions.Exclusive and value~=dropdownOptions.Exclusive then table.insert(values,item) end
        end
        if not wasPicked then table.insert(values,value) end
        selected=values
        if dropdownOptions.Flag then GogHubUI.Flags[dropdownOptions.Flag]=copy(selected) end
        paint()
        task.spawn(action,copy(selected))
    end
    function control:Clear()
        close()
        for _,entry in ipairs(entries) do entry.Button:Destroy() end
        entries,filtered={},{}
        empty.Visible=false
    end
    function control:Add(value)
        local button=create("TextButton",{AutoButtonColor=false,BackgroundColor3=theme.Surface,BackgroundTransparency=1,
            BorderSizePixel=0,Font=Enum.Font.Gotham,Size=UDim2.new(1,-2,0,30),Text="  "..tostring(value),
            TextColor3=theme.Muted,TextSize=12,TextXAlignment=Enum.TextXAlignment.Left,
            LayoutOrder=#entries+1,ZIndex=21,Parent=menu})
        local entry={Value=value,Button=button}; table.insert(entries,entry); corner(button,8)
        connect(button.MouseEnter,function()
            for i,match in ipairs(filtered) do if match==entry then highlighted=i; break end end
            paint()
        end)
        connect(button.Activated,function() choose(value) end)
        if open then filter() end
        return button
    end
    connect(search.Focused,show)
    connect(search:GetPropertyChangedSignal("Text"),function() if open and not writing then filter() end end)
    connect(search.FocusLost,function(enter)
        if enter and open then
            if filtered[highlighted] then choose(filtered[highlighted].Value) else close() end
        end
        -- Clicking an item blurs the input before Activated. Keep the results
        -- alive until that event; outside clicks are handled separately below.
    end)
    connect(arrow.Activated,function()
        if open then close() else show(); search:CaptureFocus() end
    end)
    connect(UserInputService.InputBegan,function(input)
        if not open then return end
        if input.KeyCode==Enum.KeyCode.Escape then close(); return end
        if search:IsFocused() and (input.KeyCode==Enum.KeyCode.Down or input.KeyCode==Enum.KeyCode.Up) and #filtered>0 then
            highlighted=math.clamp(highlighted+(input.KeyCode==Enum.KeyCode.Down and 1 or -1),1,#filtered)
            local y=(highlighted-1)*32
            local visible=math.min(math.max(#filtered,1)*32+8,136)-8
            local scroll=menu.CanvasPosition.Y
            if y<scroll then scroll=y elseif y+30>scroll+visible then scroll=y+30-visible end
            menu.CanvasPosition=Vector2.new(0,scroll); paint(); return
        end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            local p,s=frame.AbsolutePosition,frame.AbsoluteSize
            if input.Position.X<p.X or input.Position.X>p.X+s.X or input.Position.Y<p.Y or input.Position.Y>p.Y+s.Y then close() end
        end
    end)
    connect(page:GetPropertyChangedSignal("Visible"),function() if not page.Visible then close() end end)
    connect(UserInputService.WindowFocusReleased,close)
    registerAccentUpdater(paint)
    for _,value in ipairs(dropdownOptions.Values or {}) do control:Add(value) end
    close()
    return control
end

			function section:AddColorPicker(pickerOptions, callback)
				if typeof(pickerOptions) ~= "table" then pickerOptions = { Text = tostring(pickerOptions), Callback = callback } end
				local action = pickerOptions.Callback or function() end
				local color = typeof(pickerOptions.Default) == "Color3" and pickerOptions.Default or theme.Accent
				local hue, saturation, brightness = color:ToHSV()
				local frame = row(174)
				local labelText = text(frame, pickerOptions.Text or "Color", 12, theme.Text, Enum.Font.GothamMedium)
				labelText.Size = UDim2.new(1, -120, 0, 20)

				local hexText = text(frame, "", 11, theme.Muted, Enum.Font.Code, Enum.TextXAlignment.Right)
				hexText.Position = UDim2.new(1, -112, 0, 0)
				hexText.Size = UDim2.fromOffset(82, 20)
				local preview = create("Frame", {
					AnchorPoint = Vector2.new(1, 0),
					BorderSizePixel = 0,
					Position = UDim2.new(1, 0, 0, 0),
					Size = UDim2.fromOffset(22, 22),
					Parent = frame,
				})
				corner(preview, 11)
				stroke(preview, theme.Border, 1)

				local saturationField = create("Frame", {
					BackgroundColor3 = Color3.fromHSV(hue, 1, 1),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Position = UDim2.fromOffset(0, 30),
					Size = UDim2.new(1, 0, 0, 108),
					Parent = frame,
				})
				corner(saturationField, 9)

				local whiteLayer = create("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 2,
					Parent = saturationField,
				})
				create("UIGradient", {
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 1),
					}),
					Parent = whiteLayer,
				})
				local blackLayer = create("Frame", {
					BackgroundColor3 = Color3.new(0, 0, 0),
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 3,
					Parent = saturationField,
				})
				create("UIGradient", {
					Rotation = 90,
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0, 1),
						NumberSequenceKeypoint.new(1, 0),
					}),
					Parent = blackLayer,
				})
				local saturationInput = create("TextButton", {
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Text = "",
					ZIndex = 4,
					Parent = saturationField,
				})
				local saturationCursor = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(12, 12),
					ZIndex = 5,
					Parent = saturationField,
				})
				corner(saturationCursor, 6)
				stroke(saturationCursor, Color3.new(0, 0, 0), 2, 0.25)

				local hueBar = create("Frame", {
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					ClipsDescendants = true,
					Position = UDim2.fromOffset(0, 148),
					Size = UDim2.new(1, 0, 0, 12),
					Parent = frame,
				})
				corner(hueBar, 6)
				create("UIGradient", {
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromHSV(0, 1, 1)),
						ColorSequenceKeypoint.new(1 / 6, Color3.fromHSV(1 / 6, 1, 1)),
						ColorSequenceKeypoint.new(2 / 6, Color3.fromHSV(2 / 6, 1, 1)),
						ColorSequenceKeypoint.new(3 / 6, Color3.fromHSV(3 / 6, 1, 1)),
						ColorSequenceKeypoint.new(4 / 6, Color3.fromHSV(4 / 6, 1, 1)),
						ColorSequenceKeypoint.new(5 / 6, Color3.fromHSV(5 / 6, 1, 1)),
						ColorSequenceKeypoint.new(1, Color3.fromHSV(1, 1, 1)),
					}),
					Parent = hueBar,
				})
				local hueInput = create("TextButton", {
					AutoButtonColor = false,
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					Text = "",
					ZIndex = 2,
					Parent = hueBar,
				})
				local hueCursor = create("Frame", {
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BorderSizePixel = 0,
					Position = UDim2.fromScale(hue, 0.5),
					Size = UDim2.fromOffset(6, 16),
					ZIndex = 3,
					Parent = hueBar,
				})
				corner(hueCursor, 3)
				stroke(hueCursor, Color3.new(0, 0, 0), 1, 0.25)

				local control = { Instance = frame }
				function control:Set(nextColor, silent)
					if typeof(nextColor) ~= "Color3" then return end
					color = nextColor
					hue, saturation, brightness = color:ToHSV()
					saturationField.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
					saturationCursor.Position = UDim2.fromScale(saturation, 1 - brightness)
					hueCursor.Position = UDim2.fromScale(hue, 0.5)
					preview.BackgroundColor3 = color
					hexText.Text = string.format("#%02X%02X%02X", math.round(color.R * 255), math.round(color.G * 255), math.round(color.B * 255))
					if pickerOptions.Flag then GogHubUI.Flags[pickerOptions.Flag] = color end
					if not silent then task.spawn(action, color) end
				end
				function control:Get() return color end

				local draggingSaturation = false
				local draggingHue = false
				-- input.Position shares AbsolutePosition's space; GetMouseLocation() includes the top bar inset,
				-- which put the cursor ~58 px below the pointer.
				local function updateSaturation(point)
					saturation = math.clamp((point.X - saturationField.AbsolutePosition.X) / saturationField.AbsoluteSize.X, 0, 1)
					brightness = 1 - math.clamp((point.Y - saturationField.AbsolutePosition.Y) / saturationField.AbsoluteSize.Y, 0, 1)
					control:Set(Color3.fromHSV(hue, saturation, brightness))
				end
				local function updateHue(point)
					hue = math.clamp((point.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
					control:Set(Color3.fromHSV(hue, saturation, brightness))
				end
				local function pressed(input)
					return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
				end
				connect(saturationInput.InputBegan, function(input)
					if pressed(input) then draggingSaturation = true updateSaturation(input.Position) end
				end)
				connect(hueInput.InputBegan, function(input)
					if pressed(input) then draggingHue = true updateHue(input.Position) end
				end)
				connect(UserInputService.InputChanged, function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						if draggingSaturation then updateSaturation(input.Position) end
						if draggingHue then updateHue(input.Position) end
					end
				end)
				connect(UserInputService.InputEnded, function(input)
					if pressed(input) then
						draggingSaturation = false
						draggingHue = false
					end
				end)
				control:Set(color, true)
				return control
			end

			function section:AddKeybind(keybindOptions, callback)
				if typeof(keybindOptions) ~= "table" then keybindOptions = { Text = tostring(keybindOptions), Callback = callback } end
				local action = keybindOptions.Callback or function() end
				local changedAction = keybindOptions.Changed or function() end
				local key = keybindOptions.Default or Enum.KeyCode.Unknown
				local binding = false
				local frame = row(36)
				local labelText = text(frame, keybindOptions.Text or "Keybind", 13, theme.Text, Enum.Font.GothamMedium)
				labelText.Size = UDim2.new(1, -110, 1, 0)
				local button = create("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5),
					AutoButtonColor = false,
					BackgroundColor3 = theme.Surface,
					BorderSizePixel = 0,
					Font = Enum.Font.Code,
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromOffset(96, 28),
					Text = key.Name,
					TextColor3 = theme.Text,
					TextSize = 11,
					Parent = frame,
				})
				corner(button, 9)
				local control = { Instance = frame }
				function control:Set(nextKey, silent)
					if typeof(nextKey) == "EnumItem" then
						key = nextKey
						button.Text = nextKey.Name
						if not silent then task.spawn(changedAction, key) end
					end
				end
				function control:Get() return key end
				connect(button.MouseButton1Click, function()
					binding = true
					capturingKeybind = true
					button.Text = "Press a key"
				end)
				connect(UserInputService.InputBegan, function(input, processed)
					if binding then
						binding = false
						task.defer(function() capturingKeybind = false end)
						if input.KeyCode ~= Enum.KeyCode.Unknown then
							control:Set(input.KeyCode)
						else
							button.Text = key.Name
						end
					elseif not capturingKeybind and not processed and input.KeyCode == key then
						task.spawn(action, key)
					end
				end)
				control:Set(key, true)
				return control
			end

			return section
		end

		if not activeTab then selectTab(tab) end
		return tab
	end

	function window:SetVisible(value)
		gui.Enabled = value == true
	end

	function window:IsVisible()
		return gui.Parent ~= nil and gui.Enabled
	end

	function window:Toggle()
		if gui.Parent ~= nil then gui.Enabled = not gui.Enabled end
		return gui.Enabled
	end

	function window:SetMinimized(value)
		if value == true then minimizeWindow() else restoreWindow() end
		return minimized
	end

	function window:IsMinimized()
		return minimized
	end

	function window:SetCollapsed(value)
		setCollapsed(value)
	end

	function window:SetToggleKey(key)
		assert(typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode, "SetToggleKey expects an Enum.KeyCode")
		toggleKey = key
		return toggleKey
	end

	function window:GetToggleKey()
		return toggleKey
	end

	function window:SetAccent(color, hover)
		assert(typeof(color) == "Color3", "SetAccent expects a Color3")
		theme.Accent = color
		theme.AccentSoft = theme.Background:Lerp(color, 0.14)
		theme.AccentHover = typeof(hover) == "Color3" and hover or color:Lerp(Color3.new(1, 1, 1), 0.08)
		for _, update in ipairs(accentUpdaters) do
			pcall(update)
		end
		return theme.Accent
	end

    function window:SetStatus(value,pill,color)
        statusText.Text = statusPresentation(value)
        if pill ~= nil then self:SetStatusPill(pill,color) end
    end
    function window:SetStatusPill(value,color)
        footerValue,footerColor = value,color
        updateFooterPill()
    end

	local function layoutToasts()
		for index = #activeToasts, 1, -1 do
			if activeToasts[index].Parent == nil then table.remove(activeToasts, index) end
		end
		for index, activeToast in ipairs(activeToasts) do
			if activeToast.Parent then
				local bottomOffset = 18 + (index - 1) * 86
				tween(activeToast, { Position = UDim2.new(1, -18, 1, -bottomOffset) }, 0.22)
			end
		end
	end

	local function removeToast(target)
		for index, activeToast in ipairs(activeToasts) do
			if activeToast == target then
				table.remove(activeToasts, index)
				break
			end
		end
		layoutToasts()
	end

	function window:Notify(notificationOptions)
		if typeof(notificationOptions) ~= "table" then notificationOptions = { Title = tostring(notificationOptions) } end
		notificationOptions = merge({ Title = "Notification", Message = "", Duration = 4 }, notificationOptions)
		local notificationType = string.lower(tostring(notificationOptions.Type or ""))
		local isSuccess = notificationType == "success" or (notificationType == "" and notificationOptions.Color == theme.Success)
		local isError = notificationType == "error" or notificationOptions.Color == theme.Danger
		local statusColor = notificationOptions.Color or (isSuccess and theme.Success or (isError and theme.Danger or theme.Accent))
		local statusAsset = (isSuccess or isError) and resolveTabIcon(isSuccess and "toast-check" or "toast-x")
		local stackIndex = #activeToasts + 1
		local bottomOffset = 18 + (stackIndex - 1) * 86
		local toast = create("Frame", {
			AnchorPoint = Vector2.new(1, 1),
			BackgroundColor3 = theme.Card,
			BorderSizePixel = 0,
			Position = UDim2.new(1, 320, 1, -bottomOffset),
			Size = UDim2.fromOffset(300, 76),
			ZIndex = 100,
			Parent = gui,
		})
		corner(toast, 9)
		stroke(toast, theme.Border, 1)
		local statusCircle = create("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			BackgroundColor3 = statusColor,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 14, 0.5, 0),
			Size = UDim2.fromOffset(30, 30),
			ZIndex = 101,
			Parent = toast,
		})
		corner(statusCircle, 15)
		if statusAsset then
			create("ImageLabel", {
				BackgroundTransparency = 1,
				Image = statusAsset,
				ImageColor3 = onAccent(statusColor),
				Position = UDim2.fromOffset(5, 5),
				ScaleType = Enum.ScaleType.Fit,
				Size = UDim2.fromOffset(20, 20),
				ZIndex = 102,
				Parent = statusCircle,
			})
		else
			local fallback = text(statusCircle, isSuccess and "✓" or "×", 18, theme.Text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
			fallback.Size = UDim2.fromScale(1, 1)
			fallback.ZIndex = 102
		end
		local toastTitle = text(toast, notificationOptions.Title, 13, theme.Text, Enum.Font.GothamBold)
		toastTitle.Position = UDim2.fromOffset(56, 10)
		toastTitle.Size = UDim2.new(1, -68, 0, 22)
		toastTitle.ZIndex = 101
		local toastBody = text(toast, notificationOptions.Message, 11, theme.Muted)
		toastBody.Position = UDim2.fromOffset(56, 33)
		toastBody.Size = UDim2.new(1, -68, 0, 32)
		toastBody.TextWrapped = true
		toastBody.TextYAlignment = Enum.TextYAlignment.Top
		toastBody.ZIndex = 101
		table.insert(activeToasts, toast)
		layoutToasts()
		task.delay(notificationOptions.Duration, function()
			if toast.Parent then
				removeToast(toast)
				tween(toast, { Position = UDim2.new(1, -18, 1, 96), BackgroundTransparency = 1 }, 0.28)
				task.delay(0.3, function() if toast.Parent then toast:Destroy() end end)
			end
		end)
		return toast
	end

	function window:Destroy()
		if destroyed then return end
		destroyed = true
		for _, connection in ipairs(connections) do
			pcall(function() connection:Disconnect() end)
		end
		table.clear(connections)
		if gui.Parent then gui:Destroy() end
		if GogHubUI.Windows[options.Name] == self then GogHubUI.Windows[options.Name] = nil end
	end

	-- Reloading the module replaces the ScreenGui directly. Clean up the old
	-- module's listeners in that path as well as through window:Destroy().
	connect(gui.Destroying, function()
		if destroyed then return end
		destroyed = true
		for _, connection in ipairs(connections) do
			pcall(function() connection:Disconnect() end)
		end
		table.clear(connections)
		if GogHubUI.Windows[options.Name] == window then GogHubUI.Windows[options.Name] = nil end
	end)
	self.Windows[options.Name] = window
	return window
end

function GogHubUI:DestroyAll()
	local windows = {}
	for _, window in pairs(self.Windows) do table.insert(windows, window) end
	for _, window in ipairs(windows) do window:Destroy() end
end

return GogHubUI
end)()



local GameContext = (function()
-- GameContext: run game-module code at a game-script identity.
-- Potassium runs at identity 8; nested requires inside game ModuleScripts fail there.
local Context = {}

function Context.Call(callback, ...)
    if type(getthreadidentity) ~= "function" or type(setthreadidentity) ~= "function" then
        return callback(...)
    end
    local previous = getthreadidentity()
    setthreadidentity(2)
    local result = table.pack(pcall(callback, ...))
    setthreadidentity(previous)            -- restore even when the game module throws
    if not result[1] then error(result[2], 0) end
    return table.unpack(result, 2, result.n)
end

function Context.Require(module)
    return Context.Call(require, module)
end

return Context

end)()

local Settings = (function()
-- Settings: defaults + Validate. Validate is the single source of truth for every saved or edited value.
-- Settings.Validate({}) must always succeed and return the defaults. Unknown keys are dropped.
-- (The accent color is NOT a setting: ThemeStore keeps it across sessions, independent of configs.)
local Settings = {}
Settings.VERSION = 1
Settings.SLOTS = 6
Settings.END_ACTIONS = { "Off", "Replay", "Leave" }
Settings.TARGETS = { "Off", "First", "Last", "Close", "Far", "Strong", "Weak" }
Settings.DIFFICULTIES = { "Normal", "Hard", "Nightmare", "Extreme" }
Settings.GAME_SPEEDS = { "Off", "1x", "1.5x" }
Settings.ABILITY_MODES = { "On cooldown", "From wave", "Boss", "Off" }
Settings.UNIT_ABILITY_MODES = { "Default", "On cooldown", "From wave", "Boss", "Off" }
Settings.PLACE_MODES = { "Path", "Saved position" }
Settings.UPGRADE_MODES = { "Priority", "Even" }
Settings.MACRO_TIMINGS = { "Money", "Wave time" }
Settings.DEFAULTS = {
    -- Macro: play the selected recording, or the one assigned to the current map
    MacroPlay = false, MacroFile = "", MacroMaps = {}, MacroTiming = "Money",
    MacroAutoEquip = false,                                     -- equip the recording's team (right slots) in the lobby
    -- Match (every automation defaults OFF)
    AutoStart = false, AutoSkip = false, SkipFromWave = 1,
    EndAction = "Off", EndDelay = 2, RestartWave = 0,          -- RestartWave 0 = never
    ClaimBeforeRestart = false,                                 -- claim all quests before a replay or restart
    GameSpeed = "Off",                                          -- set the match speed each match: Off / 1x / 1.5x
    AutoSkipPopups = false,                                     -- click through "Click anywhere to continue" reveals
    DeleteMap = false,                                          -- hide everything but the track and placeable areas
    -- Autoplay
    Autoplay = false, PlaceMode = "Path", TrackPercent = 30,   -- Path: build beside the enemy path at this % from spawn
    PlaceCounts = { 6, 6, 6, 6, 6, 6 }, PlaceSpacing = 3, PlaceInterval = 0.6,   -- capped per unit by the game (spawnCap 1-6)
    Anchors = {},                                               -- Saved position mode: map name -> { x, y, z }
    AutoUpgrade = false, UpgradeInterval = 0.4, UpgradeMode = "Priority", UpgradeLimit = 99,   -- 99 = each unit's max
    UpgradeFarmsFirst = false,                                  -- max out farm units before upgrading anything else
    UpgradeOrder = { "Slot 1", "Slot 2", "Slot 3", "Slot 4", "Slot 5", "Slot 6" },
    TargetMode = "Off",
    AutoAbility = false, AbilityDefault = "On cooldown", AbilityFromWave = 1,
    AbilityUnits = {},                                          -- unit name -> { Mode, Wave }
    AutoErwin = false, AutoWendy = false, AutoKisuke = false,   -- buff rotations (3 of a kind); replace macro ability steps
    -- Lobby
    AutoJoin = false, JoinLevel = "namek", JoinDifficulty = "Normal",
    -- Webhook (Discord match reports)
    WebhookEnabled = false, WebhookURL = "", WebhookUserId = "",
    -- Rewards
    AutoClaimQuests = false, AutoClaimPass = false,
    -- Helpers and interface
    AntiAFK = true, Autosave = false, ToggleKey = "RightShift",
}

local function oneOf(value, list)
    for _, item in ipairs(list) do
        if item == value then return true end
    end
    return false
end

local function number(value, low, high, default, message, integer)
    if value == nil then return default end
    assert(type(value) == "number" and value == value and value >= low and value <= high
        and (not integer or value % 1 == 0), message)
    return value
end

function Settings.Validate(input)
    if input == nil then input = {} end
    assert(type(input) == "table", "Invalid settings.")
    local d = Settings.DEFAULTS
    local function bool(key)
        local value = input[key]
        if value == nil then return d[key] end
        assert(type(value) == "boolean", "Invalid setting: " .. key)
        return value
    end
    local function choice(key, list)
        local value = input[key] == nil and d[key] or input[key]
        assert(oneOf(value, list), "Invalid setting: " .. key)
        return value
    end
    local r = {}
    local function fileName(value, what)
        assert(type(value) == "string" and #value <= 90 and not value:find('[<>:"/\\|?*%c]') and not value:find("..", 1, true), "Invalid " .. what .. ".")
        return value
    end
    r.MacroPlay = bool("MacroPlay")
    r.MacroAutoEquip = bool("MacroAutoEquip")
    r.MacroFile = fileName(input.MacroFile == nil and d.MacroFile or input.MacroFile, "recording name")
    r.MacroTiming = choice("MacroTiming", Settings.MACRO_TIMINGS)
    local maps = input.MacroMaps == nil and d.MacroMaps or input.MacroMaps
    assert(type(maps) == "table", "Invalid map assignments.")
    r.MacroMaps = {}
    for map, file in pairs(maps) do
        assert(type(map) == "string" and #map > 0 and #map <= 80, "Invalid map name in assignments.")
        r.MacroMaps[map] = fileName(file, "assigned recording")
        assert(#file > 0, "Invalid assigned recording.")
    end
    r.AutoStart = bool("AutoStart")
    r.AutoSkip = bool("AutoSkip")
    r.SkipFromWave = number(input.SkipFromWave, 1, 1000, d.SkipFromWave, "Skip-from wave must be a whole number 1-1000.", true)
    r.EndAction = choice("EndAction", Settings.END_ACTIONS)
    r.EndDelay = number(input.EndDelay, 0, 30, d.EndDelay, "End delay must be 0-30 seconds.")
    r.RestartWave = number(input.RestartWave, 0, 1000, d.RestartWave, "Restart wave must be a whole number 0-1000 (0 = off).", true)
    r.ClaimBeforeRestart = bool("ClaimBeforeRestart")
    r.GameSpeed = choice("GameSpeed", Settings.GAME_SPEEDS)
    r.AutoSkipPopups = bool("AutoSkipPopups")
    r.DeleteMap = bool("DeleteMap")

    r.Autoplay = bool("Autoplay")
    r.PlaceMode = choice("PlaceMode", Settings.PLACE_MODES)
    r.TrackPercent = number(input.TrackPercent, 0, 100, d.TrackPercent, "Track position must be 0-100 %.")
    local counts = input.PlaceCounts == nil and d.PlaceCounts or input.PlaceCounts
    assert(type(counts) == "table", "Invalid placement counts.")
    r.PlaceCounts = {}
    for slot = 1, Settings.SLOTS do
        r.PlaceCounts[slot] = number(counts[slot] or 0, 0, 25, 0, "Placement count must be a whole number 0-25.", true)
    end
    r.PlaceSpacing = number(input.PlaceSpacing, 1, 20, d.PlaceSpacing, "Spacing must be 1-20 studs.")
    r.PlaceInterval = number(input.PlaceInterval, 0.2, 10, d.PlaceInterval, "Placement interval must be 0.2-10 seconds.")
    local anchors = input.Anchors == nil and d.Anchors or input.Anchors
    assert(type(anchors) == "table", "Invalid saved positions.")
    r.Anchors = {}
    for map, point in pairs(anchors) do
        assert(type(map) == "string" and #map > 0 and #map <= 80, "Invalid map name in saved positions.")
        assert(type(point) == "table" and #point == 3, "Invalid saved position for " .. map)
        for i = 1, 3 do
            assert(type(point[i]) == "number" and point[i] == point[i] and math.abs(point[i]) < 1e6, "Invalid saved position for " .. map)
        end
        r.Anchors[map] = { point[1], point[2], point[3] }
    end
    r.AutoUpgrade = bool("AutoUpgrade")
    r.UpgradeInterval = number(input.UpgradeInterval, 0.1, 10, d.UpgradeInterval, "Upgrade interval must be 0.1-10 seconds.")
    r.UpgradeMode = choice("UpgradeMode", Settings.UPGRADE_MODES)
    r.UpgradeLimit = number(input.UpgradeLimit, 0, 99, d.UpgradeLimit, "Upgrade limit must be a whole number 0-99 (99 = max).", true)
    r.UpgradeFarmsFirst = bool("UpgradeFarmsFirst")
    local order = input.UpgradeOrder == nil and d.UpgradeOrder or input.UpgradeOrder
    assert(type(order) == "table" and #order == Settings.SLOTS, "Invalid upgrade order.")
    local seen = {}
    r.UpgradeOrder = {}
    for i, label in ipairs(order) do
        assert(oneOf(label, d.UpgradeOrder) and not seen[label], "Invalid upgrade order.")
        seen[label] = true; r.UpgradeOrder[i] = label
    end
    r.TargetMode = choice("TargetMode", Settings.TARGETS)
    r.AutoAbility = bool("AutoAbility")
    r.AbilityFromWave = number(input.AbilityFromWave, 1, 1000, d.AbilityFromWave, "Ability wave must be a whole number 1-1000.", true)
    r.AbilityDefault = choice("AbilityDefault", Settings.ABILITY_MODES)
    local units = input.AbilityUnits == nil and d.AbilityUnits or input.AbilityUnits
    assert(type(units) == "table", "Invalid unit ability settings.")
    r.AbilityUnits = {}
    for name, entry in pairs(units) do
        assert(type(name) == "string" and #name > 0 and #name <= 80 and type(entry) == "table", "Invalid unit ability settings.")
        assert(oneOf(entry.Mode, Settings.UNIT_ABILITY_MODES), "Invalid ability mode for " .. name)
        r.AbilityUnits[name] = { Mode = entry.Mode, Wave = number(entry.Wave, 1, 1000, 1, "Ability wave must be a whole number 1-1000.", true) }
    end
    r.AutoErwin = bool("AutoErwin")
    r.AutoWendy = bool("AutoWendy")
    r.AutoKisuke = bool("AutoKisuke")

    r.AutoJoin = bool("AutoJoin")
    r.JoinLevel = input.JoinLevel == nil and d.JoinLevel or input.JoinLevel
    assert(type(r.JoinLevel) == "string" and #r.JoinLevel <= 60 and r.JoinLevel:match("^[%w_]+$") ~= nil, "Stage id must be letters, digits and _.")
    r.JoinDifficulty = choice("JoinDifficulty", Settings.DIFFICULTIES)

    r.WebhookEnabled = bool("WebhookEnabled")
    r.WebhookURL = input.WebhookURL == nil and d.WebhookURL or input.WebhookURL
    assert(type(r.WebhookURL) == "string" and #r.WebhookURL <= 300
        and (r.WebhookURL == "" or r.WebhookURL:match("^https://[%w%.]*discord[%w]*%.com/api/webhooks/%d+/[%w_%-]+$") ~= nil),
        "Paste a Discord webhook URL (https://discord.com/api/webhooks/...).")
    r.WebhookUserId = input.WebhookUserId == nil and d.WebhookUserId or input.WebhookUserId
    assert(type(r.WebhookUserId) == "string" and (r.WebhookUserId == "" or r.WebhookUserId:match("^%d%d%d%d%d%d%d%d%d%d%d?%d?%d?%d?%d?%d?%d?%d?%d?%d?$") ~= nil),
        "Discord user ID must be 10-20 digits (Developer Mode -> Copy User ID).")
    r.AutoClaimQuests = bool("AutoClaimQuests")
    r.AutoClaimPass = bool("AutoClaimPass")

    r.AntiAFK = bool("AntiAFK")
    r.Autosave = bool("Autosave")
    r.ToggleKey = input.ToggleKey == nil and d.ToggleKey or input.ToggleKey
    assert(type(r.ToggleKey) == "string" and r.ToggleKey:match("^%a%w*$"), "Invalid toggle key.")
    return r
end

-- Copy with one key changed, re-validated. Use this from UI callbacks.
function Settings.With(settings, key, value)
    local nextSettings = {}
    for k, v in pairs(settings) do nextSettings[k] = v end
    nextSettings[key] = value
    return Settings.Validate(nextSettings)
end

return Settings

end)()

local Storage = (function()
-- Storage: versioned JSON configs under <Namespace>/Configs, plus an autoload pointer.
-- Executor file functions and JSON are injectable so tests can run offline.
local Storage = {}
Storage.__index = Storage

local RESERVED = { CON = true, PRN = true, AUX = true, NUL = true }

-- User-entered names go straight into a path: sanitize for Windows.
function Storage.FileName(value)
    assert(type(value) == "string", "Enter a config name.")
    local name = value:match("^%s*(.-)%s*$"):gsub("%.[jJ][sS][oO][nN]$", "")
    assert(#name > 0 and #name <= 80, "Use a name between 1 and 80 characters.")
    assert(not name:find('[<>:"/\\|?*%c]') and not name:find("..", 1, true) and not name:match("[%.%s]$")
        and not name:match("^%."),
        "Names cannot contain paths or reserved filename characters.")
    local device = (name:match("^[^.]*") or ""):upper()
    assert(not RESERVED[device] and not device:match("^COM%d$") and not device:match("^LPT%d$"),
        "That name is reserved by Windows.")
    return name .. ".json"
end

local function defaultDeps()
    local http = game:GetService("HttpService")
    return {
        isfolder = isfolder, makefolder = makefolder, isfile = isfile, readfile = readfile,
        writefile = writefile, listfiles = listfiles, delfile = delfile,
        encode = function(v) return http:JSONEncode(v) end,
        decode = function(s) return http:JSONDecode(s) end,
    }
end

function Storage.new(namespace, deps)
    assert(type(namespace) == "string" and namespace:match("^GogHub/[%w_%-/]+$"), "Invalid storage namespace.")
    local self = setmetatable({ root = namespace, folder = namespace .. "/Configs",
        autoloadPath = namespace .. "/autoload.json", fs = deps or defaultDeps() }, Storage)
    return self
end

function Storage:_ensure()
    local path = ""
    for part in (self.folder .. "/"):gmatch("([^/]+)/") do
        path = path == "" and part or (path .. "/" .. part)
        if not self.fs.isfolder(path) then self.fs.makefolder(path) end
    end
end

function Storage:List()
    self:_ensure()
    local names = {}
    for _, path in ipairs(self.fs.listfiles(self.folder)) do
        local base = path:gsub("\\", "/"):match("([^/]+)$")
        local ok, name = pcall(Storage.FileName, base)
        if ok and name == base and self.fs.isfile(self.folder .. "/" .. base) then table.insert(names, base) end
    end
    table.sort(names, function(a, b) return a:lower() < b:lower() end)
    return names
end

function Storage:Save(name, settings, createOnly)
    local file = Storage.FileName(name)
    local valid = Settings.Validate(settings)
    self:_ensure()
    local path = self.folder .. "/" .. file
    if createOnly then assert(not self.fs.isfile(path), "That config exists. Use Save to update it.") end
    self.fs.writefile(path, self.fs.encode({ Version = Settings.VERSION, Profile = self.root, Settings = valid }))
    return file
end

function Storage:Load(name)
    local file = Storage.FileName(name)
    local path = self.folder .. "/" .. file
    assert(self.fs.isfile(path), "That config no longer exists.")
    local data = self.fs.decode(self.fs.readfile(path))
    assert(type(data) == "table" and data.Version == Settings.VERSION and data.Profile == self.root,
        "This config belongs to a different script or version.")
    return Settings.Validate(data.Settings), file
end

function Storage:Delete(name)
    local file = Storage.FileName(name)
    local path = self.folder .. "/" .. file
    assert(self.fs.isfile(path), "That config no longer exists.")
    if self:GetAutoload() == file then self:ClearAutoload() end
    self.fs.delfile(path)
end

function Storage:GetAutoload()
    if not self.fs.isfile(self.autoloadPath) then return nil end
    local ok, data = pcall(self.fs.decode, self.fs.readfile(self.autoloadPath))
    if not ok or type(data) ~= "table" or type(data.Config) ~= "string" then return nil end
    local valid, file = pcall(Storage.FileName, data.Config)
    return valid and file or nil
end

function Storage:SetAutoload(name)
    local _, file = self:Load(name)        -- must exist and be valid
    self:_ensure()
    self.fs.writefile(self.autoloadPath, self.fs.encode({ Version = 1, Config = file }))
    return file
end

function Storage:ClearAutoload()
    if self.fs.isfile(self.autoloadPath) then self.fs.delfile(self.autoloadPath) end
end

-- Free-form JSON documents in <Namespace>/<folder> (macros). Same name rules and listing as configs.
function Storage:Documents(folder)
    assert(type(folder) == "string" and folder:match("^%w+$"), "Invalid document folder.")
    return setmetatable({ root = self.root, folder = self.root .. "/" .. folder, fs = self.fs }, Storage)
end

function Storage:SaveData(name, data, createOnly)
    local file = Storage.FileName(name)
    self:_ensure()
    local path = self.folder .. "/" .. file
    if createOnly then assert(not self.fs.isfile(path), "That file exists.") end
    self.fs.writefile(path, self.fs.encode(data))
    return file
end

function Storage:LoadData(name)
    local path = self.folder .. "/" .. Storage.FileName(name)
    if not self.fs.isfile(path) then return nil end
    return self.fs.decode(self.fs.readfile(path))
end

function Storage:DeleteData(name)
    local path = self.folder .. "/" .. Storage.FileName(name)
    assert(self.fs.isfile(path), "That file no longer exists.")
    self.fs.delfile(path)
end

-- Small JSON side files under the namespace root (diagnostics, caches). data=nil reads.
function Storage:LocalFile(name, data)
    local path = self.root .. "/" .. Storage.FileName(name)
    if data ~= nil then
        self:_ensure()
        self.fs.writefile(path, self.fs.encode(data))
        return path
    end
    return self.fs.isfile(path) and self.fs.decode(self.fs.readfile(path)) or nil
end

return Storage

end)()

local ThemeStore = (function()
-- ThemeStore: the accent color persists across sessions, independently of configs.
-- Writes are debounced (0.35 s) and flushed on teleport/unload. File access is injectable for tests.
local ThemeStore = {}
ThemeStore.__index = ThemeStore

local function validChannels(values)
    assert(type(values) == "table" and #values == 3, "Invalid saved accent color.")
    for _, value in ipairs(values) do
        assert(type(value) == "number" and value == value and value >= 0 and value <= 1, "Invalid saved accent color.")
    end
    return values
end
ThemeStore.Channels = validChannels

function ThemeStore.new(namespace, options)
    options = options or {}
    local fs = options.FileSystem
    if not fs then
        local http = game:GetService("HttpService")
        fs = { isfile = isfile, readfile = readfile, writefile = writefile, isfolder = isfolder, makefolder = makefolder,
            encode = function(v) return http:JSONEncode(v) end, decode = function(s) return http:JSONDecode(s) end }
    end
    return setmetatable({ root = namespace, path = namespace .. "/theme.json", fs = fs,
        delay = options.Delay or (type(task) == "table" and task.delay),
        failed = options.Error or function() end }, ThemeStore)
end

-- Returns {r, g, b} in 0..1, or nil when nothing is saved.
function ThemeStore:Load()
    if not self.fs.isfile(self.path) then return nil end
    local data = self.fs.decode(self.fs.readfile(self.path))
    assert(type(data) == "table" and data.Version == 1, "Unsupported theme preferences.")
    return validChannels(data.Accent)
end

function ThemeStore:Flush()
    if self.writing or not self.pending then return end
    self.writing = true
    while self.pending do
        local values = self.pending
        local ok, err = pcall(function()
            local path = ""
            for part in (self.root .. "/"):gmatch("([^/]+)/") do
                path = path == "" and part or (path .. "/" .. part)
                if not self.fs.isfolder(path) then self.fs.makefolder(path) end
            end
            self.fs.writefile(self.path, self.fs.encode({ Version = 1, Accent = values }))
        end)
        if not ok then
            if not self.reported then self.reported = true; pcall(self.failed, tostring(err)) end
            break
        end
        self.reported = false
        if self.pending == values then self.pending = nil end
    end
    self.writing = false
end

-- Accepts {r, g, b} in 0..1 (App passes Color3 channels).
function ThemeStore:Set(channels)
    if self.disposed then return end
    self.pending = validChannels(channels)
    if self.scheduled then return end
    self.scheduled = true
    self.delay(0.35, function()
        self.scheduled = false
        if not self.disposed then self:Flush() end
    end)
end

function ThemeStore:Dispose()
    self.disposed = true
    self:Flush()
end

return ThemeStore

end)()

local Workers = (function()
-- Workers: owns every loop, connection, instance and cleanup function the script creates.
-- Destroy() cancels and cleans all of it (in reverse order), so unload leaves nothing running.
local Workers = {}
Workers.__index = Workers

function Workers.new(deps)
    deps = deps or {}
    local hasTask = type(task) == "table"
    return setmetatable({
        alive = true, loops = {}, items = {},
        spawn = deps.spawn or (hasTask and task.spawn),
        wait = deps.wait or (hasTask and task.wait),
        cancel = deps.cancel or (hasTask and task.cancel),
        onError = deps.onError or function() end,
    }, Workers)
end

-- Take ownership of a connection, Instance, thread or cleanup function. Returns it.
function Workers:Give(item)
    assert(self.alive, "Workers already destroyed.")
    table.insert(self.items, item)
    return item
end

-- Repeating loop: body runs, then waits interval() (number or function). Errors are reported, not fatal.
function Workers:Loop(name, interval, body)
    assert(self.alive, "Workers already destroyed.")
    self:StopLoop(name)
    local token = {}
    self.loops[name] = token
    token.thread = self.spawn(function()
        while self.alive and self.loops[name] == token do
            local ok, err = pcall(body)
            if not ok then self.onError(name, err) end
            if not (self.alive and self.loops[name] == token) then break end
            self.wait(type(interval) == "function" and interval() or interval)
        end
    end)
    return token
end

function Workers:StopLoop(name)
    local token = self.loops[name]
    if not token then return end
    self.loops[name] = nil
    -- Cancelling the running thread from inside itself errors; the loop exits on its own check instead.
    if token.thread and self.cancel and coroutine.running() ~= token.thread then
        pcall(self.cancel, token.thread)
    end
end

local function clean(item)
    local kind = type(item)
    if kind == "function" then
        item()
    elseif kind == "thread" then
        if type(task) == "table" then task.cancel(item) end
    elseif typeof ~= nil and typeof(item) == "RBXScriptConnection" then
        item:Disconnect()
    elseif typeof ~= nil and typeof(item) == "Instance" then
        item:Destroy()
    elseif kind == "table" and type(item.Disconnect) == "function" then
        item:Disconnect()
    elseif kind == "table" and type(item.Destroy) == "function" then
        item:Destroy()
    end
end

function Workers:Destroy()
    if not self.alive then return end
    self.alive = false
    for name in pairs(self.loops) do self:StopLoop(name) end
    for i = #self.items, 1, -1 do
        local ok, err = pcall(clean, self.items[i])
        if not ok then self.onError("cleanup", err) end
    end
    self.items = {}
end

return Workers

end)()

local Profile = (function()
-- Profile: identity of the game this script targets.
-- Detection is by replicated structure (see vault: Game Detection & Execution Context), never by PlaceId alone.
local Profile = {
    Id = "anime-td",
    Name = "GogHub Anime TD",
    Namespace = "GogHub/AnimeTD",
    Version = "1.0.0",
    DetectTimeout = 15,
}

-- The game keeps every remote in ReplicatedStorage.Remotes (captured with Cobalt, see _cobalt/GAME_REMOTES.md).
-- These four together are specific to this game.
Profile.MARKERS = { "MatchAction", "PlaceRequest", "MatchState", "LobbyRoomAction" }

function Profile.Matches(storage)
    local remotes = storage and storage:FindFirstChild("Remotes")
    if not remotes then return false end
    for _, name in ipairs(Profile.MARKERS) do
        if not remotes:FindFirstChild(name) then return false end
    end
    return true
end

return Profile

end)()

local GameAdapter = (function()
-- GameAdapter: the ONLY module that touches the game. Everything here comes from Cobalt captures of the
-- game's own client scripts (_cobalt/GAME_REMOTES.md). It never requires the game's ModuleScripts.
--   State in:    MatchState, MatchEvent, PlaceResult, LobbyRoom, InventoryResult, SettingsResult, QuestUpdate, BattlePassUpdate
--   Actions out: MatchAction, PlaceRequest, SellRequest, ActiveAbility, LobbyRoomAction, SettingsRequest, Quests, BattlePass
local Adapter = {}
Adapter.__index = Adapter

Adapter.SLOTS = 6
Adapter.TARGETS = { "First", "Last", "Close", "Far", "Strong", "Weak" }   -- every mode the game's PlacementClient sent
Adapter.DIFFICULTIES = { "Normal", "Hard", "Nightmare" }
-- Stage ids seen in LobbyRoom stats; more are added live from the lobby.
Adapter.KNOWN_LEVELS = { "namek", "namek_2", "namek_3", "namek_4", "namek_5", "namek_6",
    "shibuya", "shibuya_2", "shibuya_3", "shibuya_4", "shibuya_5", "shibuya_6", "shibuya_legend_1",
    "wall_maria", "wall_maria_2", "wall_maria_3", "wall_maria_4", "wall_maria_5", "wall_maria_6",
    "hueco_mundo_1", "hueco_mundo_2", "hueco_mundo_3", "hueco_mundo_4", "hueco_mundo_5",
    "witch_city", "walpurgis_night", "gilgamesh_portal", "halloween", "infinity_castle" }
-- Placed units are addressed by a per-match copy id: 1000000000 + placement order (1, 2, 3 ... sold ones included).
local ID_BASE = 1000000000
-- Game modules from the ReplicatedStorage dump (inspection/replicated). They're required at game identity and
-- used read-only: MatchPath builds the enemy path, PlacementRules is the game's own placement check,
-- UpgradePath gives each unit's own upgrade count and prices (3-12 levels; MatchConfig's generic 5 is only a fallback),
-- UnitStats resolves a unit's cost, ground/hill type and placement cap (UnitDB spawnCap 1-6, trait limits).
-- ItemData names and rates drops for webhook reports.
-- ActiveData lists each unit's active ability (UNIT_ACTIVES[name] = { id, at }) and its timing (ABILITIES[id]).
-- LevelData lists every stage (id, act, name, location, mode flags) for the gamemode > map > act assignments.
-- ChallengeData: challenges are Story stages with a modifier (regular every 30 min, daily on Hard).
Adapter.MODULES = { "MatchPath", "PlacementRules", "PlacementConfig", "MatchConfig", "UnitStats", "UpgradePath", "ItemData", "ActiveData", "LevelData", "ChallengeData" }
Adapter.CHALLENGE_MAPS = { "Planet Namek", "Wall Maria", "Shibuya" }          -- ChallengeData.MAPS (fallback)
Adapter.CHALLENGE_KINDS = { { Kind = "challenge", Title = "Challenge" }, { Kind = "daily", Title = "Daily Challenge" } }

function Adapter.new(options)
    options = options or {}
    local self = setmetatable({
        world = options.Workspace or workspace,
        replicated = options.ReplicatedStorage or game:GetService("ReplicatedStorage"),
        player = options.Player or game:GetService("Players").LocalPlayer,
        load = options.Require or GameContext.Require,
        mods = {}, moduleErrors = {}, slotCache = {},
        connections = {},
        match = nil, matchKey = 1, wave = 0, results = nil,
        room = nil, roomKey = 0,
        inventory = nil, gameSettings = nil, quests = nil, pass = nil, money = nil, notice = nil,
        units = {}, order = 0, recent = {}, pendingMine = {}, placed = {},
        waveStartedAt = os.clock(), abilitySeq = 0, abilityLog = {},
        announced = {}, levelUps = {}, reportedAt = os.clock(),   -- webhook: my unit drops and level-ups since the last report
        catalog = { Levels = {} }, catalogVersion = 0,
        loaded = false,
    }, Adapter)
    for _, id in ipairs(Adapter.KNOWN_LEVELS) do self.catalog.Levels[id] = id end
    return self
end

function Adapter:Matches() return Profile.Matches(self.replicated) end

function Adapter:Remote(name)
    local remotes = self.replicated:FindFirstChild("Remotes")
    return assert(remotes and remotes:FindFirstChild(name), "Remote unavailable: " .. name)
end

local function connect(self, signal, fn)
    table.insert(self.connections, signal:Connect(function(...)
        if self.disposed then return end
        local ok, err = pcall(fn, ...)
        if not ok then warn("[GogHub] " .. tostring(err)) end
    end))
end

-- Match lifecycle ------------------------------------------------------------------------------
function Adapter:_newMatch()
    self.matchKey = self.matchKey + 1
    self.units, self.order, self.recent, self.pendingMine, self.placed = {}, 0, {}, {}, {}
    self.results, self.wave, self.waveStartedAt = nil, 0, os.clock()
    self.mapModel, self.path = nil, nil
    self.speedScale = nil                       -- re-measured each match (speed can change between matches)
    local folder = self.world:FindFirstChild("PlacedUnits")
    if folder then for _, model in ipairs(folder:GetChildren()) do self:_track(model) end end
end

function Adapter:_setWave(wave)
    if wave ~= self.wave then self.wave = wave; self.waveStartedAt = os.clock() end
end

-- Seconds since the current wave (or prep) began.
function Adapter:WaveTime() return os.clock() - self.waveStartedAt end

function Adapter:_onState(state)
    if type(state) ~= "table" then return end
    local previous = self.match
    local prepStart = previous and state.state == "Prep" and previous.state ~= "Prep" and (tonumber(state.wave) or 0) == 0
    if prepStart and self.justReplayed then prepStart = false end      -- "replaying" already started this match
    if state.state ~= "Prep" then self.justReplayed = nil end
    local fresh = previous and ((state.levelId ~= previous.levelId) or prepStart)
    self.match = state
    self:_setWave(tonumber(state.wave) or self.wave)
    if fresh then self:_newMatch() end
end

function Adapter:_onEvent(kind, data)
    if kind == "wave" then
        self:_setWave(tonumber(data) or self.wave)
    elseif kind == "results" and type(data) == "table" then
        self.results = { Key = self.matchKey, Data = data, At = os.clock() }
    elseif kind == "replaying" then
        self:_newMatch()
        self.justReplayed = true
    elseif kind == "area" and type(data) == "table" then
        self.area = { Key = self.matchKey, Description = tostring(data.description or ""), Difficulty = data.difficulty }
    end
end

-- Placed units -------------------------------------------------------------------------------
-- Prefer an id stored on the model; fall back to the placement-order rule seen in the captures.
local function storedId(model)
    -- Confirmed in diagnostics: the server stores the copy id as the PlaceId attribute (server-wide counter).
    local placeId = tonumber(model:GetAttribute("PlaceId"))
    if placeId then return placeId end
    for _, value in pairs(model:GetAttributes()) do
        if type(value) == "number" and value > ID_BASE and value < ID_BASE * 2 then return value end
    end
    for _, child in ipairs(model:GetChildren()) do
        if (child:IsA("IntValue") or child:IsA("NumberValue")) and child.Value > ID_BASE and child.Value < ID_BASE * 2 then return child.Value end
    end
    return nil
end

function Adapter:_owner(model)
    for key, value in pairs(model:GetAttributes()) do
        local k = key:lower()
        if k:find("owner") or k == "userid" or k == "player" then
            return value == self.player.UserId or value == self.player.Name or value == tostring(self.player.UserId)
        end
    end
    local tag = model:FindFirstChild("Owner")
    if tag and tag:IsA("ObjectValue") then return tag.Value == self.player end
    return nil
end

function Adapter:_track(model)
    if self.units[model] or not model:IsA("Model") then return end
    self.order = self.order + 1
    local stored = storedId(model)
    local info = { Model = model, Name = model.Name, Id = stored or (ID_BASE + self.order), Stored = stored ~= nil,
        Mine = self:_owner(model), At = os.clock() }
    if info.Mine ~= false then
        for i, pending in ipairs(self.pendingMine) do
            if pending.Name == model.Name then info.Mine = true; info.Slot = pending.Slot; table.remove(self.pendingMine, i); break end
        end
    end
    self.units[model] = info
    table.insert(self.recent, info)
    if #self.recent > 12 then table.remove(self.recent, 1) end
end

function Adapter:_watchUnits(folder)
    if self.unitFolder == folder then return end
    self.unitFolder = folder
    for _, model in ipairs(folder:GetChildren()) do self:_track(model) end
    connect(self, folder.ChildAdded, function(model) self:_track(model) end)
    connect(self, folder.ChildRemoved, function(model) self.units[model] = nil end)
end

function Adapter:_onPlace(result)
    if type(result) ~= "table" then return end
    if tonumber(result.money) then self.money = result.money end
    if result.success and not result.sold and tonumber(result.slot) then
        self.placed[result.slot] = (self.placed[result.slot] or 0) + 1
        local matched = false
        for i = #self.recent, 1, -1 do          -- the model may replicate before the result
            local info = self.recent[i]
            if info.Name == result.name and info.Slot == nil and info.Mine ~= false and os.clock() - info.At < 3 then
                info.Mine = true; info.Slot = result.slot; matched = true; break
            end
        end
        if not matched then table.insert(self.pendingMine, { Name = result.name, Slot = result.slot }) end
    end
    if self.waiter then self.waiter.Result = result end
end

-- My units this match. In a solo match, units with an unknown owner count as mine.
-- Attributes the server sets after the model replicates: OwnerUserId, UpgradeLevel, Cost (see PlacementConfig/MatchConfig).
function Adapter:_refresh(model, info)
    if info.Mine == nil then info.Mine = self:_owner(model) end
    if not info.Stored then
        local id = storedId(model)
        if id then info.Id = id; info.Stored = true end
    end
    local cfg, path = self.mods.MatchConfig, self.mods.UpgradePath
    info.Level = tonumber(model:GetAttribute(cfg and cfg.UPGRADE_ATTRIBUTE or "UpgradeLevel")) or 0
    local mode = model:GetAttribute("TargetMode")                -- PlacementConfig.TARGET_MODE_ATTRIBUTE
    info.TargetMode = type(mode) == "string" and mode or nil
    local buff = model:GetAttribute("BuffUntil")                  -- server time the current buff ends (Combat.lua)
    info.BuffUntil = type(buff) == "number" and buff or nil
    local role = model:GetAttribute("Role")                      -- "Farm" for income units (seen in diagnostics)
    info.Role = type(role) == "string" and role or nil
    local unitName = model:GetAttribute("UnitName")
    unitName = type(unitName) == "string" and unitName ~= "" and unitName or model.Name
    info.Name = unitName
    if info.MaxLevel == nil then
        local ok, max = false, nil
        if path then ok, max = pcall(GameContext.Call, path.max, unitName) end
        info.MaxLevel = ok and tonumber(max) or (cfg and cfg.MAX_UPGRADE) or 5
    end
    info.NextCost = nil
    local cost = tonumber(model:GetAttribute("Cost"))
    if cost and info.Level < info.MaxLevel then
        local ok, price = false, nil
        if path then ok, price = pcall(GameContext.Call, path.cost, unitName, cost, info.Level + 1) end
        if not (ok and tonumber(price)) and cfg then ok, price = pcall(cfg.upgradeCost, cost, info.Level + 1) end
        if ok and tonumber(price) then info.NextCost = tonumber(price) end
    end
end

function Adapter:MyUnits()
    local solo = self.match and tonumber(self.match.players) == 1
    local list = {}
    for model, info in pairs(self.units) do
        if model.Parent then
            self:_refresh(model, info)
            if info.Mine == true or (solo and info.Mine == nil) then table.insert(list, info) end
        end
    end
    table.sort(list, function(a, b) return a.Id < b.Id end)
    return list
end

function Adapter:PlacedCount(slot) return self.placed[slot] or 0 end

-- Lobby, inventory, rewards ----------------------------------------------------------------------
function Adapter:_onRoom(data)
    if type(data) ~= "table" then return end
    if data.phase == "left" then self.room = nil; return end
    if data.phase then if self.room then self.room.Phase = data.phase end; return end
    if data.players then
        if not self.room then self.roomKey = self.roomKey + 1; self.room = { Key = self.roomKey } end
        self.room.Players = #data.players; self.room.SecondsLeft = data.secondsLeft; self.room.Portal = data.portal
    end
    -- After a stage is selected the room reports it (levelId, difficulty), whoever selected it.
    if self.room and type(data.levelId) == "string" then
        self.room.Level, self.room.Difficulty = data.levelId, data.difficulty
    end
    if self.room and type(data.kind) == "string" then self.room.Kind = data.kind end
    if type(data.stats) == "table" then
        local added = false
        for id in pairs(data.stats) do
            if type(id) == "string" and not self.catalog.Levels[id] then self.catalog.Levels[id] = id; added = true end
        end
        if added then self.catalogVersion = self.catalogVersion + 1 end
    end
end

function Adapter:EquippedNames()
    local names = {}
    local inv = self.inventory
    if type(inv) ~= "table" or type(inv.equipped) ~= "table" then return names end
    local byId = {}
    for _, unit in ipairs(inv.units or {}) do byId[unit.id] = unit.name end
    for slot = 1, Adapter.SLOTS do
        local id = inv.equipped[slot]
        names[slot] = id and (byId[id] or ("#" .. tostring(id))) or "Empty"   -- no holes: JSONEncode rejects sparse arrays
    end
    return names
end

-- Load / Read ----------------------------------------------------------------------------------
-- Game modules load in the background, each with a timeout: a module that yields forever (WaitForChild on
-- something this server never creates) must not keep the script from starting. Features that use a module
-- fall back when it isn't loaded (moduleErrors says which).
Adapter.MODULE_TIMEOUT = 5
function Adapter:_loadModules()
    self.moduleLoading = self.moduleLoading or {}
    for _, name in ipairs(Adapter.MODULES) do
        if not self.mods[name] and not self.moduleLoading[name] then
            local module = self.replicated:FindFirstChild(name)
            if not module then
                self.moduleErrors[name] = "missing"
            else
                local job = { Done = false }
                self.moduleLoading[name] = job
                self.moduleErrors[name] = "loading"
                task.spawn(function()
                    local ok, result = pcall(self.load, module)
                    job.Done = true
                    if self.moduleLoading[name] == job then self.moduleLoading[name] = nil end
                    if ok and type(result) == "table" then self.mods[name] = result; self.moduleErrors[name] = nil
                    else self.moduleErrors[name] = tostring(result) end
                end)
                task.delay(Adapter.MODULE_TIMEOUT, function()
                    if not job.Done then self.moduleErrors[name] = "timed out"; self.moduleLoading[name] = nil end
                end)
            end
        end
    end
end

function Adapter:Load()
    assert(self:Matches(), "This game does not match the profile.")
    -- The player can be nil if the adapter was built before Roblox created it (autoexecute).
    if not self.player then
        local players = game:GetService("Players")
        while not players.LocalPlayer do players:GetPropertyChangedSignal("LocalPlayer"):Wait() end
        self.player = players.LocalPlayer
    end
    if not self.loaded then
        self.missingRemotes = {}
        local remotes = self.replicated:FindFirstChild("Remotes")
        local function on(name, fn)
            local remote = remotes and remotes:FindFirstChild(name)
            if remote then connect(self, remote.OnClientEvent, fn) else table.insert(self.missingRemotes, name) end
        end
        on("MatchState", function(state) self:_onState(state) end)
        on("MatchEvent", function(kind, data) self:_onEvent(kind, data) end)
        on("PlaceResult", function(result) self:_onPlace(result) end)
        on("LobbyRoom", function(data) self:_onRoom(data) end)
        on("InventoryResult", function(data) if type(data) == "table" then self.inventory = data end end)
        on("SettingsResult", function(data) if type(data) == "table" then self.gameSettings = data end end)
        on("QuestUpdate", function(data) if type(data) == "table" then self.quests = data end end)
        on("BattlePassUpdate", function(data) if type(data) == "table" then self.pass = data end end)
        on("Notify", function(message)
            self.notice = tostring(message)
            local level = self.notice:match("[Ll]evel up!.-level (%d+)")
            if level then table.insert(self.levelUps, { Level = tonumber(level), At = os.clock() }) end
        end)
        -- PullAnnounce is global ("<user> obtained <unit>"); entries naming me are my drops/pulls.
        on("PullAnnounce", function(data)
            if type(data) ~= "table" then return end
            if data.user ~= self.player.Name and data.user ~= self.player.DisplayName then return end
            table.insert(self.announced, { Name = tostring(data.unit), Rarity = data.rarity, Shiny = data.shiny == true,
                Verb = data.verb, At = os.clock() })
            if #self.announced > 40 then table.remove(self.announced, 1) end
        end)
        -- ActiveFX(abilityId, unitModel, fx) is the server confirming an active ability: the macro recorder reads it.
        on("ActiveFX", function(ability, model, fx)
            local info = typeof(model) == "Instance" and self.units[model]
            if info then
                self.abilitySeq = self.abilitySeq + 1
                table.insert(self.abilityLog, { Seq = self.abilitySeq, Model = model, Ability = tostring(ability),
                    Duration = type(fx) == "table" and tonumber(fx.duration) or nil, Server = workspace:GetServerTimeNow() })
                if #self.abilityLog > 60 then table.remove(self.abilityLog, 1) end
            end
        end)
        local folder = self.world:FindFirstChild("PlacedUnits")
        if folder then self:_watchUnits(folder) end
        pcall(self._watchPrompts, self)
        connect(self, self.player.ChildAdded, function(child)
            if child:IsA("PlayerGui") then self:_watchPrompts() end
        end)
        connect(self, self.world.ChildAdded, function(child)
            if child.Name == "PlacedUnits" then self:_watchUnits(child) end
        end)
        self.loaded = true
    end
    self:_loadModules()
    pcall(function() self:Remote("InventoryRequest"):FireServer(true) end)   -- the same refresh the game's PlacementClient sends
    self:RequestSettings()
    return self.catalog
end

function Adapter:Read()
    local m = self.match or {}
    if m.state == "Prep" or m.state == "Wave" then pcall(self.MapModel, self) end   -- path status for the UI
    local units = 0
    for model in pairs(self.units) do if model.Parent then units = units + 1 end end
    return {
        Compatible = self:Matches(), Loaded = self.loaded, MatchKey = self.matchKey,
        State = m.state, Wave = self.wave, WaveCount = m.waveCount, Level = m.levelId, Title = m.levelTitle,
        Location = m.location, Difficulty = m.difficulty, Players = m.players,
        BaseHp = m.baseHp, Money = self:Money(), PlacedUnits = units, MyUnits = #self:MyUnits(),
        InRoom = self.room ~= nil, Equipped = self:EquippedNames(), GameSettings = self.gameSettings,
        Quests = self.quests, Pass = self.pass, ModuleErrors = self.moduleErrors, MissingRemotes = self.missingRemotes,
        Map = self.mapModel and self.mapModel.Name or m.mapName, PathLength = self.path and self.path.total or nil,
    }
end


function Adapter:MapKey()
    local m = self.match
    return m and (m.mapName or m.levelId) or nil
end

-- Actions (argument shapes copied from the game's own calls) ----------------------------------------
function Adapter:Action(...) self:Remote("MatchAction"):FireServer(...) end
function Adapter:VoteStart() self:Action("voteStart", true) end
function Adapter:VoteSkip() self:Action("voteSkip", true) end
function Adapter:Replay() self:Action("replay", "seamless") end
function Adapter:Restart() self:Action("restartMatch", "seamless") end
function Adapter:Leave() self:Action("leaveMatch") end
function Adapter:SetSpeed(value) self:Action("setSpeed", value) end
function Adapter:Upgrade(id) self:Action("upgrade", id) end
function Adapter:SetTarget(id, mode) self:Action("setTarget", id, mode) end
function Adapter:Sell(id) self:Remote("SellRequest"):FireServer({ copyId = id }) end
function Adapter:Ability(model) self:Remote("ActiveAbility"):FireServer("use", model) end
function Adapter:RoomAction(...) self:Remote("LobbyRoomAction"):FireServer(...) end
-- Equip / unequip an inventory unit. InventoryAction is the game's inventory remote (UnitPopup sends
-- { type = "lock" | "skin", id = ... } through it). The equip shape was inferred from those calls and is
-- confirmed working in-game; the macro Equipper still checks every change via InventoryResult.
function Adapter:EquipUnit(id, slot) self:Remote("InventoryAction"):FireServer({ type = "equip", id = id, slot = slot }) end
function Adapter:UnequipUnit(id) self:Remote("InventoryAction"):FireServer({ type = "unequip", id = id }) end
function Adapter:GameSetting(kind, value) self:Remote("SettingsRequest"):FireServer({ type = kind, value = value }) end

-- Places one unit and waits for PlaceResult (yields up to 2 s). Returns success, result.
function Adapter:Place(slot, position, yaw)
    local waiter = {}
    self.waiter = waiter
    self:Remote("PlaceRequest"):FireServer({ slot = slot, position = position, yaw = yaw or 0 })
    local deadline = os.clock() + 2
    while not waiter.Result and os.clock() < deadline and not self.disposed do task.wait(0.05) end
    if self.waiter == waiter then self.waiter = nil end
    local result = waiter.Result
    return result ~= nil and result.success == true and not result.sold, result
end

function Adapter:ClaimQuests()
    local result = self:Remote("Quests"):InvokeServer("claimAll")
    if type(result) == "table" and type(result.list) == "table" and type(result.list.claimable) == "table" then
        self.quests = result.list.claimable
    end
    return result
end

function Adapter:ClaimPass()
    local result = self:Remote("BattlePass"):InvokeServer("claim")
    if type(result) == "table" then self.pass = { claimable = result.claimable, tier = result.tier, xp = result.xp } end
    return result
end

-- Reward popups ("Click anywhere to continue") ------------------------------------------------------
-- The popup is built by a PlayerScripts LocalScript that isn't in the dumps, so it's found by its text:
-- PlayerGui text objects are tracked as they appear, and a visible match is clicked through.
Adapter.CONTINUE_PATTERNS = { "anywhere to continue", "tap to continue", "click to continue" }

local function continueText(object)
    local ok, value = pcall(function() return object.Text end)
    if not ok or type(value) ~= "string" then return false end
    local plain = value:gsub("<[^>]->", ""):lower()
    for _, pattern in ipairs(Adapter.CONTINUE_PATTERNS) do
        if plain:find(pattern, 1, true) then return true end
    end
    return false
end

function Adapter:_watchPrompts()
    local gui = self.player:FindFirstChildOfClass("PlayerGui")
    if not gui or self.promptGui == gui then return end
    self.promptGui, self.prompts = gui, {}
    local function track(object)
        if not (object:IsA("TextLabel") or object:IsA("TextButton")) then return end
        if continueText(object) then self.prompts[object] = true end
        -- Not kept in self.connections: it dies with the object, so the list doesn't grow with every UI the game builds.
        object:GetPropertyChangedSignal("Text"):Connect(function()
            if self.disposed or self.promptGui ~= gui then return end
            self.prompts[object] = continueText(object) or nil
        end)
    end
    for _, object in ipairs(gui:GetDescendants()) do track(object) end
    connect(self, gui.DescendantAdded, track)
    connect(self, gui.DescendantRemoving, function(object) self.prompts[object] = nil end)
end

local function shown(object)
    if object.TextTransparency >= 0.95 then return false end
    local node = object
    while node do
        if node:IsA("LayerCollector") then return node.Enabled end
        if node:IsA("GuiObject") and not node.Visible then return false end
        node = node.Parent
    end
    return false
end

-- A visible "continue" prompt, or nil.
function Adapter:ContinuePrompt()
    if not self.prompts then return nil end
    for object in pairs(self.prompts) do
        if object.Parent and shown(object) then return object end
    end
    return nil
end

-- Click on the prompt itself (inside the popup, so the click can't land on the game world).
function Adapter:ClickPrompt(prompt)
    local inset = game:GetService("GuiService"):GetGuiInset()
    local center = prompt.AbsolutePosition + prompt.AbsoluteSize / 2
    local x, y = math.floor(center.X), math.floor(center.Y + inset.Y)
    local ok = pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendMouseButtonEvent(x, y, 0, true, game, 0)
        task.wait(0.03)
        vim:SendMouseButtonEvent(x, y, 0, false, game, 0)
    end)
    if not ok and type(mousemoveabs) == "function" and type(mouse1click) == "function" then
        ok = pcall(function() mousemoveabs(x, y); mouse1click() end)
    end
    assert(ok, "This executor can't send clicks.")
end

-- Webhook report ---------------------------------------------------------------------------------
-- Player level: not in any captured remote or dumped module, so read best-effort from player attributes and
-- leaderstats, with the "Level up! You are now level N" notice as a fallback.
function Adapter:PlayerProgress()
    local found = {}
    for key, value in pairs(self.player:GetAttributes()) do
        if type(value) == "number" then found[key:lower()] = value end
    end
    local stats = self.player:FindFirstChild("leaderstats")
    for _, v in ipairs(stats and stats:GetChildren() or {}) do
        if v:IsA("ValueBase") and tonumber(v.Value) then found[v.Name:lower()] = tonumber(v.Value) end
    end
    local function pick(...)
        for _, key in ipairs({ ... }) do if found[key] then return found[key] end end
        return nil
    end
    local level = pick("level", "playerlevel", "lvl", "accountlevel")
    local xp = pick("xp", "exp", "experience", "playerxp", "levelxp")
    local needed = pick("xpneeded", "maxxp", "xpmax", "nextxp", "requiredxp", "xpgoal")
    if not level and #self.levelUps > 0 then level = self.levelUps[#self.levelUps].Level end
    return { Level = level, Xp = xp, Needed = needed, Raw = found }
end

-- Current account totals from the last InventoryResult (gems, gold = money, trait rerolls).
function Adapter:Totals()
    local inv = type(self.inventory) == "table" and self.inventory or {}
    return { Gems = tonumber(inv.gems), Gold = tonumber(inv.money), Rerolls = tonumber(inv.traitRerollers) }
end

-- Ask the server for a fresh InventoryResult (the same call the game's PlacementClient makes after results).
function Adapter:RequestInventory()
    pcall(function() self:Remote("InventoryRequest"):FireServer(true) end)
end

local function addDrop(list, index, id, count)
    if type(id) ~= "string" or type(count) ~= "number" then return end
    local entry = index[id]
    if entry then entry.Count = entry.Count + count; return end
    entry = { Id = id, Count = count }
    index[id] = entry
    table.insert(list, entry)
end

-- Everything the webhook shows, from a MatchEvent "results" payload plus state gathered since the last report.
function Adapter:MatchReport(results, match)
    local data = type(results) == "table" and type(results.Data) == "table" and results.Data or {}
    local m = match or self.match or {}
    local event = type(data.event) == "table" and data.event or {}
    local drops, index = {}, {}
    for _, source in ipairs({ event.drops, event.raid, data.drops }) do
        if type(source) == "table" and type(source.items) == "table" then
            for _, item in ipairs(source.items) do addDrop(drops, index, item.id, item.count) end
        end
    end
    for _, currency in ipairs(type(event.currencies) == "table" and event.currencies or {}) do
        if not index[currency.item] then addDrop(drops, index, currency.item, currency.amount) end   -- often repeats raid items
    end
    local items = self.mods.ItemData
    for _, d in ipairs(drops) do
        d.Name, d.Rarity = d.Id, nil
        if items then
            local ok, name = pcall(GameContext.Call, items.nameOf, d.Id)
            if ok and type(name) == "string" and name ~= "" then d.Name = name end
            local okR, rarity = pcall(GameContext.Call, items.rarityOf, d.Id)
            if okR and type(rarity) == "string" then d.Rarity = rarity end
        end
    end
    local since = self.reportedAt
    local units, levelUp = {}, false
    for _, a in ipairs(self.announced) do if a.At > since then table.insert(units, a) end end
    for _, l in ipairs(self.levelUps) do if l.At > since then levelUp = true end end
    self.reportedAt = os.clock()
    local rewards = type(data.rewards) == "table" and data.rewards or {}
    local rerolls = type(event.drops) == "table" and tonumber(event.drops.rerollers) or (type(data.drops) == "table" and tonumber(data.drops.rerollers)) or nil
    local progress = self:PlayerProgress()
    progress.LevelUp = levelUp
    progress.Raw = nil
    return {
        Won = data.won == true, Title = data.levelTitle or m.levelTitle, Location = m.location,
        Difficulty = data.difficulty or m.difficulty, Waves = data.wavesCompleted or self.wave, WaveCount = data.waveCount or m.waveCount,
        Elapsed = tonumber(data.elapsed), Kills = tonumber(data.kills), FirstClear = data.firstClear == true, NewBest = data.newBest == true,
        Player = self.player.Name,
        Rewards = { Gems = tonumber(rewards.gems), Gold = tonumber(rewards.gold), Xp = tonumber(rewards.xp),
            Trophies = tonumber(rewards.trophies), Rerolls = rerolls },
        Totals = self:Totals(),
        Level = progress, Drops = drops, Units = units,
    }
end

-- A unit's active ability from ActiveData: { Id, Name, At (upgrade that unlocks it), Cooldown, First }, or nil.
function Adapter:AbilityFor(name)
    local data = self.mods.ActiveData
    if not data or type(data.UNIT_ACTIVES) ~= "table" then return nil end
    local entry = data.UNIT_ACTIVES[name]
    if type(entry) ~= "table" then return nil end
    local ability = type(data.ABILITIES) == "table" and data.ABILITIES[entry.id] or nil
    return { Id = entry.id, Name = ability and ability.name or entry.id, At = tonumber(entry.at) or 0,
        Cooldown = ability and tonumber(ability.cooldown) or 60, First = ability and tonumber(ability.firstCooldown) or 10 }
end

-- Names of equipped units that have an active ability (for the per-unit ability settings).
function Adapter:AbilityUnits()
    local list = {}
    for _, name in ipairs(self:EquippedNames()) do
        if name ~= "Empty" and self:AbilityFor(name) then table.insert(list, name) end
    end
    return list
end

-- True while a boss enemy is alive (enemies carry Boss; dying ones EnemyDying).
function Adapter:BossAlive()
    local folder = self.world:FindFirstChild("Enemies")
    if not folder then return false end
    for _, enemy in ipairs(folder:GetChildren()) do
        if enemy:GetAttribute("Boss") == true and enemy:GetAttribute("EnemyDying") ~= true then return true end
    end
    return false
end

-- Ask the server for the game's own settings (the game's SettingsClient sends an empty SettingsRequest).
function Adapter:RequestSettings()
    pcall(function() self:Remote("SettingsRequest"):FireServer() end)
end

-- Stages ------------------------------------------------------------------------------------------
function Adapter.ModeOf(level)
    if level.infinite then return "Infinite" end
    if level.raid then return "Raid" end
    if level.legend then return "Legend" end
    if level.castle then return "Castle" end
    if level.portal then return "Portal" end
    if level.event then return "Event" end
    return "Story"
end
function Adapter.AllKey(mode, location) return "all:" .. tostring(mode) .. "|" .. tostring(location) end
function Adapter.ModeKey(mode) return "mode:" .. tostring(mode) end
function Adapter.ChallengeKey(kind, location) return "challenge:" .. tostring(kind) .. "|" .. tostring(location) end

-- "challenge" / "daily" when the match is a challenge: the game adds the challenge modifier to MatchState.modifiers.
function Adapter:ChallengeKind(match)
    match = match or self.match
    if type(match) ~= "table" then return nil end
    if type(match.modifiers) ~= "table" then match = { modifiers = {}, difficulty = match.difficulty } end
    local names = {}
    local data = self.mods.ChallengeData
    if data and type(data.MODIFIERS) == "table" then
        for _, modifier in pairs(data.MODIFIERS) do
            if type(modifier) == "table" and type(modifier.name) == "string" then names[modifier.name:lower()] = true end
        end
    end
    for _, text in ipairs(match.modifiers) do
        local lower = tostring(text):lower()
        local hit = lower:find("challenge", 1, true) ~= nil
        for name in pairs(names) do if lower:find(name, 1, true) then hit = true end end
        if hit then return (lower:find("daily", 1, true) or match.difficulty == "Hard") and "daily" or "challenge" end
    end
    local area = self.area
    if area and area.Key == self.matchKey then
        local lower = area.Description:lower()
        if lower:find("^%s*daily challenge") then return "daily" end
        if lower:find("^%s*challenge") then return (area.Difficulty == "Hard") and "daily" or "challenge" end
    end
    return nil
end

-- { [mode] = { [location] = { { Id, Title, Act } ... in act order } } } from LevelData (built once).
function Adapter:LevelCatalog()
    if self.levelCatalog then return self.levelCatalog end
    local data = self.mods.LevelData
    if not data or type(data.Levels) ~= "table" then return nil end
    local catalog = {}
    for index, level in ipairs(data.Levels) do
        if type(level) == "table" and type(level.id) == "string" then
            local mode, location = Adapter.ModeOf(level), tostring(level.location or level.map or "Other")
            catalog[mode] = catalog[mode] or {}
            catalog[mode][location] = catalog[mode][location] or {}
            local ok, title = pcall(data.title, level)
            table.insert(catalog[mode][location], { Id = level.id, Act = tonumber(level.legendAct or level.act) or index, Index = index,
                Title = ok and type(title) == "string" and title ~= "" and title or tostring(level.name or level.id) })
        end
    end
    local challengeMaps = data.ChallengeMaps or (self.mods.ChallengeData and self.mods.ChallengeData.MAPS) or Adapter.CHALLENGE_MAPS
    catalog.Challenge = {}
    for _, location in ipairs(challengeMaps) do
        catalog.Challenge[location] = {}
        for i, kind in ipairs(Adapter.CHALLENGE_KINDS) do
            table.insert(catalog.Challenge[location], { Id = Adapter.ChallengeKey(kind.Kind, location), Title = kind.Title, Act = i, Index = i })
        end
    end
    for _, locations in pairs(catalog) do
        for _, acts in pairs(locations) do
            table.sort(acts, function(x, y) if x.Act ~= y.Act then return x.Act < y.Act end return x.Index < y.Index end)
        end
    end
    self.levelCatalog = catalog
    return catalog
end

-- Assignment keys for a stage, most specific first: its level id, then "all acts" of its map, then its gamemode.
function Adapter:AssignmentKeys(levelId, challengeKind)
    local keys = {}
    if type(levelId) ~= "string" then return keys end
    local data = self.mods.LevelData
    local ok, level = false, nil
    if data and data.byId then ok, level = pcall(data.byId, levelId) end
    if challengeKind == "challenge" or challengeKind == "daily" then
        local location = ok and type(level) == "table" and tostring(level.location or level.map or "Other") or "Other"
        table.insert(keys, Adapter.ChallengeKey(challengeKind, location))
        table.insert(keys, Adapter.AllKey("Challenge", location))
        table.insert(keys, Adapter.ModeKey("Challenge"))
        return keys
    end
    table.insert(keys, levelId)
    if ok and type(level) == "table" then
        local mode = Adapter.ModeOf(level)
        table.insert(keys, Adapter.AllKey(mode, tostring(level.location or level.map or "Other")))
        table.insert(keys, Adapter.ModeKey(mode))
    end
    return keys
end

-- Server clock, the time base of BuffUntil.
function Adapter:ServerNow() return workspace:GetServerTimeNow() end

-- Macro helpers ---------------------------------------------------------------------------------
function Adapter:AbilityEvents(after)
    local list = {}
    for _, event in ipairs(self.abilityLog) do if event.Seq > after then table.insert(list, event) end end
    return list
end

-- Position and facing of a placed unit (pivot), as plain numbers.
function Adapter:UnitPose(info)
    local ok, pivot = pcall(info.Model.GetPivot, info.Model)
    if not ok then return 0, 0, 0, 0 end
    local look = pivot.LookVector
    local function r(v) return math.floor(v * 100 + 0.5) / 100 end
    return r(pivot.Position.X), r(pivot.Position.Y), r(pivot.Position.Z), r(math.deg(math.atan2(-look.X, -look.Z)))
end

-- Hotbar slot currently holding a unit with this name (macros store names, so a reordered team still works).
function Adapter:SlotForName(name)
    for slot, unitName in ipairs(self:EquippedNames()) do
        if unitName == name then return slot end
    end
    return nil
end

-- Placement data from the game's own modules -------------------------------------------------------
function Adapter:Money()
    return tonumber(self.player:GetAttribute("MatchMoney")) or self.money   -- MatchConfig.MONEY_ATTRIBUTE
end

-- The current map: the workspace model with a Waypoints folder or Path model (not the PlacementArena fallback).
function Adapter:MapModel()
    local MatchPath = self.mods.MatchPath
    if not MatchPath then return nil end
    if self.mapModel and self.mapModel.Parent then return self.mapModel end
    if self.mapCheckedAt and os.clock() - self.mapCheckedAt < 3 then return nil end   -- the search is recursive: not every tick
    self.mapCheckedAt = os.clock()
    local found
    for _, child in ipairs(self.world:GetChildren()) do
        if child.Name ~= "PlacementArena" and child.Name ~= "PlacedUnits" and (child:IsA("Model") or child:IsA("Folder"))
            and child:FindFirstChild("Waypoints", true) then
            found = child; break
        end
    end
    if not found then found = MatchPath.findMap(self.match and self.match.mapName) end
    self.mapModel = found
    self.path = found and MatchPath.build(found) or nil
    return found
end

-- Point and flat direction on the enemy path at `percent` (0 = spawn, 100 = goal), as plain numbers.
function Adapter:PathFrame(percent)
    local MatchPath = self.mods.MatchPath
    if not (MatchPath and self:MapModel() and MatchPath.isUsable(self.path)) then return nil end
    local point, segment = MatchPath.pointAt(self.path, self.path.total * percent / 100)
    local direction = MatchPath.directionAt(self.path, segment)
    return { point.X, point.Y, point.Z }, { direction.X, direction.Z }
end

-- The game's placement check: surface type (not the path), slope, spacing, hill/ground rule.
-- Returns the snapped Vector3 or nil and the game's reason.
function Adapter:Validate(x, y, z, placement)
    local rules = self.mods.PlacementRules
    local point = Vector3.new(x, y + 15, z)
    if not rules then
        local ground = self:Ground(point)
        return ground, ground and nil or "No ground there"
    end
    local position, reason = rules.classify(point)
    if not position then return nil, reason end
    if rules.tooClose(position) then return nil, "Too close to another unit" end
    local hill = placement and rules.hillProblem(position, placement)
    if hill then return nil, hill end
    return position
end

-- Equipped unit in a hotbar slot: name, match cost, placement type and per-unit cap.
function Adapter:SlotInfo(slot)
    local inv = self.inventory
    if type(inv) ~= "table" or type(inv.equipped) ~= "table" then return nil end
    local id = inv.equipped[slot]
    if not id then return false end                       -- empty slot
    local cached = self.slotCache[slot]
    if cached and cached.Inventory == inv and cached.UnitId == id then return cached end
    local unit
    for _, u in ipairs(inv.units or {}) do if u.id == id then unit = u; break end end
    if not unit then return nil end
    local info = { Inventory = inv, UnitId = id, Name = unit.name }   -- Max stays nil when the game's cap can't be read
    local stats = self.mods.UnitStats
    if stats then
        local ok, resolved = pcall(GameContext.Call, stats.resolve, unit)
        if ok and type(resolved) == "table" then
            info.Cost = tonumber(resolved.cost)
            info.Placement = type(resolved.roles) == "table" and resolved.roles.placement or nil
        end
        local okMax, max = pcall(GameContext.Call, stats.maxPlaced, unit.trait, unit.name)   -- spawnCap 1-6, trait limits
        if okMax and tonumber(max) then info.Max = tonumber(max) end
        if not info.Max then
            local okCap, cap = pcall(GameContext.Call, stats.unitCap, unit.name)
            if okCap and tonumber(cap) then info.Max = tonumber(cap) end
        end
    end
    self.slotCache[slot] = info
    return info
end

-- Show where autoplay will build: a neon ball on the path for a few seconds.
-- Show where autoplay will build for 8 s: a tall glowing column and ring on the track point, plus a dot on each
-- candidate spot. Parented to the camera so Delete map (which hides new workspace objects) leaves it alone.
function Adapter:Preview(base, spots)
    local old = self.previewFolder
    if old then pcall(function() old:Destroy() end) end
    local folder = Instance.new("Folder")
    folder.Name = "GogHubPreview"
    local accent = Color3.fromRGB(180, 138, 255)
    local function part(size, cframe, shape, transparency, color)
        local p = Instance.new("Part")
        p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
        p.Material = Enum.Material.Neon
        p.Color = color or accent
        p.Transparency = transparency or 0
        if shape then p.Shape = shape end
        p.Size = size
        p.CFrame = cframe
        p.Parent = folder
        return p
    end
    local x, y, z = base[1], base[2], base[3]
    part(Vector3.new(0.6, 40, 0.6), CFrame.new(x, y + 20, z), nil, 0.25)                                   -- column
    part(Vector3.new(0.3, 7, 7), CFrame.new(x, y + 0.2, z) * CFrame.Angles(0, 0, math.rad(90)), Enum.PartType.Cylinder, 0.45) -- ring
    for _, spot in ipairs(spots or {}) do
        part(Vector3.new(1.4, 1.4, 1.4), CFrame.new(spot + Vector3.new(0, 0.9, 0)), Enum.PartType.Ball, 0, Color3.fromRGB(155, 227, 201))
    end
    folder.Parent = self.world.CurrentCamera or self.world
    self.previewFolder = folder
    task.delay(8, function()
        if self.previewFolder == folder then self.previewFolder = nil end
        pcall(function() folder:Destroy() end)
    end)
end

-- World helpers -------------------------------------------------------------------------------
function Adapter:Ground(position)
    local params = RaycastParams.new()
    local ignore = {}
    for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
        if player.Character then table.insert(ignore, player.Character) end
    end
    local folder = self.world:FindFirstChild("PlacedUnits")
    if folder then table.insert(ignore, folder) end
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = ignore
    local hit = self.world:Raycast(position + Vector3.new(0, 12, 0), Vector3.new(0, -80, 0), params)
    return hit and hit.Position or nil
end

function Adapter:CharacterGround()
    local character = self.player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    assert(root, "Your character isn't loaded.")
    return assert(self:Ground(root.Position), "No ground below your character.")
end

-- Ground point near (x, y, z) for a placement, or the raw point when nothing is hit.
function Adapter:PlacementPoint(x, y, z)
    local point = Vector3.new(x, y, z)
    return self:Ground(point) or point
end

function Adapter:Dispose()
    self.disposed = true
    for _, connection in ipairs(self.connections) do pcall(function() connection:Disconnect() end) end
    self.connections = {}
end

return Adapter

end)()

local AntiAFK = (function()
-- AntiAFK: generic Roblox idle prevention (VirtualUser click on Player.Idled, at most once per 60 s).
-- Game-specific AFK timers are NOT handled here; add them in your own controller if a game needs it.
local Anti = {}
Anti.__index = Anti

function Anti.new(player, options)
    options = options or {}
    local self = setmetatable({ player = player, clock = options.Clock or os.clock,
        notify = options.Notify or function() end, enabled = false, status = "Off" }, Anti)
    if player and player.Idled then
        self.idled = player.Idled:Connect(function() self:Pulse() end)
    end
    return self
end

function Anti:Pulse()
    if self.disposed or not self.enabled then return end
    local now = self.clock()
    if now - (self.lastPulse or -math.huge) < 5 then return end
    self.lastPulse = now
    local ok, err = pcall(function()
        local virtual = game:GetService("VirtualUser")
        virtual:CaptureController()
        virtual:ClickButton2(Vector2.new(0, 0))
    end)
    self.status = ok and "Active" or "Error"
    if not ok and not self.warned then self.warned = true; self.notify("Anti-AFK", err, "Error") end
end

function Anti:Step(settings)
    if self.disposed then return end
    self.enabled = settings.AntiAFK == true
    if not self.enabled then self.status = "Off"; return end
    if self.status == "Off" then self.status = "Active" end
    -- Some games kick on their own timers; a periodic pulse keeps Roblox idle at bay too.
    if self.clock() - (self.lastPulse or -math.huge) >= 60 then self:Pulse() end
end

function Anti:Dispose()
    self.disposed = true
    if self.idled then self.idled:Disconnect(); self.idled = nil end
end

return Anti

end)()

local Controller = (function()
-- Controller: the GogHub job-supervisor pattern, shared by every feature.
-- App calls controller:Step(settings) every Heartbeat. Step never blocks: it runs one feature Tick at a time
-- in its own thread, rate-limited, and cancels a Tick that hangs (8 s) and pauses instead of freezing.
-- A feature is a table with:
--   Enabled(settings) -> bool    Interval(settings) -> seconds    Tick(settings) (may yield)
--   Stop() (optional, restore state)    status (string shown in the UI)
local Controller = {}
Controller.__index = Controller
Controller.TIMEOUT = 8

function Controller.new(name, feature, options)
    options = options or {}
    local hasTask = type(task) == "table"
    return setmetatable({
        name = name, feature = feature,
        clock = options.Clock or os.clock,
        spawn = options.Spawn or (hasTask and task.spawn),
        cancel = options.Cancel or (hasTask and task.cancel),
        notify = options.Notify or function() end,
        status = "Off", steps = 0, enabled = false,
    }, Controller)
end

function Controller:Step(settings)
    if self.disposed then return end
    local feature = self.feature
    if not feature:Enabled(settings) then
        if self.enabled then self:Stop() end
        return
    end
    self.enabled = true
    local now = self.clock()
    if self.job and not self.job.Done then
        if now - self.job.At < Controller.TIMEOUT then return end      -- still working
        if self.job.Thread then pcall(self.cancel, self.job.Thread) end
        self.job = nil; self.error = "Worker timed out. Toggle the feature to retry."
    end
    if self.error then self.status = "Paused: " .. tostring(self.error):gsub("^.-:%d+: ", ""); return end
    if not self.lastStep then self.status = "Starting" else self.status = feature.status or "Running" end
    if now - (self.lastStep or -math.huge) < feature:Interval(settings) then return end
    self.lastStep = now
    local job = { At = now }
    self.job = job
    job.Thread = self.spawn(function()
        local ok, err = pcall(feature.Tick, feature, settings)
        job.Done = true
        self.steps = self.steps + 1
        if not ok and self.enabled then
            self.error = tostring(err); self.status = "Paused: " .. self.error:gsub("^.-:%d+: ", ""); self.notify(self.name, err, "Error")
        elseif self.enabled then
            self.status = feature.status or "Running"
        end
    end)
end

function Controller:Stop()
    if self.job and not self.job.Done and self.job.Thread then pcall(self.cancel, self.job.Thread) end
    self.job = nil; self.enabled = false; self.error = nil; self.status = "Off"
    if self.feature.Stop then pcall(self.feature.Stop, self.feature) end
end

function Controller:Dispose()
    self:Stop()
    self.disposed = true
end

return Controller

end)()

local Automation = (function()
-- Automation: the game features. Each one is driven by a Controller (App §12) and only talks to the adapter,
-- so tests run them against a fake adapter. Constructors take (adapter, clock).
local Automation = {}

local function class()
    local c = {}
    c.__index = c
    return c
end

local function inMatch(match)
    return match ~= nil and (match.state == "Prep" or match.state == "Wave")
end


-- Match: vote start, vote skip, restart at a wave, replay or leave on results ---------------------------
local Match = class()
Automation.Match = Match

function Match.new(adapter, clock)
    return setmetatable({ adapter = adapter, clock = clock or os.clock, sent = {}, status = "Idle" }, Match)
end
function Match:Enabled(s) return s.AutoStart or s.AutoSkip or s.EndAction ~= "Off" or s.RestartWave > 0 or s.GameSpeed ~= "Off" end

-- Game speed: MatchAction("setSpeed", n) like the game's speed button; only 1 (1x) and 2 (1.5x) are accepted.
Match.SPEEDS = { ["1x"] = { Value = 1, Factor = 1 }, ["1.5x"] = { Value = 2, Factor = 1.5 } }
function Match:_speed(s, key, phase)
    local speed = Match.SPEEDS[s.GameSpeed]
    if not speed then self.adapter.gameSpeed = nil; return end
    self.adapter.gameSpeed = speed.Factor                -- ability/buff timers use it until they measure the real speed
    if self:_due("speed" .. phase, key, 4, 2) then self.adapter:SetSpeed(speed.Value) end
end
function Match:Interval() return 0.5 end

-- True when an action for this match may be sent now (at most `max` times, `retry` seconds apart).
function Match:_due(name, key, retry, max)
    local entry = self.sent[name]
    local now = self.clock()
    if not entry or entry.Key ~= key then entry = { Key = key, Count = 0, Last = -math.huge }; self.sent[name] = entry end
    if entry.Count >= max or now - entry.Last < retry then return false end
    entry.Count = entry.Count + 1; entry.Last = now
    return true
end

-- Claim every finished quest once per match before a replay or restart wipes the match (Quests "claimAll").
function Match:_claimFirst(s, key)
    if not s.ClaimBeforeRestart or self.claimedKey == key then return end
    self.claimedKey = key
    local ok, result = pcall(self.adapter.ClaimQuests, self.adapter)
    self.claimed = ok and type(result) == "table" and tostring(result.message or (result.success and "Quests claimed" or "Nothing to claim")) or "Quest claim failed"
end

function Match:Tick(s)
    local a = self.adapter
    local key, m = a.matchKey, a.match
    local results = a.results
    if results and results.Key == key then
        if s.EndAction == "Off" then self.status = "Match finished"; return end
        local seen = self.sent.results
        if not seen or seen.Key ~= key then seen = { Key = key, At = self.clock() }; self.sent.results = seen end
        if self.clock() - seen.At < s.EndDelay then self.status = "Results: waiting " .. s.EndDelay .. " s"; return end
        local replay = s.EndAction == "Replay" and (type(results.Data) ~= "table" or results.Data.canReplay ~= false)
        if self:_due("end", key, 8, 3) then
            if replay then self:_claimFirst(s, key); a:Replay() else a:Leave() end
        end
        self.status = replay and "Replaying" or "Leaving"
        return
    end
    if not inMatch(m) then self.status = "Waiting for match"; return end
    if m.state == "Prep" then
        self:_speed(s, key, "prep")
        if s.AutoStart and self:_due("start", key, 6, 5) then a:VoteStart() end
        self.status = s.AutoStart and "Voted start" or "Prep"
        return
    end
    local wave = a.wave or 0
    self:_speed(s, key, "wave")                          -- again once waves begin, in case the game reset it
    if s.RestartWave > 0 and wave >= s.RestartWave then
        if self:_due("restart", key, 10, 3) then self:_claimFirst(s, key); a:Restart() end
        self.status = "Restarting at wave " .. wave
        return
    end
    if s.AutoSkip and wave >= s.SkipFromWave and self:_due("skip" .. wave, key, 5, 2) then a:VoteSkip() end
    self.status = "Wave " .. wave
end

-- Placer: place each hotbar slot's units beside the enemy path (or around a saved position) ----------------
-- Candidate spots are checked with the game's own PlacementRules (through adapter:Validate) before sending,
-- and a slot waits until the match cash covers its cost.
local Placer = class()
Automation.Placer = Placer
Placer.GOLDEN = 2.399963229728653   -- golden angle: evenly spread points at any count
Placer.MAX_CHECKS = 60              -- validations per tick
local atan2 = math.atan2 or math.atan

function Placer.new(adapter, clock)
    return setmetatable({ adapter = adapter, clock = clock or os.clock, status = "Idle", fails = {}, held = {} }, Placer)
end
function Placer:Enabled(s) return s.Autoplay end
function Placer:Interval(s) return s.PlaceInterval end

function Placer.Spot(anchor, index, spacing)
    if index == 0 then return anchor[1], anchor[2], anchor[3] end
    local radius = spacing * math.sqrt(index)
    local angle = index * Placer.GOLDEN
    return anchor[1] + radius * math.cos(angle), anchor[2], anchor[3] + radius * math.sin(angle)
end

-- Spots beside the path: rows on both sides at spacing multiples, stepping along the path, nearest first.
function Placer.PathCandidates(base, direction, spacing)
    local dx, dz = direction[1], direction[2]
    local px, pz = -dz, dx                     -- perpendicular, flat
    local list = {}
    for along = -4, 4 do
        for side = 1, 5 do
            for _, sign in ipairs({ 1, -1 }) do
                local a, o = along * spacing, sign * side * spacing
                table.insert(list, { base[1] + dx * a + px * o, base[2], base[3] + dz * a + pz * o, a * a + o * o })
            end
        end
    end
    table.sort(list, function(x, y) return x[4] < y[4] end)
    return list
end

function Placer.SpiralCandidates(anchor, spacing)
    local list = {}
    for i = 0, Placer.MAX_CHECKS - 1 do
        local x, y, z = Placer.Spot(anchor, i, spacing)
        list[i + 1] = { x, y, z }
    end
    return list
end

-- Yaw (degrees) that faces a unit at (x, z) toward (tx, tz).
function Placer.Yaw(x, z, tx, tz)
    if math.abs(tx - x) < 1e-6 and math.abs(tz - z) < 1e-6 then return 0 end
    return math.deg(atan2(-(tx - x), -(tz - z)))
end

local function message(result)
    return type(result) == "table" and tostring(result.message or result.error or result.reason or ""):lower() or ""
end

function Placer:_candidates(s)
    local a = self.adapter
    if s.PlaceMode == "Path" then
        local base, direction = a:PathFrame(s.TrackPercent)
        if not base then return nil, "No enemy path found on this map" end
        return Placer.PathCandidates(base, direction, s.PlaceSpacing), base
    end
    local map = a:MapKey()
    local anchor = map and s.Anchors[map]
    if not anchor then return nil, "Save a position for " .. tostring(map or "this map") end
    return Placer.SpiralCandidates(anchor, s.PlaceSpacing), anchor
end

function Placer:Tick(s)
    local a = self.adapter
    if not inMatch(a.match) then self.status = "Waiting for match"; return end
    if self.key ~= a.matchKey then self.key = a.matchKey; self.fails = {}; self.held = {} end
    local now = self.clock()
    for slot = 1, #s.PlaceCounts do
        local info = a:SlotInfo(slot)
        local want = s.PlaceCounts[slot]
        if info then want = math.min(want, info.Max or want) end
        if info ~= false and want > 0 and a:PlacedCount(slot) < want and now >= (self.held[slot] or -math.huge) then
            local name = info and info.Name or ("slot " .. slot)
            local money = a:Money()
            if info and info.Cost and money and money < info.Cost then
                self.status = string.format("Waiting for %s (%d/%d cash)", name, math.floor(money), math.floor(info.Cost))
                return                                  -- keep slot order: don't skip ahead of a unit we can't afford yet
            end
            local candidates, target = self:_candidates(s)
            if not candidates then self.status = target; return end
            local reason
            for i = 1, math.min(#candidates, Placer.MAX_CHECKS) do
                local c = candidates[i]
                local position, why = a:Validate(c[1], c[2], c[3], info and info.Placement)
                if position then
                    local ok, result = a:Place(slot, position, Placer.Yaw(c[1], c[3], target[1], target[3]))
                    local text = message(result)
                    if ok then
                        self.fails[slot] = 0
                        self.status = string.format("Placed %s (%d/%d)", name, a:PlacedCount(slot), want)
                    elseif text:find("money") or text:find("afford") or text:find("cash") or text:find("enough") then
                        self.status = "Waiting for money (" .. name .. ")"
                    else
                        self.fails[slot] = (self.fails[slot] or 0) + 1
                        if text:find("max") or text:find("limit") or self.fails[slot] >= 3 then
                            self.held[slot] = now + 20; self.fails[slot] = 0
                        end
                        self.status = name .. " failed" .. (text ~= "" and (": " .. text) or "")
                    end
                    return
                end
                reason = why or reason
            end
            self.held[slot] = now + 10
            self.status = "No valid spot for " .. name .. (reason and (" (" .. reason .. ")") or "")
            return
        end
    end
    self.status = "All units placed"
end

-- Units in upgrade-priority order (slot labels "Slot N" from the priority list; unknown slots last).
function Automation.Ordered(units, order)
    local rank = {}
    for i, label in ipairs(order) do rank[tonumber(label:match("%d+"))] = i end
    local list = {}
    for i, unit in ipairs(units) do list[i] = unit end
    table.sort(list, function(x, y)
        local rx, ry = rank[x.Slot] or 99, rank[y.Slot] or 99
        if rx ~= ry then return rx < ry end
        return x.Id < y.Id
    end)
    return list
end

-- Upgrader: one upgrade per interval. Priority mode finishes the top slot first; Even raises the lowest level.
-- With the unit's level and next cost known (UpgradeLevel / Cost attributes), it only sends affordable upgrades.
local Upgrader = class()
Automation.Upgrader = Upgrader

function Upgrader.new(adapter) return setmetatable({ adapter = adapter, index = 0, status = "Idle" }, Upgrader) end
function Upgrader:Enabled(s) return s.AutoUpgrade end
function Upgrader:Interval(s) return s.UpgradeInterval end
function Upgrader:Tick(s)
    local a = self.adapter
    if not inMatch(a.match) then self.status = "Waiting for match"; return end
    local units = Automation.Ordered(a:MyUnits(), s.UpgradeOrder)
    if #units == 0 then self.status = "No units placed"; return end
    local open = {}
    for _, unit in ipairs(units) do
        local cap = math.min(s.UpgradeLimit, unit.MaxLevel or s.UpgradeLimit)
        if unit.Level == nil or unit.Level < cap then table.insert(open, unit) end
    end
    if #open == 0 then self.status = "All units at the upgrade limit"; return end
    if s.UpgradeFarmsFirst then
        -- Farms (Role = "Farm") take every upgrade until they're maxed; the others wait, even if a farm isn't affordable yet.
        local farms = {}
        for _, unit in ipairs(open) do if unit.Role == "Farm" then table.insert(farms, unit) end end
        if #farms > 0 then open = farms end
    end
    local unit
    if open[1].Level == nil then                       -- levels unknown: cycle
        self.index = self.index % #open + 1
        unit = open[self.index]
    elseif s.UpgradeMode == "Even" then
        unit = open[1]
        for _, u in ipairs(open) do if (u.Level or 0) < (unit.Level or 0) then unit = u end end
    else
        unit = open[1]
    end
    local money = a:Money()
    if unit.NextCost and money and money < unit.NextCost then
        self.status = string.format("Waiting for %s upgrade (%d/%d cash)", unit.Name, math.floor(money), math.floor(unit.NextCost))
        return
    end
    a:Upgrade(unit.Id)
    self.status = string.format("Upgrading %s%s", unit.Name, unit.Level and (" to " .. (unit.Level + 1)) or "")
end

-- Targeter: set each new unit's targeting mode once per match --------------------------------------------
local Targeter = class()
Automation.Targeter = Targeter

function Targeter.new(adapter) return setmetatable({ adapter = adapter, done = {}, status = "Idle" }, Targeter) end
function Targeter:Enabled(s) return s.TargetMode ~= "Off" end
function Targeter:Interval() return 0.5 end
function Targeter:Tick(s)
    local a = self.adapter
    if self.key ~= a.matchKey then self.key = a.matchKey; self.done = {} end
    for _, unit in ipairs(a:MyUnits()) do
        if self.done[unit.Id] ~= s.TargetMode then
            a:SetTarget(unit.Id, s.TargetMode)
            self.done[unit.Id] = s.TargetMode
            self.status = unit.Name .. " -> " .. s.TargetMode
            return
        end
    end
    self.status = "All units on " .. s.TargetMode
end

-- Abilities (smart auto ability): per unit, choose when its active ability fires.
--   On cooldown  - whenever it's ready.        From wave - from wave N on, whenever ready.
--   Boss         - only while a boss is alive.  Off      - never.
-- Units you haven't configured use the default mode. Every use respects the game's rules (ActiveData): the
-- ability unlocks at an upgrade level ("at"), can't be used for firstCooldown seconds after placement, and then
-- has a cooldown (both scaled by match speed). Uses are confirmed by the server's ActiveFX; an unconfirmed use
-- is retried after a moment. Units in an Erwin / Wendy / Kisuke rotation are left to the rotation.
local Abilities = class()
Automation.Abilities = Abilities
Abilities.MODES = { "On cooldown", "From wave", "Boss", "Off" }
Abilities.CONFIRM = 3
Abilities.RETRY = 3

function Abilities.new(adapter, clock)
    return setmetatable({ adapter = adapter, clock = clock or os.clock, usedAt = {}, retryAt = {}, status = "Idle" }, Abilities)
end
function Abilities:Enabled(s) return s.AutoAbility end
function Abilities:Interval() return 0.25 end

-- The mode and wave that apply to a unit name.
function Abilities.ModeFor(s, name)
    local custom = s.AbilityUnits[name]
    if custom and custom.Mode ~= "Default" then return custom.Mode, custom.Wave or s.AbilityFromWave end
    return s.AbilityDefault, s.AbilityFromWave
end

function Abilities:Tick(s)
    local a = self.adapter
    if self.key ~= a.matchKey then self.key, self.usedAt, self.retryAt, self.pending = a.matchKey, {}, {}, nil end
    local m = a.match
    if not m or m.state ~= "Wave" then self.status = "Waiting for a wave"; return end
    local now = self.clock()
    local scale = a.speedScale or Automation.Buffs.ModifierScale(m) or (a.gameSpeed and 1 / a.gameSpeed) or 1
    -- Confirm the last use.
    local pending = self.pending
    if pending then
        for _, event in ipairs(a:AbilityEvents(pending.Seq)) do
            if event.Model == pending.Model then self.usedAt[pending.Model] = pending.At; self.pending = nil; break end
        end
        if self.pending then
            if now - pending.At < Abilities.CONFIRM then return end
            self.retryAt[pending.Model] = now + Abilities.RETRY
            self.pending = nil
        end
    end
    local boss = a:BossAlive()
    local wave = a.wave or 0
    local waiting
    local units = a:MyUnits()
    for _, unit in ipairs(units) do
        local ability = not Automation.Rotated(s, unit.Name, units) and a:AbilityFor(unit.Name) or nil
        if ability then
            local mode, fromWave = Abilities.ModeFor(s, unit.Name)
            local reason
            if mode == "Off" then reason = nil
            elseif unit.Level ~= nil and unit.Level < (ability.At or 0) then reason = "needs upgrade " .. ability.At
            elseif mode == "From wave" and wave < fromWave then reason = "wave " .. fromWave
            elseif mode == "Boss" and not boss then reason = "boss"
            else
                local ready = (unit.At or -math.huge) + (ability.First or 0) * scale
                local used = self.usedAt[unit.Model]
                if used then ready = math.max(ready, used + (ability.Cooldown or 60) * scale) end
                local retry = self.retryAt[unit.Model]
                if retry then ready = math.max(ready, retry) end
                if ready <= now then
                    a:Ability(unit.Model)
                    self.pending = { Model = unit.Model, At = now, Seq = a.abilitySeq or 0 }
                    self.status = "Used " .. unit.Name .. (mode == "Boss" and " on the boss" or "")
                    return
                end
                reason = string.format("ready in %ds", math.ceil(ready - now))
            end
            if reason and not waiting then waiting = unit.Name .. ": " .. reason end
        end
    end
    self.status = waiting and ("Waiting - " .. waiting) or "No abilities to use"
end
function Abilities:Stop() self.usedAt, self.retryAt, self.pending = {}, {}, nil end

-- Buff rotations (Auto Erwin / Auto Wendy / Auto Kisuke) -----------------------------------------------------
-- ActiveData: erwin:buff_units, wendy:buff_units and kisuke:buff are ally buffs lasting 20 s with a 60 s
-- cooldown, so three units of one kind keep their buff up permanently: buff with one, and when that buff ends
-- use the next, then the third, repeat. Kisuke (Bankai)'s buff unlocks at upgrade 6 (ActiveData "at").
-- Timing follows the real buff, not a clock: the server's ActiveFX(ability, unit, { duration }) marks the start
-- (server time), and buffed units' BuffUntil (server time; Combat checks GetServerTimeNow() < BuffUntil) gives
-- the real end, which is shorter under match speed modifiers (20 s at 1.5x = 13.3 s). The measured ratio is
-- reused for later buffs; a "speed x1.5" match modifier is used until the first measurement.
local Buffs = class()
Automation.Buffs = Buffs
Buffs.NEEDED = 3
Buffs.LEAD = 0.25        -- fire this many seconds before the buff ends so there's no gap
Buffs.CONFIRM = 3        -- seconds for ActiveFX to confirm a buff; otherwise that unit is skipped (cooldown)
Buffs.FIRST_COOLDOWN = 10  -- ActiveData firstCooldown: no ability for 10 game-seconds after placement
Buffs.COOLDOWN = 60        -- ActiveData cooldown after each use (game-seconds; scaled by match speed)
Buffs.RETRY = 3            -- a use the server didn't confirm: try that unit again after this long
Buffs.SCALES = { 1, 1 / 1.5 }   -- real seconds per game second at the speeds the game offers (1x, 1.5x)
Buffs.GROUPS = {
    { Name = "Erwin", Setting = "AutoErwin", Pattern = "^erw[ei]n", MinLevel = 0, Duration = 20 },
    { Name = "Wendy", Setting = "AutoWendy", Pattern = "^wend", MinLevel = 0, Duration = 20 },
    { Name = "Kisuke", Setting = "AutoKisuke", Pattern = "^kisuke", MinLevel = 6, Duration = 20 },
}

function Automation.BuffGroupFor(name)
    local n = tostring(name or ""):lower()
    for _, group in ipairs(Buffs.GROUPS) do
        if n:find(group.Pattern) then return group end
    end
    return nil
end
function Automation.IsErwin(name)
    local group = Automation.BuffGroupFor(name)
    return group ~= nil and group.Name == "Erwin"
end
-- True when this unit's ability belongs to a rotation that's switched on (Auto ability and macros leave it alone).
function Automation.Rotated(s, name, units)
    local group = Automation.BuffGroupFor(name)
    if group == nil or s[group.Setting] ~= true then return false end
    if not units then return true end
    local count = 0
    for _, unit in ipairs(units) do
        if Automation.BuffGroupFor(unit.Name) == group and (unit.Level == nil or unit.Level >= group.MinLevel) then count = count + 1 end
    end
    return count >= Buffs.NEEDED
end

-- Real seconds per game second from a match modifier like "Game Speed x1.5" (nil when there's none).
function Buffs.ModifierScale(match)
    for _, text in ipairs(type(match) == "table" and type(match.modifiers) == "table" and match.modifiers or {}) do
        local lower = tostring(text):lower()
        if lower:find("speed") then
            local x = tonumber(lower:match("x%s*([%d%.]+)")) or tonumber(lower:match("([%d%.]+)%s*x"))
            if x and x > 0 then return 1 / x end
        end
    end
    return nil
end

function Buffs.new(adapter, clock)
    return setmetatable({ adapter = adapter, clock = clock or os.clock, groups = {}, status = "Idle" }, Buffs)
end
function Buffs:Enabled(s)
    for _, group in ipairs(Buffs.GROUPS) do if s[group.Setting] then return true end end
    return false
end
function Buffs:Interval() return 0.25 end

function Buffs:_tickGroup(group, s, units, serverNow, events)
    local g = self.groups[group.Name]
    local members = {}
    for _, unit in ipairs(units) do
        if Automation.BuffGroupFor(unit.Name) == group and (unit.Level == nil or unit.Level >= group.MinLevel) then
            table.insert(members, unit)
        end
    end
    table.sort(members, function(x, y) return x.Id < y.Id end)
    if #members < Buffs.NEEDED then
        return string.format("waiting for %d (%d ready)", Buffs.NEEDED, #members)
    end
    local now = self.clock()
    g.UsedAt, g.RetryAt = g.UsedAt or {}, g.RetryAt or {}
    local scale = self.scale or Buffs.ModifierScale(self.adapter.match) or (self.adapter.gameSpeed and 1 / self.adapter.gameSpeed) or 1
    -- When a unit can use its buff: 10 s after placement, 60 s after its last confirmed use (real seconds via scale).
    local function readyAt(unit)
        local at = (unit.At or -math.huge) + Buffs.FIRST_COOLDOWN * scale
        local used = g.UsedAt[unit.Model]
        if used then at = math.max(at, used + Buffs.COOLDOWN * scale) end
        local retry = g.RetryAt[unit.Model]
        if retry then at = math.max(at, retry) end
        return at
    end
    local pending = g.Pending
    if pending then
        for _, event in ipairs(events) do
            if event.Model == pending.Model and event.Seq > pending.Seq then
                g.UsedAt[pending.Model] = pending.At
                g.Start = event.Server or serverNow
                g.Duration = event.Duration or group.Duration
                g.End = g.Start + g.Duration * scale
                g.Measured = false
                g.Pending = nil
                break
            end
        end
        if g.Pending then
            if now - pending.At < Buffs.CONFIRM then return "buffing with #" .. g.Index end
            g.Pending = nil                                     -- never confirmed: that unit waits, the next one goes now
            g.RetryAt[pending.Model] = now + Buffs.RETRY
            g.End = nil
        end
    end
    -- Measure the real length once BuffUntil shows the new buff (the latest end within the expected window).
    if g.End and not g.Measured and g.Start then
        local best, bestScale
        for _, unit in ipairs(units) do
            local b = unit.BuffUntil
            if type(b) == "number" then
                local measured = (b - g.Start) / g.Duration
                for _, known in ipairs(Buffs.SCALES) do
                    if math.abs(measured - known) < 0.06 and (not best or b > best) then best, bestScale = b, known end
                end
            end
        end
        if best then
            g.End, g.Measured = best, true
            self.scale = bestScale                            -- snapped to a real game speed
            self.adapter.speedScale = self.scale              -- shared with smart auto ability
        end
    end
    if g.End and serverNow < g.End - Buffs.LEAD then
        return string.format("#%d up, next in %.1fs", g.Index, g.End - serverNow)
    end
    -- Next unit in rotation order that can actually use its buff; otherwise wait for the earliest one.
    local pick, soonest, soonestIndex
    for k = 1, #members do
        local index = (g.Index + k - 1) % #members + 1
        local at = readyAt(members[index])
        if at <= now then pick = index; break end
        if not soonest or at < soonest then soonest, soonestIndex = at, index end
    end
    if not pick then
        return string.format("waiting for #%d's ability (ready in %.1fs)", soonestIndex, soonest - now)
    end
    g.Index = pick
    local unit = members[g.Index]
    self.adapter:Ability(unit.Model)
    g.Pending = { Model = unit.Model, At = now, Seq = self.adapter.abilitySeq or 0 }
    return "buffed with #" .. g.Index
end

function Buffs:Tick(s)
    local a = self.adapter
    if self.key ~= a.matchKey then self.key, self.groups, self.scale = a.matchKey, {}, nil end
    local m = a.match
    if not m or m.state ~= "Wave" then self.status = "Waiting for a wave"; return end
    local units = a:MyUnits()
    local serverNow = a:ServerNow()
    local events = a:AbilityEvents(self.seenSeq or 0)
    local parts = {}
    for _, group in ipairs(Buffs.GROUPS) do
        if s[group.Setting] then
            self.groups[group.Name] = self.groups[group.Name] or { Index = 0 }
            table.insert(parts, group.Name .. ": " .. self:_tickGroup(group, s, units, serverNow, events))
        end
    end
    for _, event in ipairs(events) do self.seenSeq = math.max(self.seenSeq or 0, event.Seq) end
    if self.scale and math.abs(self.scale - 1) > 0.05 then table.insert(parts, string.format("speed x%.2f", 1 / self.scale)) end
    self.status = table.concat(parts, " | ")
end
function Buffs:Stop() self.groups, self.seenSeq = {}, nil end

-- Lobby: inside a room, select the stage and difficulty, then start -----------------------------------------
local Lobby = class()
Automation.Lobby = Lobby
Lobby.CASTLE = "infinity_castle"

function Lobby.new(adapter, clock)
    return setmetatable({ adapter = adapter, clock = clock or os.clock, status = "Idle" }, Lobby)
end
function Lobby:Enabled(s) return s.AutoJoin end
function Lobby:Interval() return 1 end
function Lobby:Tick(s)
    local a = self.adapter
    if a.match and a.match.state ~= "Lobby" then self.status = "In a match"; return end
    local want = s.JoinLevel .. "/" .. s.JoinDifficulty
    local now = self.clock()
    -- With Auto equip on, start only once the team for this stage is equipped.
    local function teamReady()
        if not s.MacroAutoEquip or a.teamReady == nil then return true end      -- nothing to equip for this stage
        return a.teamReady == true and a.teamReadyFor == s.JoinLevel
    end
    -- Infinity Castle has no room: the game's MuzanClient sends LobbyRoomAction("castle", difficulty) directly.
    if s.JoinLevel == Lobby.CASTLE then
        if not teamReady() then self.status = "Equipping the macro team for Infinity Castle"; return end
        if not self.castleAt or now - self.castleAt >= 8 then
            self.castleAt = now
            a:RoomAction("castle", s.JoinDifficulty)
            self.status = "Entering Infinity Castle (" .. s.JoinDifficulty .. ")"
        end
        return
    end
    local room = a.room
    if room then
        if room.Phase == "teleporting" then self.status = "Teleporting"; return end
        -- Challenge rooms come with their stage set (the game only sends "start"): don't change it.
        if room.Kind == "challenge" or room.Kind == "daily" then
            if not teamReady() then self.status = "Equipping the macro team for the challenge"; return end
            if not self.startedAt or self.key ~= room.Key or now - self.startedAt >= 6 then
                self.key, self.startedAt = room.Key, now
                a:RoomAction("start")
                self.status = "Starting the challenge (" .. tostring(room.Level) .. ")"
            end
            return
        end
        if self.key ~= room.Key or self.selection ~= want then
            a:RoomAction("select", s.JoinLevel, s.JoinDifficulty)
            self.key, self.selection, self.selectedAt, self.startedAt = room.Key, want, now, nil
            self.status = "Selected " .. want
            return
        end
        if not teamReady() then self.status = "Equipping the macro team for " .. s.JoinLevel; return end
        if now - self.selectedAt >= 1.5 and (not self.startedAt or now - self.startedAt >= 6) then
            a:RoomAction("start")
            self.startedAt = now
            self.status = "Starting " .. want
        end
        return
    end
    -- Not in a room yet: the game's LobbyClient only sends select + start, so try them directly.
    if not self.directAt or now - self.directAt >= 8 then
        self.directAt = now
        a:RoomAction("select", s.JoinLevel, s.JoinDifficulty)
        self.directStart = now + 1.5
        self.status = "Selecting " .. want
    elseif self.directStart and now >= self.directStart then
        if not teamReady() then self.status = "Equipping the macro team for " .. s.JoinLevel; return end
        self.directStart = nil
        a:RoomAction("start")
        self.status = "Starting " .. want .. " (walk into a room if nothing happens)"
    end
end

-- Popups: click through "Click anywhere to continue" reward reveals ----------------------------------------
local Popups = class()
Automation.Popups = Popups

function Popups.new(adapter) return setmetatable({ adapter = adapter, clicks = 0, status = "Idle" }, Popups) end
function Popups:Enabled(s) return s.AutoSkipPopups end
function Popups:Interval() return 0.4 end
function Popups:Tick()
    local prompt = self.adapter:ContinuePrompt()
    if not prompt then
        self.status = self.clicks > 0 and ("Watching (" .. self.clicks .. " skipped)") or "Watching"
        return
    end
    self.adapter:ClickPrompt(prompt)
    self.clicks = self.clicks + 1
    self.status = "Skipping popup (" .. self.clicks .. ")"
end

-- Rewards: claim quests and battle pass tiers when the game reports something claimable -------------------
local Rewards = class()
Automation.Rewards = Rewards

local function claimable(counts)
    if type(counts) ~= "table" then return nil end
    local total = 0
    for _, n in pairs(counts) do if type(n) == "number" then total = total + n end end
    return total
end

function Rewards.new(adapter, clock)
    return setmetatable({ adapter = adapter, clock = clock or os.clock, lastQuest = -math.huge, lastPass = -math.huge, status = "Idle" }, Rewards)
end
function Rewards:Enabled(s) return s.AutoClaimQuests or s.AutoClaimPass end
function Rewards:Interval() return 5 end
function Rewards:Tick(s)
    local a = self.adapter
    local now = self.clock()
    if s.AutoClaimQuests then
        local count = claimable(a.quests)
        -- Unknown count: try once a minute. Known count: claim as soon as it is above zero.
        if (count == nil and now - self.lastQuest >= 60) or (count and count > 0 and now - self.lastQuest >= 10) then
            self.lastQuest = now
            local okClaim, result = pcall(a.ClaimQuests, a)
            if not okClaim then result = nil end
            self.status = type(result) == "table" and tostring(result.message or (result.success and "Quests claimed" or "Nothing to claim")) or "Quests checked"
        end
    end
    if s.AutoClaimPass then
        local pass = a.pass
        local count = type(pass) == "table" and tonumber(pass.claimable) or nil
        if (count == nil and now - self.lastPass >= 60) or (count and count > 0 and now - self.lastPass >= 10) then
            self.lastPass = now
            local okPass, result = pcall(a.ClaimPass, a)
            if not okPass then result = nil end
            if type(result) == "table" and result.success then self.status = "Battle pass claimed" end
        end
    end
end

return Automation

end)()

local Macro = (function()
-- Macro: record and play back a match (place, sell, upgrade, targeting, abilities).
-- Recording is confirmation-driven: it watches the game's own state instead of hooking remotes, so only actions the
-- server accepted are saved. New units of mine in PlacedUnits = Place, a unit leaving = Sell, UpgradeLevel rising =
-- Upgrade, the TargetMode attribute changing = Target, ActiveFX naming my unit = Ability.
-- Files use logical unit keys (U1, U2 ...) and unit names, never the per-match copy ids.
-- Playback runs the actions strictly in order; each waits for its wave (optionally its time into the wave) and for
-- enough cash, and later actions act on whichever unit that key's placement produced in this match.
local Macro = {}
Macro.__index = Macro
Macro.SCHEMA = 1
Macro.TYPES = { Place = true, Sell = true, Upgrade = true, Target = true, Ability = true }
Macro.BIND_TIMEOUT = 5          -- seconds to wait for a placed unit's model
Macro.RESEND = 2                -- seconds between repeated upgrade sends for the same step (lag-safe)
Macro.ABILITY_CONFIRM = 3       -- seconds to wait for ActiveFX before resending an ability step
Macro.ABILITY_TRIES = 4

local function finite(n) return type(n) == "number" and n == n and math.abs(n) < 1e9 end

function Macro.Validate(data)
    assert(type(data) == "table" and data.Schema == Macro.SCHEMA and type(data.Actions) == "table", "Not a macro file (or an unsupported version).")
    assert(#data.Actions > 0, "The recording has no actions.")
    if data.Team ~= nil then
        assert(type(data.Team) == "table", "Invalid team in recording.")
        for _, entry in ipairs(data.Team) do
            assert(type(entry) == "table" and finite(entry.Slot) and entry.Slot >= 1 and entry.Slot <= 6 and entry.Id ~= nil, "Invalid team entry.")
        end
    end
    local placed = {}
    for i, a in ipairs(data.Actions) do
        local where = "Invalid macro step " .. i
        assert(type(a) == "table" and Macro.TYPES[a.Type] and type(a.Unit) == "string" and #a.Unit <= 16, where)
        assert(finite(a.Wave) and a.Wave >= 0 and finite(a.WaveTime) and a.WaveTime >= 0, where .. " (timing)")
        if a.Type == "Place" then
            assert(not placed[a.Unit], where .. " (unit placed twice)")
            assert(type(a.Name) == "string" and #a.Name > 0 and #a.Name <= 80, where .. " (unit name)")
            assert(finite(a.Slot) and a.Slot >= 1 and a.Slot <= 6 and a.Slot % 1 == 0, where .. " (slot)")
            assert(type(a.Position) == "table" and finite(a.Position[1]) and finite(a.Position[2]) and finite(a.Position[3]), where .. " (position)")
            assert(a.Yaw == nil or finite(a.Yaw), where .. " (yaw)")
            placed[a.Unit] = true
        else
            assert(placed[a.Unit], where .. " (unit was never placed)")
            if a.Type == "Upgrade" then assert(finite(a.Level) and a.Level >= 1 and a.Level % 1 == 0, where .. " (level)") end
            if a.Type == "Target" then assert(type(a.Mode) == "string" and #a.Mode > 0 and #a.Mode <= 20, where .. " (mode)") end
        end
    end
    return data
end

-- Human-readable step text for the UI.
function Macro.Describe(a)
    if not a then return "-" end
    local base = a.Type .. " " .. a.Unit
    if a.Type == "Place" then base = string.format("Place %s (%s, slot %d)", a.Unit, a.Name, a.Slot)
    elseif a.Type == "Upgrade" then base = string.format("Upgrade %s to %d", a.Unit, a.Level)
    elseif a.Type == "Target" then base = string.format("Target %s -> %s", a.Unit, a.Mode) end
    return base .. string.format(" @ wave %d", a.Wave)
end

function Macro.new(adapter, files, options)
    options = options or {}
    return setmetatable({ adapter = adapter, files = files, clock = options.Clock or os.clock,
        notify = options.Notify or function() end, status = "Idle", cache = {} }, Macro)
end

local function inMatch(m) return m ~= nil and (m.state == "Prep" or m.state == "Wave") end

function Macro:Enabled(s) return self.recording ~= nil or s.MacroPlay end
function Macro:Interval() return 0.25 end
function Macro:Busy() return self.recording ~= nil end
function Macro:Playing() return self.run ~= nil end

-- Recording -----------------------------------------------------------------------------------
function Macro:StartRecord(name)
    assert(self.files, "This executor has no file functions.")
    assert(not self.recording, "Already recording.")
    local a = self.adapter
    assert(inMatch(a.match), "Start recording in a match (prep or a wave).")
    local file = Storage.FileName(name)
    local known = {}
    for _, unit in ipairs(a:MyUnits()) do known[unit.Model] = false end      -- units placed before recording are ignored
    self.recording = { File = file, MatchKey = a.matchKey, Map = a:MapKey(), Level = a.match.levelId, Title = a.match.levelTitle,
        Difficulty = a.match.difficulty, Actions = {}, Known = known, Next = 1, AbilitySeq = a.abilitySeq or 0,
        Ignored = #a:MyUnits(), Team = Macro.CaptureTeam(a.inventory) }
    self.status = "Recording " .. file
    return file
end

function Macro:_add(r, action)
    local a = self.adapter
    action.Wave = a.wave or 0
    action.WaveTime = math.floor((a:WaveTime() or 0) * 100 + 0.5) / 100
    local money = a:Money()
    if money then action.Money = math.floor(money) end
    table.insert(r.Actions, action)
    r.Dirty = true
end

function Macro:_recordTick()
    local r, a = self.recording, self.adapter
    if a.matchKey ~= r.MatchKey or (a.results and a.results.Key == r.MatchKey) or not inMatch(a.match) then
        local file = self:StopRecord()
        self.notify("Macro", file and ("Saved " .. file .. " when the match ended") or "Recording stopped: match ended", "Success")
        return
    end
    local present = {}
    for _, unit in ipairs(a:MyUnits()) do
        present[unit.Model] = true
        local k = r.Known[unit.Model]
        if k == nil then
            local key = "U" .. r.Next
            r.Next = r.Next + 1
            local x, y, z, yaw = a:UnitPose(unit)
            self:_add(r, { Type = "Place", Unit = key, Name = unit.Name, Slot = unit.Slot or a:SlotForName(unit.Name) or 1,
                Position = { x, y, z }, Yaw = yaw })
            r.Known[unit.Model] = { Key = key, Level = unit.Level or 0, Target = unit.TargetMode }
        elseif k then
            if unit.Level and unit.Level > k.Level then
                for level = k.Level + 1, unit.Level do self:_add(r, { Type = "Upgrade", Unit = k.Key, Level = level }) end
                k.Level = unit.Level
            end
            if unit.TargetMode and unit.TargetMode ~= k.Target then
                self:_add(r, { Type = "Target", Unit = k.Key, Mode = unit.TargetMode })
                k.Target = unit.TargetMode
            end
        end
    end
    local gone = {}
    for model, k in pairs(r.Known) do
        if k and not present[model] then table.insert(gone, model) end
    end
    -- Several units vanishing at once is the match clearing them, not you selling: don't record those.
    for _, model in ipairs(gone) do
        if #gone < 3 then self:_add(r, { Type = "Sell", Unit = r.Known[model].Key }) end
        r.Known[model] = false
    end
    for _, event in ipairs(a:AbilityEvents(r.AbilitySeq)) do
        r.AbilitySeq = math.max(r.AbilitySeq, event.Seq)
        local k = r.Known[event.Model]
        if k then self:_add(r, { Type = "Ability", Unit = k.Key }) end
    end
    self.status = string.format("Recording %s: %d steps", r.File, #r.Actions)
end

function Macro:StopRecord()
    local r = self.recording
    if not r then return nil end
    self.recording = nil
    self.status = "Idle"
    if #r.Actions == 0 then return nil end
    self.lastSaved = r.File
    self.files:SaveData(r.File, { Schema = Macro.SCHEMA, Profile = Profile.Id, Map = r.Map, Level = r.Level, Title = r.Title,
        Difficulty = r.Difficulty, Created = os.time(), Actions = r.Actions, Team = r.Team })
    self.cache[r.File] = nil
    return r.File
end

-- Playback ------------------------------------------------------------------------------------
-- Recording for a stage: assigned to its act, then to "all acts" of its map, then (older assignments) to the
-- map name; otherwise the selected recording.
function Macro.FileForStage(adapter, s, levelId, mapName, challengeKind)
    local keys = adapter.AssignmentKeys and adapter:AssignmentKeys(levelId, challengeKind) or { levelId }
    for _, key in ipairs(keys) do
        if key and s.MacroMaps[key] then return s.MacroMaps[key], true end
    end
    if mapName and s.MacroMaps[mapName] then return s.MacroMaps[mapName], true end
    if s.MacroFile ~= "" then return s.MacroFile, false end
    return nil
end

function Macro:FileFor(s)
    local a = self.adapter
    return Macro.FileForStage(a, s, a.match and a.match.levelId, a:MapKey(), a.ChallengeKind and a:ChallengeKind() or nil)
end

function Macro:_load(file)
    local cached = self.cache[file]
    if cached then return cached end
    local data = Macro.Validate(assert(self.files:LoadData(file), "Recording not found: " .. file))
    self.cache[file] = data
    return data
end

function Macro:_unit(run, key)
    local model = run.Bound[key]
    if not model then return nil end
    if type(model) ~= "string" and model.Parent == nil then run.Bound[key] = nil; return nil end
    for _, unit in ipairs(self.adapter:MyUnits()) do
        if unit.Model == model then return unit end
    end
    return nil
end

function Macro:_next(run)
    run.Index = run.Index + 1
    run.Pending, run.SentAt, run.Tries = nil, nil, 0
end

function Macro:_place(run, step, s)
    local a = self.adapter
    local now = self.clock()
    if run.Pending then                                   -- placed: bind the model that appeared
        local bound = {}
        for _, model in pairs(run.Bound) do bound[model] = true end
        local pick
        for _, unit in ipairs(a:MyUnits()) do
            if not bound[unit.Model] and unit.Name == step.Name then
                local fresh = unit.At == nil or unit.At >= run.Pending - 0.5      -- appeared after our request
                if fresh and (not pick or unit.Id > pick.Id) then pick = unit end
            end
        end
        if pick then
            run.Bound[step.Unit] = pick.Model
            self:_next(run)
            return "Placed " .. step.Unit
        end
        if now - run.Pending < Macro.BIND_TIMEOUT then return "Waiting for " .. step.Name .. " to appear" end
        run.Pending = nil                                 -- never appeared: place again
    end
    local slot = a:SlotForName(step.Name) or step.Slot
    local info = a:SlotInfo(slot)
    if info == false then return "Slot " .. slot .. " is empty (needs " .. step.Name .. ")" end
    local money = a:Money()
    if info and info.Cost and money and money < info.Cost then
        return string.format("Waiting for cash: %s %d/%d", step.Name, math.floor(money), math.floor(info.Cost))
    end
    local p = step.Position
    local position, reason
    for i = 0, 11 do                                      -- the recorded spot, then the closest spots around it
        local x, y, z = p[1], p[2], p[3]
        if i > 0 then
            local angle, radius = i * 2.399963229728653, 1.5 * math.sqrt(i)
            x, z = x + radius * math.cos(angle), z + radius * math.sin(angle)
        end
        local why
        position, why = a:Validate(x, y, z, info and info.Placement)
        if position then break end
        reason = reason or why
    end
    if not position then return "Recorded spot for " .. step.Unit .. " is blocked" .. (reason and (" (" .. reason .. ")") or "") end
    local ok, result = a:Place(slot, position, step.Yaw or 0)
    if ok or result == nil then
        run.Pending = now
        return ok and ("Placed " .. step.Name .. ", binding") or ("No reply for " .. step.Name .. " yet, waiting")
    end
    local text = type(result) == "table" and tostring(result.message or result.error or "") or ""
    return "Place " .. step.Unit .. " failed" .. (text ~= "" and (": " .. text) or "")
end

function Macro:_act(run, step, s)
    local a = self.adapter
    local unit = self:_unit(run, step.Unit)
    if step.Type == "Ability" and s and unit and Automation.Rotated(s, unit.Name, a:MyUnits()) then
        self:_next(run)
        return "Skipped " .. unit.Name .. " ability (buff rotation handles it)"
    end
    if not unit then
        if step.Type == "Sell" or not run.Bound[step.Unit] then self:_next(run); return "Skipped " .. step.Type .. " " .. step.Unit .. " (unit missing)" end
        return "Waiting for " .. step.Unit .. " to load"
    end
    if step.Type == "Upgrade" then
        if unit.Level == nil then a:Upgrade(unit.Id); self:_next(run); return "Upgraded " .. step.Unit end
        if unit.Level >= step.Level then self:_next(run); return step.Unit .. " is level " .. unit.Level end
        if unit.MaxLevel and unit.Level >= unit.MaxLevel then self:_next(run); return step.Unit .. " is at its max level" end
        local money = a:Money()
        if unit.NextCost and money and money < unit.NextCost then
            return string.format("Waiting for cash: %s upgrade %d/%d", step.Unit, math.floor(money), math.floor(unit.NextCost))
        end
        local now = self.clock()
        if not run.SentAt or now - run.SentAt >= Macro.RESEND then a:Upgrade(unit.Id); run.SentAt = now end
        return "Upgrading " .. step.Unit .. " to " .. step.Level
    elseif step.Type == "Target" then
        a:SetTarget(unit.Id, step.Mode)
    elseif step.Type == "Sell" then
        a:Sell(unit.Id); run.Bound[step.Unit] = nil
    elseif step.Type == "Ability" then
        local now = self.clock()
        local ability = a.AbilityFor and a:AbilityFor(unit.Name) or nil
        if ability and unit.Level ~= nil and unit.Level < (ability.At or 0) then
            return step.Unit .. " ability needs upgrade " .. ability.At
        end
        if run.SentAt then
            for _, event in ipairs(a:AbilityEvents(run.AbilitySeq or 0)) do
                if event.Model == unit.Model then self:_next(run); return "Ability " .. step.Unit end
            end
            if now - run.SentAt < Macro.ABILITY_CONFIRM then return "Using " .. step.Unit .. "'s ability" end
            if (run.Tries or 0) >= Macro.ABILITY_TRIES then self:_next(run); return "Skipped " .. step.Unit .. "'s ability (not confirmed)" end
        end
        run.AbilitySeq = a.abilitySeq or 0
        a:Ability(unit.Model)
        run.SentAt, run.Tries = now, (run.Tries or 0) + 1
        return "Using " .. step.Unit .. "'s ability"
    end
    self:_next(run)
    return step.Type .. " " .. step.Unit
end

function Macro:_playTick(s)
    local a = self.adapter
    if not inMatch(a.match) then self.status = "Waiting for a match"; return end
    local file = self:FileFor(s)
    if not file then self.status = "Select a recording or assign one to this map"; return end
    if not self.run or self.run.Key ~= a.matchKey or self.run.File ~= file then
        self.run = { Key = a.matchKey, File = file, Index = 1, Bound = {}, Tries = 0 }
    end
    local run = self.run
    local okLoad, data = pcall(self._load, self, file)
    if not okLoad then self.status = "Can't play " .. file .. " (missing or damaged)"; return end
    local step = data.Actions[run.Index]
    if not step then self.status = string.format("%s complete (%d steps)", file, #data.Actions); return end
    local wave = a.wave or 0
    local prefix = string.format("%s %d/%d: ", file, run.Index, #data.Actions)
    if wave < step.Wave then self.status = prefix .. "waiting for wave " .. step.Wave; return end
    if s.MacroTiming == "Wave time" and wave == step.Wave and (a:WaveTime() or 0) < step.WaveTime then
        self.status = prefix .. string.format("waiting %.1fs into wave %d", step.WaveTime, step.Wave); return
    end
    local text
    if step.Type == "Place" then text = self:_place(run, step, s) else text = self:_act(run, step, s) end
    self.status = prefix .. text
end

function Macro:Tick(s)
    if self.recording then self:_recordTick() return end
    self:_playTick(s)
end

function Macro:Stop()
    self.run = nil
    if not self.recording then self.status = "Idle" end
end

function Macro:Current(s)
    local run = self.run
    if not run then return nil end
    local data = self.cache[run.File]
    return data and data.Actions[run.Index] or nil, run.Index, data and #data.Actions or 0
end

function Macro:Dispose()
    pcall(function() self:StopRecord() end)
    self.run = nil
end

-- Team equip ------------------------------------------------------------------------------------
-- Recordings keep the team that was equipped (Team = { { Slot, Id, Name } }). Older recordings have no Team, so
-- it's rebuilt from their Place steps (name + slot). Ids are inventory unit ids; if that copy is gone, the
-- highest-level copy with the same name is used.
function Macro.CaptureTeam(inventory)
    if type(inventory) ~= "table" or type(inventory.equipped) ~= "table" then return nil end
    local names = {}
    for _, unit in ipairs(inventory.units or {}) do names[unit.id] = unit.name end
    local team = {}
    for slot = 1, 6 do
        local id = inventory.equipped[slot]
        if id then table.insert(team, { Slot = slot, Id = id, Name = names[id] }) end
    end
    return team
end

-- Desired { [slot] = inventoryId } for a recording, plus the names that couldn't be found.
function Macro.TeamFor(data, inventory)
    local wanted = {}
    if type(data.Team) == "table" and #data.Team > 0 then
        for _, entry in ipairs(data.Team) do wanted[entry.Slot] = { Id = entry.Id, Name = entry.Name } end
    else
        for _, step in ipairs(data.Actions or {}) do
            if step.Type == "Place" and not wanted[step.Slot] then wanted[step.Slot] = { Name = step.Name } end
        end
    end
    local units = type(inventory) == "table" and inventory.units or {}
    local byId, used, desired, missing = {}, {}, {}, {}
    for _, unit in ipairs(units) do byId[unit.id] = unit end
    for slot = 1, 6 do
        local want = wanted[slot]
        if want then
            local pick = want.Id and byId[want.Id] and (want.Name == nil or byId[want.Id].name == want.Name) and byId[want.Id] or nil
            if not pick and want.Name then
                for _, unit in ipairs(units) do
                    if unit.name == want.Name and not used[unit.id] and (not pick or (unit.level or 0) > (pick.level or 0)) then pick = unit end
                end
            end
            if pick then desired[slot] = pick.id; used[pick.id] = true
            else table.insert(missing, tostring(want.Name or want.Id)) end
        end
    end
    return desired, missing
end

-- Equipper: in the lobby, make the equipped slots match the macro's team, one confirmed change at a time.
-- It unequips anything in a wrong slot first, then equips the right units slot by slot; this converges whether
-- the game honours the slot or appends/compacts.
local Equipper = {}
Equipper.__index = Equipper
Macro.Equipper = Equipper
Equipper.CONFIRM = 3      -- seconds to wait for InventoryResult to show a change
Equipper.MAX_FAILS = 3

function Equipper.new(adapter, macro, options)
    options = options or {}
    return setmetatable({ adapter = adapter, macro = macro, clock = options.Clock or os.clock, status = "Idle", fails = 0 }, Equipper)
end
function Equipper:Enabled(s) return s.MacroAutoEquip end
function Equipper:Interval() return 0.5 end

-- The stage being joined: the one selected in your room (the room reports it), else Auto join's stage.
function Equipper:_level(s)
    local room = self.adapter.room
    return room and room.Level or s.JoinLevel
end

function Equipper:_file(s)
    local level = self:_level(s)
    local room = self.adapter.room
    local kind = room and (room.Kind == "challenge" or room.Kind == "daily") and room.Kind or nil
    local file, assigned = Macro.FileForStage(self.adapter, s, level, nil, kind)
    if assigned then return file end
    -- Older map-name assignments: use one whose recording was made on this stage.
    for _, candidate in pairs(s.MacroMaps) do
        local ok, data = pcall(self.macro._load, self.macro, candidate)
        if ok and data.Level == level then return candidate end
    end
    return file
end

function Equipper:Tick(s)
    local a = self.adapter
    local m = a.match
    if m and (m.state == "Prep" or m.state == "Wave") then
        a.teamReady = nil
        self.status = "In a match (the team is changed in the lobby)"; return
    end
    local file = self:_file(s)
    if not file then a.teamReady = nil; self.status = "Select a recording"; return end
    local inv = a.inventory
    if type(inv) ~= "table" or type(inv.equipped) ~= "table" then
        a.teamReady = false; a:RequestInventory(); self.status = "Loading inventory"; return
    end
    local okLoad, data = pcall(self.macro._load, self.macro, file)
    if not okLoad then a.teamReady = nil; self.status = "Can't read " .. file; return end
    local desired, missing = Macro.TeamFor(data, inv)
    local now = self.clock()
    local pending = self.pending
    if pending then
        local current = inv.equipped
        local done = (pending.Kind == "equip" and current[pending.Slot] == pending.Id) or (pending.Kind == "equip" and Macro._has(current, pending.Id))
            or (pending.Kind == "unequip" and not Macro._has(current, pending.Id))
        if done then self.pending, self.fails = nil, 0
        elseif now - pending.At < Equipper.CONFIRM then
            if now - pending.At > 1 and not pending.Asked then pending.Asked = true; a:RequestInventory() end
            return
        else
            self.pending = nil
            self.fails = self.fails + 1
            if self.fails >= Equipper.MAX_FAILS then
                self.blockedUntil = now + 30; self.fails = 0
            end
        end
    end
    if self.blockedUntil and now < self.blockedUntil then
        a.teamReady = false
        self.status = "Equip not confirmed by the game; retrying in " .. math.ceil(self.blockedUntil - now) .. "s"
        return
    end
    if self.file ~= file then self.file, self.actions = file, 0 end
    if (self.actions or 0) >= 30 then self.loose, self.actions = file, 0 end   -- the game orders slots itself
    local current = inv.equipped
    if self.loose == file then
        -- Loose mode: the right units in any slot (playback finds units by name, not slot).
        for slot = 1, 6 do
            local id = desired[slot]
            if id and not Macro._has(current, id) then
                local free
                for k = 1, 6 do if not current[k] then free = k; break end end
                if free then
                    a:EquipUnit(id, free)
                    self.pending = { Kind = "equip", Id = id, Slot = free, At = now }
                    a.teamReady = false; self.status = "Equipping " .. tostring(id); return
                end
                for k = 1, 6 do
                    if current[k] and not Macro._wantedElsewhere(desired, current[k], 0) then
                        a:UnequipUnit(current[k])
                        self.pending = { Kind = "unequip", Id = current[k], Slot = k, At = now }
                        a.teamReady = false; self.status = "Making room"; return
                    end
                end
            end
        end
        a.teamReady, a.teamReadyFor = true, self:_level(s)
        self.status = "Team ready for " .. file .. " (the game chose the slots)"
        return
    end
    for slot = 1, 6 do                                   -- 1) clear wrong slots
        local id = current[slot]
        if id and desired[slot] ~= id and (desired[slot] ~= nil or Macro._wantedElsewhere(desired, id, slot) ~= nil) then
            a:UnequipUnit(id)
            self.actions = (self.actions or 0) + 1
            self.pending = { Kind = "unequip", Id = id, Slot = slot, At = now }
            a.teamReady = false
            self.status = "Unequipping slot " .. slot
            return
        end
    end
    for slot = 1, 6 do                                   -- 2) equip the macro's units in slot order
        local id = desired[slot]
        if id and current[slot] ~= id then
            a:EquipUnit(id, slot)
            self.actions = (self.actions or 0) + 1
            self.pending = { Kind = "equip", Id = id, Slot = slot, At = now }
            a.teamReady = false
            self.status = "Equipping slot " .. slot
            return
        end
    end
    a.teamReady = true
    a.teamReadyFor = self:_level(s)
    self.actions = 0
    self.status = "Team ready for " .. file .. (#missing > 0 and (" (missing: " .. table.concat(missing, ", ") .. ")") or "")
end

function Equipper:Stop()
    self.pending, self.blockedUntil, self.fails = nil, nil, 0
    self.adapter.teamReady = nil
end

function Macro._has(list, id)
    for slot = 1, 6 do if list[slot] == id then return true end end
    return false
end

-- Slot where the macro wants this unit, if it's a different slot.
function Macro._wantedElsewhere(desired, id, slot)
    for s, wanted in pairs(desired) do
        if wanted == id and s ~= slot then return s end
    end
    return nil
end

return Macro

end)()

local Webhook = (function()
-- Webhook: Discord match reports. Pure logic (payload building, URL checks, when to send) so tests run offline;
-- the adapter builds the report from the game's results and App supplies the HTTP sender.
-- A report is sent once per match, a few seconds after the results so the inventory refresh, drop announcements
-- and level-up notices that follow the results have arrived.
local Webhook = {}
Webhook.__index = Webhook
Webhook.DELAY = 3
Webhook.SPECIAL = { Legendary = true, Mythic = true, Secret = true }
Webhook.COLORS = { Win = 0x5BD68A, Loss = 0xE5534B, Secret = 0xFF1A1A }

function Webhook.ValidUrl(url)
    return type(url) == "string" and (url:match("^https://discord%.com/api/webhooks/%d+/[%w_%-]+$")
        or url:match("^https://discordapp%.com/api/webhooks/%d+/[%w_%-]+$")
        or url:match("^https://ptb%.discord%.com/api/webhooks/%d+/[%w_%-]+$")
        or url:match("^https://canary%.discord%.com/api/webhooks/%d+/[%w_%-]+$")) ~= nil
end

local function num(n)
    if type(n) ~= "number" then return "?" end
    local s = tostring(math.floor(n + 0.5))
    local out = s:reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (out:gsub("^,", ""):gsub("^%-,", "-"))
end

local function delta(total, gained)
    if total == nil and gained == nil then return "?" end
    if total == nil then return "+" .. num(gained) end
    return num(total) .. (gained and gained ~= 0 and (" (+" .. num(gained) .. ")") or "")
end

local function clock(seconds)
    if type(seconds) ~= "number" then return "?" end
    seconds = math.floor(seconds + 0.5)
    return string.format("%d:%02d", seconds // 60, seconds % 60)
end

-- Secret items or units in the report.
function Webhook.Secrets(report)
    local list = {}
    for _, d in ipairs(report.Drops or {}) do if d.Rarity == "Secret" then table.insert(list, d.Name) end end
    for _, u in ipairs(report.Units or {}) do if u.Rarity == "Secret" then table.insert(list, u.Name .. (u.Shiny and " (Shiny)" or "")) end end
    return list
end

-- report: { Won, Title, Location, Difficulty, Waves, WaveCount, Elapsed, Kills, FirstClear, NewBest, Mode, Player,
--   Rewards = { Gems, Gold, Xp, Trophies, Rerolls }, Totals = { Gems, Gold, Rerolls },
--   Level = { Level, Xp, Needed, LevelUp }, Drops = { { Name, Count, Rarity } }, Units = { { Name, Rarity, Shiny } } }
function Webhook.Payload(report, userId)
    local secrets = Webhook.Secrets(report)
    local rewards, totals, level = report.Rewards or {}, report.Totals or {}, report.Level or {}
    local fields = {}
    local function field(name, value, inline) table.insert(fields, { name = name, value = value, inline = inline ~= false }) end
    field("Result", (report.Won and "Cleared" or "Lost") .. string.format(" - wave %s/%s", tostring(report.Waves or "?"), tostring(report.WaveCount or "?")))
    field("Time", clock(report.Elapsed))
    field("Mode", report.Mode or "Manual")
    field("Gems", delta(totals.Gems, rewards.Gems))
    field("Gold", delta(totals.Gold, rewards.Gold))
    field("Trait rerolls", delta(totals.Rerolls, rewards.Rerolls))
    local levelText = level.Level and ("Level " .. tostring(level.Level)) or "Level ?"
    if level.Xp and level.Needed and level.Needed > 0 then
        levelText = levelText .. string.format(" - %s/%s XP (%d%%)", num(level.Xp), num(level.Needed), math.floor(level.Xp / level.Needed * 100))
    end
    if rewards.Xp then levelText = levelText .. " (+" .. num(rewards.Xp) .. " XP)" end
    if level.LevelUp then levelText = levelText .. "\nLevel up!" end
    field("Player", levelText, false)
    local drops = {}
    for _, d in ipairs(report.Drops or {}) do
        local mark = Webhook.SPECIAL[d.Rarity] and "**" or ""
        table.insert(drops, string.format("%s%s x%s%s%s", mark, d.Name, num(d.Count), d.Rarity and (" (" .. d.Rarity .. ")") or "", mark))
    end
    for _, u in ipairs(report.Units or {}) do
        table.insert(drops, string.format("**Unit: %s%s (%s)**", u.Name, u.Shiny and " Shiny" or "", tostring(u.Rarity or "?")))
    end
    field("Drops", #drops > 0 and table.concat(drops, "\n"):sub(1, 1000) or "None", false)
    local extras = {}
    if report.FirstClear then table.insert(extras, "First clear") end
    if report.NewBest then table.insert(extras, "New best") end
    if report.Kills then table.insert(extras, num(report.Kills) .. " kills") end
    local title = string.format("%s%s", tostring(report.Title or "Match"), report.Difficulty and (" (" .. report.Difficulty .. ")") or "")
    local lines = {}
    if report.Location then table.insert(lines, "**" .. report.Location .. "**") end
    if #extras > 0 then table.insert(lines, table.concat(extras, " - ")) end
    local embed = {
        title = title:sub(1, 250),
        description = #lines > 0 and table.concat(lines, "\n") or nil,   -- Discord rejects an empty description
        color = #secrets > 0 and Webhook.COLORS.Secret or (report.Won and Webhook.COLORS.Win or Webhook.COLORS.Loss),
        fields = fields,
        footer = { text = "GogHub Anime TD" .. (report.Player and (" - " .. report.Player) or "") },
    }
    local payload = { username = "GogHub", embeds = { embed }, allowed_mentions = { parse = {} } }
    if #secrets > 0 then
        local ping = (userId and userId ~= "") and ("<@" .. userId .. "> ") or ""
        payload.content = ping .. "Secret drop: " .. table.concat(secrets, ", ")
        if ping ~= "" then payload.allowed_mentions = { users = { userId } } end
    end
    return payload
end

-- Reporter: watches for results and sends one report per match.
-- adapter: results / matchKey / MatchReport(results); send(payload) -> ok, err; mode() -> string.
function Webhook.new(adapter, send, options)
    options = options or {}
    return setmetatable({ adapter = adapter, send = send, clock = options.Clock or os.clock, mode = options.Mode or function() return "Manual" end,
        notify = options.Notify or function() end, status = "Idle", sent = 0 }, Webhook)
end
function Webhook:Enabled(s) return s.WebhookEnabled and Webhook.ValidUrl(s.WebhookURL) end
function Webhook:Interval() return 0.5 end
function Webhook:Tick(s)
    local a = self.adapter
    local results = a.results
    -- Snapshot the results and the match when first seen: a replay or leave can reset them before the report goes out.
    if results and results.Key ~= self.lastKey and (not self.snapshot or self.snapshot.Results.Key ~= results.Key) then
        self.snapshot = { Results = results, Match = a.match, At = self.clock() }
        if a.RequestInventory then a:RequestInventory() end            -- fresh totals for the report
    end
    local snap = self.snapshot
    if not snap then
        if self.sent == 0 then self.status = "Waiting for a match to finish" end
        return
    end
    if self.clock() - snap.At < Webhook.DELAY then self.status = "Collecting results"; return end
    self.snapshot, self.lastKey = nil, snap.Results.Key
    results = snap.Results
    local report = a:MatchReport(results, snap.Match)
    report.Mode = self.mode()
    local ok, err = self.send(Webhook.Payload(report, s.WebhookUserId))
    if ok then
        self.sent = self.sent + 1
        self.status = string.format("Sent %d report%s (last: %s)", self.sent, self.sent == 1 and "" or "s", report.Won and "cleared" or "lost")
    else
        self.status = "Send failed: " .. tostring(err)
        self.notify("Webhook", err, "Error")
    end
end

return Webhook

end)()

local MapCleaner = (function()
-- MapCleaner ("Delete map"): client-only, reversible map stripping for performance and a clear view.
--   Placeable areas (_terrain, or tagged PlaceableGround / Hill) -> plain white platforms in their exact shape
--     (hills slightly blue), still solid so placement and walking work.
--   Track (_road, Path, Waypoints, EnemySpawn, Goal, tagged NoPlace) -> dark slate, still solid.
--   Everything else in the map, and scenery outside it (other workspace models/parts) -> hidden and non-solid.
--   Roblox Terrain (grass slopes, rock boulders) is snapshotted with CopyRegion, cleared, and pasted back on
--   restore; terrain clouds are switched off. Placement doesn't use terrain (only platforms and the track).
--   A grey baseplate is added at track level under the map.
-- Units, enemies, players, the camera and the game's world UI are never touched. Placement is unaffected: the
-- game's PlacementRules raycasts only against the track and placeable surfaces. Nothing is deleted: turning it
-- off, a new map, or unloading restores every changed property and removes the baseplate.
local Cleaner = {}
Cleaner.__index = Cleaner
Cleaner.TRACK_NAMES = { _road = true, Path = true, Waypoints = true, EnemySpawn = true, Goal = true }
Cleaner.PLACE_NAMES = { _terrain = true }
Cleaner.PLACE_TAGS = { "PlaceableGround", "Hill" }
Cleaner.TRACK_TAGS = { "NoPlace" }
-- Workspace children that are gameplay, not scenery.
Cleaner.KEEP_CHILDREN = { PlacedUnits = true, Enemies = true, ["Game Uis"] = true, attack_indicators = true, Portals = true,
    passive_anims = true, passive_accessory_anims = true, sfx = true, GogHubBaseplate = true }
Cleaner.WHITE = { 242, 243, 247 }
Cleaner.HILL = { 214, 226, 245 }
Cleaner.TRACK = { 52, 56, 68 }
Cleaner.BASE = { 140, 142, 148 }
Cleaner.FALL_MARGIN = 25
-- Only in a match (MatchConfig.STATE): the lobby has map previews with paths too, and must never be stripped.
Cleaner.MATCH_STATES = { Starting = true, Prep = true, Wave = true, Victory = true, Defeat = true }
Cleaner.NOT_MAPS = { map = true, PlacementArena = true }

function Cleaner.new(adapter, options)
    options = options or {}
    return setmetatable({ adapter = adapter, collection = options.Collection, player = options.Player, world = options.Workspace,
        players = options.Players, newPart = options.NewPart, color = options.Color or function(c) return Color3.fromRGB(c[1], c[2], c[3]) end,
        material = options.Material or function() return Enum.Material.SmoothPlastic end,
        changed = {}, connections = {}, dirty = true, hidden = 0, platforms = 0, status = "Starting" }, Cleaner)
end
function Cleaner:Enabled(s) return s.DeleteMap end
function Cleaner:Interval() return 0.5 end

-- Record and apply property changes so they can be undone. A change whose value is nil (Parent) is allowed.
function Cleaner:_set(object, changes, counter)
    if self.changed[object] then return end
    local entry = {}
    for _, change in ipairs(changes) do
        local property, value = change[1], change[2]
        local ok, original = pcall(function() return object[property] end)
        if ok and original ~= value then
            if property == "Parent" then self.quiet = object end      -- our own removal: don't treat it as the game's
            local applied = pcall(function() object[property] = value end)
            self.quiet = nil
            if applied then
                table.insert(entry, { Property = property, Original = original, Hidden = value })
            end
        end
    end
    if #entry > 0 then
        entry.Counter = counter
        self.changed[object] = entry
        self[counter] = self[counter] + 1
    end
end

function Cleaner:_restore(object)
    local entry = self.changed[object]
    if not entry then return end
    self.changed[object] = nil
    self[entry.Counter] = self[entry.Counter] - 1
    for i = #entry, 1, -1 do                 -- reverse: CanQuery goes back before CanCollide
        local change = entry[i]
        pcall(function()
            if object[change.Property] == change.Hidden then object[change.Property] = change.Original end
        end)
    end
end

local EFFECTS = { "ParticleEmitter", "Trail", "Beam", "Light", "SurfaceGui", "BillboardGui", "Fire", "Smoke", "Sparkles", "Highlight" }
local function isEffect(object)
    for _, class in ipairs(EFFECTS) do if object:IsA(class) then return true end end
    return false
end

function Cleaner:_hide(object)
    if object:IsA("BasePart") then
        self:_set(object, { { "LocalTransparencyModifier", 1 }, { "CanCollide", false }, { "CanQuery", false } }, "hidden")
    elseif object:IsA("Decal") or object:IsA("Texture") then
        self:_set(object, { { "Transparency", 1 } }, "hidden")
    elseif isEffect(object) then
        self:_set(object, { { "Enabled", false } }, "hidden")
    end
end

function Cleaner:_style(object, rgb)
    if object:IsA("BasePart") then
        local changes = { { "Color", self.color(rgb) }, { "Material", self.material() } }
        if object:IsA("MeshPart") then table.insert(changes, { "TextureID", "" }) end
        if object:IsA("UnionOperation") then table.insert(changes, { "UsePartColor", true }) end
        self:_set(object, changes, "platforms")
    elseif object:IsA("SurfaceAppearance") then
        self:_set(object, { { "Parent", nil } }, "platforms")       -- it would override the plain colour
    elseif object:IsA("Decal") or object:IsA("Texture") then
        self:_set(object, { { "Transparency", 1 } }, "platforms")
    elseif isEffect(object) then
        self:_set(object, { { "Enabled", false } }, "platforms")
    end
end

function Cleaner:_tagged(object, tags)
    local collection = self.collection
    if not collection then return false end
    for _, tag in ipairs(tags) do
        if collection:HasTag(object, tag) then return true end
    end
    return false
end

-- "track", "hill", "place" or nil (excess), from the object and its ancestors inside the map.
function Cleaner:_kind(object)
    local cursor, hill = object, false
    while cursor and cursor ~= self.map do
        if Cleaner.TRACK_NAMES[cursor.Name] or self:_tagged(cursor, Cleaner.TRACK_TAGS) then return "track" end
        if cursor.Name == "hill" or self:_tagged(cursor, { "Hill" }) then hill = true end
        if Cleaner.PLACE_NAMES[cursor.Name] or self:_tagged(cursor, Cleaner.PLACE_TAGS) then return hill and "hill" or "place" end
        cursor = cursor.Parent
    end
    return nil
end

function Cleaner:_applyMap(object)
    local kind = self:_kind(object)
    if kind == "track" then self:_style(object, Cleaner.TRACK)
    elseif kind == "hill" then self:_style(object, Cleaner.HILL)
    elseif kind == "place" then self:_style(object, Cleaner.WHITE)
    else self:_hide(object) end
    if kind and object:IsA("BasePart") then
        local top, bottom = object.Position.Y + object.Size.Y / 2, object.Position.Y - object.Size.Y / 2
        local x, z, hx, hz = object.Position.X, object.Position.Z, object.Size.X / 2, object.Size.Z / 2
        local b = self.bounds
        if not b then b = { minX = x - hx, maxX = x + hx, minZ = z - hz, maxZ = z + hz }; self.bounds = b end
        b.minX, b.maxX = math.min(b.minX, x - hx), math.max(b.maxX, x + hx)
        b.minZ, b.maxZ = math.min(b.minZ, z - hz), math.max(b.maxZ, z + hz)
        if kind == "track" and (not self.trackTop or top < self.trackTop) then self.trackTop = top end
        if not self.floor or bottom < self.floor then self.floor = bottom end
    end
    if object.Name == "PlayerSpawn" and object:IsA("BasePart") then self.spawn = object.Position end
end

function Cleaner:_isCharacter(child)
    local players = self.players or game:GetService("Players")
    return players:GetPlayerFromCharacter(child) ~= nil
end

-- Scenery outside the map model: every other workspace model, folder or part that isn't gameplay.
function Cleaner:_outside(child)
    if child == self.map or child == self.baseplate or Cleaner.KEEP_CHILDREN[child.Name] then return false end
    if child:IsA("Camera") or child:IsA("Terrain") or self:_isCharacter(child) then return false end
    return child:IsA("Model") or child:IsA("Folder") or child:IsA("BasePart")
end

function Cleaner:_hideTree(root)
    self:_hide(root)
    for _, object in ipairs(root:GetDescendants()) do self:_hide(object) end
end

function Cleaner:_baseplate()
    local b = self.bounds
    if not b or self.baseplate or not self.newPart then return end
    local y = (self.trackTop or self.floor or 0) - 0.25
    local part = self.newPart()
    part.Name = "GogHubBaseplate"
    part.Anchored = true
    part.Color = self.color(Cleaner.BASE)
    part.Material = self.material()
    part.Size = Vector3.new(b.maxX - b.minX + 400, 1, b.maxZ - b.minZ + 400)
    part.CFrame = CFrame.new((b.minX + b.maxX) / 2, y - 0.5, (b.minZ + b.maxZ) / 2)
    part.Parent = self.world
    self.baseplate = part
end

-- Clear the terrain on this client, keeping a snapshot to paste back. Only clears if the snapshot worked.
function Cleaner:_clearTerrain()
    if self.terrainSaved ~= nil then return end
    local terrain = self.world:FindFirstChildOfClass("Terrain")
    if not terrain then self.terrainSaved = false; return end
    local clouds = terrain:FindFirstChildOfClass("Clouds")
    if clouds then self:_set(clouds, { { "Enabled", false } }, "hidden") end
    local ok, region, corner = pcall(function()
        local extents = terrain.MaxExtents
        return terrain:CopyRegion(extents), extents.Min
    end)
    if ok and region then
        if pcall(function() terrain:Clear() end) then
            self.terrainSaved = { Terrain = terrain, Region = region, Corner = corner }
            return
        end
    end
    self.terrainSaved = false
    self.terrainError = "terrain kept (couldn't snapshot it)"
end

function Cleaner:_restoreTerrain()
    local saved = self.terrainSaved
    self.terrainSaved, self.terrainError = nil, nil
    if saved then pcall(function() saved.Terrain:PasteRegion(saved.Region, saved.Corner, true) end) end
end

function Cleaner:_detach()
    self:_restoreTerrain()
    for _, connection in pairs(self.childConnections or {}) do pcall(function() connection:Disconnect() end) end
    self.childConnections = {}
    for _, connection in ipairs(self.connections) do pcall(function() connection:Disconnect() end) end
    self.connections = {}
    local objects = {}
    for object in pairs(self.changed) do table.insert(objects, object) end
    for _, object in ipairs(objects) do self:_restore(object) end
    if self.baseplate then pcall(function() self.baseplate:Destroy() end) end
    self.map, self.baseplate, self.bounds, self.trackTop, self.floor, self.spawn, self.dirty = nil, nil, nil, nil, nil, nil, true
end

function Cleaner:_attach(map)
    self.map = map
    self.world = self.world or workspace
    self.collection = self.collection or game:GetService("CollectionService")
    self.newPart = self.newPart or function() return Instance.new("Part") end
    local function connect(signal, fn) table.insert(self.connections, signal:Connect(fn)) end
    connect(map.DescendantAdded, function(object) if self.map == map then self:_applyMap(object) end end)
    connect(map.DescendantRemoving, function(object) if object ~= self.quiet then self:_restore(object) end end)
    self.childConnections = {}
    connect(self.world.ChildAdded, function(child)
        if self.map ~= map or not self:_outside(child) then return end
        self:_hideTree(child)
        self.childConnections[child] = child.DescendantAdded:Connect(function(object) if self.map == map then self:_hide(object) end end)
    end)
    -- Effects come and go: when one leaves, disconnect it and forget what we changed in it.
    connect(self.world.ChildRemoved, function(child)
        local connection = self.childConnections and self.childConnections[child]
        if connection then connection:Disconnect(); self.childConnections[child] = nil end
        self.purge = true
    end)
end

function Cleaner:_scan()
    for _, object in ipairs(self.map:GetDescendants()) do self:_applyMap(object) end
    for _, child in ipairs(self.world:GetChildren()) do
        if self:_outside(child) then self:_hideTree(child) end
    end
    self:_clearTerrain()
    self:_baseplate()
end

-- Safety net: if you still fall below the map (e.g. walked off the baseplate), go back to the spawn.
function Cleaner:_catchFall()
    if not self.floor then return end
    local player = self.player or game:GetService("Players").LocalPlayer
    local character = player and player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root and root.Position.Y < (self.trackTop or self.floor) - Cleaner.FALL_MARGIN then
        local target = self.spawn or root.Position
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        root.CFrame = CFrame.new(target.X, (self.trackTop or target.Y) + 4, target.Z)
    end
end

function Cleaner:Tick()
    local m = self.adapter.match
    local inMatch = m ~= nil and Cleaner.MATCH_STATES[m.state] == true
    local map = inMatch and self.adapter:MapModel() or nil
    if map and Cleaner.NOT_MAPS[map.Name] then map = nil end
    if not inMatch then
        if self.map then self:_detach() end
        self.status = "Only runs in a match"
        return
    end
    if not map then
        if self.map then self:_detach() end
        self.status = "Waiting for the match map"
        return
    end
    if map ~= self.map then
        self:_detach()
        if not map then self.status = "Waiting for a match map"; return end
        self:_attach(map)
    end
    if self.dirty then self:_scan(); self.dirty = false end
    if self.purge then
        self.purge = false
        for object, entry in pairs(self.changed) do
            if not object:IsDescendantOf(game) then self.changed[object] = nil; self[entry.Counter] = self[entry.Counter] - 1 end
        end
    end
    pcall(self._catchFall, self)
    self.status = string.format("%s: %d removed, %d platforms%s", tostring(self.map.Name), self.hidden, self.platforms,
        self.terrainSaved and ", terrain cleared" or (self.terrainError and (", " .. self.terrainError) or ""))
end

function Cleaner:Stop()
    self:_detach()
    self.status = "Off"
end

return Cleaner

end)()

-- App: entry point (appended last by build.py). Same layout as the GogHub TD profile: Game, AutoPlay, Lobby, Misc,
-- Config and a footer Settings tab. Every game action goes through GameAdapter (remotes captured with Cobalt).
-- Bundle order provides: UI, GameContext, Settings, Storage, ThemeStore, Workers, Profile, GameAdapter, AntiAFK,
-- Controller, Automation, Macro, Webhook, MapCleaner.
-- Returns the window so GogHubHub can host this profile (it needs window.Gui and window:Destroy()).
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- 0. Autoexecute runs before the game and your player exist: wait for both before building anything.
if not game:IsLoaded() then game.Loaded:Wait() end
while not Players.LocalPlayer do Players:GetPropertyChangedSignal("LocalPlayer"):Wait() end

-- 1. Single instance: destroy any previous copy of this script before starting.
local env = type(getgenv) == "function" and getgenv() or _G
local KEY = "__GogHub_" .. Profile.Id
local previous = env[KEY]
if previous and type(previous.Destroy) == "function" then pcall(previous.Destroy, previous) end
local app = { alive = true, ready = false }
env[KEY] = app

-- 2. Capability check: missing file functions disable configs/theme instead of crashing.
local missing = {}
for _, name in ipairs({ "readfile", "writefile", "isfile", "isfolder", "makefolder", "listfiles", "delfile" }) do
    if type(env[name]) ~= "function" and type(getfenv()[name]) ~= "function" then table.insert(missing, name) end
end
local canWrite = #missing == 0

-- 3. Window + toast/safe helpers.
local localPlayer = Players.LocalPlayer
local window = UI:CreateWindow({ Name = "GogHub_" .. Profile.Id, Title = "goghub", Subtitle = Profile.Name,
    Size = Vector2.new(940, 680), ToggleKey = Enum.KeyCode.RightShift,
    User = localPlayer and localPlayer.DisplayName or "Player", Status = "Starting", StatusPill = "v" .. Profile.Version })
local function toast(title, message, kind)
    if app.alive and window.Gui.Parent then window:Notify({ Title = title, Message = tostring(message), Type = kind or "Info", Duration = 4 }) end
end
-- Every UI callback goes through safe(): errors become a toast instead of a dead thread.
local function safe(fn)
    return function(...)
        local ok, err = pcall(fn, ...)
        if not ok then toast("GogHub Error", err, "Error") end
    end
end

-- 4. Services and controllers.
local store = canWrite and Storage.new(Profile.Namespace) or nil
local theme = canWrite and ThemeStore.new(Profile.Namespace, { Error = function(message) toast("Theme Error", message, "Error") end }) or nil
local workers = Workers.new({ onError = function(name, err) toast(name .. " error", err, "Error") end })
local adapter = GameAdapter.new()
local antiAFK = AntiAFK.new(localPlayer, { Notify = toast })
local function controller(name, feature) return Controller.new(name, feature, { Notify = toast }) end
local matchCtl = controller("Match automation", Automation.Match.new(adapter))
local placeCtl = controller("Autoplay", Automation.Placer.new(adapter))
local upgradeCtl = controller("Auto upgrade", Automation.Upgrader.new(adapter))
local targetCtl = controller("Targeting", Automation.Targeter.new(adapter))
local abilityCtl = controller("Auto ability", Automation.Abilities.new(adapter))
local erwinCtl = controller("Buff rotation", Automation.Buffs.new(adapter))
local lobbyCtl = controller("Auto join", Automation.Lobby.new(adapter))
local rewardCtl = controller("Rewards", Automation.Rewards.new(adapter))
local popupCtl = controller("Popup skip", Automation.Popups.new(adapter))
local mapCtl = controller("Delete map", MapCleaner.new(adapter))
local settings   -- forward: the webhook reads the live mode
local HttpService = game:GetService("HttpService")
local httpRequest = (type(request) == "function" and request) or (type(http_request) == "function" and http_request)
    or (type(syn) == "table" and type(syn.request) == "function" and syn.request) or nil
local function postWebhook(url, payload)
    if not httpRequest then return false, "This executor has no request function." end
    local ok, response = pcall(httpRequest, { Url = url, Method = "POST",
        Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(payload) })
    if not ok then return false, tostring(response) end
    local code = type(response) == "table" and tonumber(response.StatusCode) or nil
    if code and (code < 200 or code >= 300) then return false, "Discord answered " .. code end
    return true
end
local macroFiles = store and store:Documents("Macros") or nil
local macro = Macro.new(adapter, macroFiles, { Notify = toast })
local macroCtl = controller("Macro", macro)
local equipCtl = controller("Auto equip", Macro.Equipper.new(adapter, macro))
local reporter = Webhook.new(adapter, function(payload) return postWebhook(settings.WebhookURL, payload) end, {
    Notify = toast,
    Mode = function()
        if settings.MacroPlay then return "Macro: " .. tostring(macro:FileFor(settings) or "none") end
        if settings.Autoplay then return "Autoplay (" .. settings.PlaceMode .. ")" end
        return "Manual"
    end })
local webhookCtl = controller("Webhook", reporter)
local controllers = { macroCtl, equipCtl, matchCtl, placeCtl, upgradeCtl, targetCtl, abilityCtl, erwinCtl, lobbyCtl, rewardCtl, popupCtl, webhookCtl, mapCtl }
-- Unit automation that would fight a playing macro.
local macroConflicts = { [placeCtl] = true, [upgradeCtl] = true, [targetCtl] = true, [abilityCtl] = true }

-- 5. Settings state. commit() validates; refresh() pushes settings back into every control.
settings = Settings.Validate({})
local selectedConfig, autosaveTarget, dirty = nil, nil, false
local refreshers = {}
local function refresh() for _, fn in ipairs(refreshers) do fn() end end
local function commit(key, value)
    settings = Settings.With(settings, key, value)
    dirty = true
end
local function keyCode(name)
    local ok, key = pcall(function() return Enum.KeyCode[name] end)
    return ok and key or Enum.KeyCode.RightShift
end

-- Control helpers bound to a settings key (they register their own refresher).
local function toggle(section, title, key, description)
    local control = section:AddToggle({ Text = title, Description = description, Default = settings[key],
        Callback = safe(function(value) commit(key, value) end) })
    table.insert(refreshers, function() control:Set(settings[key], true) end)
    return control
end
local function dropdown(section, title, key, values)
    local field = section:AddDropdown({ Text = title, Values = values, Default = settings[key],
        Callback = safe(function(value) commit(key, value) end) })
    table.insert(refreshers, function() field:Set(settings[key], true) end)
    return field
end
local function input(section, title, key)
    local field
    field = section:AddInput({ Text = title, Default = tostring(settings[key]), Callback = function(value)
        local number = tonumber(value)
        if number == nil then
            field:Set(tostring(settings[key]), true)
            if tostring(value):match("%S") then toast("Invalid setting", title .. " needs a number.", "Error") end
            return
        end
        local ok, err = pcall(commit, key, number)
        field:Set(tostring(settings[key]), true)
        if not ok then toast("Invalid setting", err, "Error") end
    end })
    table.insert(refreshers, function() field:Set(tostring(settings[key]), true) end)
    return field
end
-- Fill a dropdown from {id = title} and return label->id lookup (handles multi-select).
local function fill(field, values, current, multi)
    local lookup, labels, selected, wanted = {}, {}, {}, {}
    if multi then for _, id in ipairs(current or {}) do wanted[id] = true end elseif current then wanted[current] = true end
    for id in pairs(wanted) do if not values[id] then values[id] = id end end
    for id, title in pairs(values) do
        local label = title == id and id or title .. " [" .. id .. "]"
        lookup[label] = id; table.insert(labels, label)
        if wanted[id] then table.insert(selected, label) end
    end
    table.sort(labels); table.sort(selected); field:Clear()
    for _, label in ipairs(labels) do field:Add(label) end
    field:Set(multi and selected or selected[1], true)
    return lookup
end
local live = {}          -- status rows updated by the live loop (§13)

-- 6a. Macro tab: record and play back matches (the core of the script).
local macroTab = window:AddTab({ Title = "Macro", Subtitle = "Record and play back matches", Icon = "td-play" })
local recordings = macroTab:AddSection({ Title = "Recordings",
    Description = macroFiles and ("Saved in workspace/" .. Profile.Namespace .. "/Macros") or "File functions unavailable: recording is disabled." })
local recordingField, recordToggle, newRecording
local fillStageRecordings, showAssignment          -- defined with the stage assignments below
live.macro = recordings:AddStatus({ Title = "Macro", Value = "No recording selected" })
local recordingSummary = "No recording selected"
local function describeRecording()
    local file = settings.MacroFile
    if file == "" or not macroFiles then recordingSummary = "No recording selected"; return end
    local ok, data = pcall(macroFiles.LoadData, macroFiles, file)
    if not ok or type(data) ~= "table" or type(data.Actions) ~= "table" then recordingSummary = file .. ": unreadable"; return end
    recordingSummary = string.format("%s (%s), %d steps", tostring(data.Title or data.Level or "?"), tostring(data.Difficulty or "?"), #data.Actions)
end
local function refreshRecordings()
    recordingField:Clear()
    local found = false
    for _, file in ipairs(macroFiles and macroFiles:List() or {}) do
        recordingField:Add(file)
        if file == settings.MacroFile then found = true end
    end
    recordingField:Set(found and settings.MacroFile or nil, true)
    describeRecording()
    if fillStageRecordings then fillStageRecordings(); showAssignment() end
end
recordingField = recordings:AddDropdown({ Text = "Recording", Values = {}, Callback = safe(function(value)
    commit("MacroFile", type(value) == "string" and value or ""); describeRecording()
end) })
table.insert(refreshers, function() refreshRecordings() end)
recordings:AddInput({ Text = "New recording name", Placeholder = "Defaults to map + time", Callback = function(value) newRecording = value end })
recordToggle = recordings:AddToggle({ Text = "Record",
    Description = "Records your placements, sells, upgrades, targeting and abilities until you stop or the match ends",
    Default = false, Callback = function(value)
        local ok, err = pcall(function()
            if value then
                assert(app.ready, "Game not detected: the Game tab shows why.")
                assert(adapter.loaded, "Game data is still loading: wait a moment and try again.")
                assert(not settings.MacroPlay, "Turn off Play before recording.")
                local name = (newRecording and newRecording:match("%S")) and newRecording
                    or (tostring(adapter:MapKey() or "macro") .. " " .. os.date("%m-%d %H.%M"))
                toast("Recording", macro:StartRecord(name), "Success")
            else
                local file = macro:StopRecord()
                if file then commit("MacroFile", file); refreshRecordings(); toast("Recording Saved", file, "Success")
                else toast("Recording", "Nothing was recorded.") end
            end
        end)
        recordToggle:Set(macro.recording ~= nil, true)
        if not ok then toast("Macro", err, "Error") end
    end })
recordings:AddButton({ Text = "Delete selected", Secondary = true, Callback = safe(function()
    assert(macroFiles, "File functions unavailable.")
    assert(settings.MacroFile ~= "", "Select a recording.")
    macroFiles:DeleteData(settings.MacroFile)
    local maps = {}
    for map, file in pairs(settings.MacroMaps) do if file ~= settings.MacroFile then maps[map] = file end end
    commit("MacroMaps", maps); commit("MacroFile", ""); refreshRecordings()
end) })
recordings:AddButton({ Text = "Refresh recordings", Secondary = true, Callback = safe(refreshRecordings) })

local playback = macroTab:AddSection({ Title = "Playback",
    Description = "Steps run in order. Each waits for its wave and enough cash; placements reuse the recorded spot." })
toggle(playback, "Play", "MacroPlay", "Pauses Autoplay and auto upgrade/ability while playing")
dropdown(playback, "Timing", "MacroTiming", Settings.MACRO_TIMINGS)
toggle(playback, "Auto equip macro units", "MacroAutoEquip", "Equips the recording's team in the lobby")

-- Stage assignments, nested: Recording, then Gamemode > Map > Act (Map shows once a gamemode is picked, Act once
-- a map is). The deepest level you pick is what the recording is assigned to:
--   gamemode only / "All maps"  -> the whole gamemode     map + "All acts" -> every act of that map
--   map + act                   -> that act
-- Playback and Auto equip use the most specific match: act, then map, then gamemode, then the recording selected
-- under Recordings.
local assignments = macroTab:AddSection({ Title = "Stage assignments",
    Description = "Pick a recording and where it applies. More specific picks override broader ones." })
local ALL_MAPS, ALL_ACTS = "All maps", "All acts"
local stageRecordingField
local assignMode, assignMap, assignAct, assignKey
local modeField, mapField, actField
local actLookup = {}
local stagesFilled = false
local inheritLabel
local function stageCatalog() return adapter.loaded and adapter:LevelCatalog() or nil end
local function sortedKeys(t)
    local out = {}
    for k in pairs(t) do table.insert(out, k) end
    table.sort(out)
    return out
end
-- What the current target would use without its own assignment (the next broader level).
local function inherited()
    local chain = {}
    if assignAct and assignMap then table.insert(chain, { GameAdapter.AllKey(assignMode, assignMap), "map" }) end
    if assignMap or assignAct then table.insert(chain, { GameAdapter.ModeKey(assignMode), "gamemode" }) end
    for _, link in ipairs(chain) do
        local file = settings.MacroMaps[link[1]]
        if file then return file, link[2] end
    end
    if settings.MacroFile ~= "" then return settings.MacroFile, "selected recording" end
    return nil
end
local function targetKey()
    if not assignMode then return nil end
    if assignAct then return assignAct end
    if assignMap then return GameAdapter.AllKey(assignMode, assignMap) end
    return GameAdapter.ModeKey(assignMode)
end
-- The recording list: an "inherit" entry first (clears this level's assignment), then every saved macro.
function fillStageRecordings()      -- forward-declared near the recordings list
    if not stageRecordingField then return end
    local file, from = inherited()
    inheritLabel = file and ("Inherit: " .. file .. " (" .. from .. ")") or "Inherit: nothing (no recording selected)"
    stageRecordingField:Clear()
    stageRecordingField:Add(inheritLabel)
    for _, name in ipairs(macroFiles and macroFiles:List() or {}) do stageRecordingField:Add(name) end
end
function showAssignment()
    if not stageRecordingField then return end
    assignKey = targetKey()
    fillStageRecordings()
    if not assignKey then stageRecordingField:Set(nil, true); return end
    stageRecordingField:Set(settings.MacroMaps[assignKey] or inheritLabel, true)
end
local function showLevels()
    mapField.Instance.Visible = assignMode ~= nil
    actField.Instance.Visible = assignMap ~= nil
end
local function fillActs()
    actField:Clear(); actLookup = {}; assignAct = nil
    local c = stageCatalog()
    local acts = c and assignMode and assignMap and c[assignMode] and c[assignMode][assignMap]
    if acts then
        actField:Add(ALL_ACTS)
        for _, level in ipairs(acts) do
            local label = actLookup[level.Title] and (level.Title .. " [" .. level.Id .. "]") or level.Title
            actLookup[label] = level.Id
            actField:Add(label)
        end
    end
    actField:Set(assignMap and ALL_ACTS or nil, true)
    showLevels(); showAssignment()
end
local function fillMaps()
    mapField:Clear(); assignMap = nil
    local c = stageCatalog()
    if c and assignMode and c[assignMode] then
        mapField:Add(ALL_MAPS)
        for _, location in ipairs(sortedKeys(c[assignMode])) do mapField:Add(location) end
    end
    mapField:Set(assignMode and ALL_MAPS or nil, true)
    fillActs()
end
local function fillModes()
    local c = stageCatalog()
    if not c then return end
    modeField:Clear()
    for _, mode in ipairs(sortedKeys(c)) do modeField:Add(mode) end
    stagesFilled = true
end
stageRecordingField = assignments:AddDropdown({ Text = "Recording", Values = {}, Placeholder = "Pick a gamemode below",
    Callback = function(value)
        local ok, err = pcall(function()
            assert(assignKey, "Pick a gamemode first.")
            local maps = {}
            for k, v in pairs(settings.MacroMaps) do if k ~= assignKey then maps[k] = v end end
            if type(value) == "string" and value ~= inheritLabel then maps[assignKey] = value end
            commit("MacroMaps", maps)
        end)
        if not ok then toast("Stage assignment", err, "Error") end
        showAssignment()
    end })
modeField = assignments:AddDropdown({ Text = "Gamemode", Values = {}, Callback = function(value)
    assignMode = type(value) == "string" and value or nil; fillMaps()
end })
mapField = assignments:AddDropdown({ Text = "Map", Values = {}, Callback = function(value)
    assignMap = type(value) == "string" and value ~= ALL_MAPS and value or nil; fillActs()
end })
actField = assignments:AddDropdown({ Text = "Act", Values = {}, Callback = function(value)
    assignAct = type(value) == "string" and actLookup[value] or nil; showAssignment()
end })
showLevels()
table.insert(refreshers, function() showAssignment() end)

-- 6. Game tab: detection, match status, match automation, the game's own settings.
local gameTab = window:AddTab({ Title = "Game", Subtitle = "Match status and automation", Icon = "td-game" })
local status = gameTab:AddSection({ Title = "Match" })
local detectStatus = status:AddStatus({ Title = "Game", Value = "Detecting" })
local connection = detectStatus          -- one row: detection, then data loading
live.matchInfo = status:AddStatus({ Title = "Match", Value = "Lobby" })
local loading = false
local function loadData()
    if loading or not app.alive then return end
    loading = true; connection:Set("Loading")
    workers:Give(task.spawn(function()
        local ok, err = pcall(adapter.Load, adapter); loading = false
        if not app.alive then return end
        connection:Set(ok and "Connected" or "Unavailable")
        if ok then safe(refresh)() else toast("Game Data Error", err, "Error") end
    end))
end

local auto = gameTab:AddSection({ Title = "Match automation" })
live.match = auto:AddStatus({ Title = "Status", Value = "Off" })
toggle(auto, "Auto start", "AutoStart", "Votes start during prep")
toggle(auto, "Auto skip waves", "AutoSkip", "Votes skip once per wave")
input(auto, "Skip from wave", "SkipFromWave")
dropdown(auto, "When the match ends", "EndAction", Settings.END_ACTIONS)
input(auto, "End delay (seconds)", "EndDelay")
input(auto, "Restart at wave (0 = off)", "RestartWave")
dropdown(auto, "Game speed", "GameSpeed", Settings.GAME_SPEEDS)
toggle(auto, "Claim quests before restart", "ClaimBeforeRestart", "Claims all finished quests right before a replay or restart")
toggle(auto, "Auto skip reward popups", "AutoSkipPopups", "Clicks through \"Click anywhere to continue\" reveals after a match")

local performance = gameTab:AddSection({ Title = "Performance" })
live.map = performance:AddStatus({ Title = "Status", Value = "Off" })
toggle(performance, "Delete map", "DeleteMap", "White platforms for placeable areas, a dark track and a grey baseplate; everything else is removed on your side")

-- The game's own server-side settings (SettingsRequest). Not part of configs: the server stores them.
local gameSettings = gameTab:AddSection({ Title = "Game settings", Description = "Sent to the game's own settings; the server keeps them." })
local serverToggles = {}
local serverPending = {}   -- kind -> { Value, At }: a change waiting for SettingsResult
for _, entry in ipairs({ { "autoWaveSkip", "Game auto wave skip" }, { "autoReplay", "Game auto replay" },
    { "seamlessRetry", "Game seamless retry" }, { "autoSellFarms", "Game auto sell farms" }, { "lowQuality", "Game low quality" } }) do
    local kind = entry[1]
    local control
    control = gameSettings:AddToggle({ Text = entry[2], Default = false, Callback = function(value)
        local ok, err = pcall(function() assert(app.ready and adapter.loaded, "Game data is still loading."); adapter:GameSetting(kind, value) end)
        if ok then serverPending[kind] = { Value = value, At = os.clock() } end
        if not ok then toast("Game setting", err, "Error"); control:Set(not value, true); return end
        -- Read back what the server kept (the live loop shows SettingsResult).
        task.delay(0.6, function() adapter:RequestSettings() end)
    end })
    serverToggles[kind] = control
end

-- 7. AutoPlay tab: placement, upgrades, targeting, abilities.
local autoTab = window:AddTab({ Title = "AutoPlay", Subtitle = "Place, upgrade, target, abilities", Icon = "td-auto" })
local placement = autoTab:AddSection({ Title = "Autoplay",
    Description = "Places each hotbar slot's units beside the enemy path, checked with the game's own placement rules." })
live.place = placement:AddStatus({ Title = "Status", Value = "Off" })
toggle(placement, "Autoplay", "Autoplay", "Places units during prep and waves, in slot order, when affordable")
dropdown(placement, "Placement mode", "PlaceMode", Settings.PLACE_MODES)
input(placement, "Track position (% from spawn)", "TrackPercent")
placement:AddButton({ Text = "Preview track position", Secondary = true, Callback = safe(function()
    assert(app.ready and adapter.loaded, "Game data is still loading.")
    local base, direction = adapter:PathFrame(settings.TrackPercent)
    assert(base, "No enemy path here: join a match first.")
    -- The spots autoplay would use next: the nearest candidates that pass the game's placement check.
    local spots = {}
    for _, c in ipairs(Automation.Placer.PathCandidates(base, direction, settings.PlaceSpacing)) do
        local position = adapter:Validate(c[1], c[2], c[3])
        if position then table.insert(spots, position) end
        if #spots >= 8 then break end
    end
    adapter:Preview(base, spots)
    toast("Track preview", string.format("%g%% along the path, %d valid spots nearby", settings.TrackPercent, #spots))
end) })
placement:AddButton({ Text = "Save position below character", Callback = safe(function()
    local map = assert(adapter:MapKey(), "Join a match first: positions are saved per map.")
    local point = adapter:CharacterGround()
    local anchors = {}
    for k, v in pairs(settings.Anchors) do anchors[k] = v end
    anchors[map] = { point.X, point.Y, point.Z }
    commit("Anchors", anchors)
    toast("Position Saved", map, "Success")
end) })
placement:AddButton({ Text = "Clear position for this map", Secondary = true, Callback = safe(function()
    local map = assert(adapter:MapKey(), "Not in a match.")
    local anchors = {}
    for k, v in pairs(settings.Anchors) do if k ~= map then anchors[k] = v end end
    commit("Anchors", anchors)
end) })
local countsField
countsField = placement:AddInput({ Text = "Units per slot (1-6, comma separated; each unit's cap applies)", Default = table.concat(settings.PlaceCounts, ","),
    Callback = function(value)
        local counts = {}
        for n in tostring(value):gmatch("[^,%s]+") do table.insert(counts, tonumber(n) or -1) end
        local ok, err = pcall(function()
            assert(#counts == Settings.SLOTS, "Enter 6 numbers, one per slot, e.g. 1,1,2,0,3,1")
            commit("PlaceCounts", counts)
        end)
        countsField:Set(table.concat(settings.PlaceCounts, ","), true)
        if not ok then toast("Invalid setting", err, "Error") end
    end })
table.insert(refreshers, function() countsField:Set(table.concat(settings.PlaceCounts, ","), true) end)
input(placement, "Spacing (studs)", "PlaceSpacing")
input(placement, "Placement interval (seconds)", "PlaceInterval")

local upgrades = autoTab:AddSection({ Title = "Auto upgrade",
    Description = "Priority finishes the top slot first; Even raises the lowest level. Waits until the next upgrade is affordable." })
live.upgrade = upgrades:AddStatus({ Title = "Status", Value = "Off" })
toggle(upgrades, "Auto upgrade", "AutoUpgrade")
dropdown(upgrades, "Upgrade mode", "UpgradeMode", Settings.UPGRADE_MODES)
input(upgrades, "Upgrade limit (99 = each unit's max)", "UpgradeLimit")
toggle(upgrades, "Upgrade farms first", "UpgradeFarmsFirst", "Farm units get every upgrade until they hit the limit, then the rest")
input(upgrades, "Upgrade interval (seconds)", "UpgradeInterval")
local priority = upgrades:AddPriorityList({ Text = "Upgrade priority", Values = settings.UpgradeOrder,
    Callback = function(order) commit("UpgradeOrder", order) end })
table.insert(refreshers, function() priority:Set(settings.UpgradeOrder, true) end)

local targeting = autoTab:AddSection({ Title = "Targeting" })
dropdown(targeting, "Target mode for new units", "TargetMode", Settings.TARGETS)

local abilities = autoTab:AddSection({ Title = "Auto ability" })
live.ability = abilities:AddStatus({ Title = "Status", Value = "Off" })
toggle(abilities, "Auto ability", "AutoAbility", "Uses unit abilities by their mode; respects unlock level and cooldowns")
dropdown(abilities, "Default mode", "AbilityDefault", Settings.ABILITY_MODES)
input(abilities, "Default from wave", "AbilityFromWave")
-- Per-unit modes: pick a unit with an ability, then its mode (and wave for From wave).
local abilityUnit
local abilityUnitField, unitModeField, unitWaveField
local function unitEntry(name)
    return settings.AbilityUnits[name] or { Mode = "Default", Wave = settings.AbilityFromWave }
end
local function setUnitEntry(name, entry)
    local units = {}
    for k, v in pairs(settings.AbilityUnits) do units[k] = v end
    units[name] = entry.Mode ~= "Default" and entry or nil
    commit("AbilityUnits", units)
end
local function showUnit()
    if not abilityUnit then return end
    local entry = unitEntry(abilityUnit)
    unitModeField:Set(entry.Mode, true)
    unitWaveField:Set(tostring(entry.Wave), true)
end
abilityUnitField = abilities:AddDropdown({ Text = "Unit", Values = {}, Callback = function(value)
    abilityUnit = type(value) == "string" and value or nil; showUnit()
end })
unitModeField = abilities:AddDropdown({ Text = "Unit ability mode", Values = Settings.UNIT_ABILITY_MODES, Default = "Default",
    Callback = function(value)
        local ok, err = pcall(function()
            assert(abilityUnit, "Pick a unit first.")
            local entry = unitEntry(abilityUnit)
            setUnitEntry(abilityUnit, { Mode = value, Wave = entry.Wave })
        end)
        if not ok then toast("Unit ability", err, "Error"); unitModeField:Set("Default", true) end
    end })
unitWaveField = abilities:AddInput({ Text = "Unit ability wave", Default = "1", Callback = function(value)
    local ok, err = pcall(function()
        assert(abilityUnit, "Pick a unit first.")
        local entry = unitEntry(abilityUnit)
        setUnitEntry(abilityUnit, { Mode = entry.Mode == "Default" and "From wave" or entry.Mode, Wave = tonumber(value) })
    end)
    if not ok then toast("Invalid setting", err, "Error") end
    showUnit()
end })
local abilityUnitsKey
local function refreshAbilityUnits()
    local names = adapter.loaded and adapter:AbilityUnits() or {}
    for name in pairs(settings.AbilityUnits) do
        local known = false
        for _, n in ipairs(names) do if n == name then known = true end end
        if not known then table.insert(names, name) end
    end
    table.sort(names)
    local key = table.concat(names, "|")
    if key == abilityUnitsKey then return end
    abilityUnitsKey = key
    abilityUnitField:Clear()
    for _, name in ipairs(names) do abilityUnitField:Add(name) end
    if abilityUnit then abilityUnitField:Set(abilityUnit, true) end
end
table.insert(refreshers, function() abilityUnitsKey = nil; refreshAbilityUnits(); showUnit() end)
toggle(abilities, "Auto Erwin", "AutoErwin", "Rotates 3 Erwen buffs back to back")
toggle(abilities, "Auto Wendy", "AutoWendy", "Rotates 3 Wendy buffs back to back")
toggle(abilities, "Auto Kisuke", "AutoKisuke", "Rotates 3 Kisuke (Bankai) buffs; needs upgrade 6")

-- 8. Lobby tab: auto select + start inside a room.
local lobbyTab = window:AddTab({ Title = "Lobby", Subtitle = "Room auto start", Icon = "td-lobby" })
local join = lobbyTab:AddSection({ Title = "Auto join",
    Description = "Walk into a room; the script selects the stage and difficulty and starts it." })
live.lobby = join:AddStatus({ Title = "Status", Value = "Off" })
toggle(join, "Auto join", "AutoJoin")
local levelLookup = {}
local levelField = join:AddDropdown({ Text = "Stage", Values = {}, Callback = safe(function(value)
    if levelLookup[value] then commit("JoinLevel", levelLookup[value]) end
end) })
local levelVersion = -1
local function refreshLevels()
    local values = {}
    for id, title in pairs(adapter.catalog.Levels) do values[id] = title end
    levelLookup = fill(levelField, values, settings.JoinLevel)
    levelVersion = adapter.catalogVersion
end
table.insert(refreshers, refreshLevels)
local customLevel
customLevel = join:AddInput({ Text = "Custom stage id", Placeholder = "e.g. namek_3", Callback = function(value)
    value = tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
    if value == "" then return end
    local ok, err = pcall(commit, "JoinLevel", value)
    if ok then refreshLevels() else toast("Invalid setting", err, "Error") end
end })
dropdown(join, "Difficulty", "JoinDifficulty", Settings.DIFFICULTIES)
join:AddButton({ Text = "Leave room", Secondary = true, Callback = safe(function() adapter:RoomAction("leave") end) })

-- 9. Misc tab: rewards.
local miscTab = window:AddTab({ Title = "Misc", Subtitle = "Quests and battle pass", Icon = "td-shop" })
local rewards = miscTab:AddSection({ Title = "Rewards" })
live.rewards = rewards:AddStatus({ Title = "Status", Value = "Off" })
toggle(rewards, "Auto claim quests", "AutoClaimQuests")
toggle(rewards, "Auto claim battle pass", "AutoClaimPass")
rewards:AddButton({ Text = "Claim quests now", Secondary = true, Callback = safe(function()
    local result = adapter:ClaimQuests()
    toast("Quests", type(result) == "table" and (result.message or (result.success and "Claimed" or "Nothing to claim")) or "Done")
end) })
rewards:AddButton({ Text = "Claim battle pass now", Secondary = true, Callback = safe(function()
    local result = adapter:ClaimPass()
    toast("Battle pass", type(result) == "table" and (result.message or (result.success and "Claimed" or "Nothing to claim")) or "Done")
end) })

-- 9b. Webhook tab: Discord match reports.
local webhookTab = window:AddTab({ Title = "Webhook", Subtitle = "Discord match reports", Icon = "td-webhook" })
local hook = webhookTab:AddSection({ Title = "Match reports",
    Description = "After each match: result, time, mode, gems, gold, trait rerolls, level and XP, and every drop. Secret drops ping you." })
live.webhook = hook:AddStatus({ Title = "Status", Value = "Off" })
toggle(hook, "Send match reports", "WebhookEnabled")
local function textSetting(section, title, key, placeholder, secret)
    local field
    field = section:AddInput({ Text = title, Placeholder = placeholder, Default = secret and "" or settings[key], Callback = function(value)
        local trimmed = tostring(value):gsub("^%s+", ""):gsub("%s+$", "")
        if secret and trimmed == "" then field:Set("", true); return end       -- blur on the hidden box: keep the saved URL
        local ok, err = pcall(commit, key, trimmed)
        if not ok then toast("Invalid setting", err, "Error") end
        field:Set(secret and "" or settings[key], true)
    end })
    table.insert(refreshers, function() field:Set(secret and "" or settings[key], true) end)
    return field
end
textSetting(hook, "Discord webhook URL", "WebhookURL", "Paste the URL (hidden after saving)", true)
textSetting(hook, "Discord user ID to ping for Secret drops", "WebhookUserId", "e.g. 123456789012345678")
hook:AddButton({ Text = "Send test report", Secondary = true, Callback = safe(function()
    assert(Webhook.ValidUrl(settings.WebhookURL), "Paste a Discord webhook URL first.")
    local report = adapter.loaded and adapter.results and adapter:MatchReport(adapter.results)
    if not report then
        -- Sample match, but with your live totals and level so the layout matches a real report.
        local totals, level = {}, {}
        if adapter.loaded then
            if not adapter.inventory then adapter:RequestInventory(); task.wait(1.5) end
            totals = adapter:Totals()
            level = adapter:PlayerProgress(); level.Raw = nil
        end
        report = { Won = true, Title = "Test report", Location = "GogHub", Difficulty = "Normal", Waves = 15, WaveCount = 15, Elapsed = 240,
            Rewards = { Gems = 240, Gold = 0, Xp = 240, Rerolls = 2 }, Totals = totals, Level = level,
            Drops = { { Name = "Relic Shard", Count = 2, Rarity = "Legendary" } }, Units = {} }
    end
    report.Mode = "Test"
    local ok, err = postWebhook(settings.WebhookURL, Webhook.Payload(report, settings.WebhookUserId))
    assert(ok, err)
    toast("Webhook", "Test report sent.", "Success")
end) })
hook:AddButton({ Text = "Clear webhook URL", Secondary = true, Callback = safe(function() commit("WebhookURL", "") end) })

-- 10. Config tab.
local configs = window:AddTab({ Title = "Config", Icon = "td-config" }):AddSection({ Title = "Configs",
    Description = store and ("Saved in workspace/" .. Profile.Namespace .. "/Configs") or ("File functions unavailable: " .. table.concat(missing, ", ")) })
local configField, autosave, configName
local function refreshConfigs()
    configField:Clear()
    for _, file in ipairs(store and store:List() or {}) do configField:Add(file) end
    configField:Set(selectedConfig, true)
end
local function saveAutosave()
    if store and settings.Autosave and autosaveTarget and dirty then
        store:Save(autosaveTarget, settings); dirty = false
    end
end
local function requireStore() assert(store, "This executor has no file functions.") end
local function loadConfig(file)
    requireStore(); saveAutosave()
    settings, selectedConfig = store:Load(file)
    autosaveTarget = settings.Autosave and selectedConfig or nil; dirty = false
    window:SetToggleKey(keyCode(settings.ToggleKey))
    refresh(); autosave:Set(settings.Autosave, true); refreshConfigs()
end
configField = configs:AddDropdown({ Text = "Selected config", Values = {}, Callback = function(value) selectedConfig = value end })
configs:AddInput({ Text = "New config", Placeholder = "File name", Callback = function(value) configName = value end })
configs:AddButton({ Text = "Create Config", Callback = safe(function()
    requireStore(); selectedConfig = store:Save(configName, settings, true)
    if settings.Autosave then autosaveTarget = selectedConfig end
    refreshConfigs(); toast("Config Created", selectedConfig, "Success")
end) })
configs:AddButton({ Text = "Save Config", Callback = safe(function()
    requireStore(); assert(selectedConfig, "Select a config."); store:Save(selectedConfig, settings); dirty = false
    toast("Config Saved", selectedConfig, "Success")
end) })
configs:AddButton({ Text = "Load Config", Callback = safe(function() assert(selectedConfig, "Select a config."); loadConfig(selectedConfig) end) })
configs:AddButton({ Text = "Delete Config", Secondary = true, Callback = safe(function()
    requireStore(); assert(selectedConfig, "Select a config."); store:Delete(selectedConfig)
    if autosaveTarget == selectedConfig then commit("Autosave", false); autosaveTarget = nil; autosave:Set(false, true) end
    selectedConfig = nil; refreshConfigs()
end) })
configs:AddButton({ Text = "Autoload Selected", Callback = safe(function()
    requireStore(); assert(selectedConfig, "Select a config."); toast("Autoload Set", store:SetAutoload(selectedConfig), "Success")
end) })
configs:AddButton({ Text = "Clear Autoload", Secondary = true, Callback = safe(function() requireStore(); store:ClearAutoload() end) })
autosave = configs:AddToggle({ Text = "Config autosave", Default = false, Callback = function(value)
    local ok, err = pcall(function()
        if value then requireStore(); assert(selectedConfig, "Create or select a config first."); store:Load(selectedConfig); autosaveTarget = selectedConfig end
        local target = autosaveTarget
        commit("Autosave", value)
        if target then store:Save(target, settings); dirty = false end
        if not value then autosaveTarget = nil end
    end)
    autosave:Set(settings.Autosave, true)
    if not ok then toast("Autosave Error", err, "Error") end
end })

-- 11. Footer Settings tab: signature color, interface, helpers, session.
local settingsTab = window:AddTab({ Title = "Settings", Icon = "settings", Footer = true })
local appearance = settingsTab:AddSection({ Title = "Signature color" })
local COLORS = { Jade = Color3.fromRGB(155, 227, 201), Glacier = Color3.fromRGB(157, 199, 245),
    Iris = Color3.fromRGB(195, 177, 242), Coral = Color3.fromRGB(242, 151, 137) }
local picker
local function applyAccent(color, persist)
    window:SetAccent(color)
    if persist and theme then theme:Set({ color.R, color.G, color.B }) end
end
appearance:AddDropdown({ Text = "Palette", Values = { "Jade", "Glacier", "Iris", "Coral" }, Callback = function(value)
    if COLORS[value] then applyAccent(COLORS[value], true); picker:Set(COLORS[value], true) end
end })
picker = appearance:AddColorPicker({ Text = "Custom accent", Default = window.Theme.Accent, Callback = function(value) applyAccent(value, true) end })
if theme then
    safe(function()
        local c = theme:Load()
        if c then local color = Color3.new(c[1], c[2], c[3]); applyAccent(color, false); picker:Set(color, true) end
    end)()
end
local interface = settingsTab:AddSection({ Title = "Interface" })
local keybind = interface:AddKeybind({ Text = "Toggle window", Default = keyCode(settings.ToggleKey),
    Changed = safe(function(key) commit("ToggleKey", key.Name); window:SetToggleKey(key) end) })
table.insert(refreshers, function() keybind:Set(keyCode(settings.ToggleKey), true) end)
local helpers = settingsTab:AddSection({ Title = "Helpers" })
toggle(helpers, "Anti-AFK", "AntiAFK", "Prevents the Roblox idle kick")
local session = settingsTab:AddSection({ Title = "Session" })
session:AddParagraph("Executor", type(identifyexecutor) == "function" and table.concat({ identifyexecutor() }, " ") or "unknown")
session:AddButton({ Text = "Unload script", Secondary = true, Callback = function() app:Destroy() end })

-- 12. Lifecycle: unload disposes controllers in order and flushes state.
function app:Destroy()
    if not self.alive then return end
    pcall(saveAutosave)
    if theme then pcall(theme.Dispose, theme) end
    self.alive = false
    pcall(macro.Dispose, macro)                   -- saves an unfinished recording
    for _, c in ipairs(controllers) do pcall(c.Dispose, c) end
    pcall(antiAFK.Dispose, antiAFK); pcall(adapter.Dispose, adapter)
    workers:Destroy()
    window:Destroy()
    if env[KEY] == self then env[KEY] = nil end
end
workers:Give(window.Gui.Destroying:Connect(function() app:Destroy() end))   -- close button, hub, or UI reload
if localPlayer and localPlayer.OnTeleport then
    workers:Give(localPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then
            safe(saveAutosave)(); if theme then theme:Flush() end
            if macro.recording then pcall(macro.StopRecord, macro) end
        end
    end))
end

-- 13. Startup: controls, configs, autoload.
refresh(); refreshConfigs()
if store then safe(function() local file = store:GetAutoload(); if file then loadConfig(file) end end)() end
macroTab:Select(); window:SetStatus("Ready", "Idle")

-- 14. Heartbeat supervisor: every controller Step is non-blocking and individually guarded.
workers:Give(RunService.Heartbeat:Connect(function()
    if not app.alive then return end
    local ok, err = pcall(antiAFK.Step, antiAFK, settings)
    if not ok then toast("Anti-AFK Error", err, "Error") end
    if not (app.ready and adapter.loaded) then return end
    local playing = settings.MacroPlay and not macro.recording
    for _, c in ipairs(controllers) do
        if playing and macroConflicts[c] then
            if c.enabled then c:Stop() end
        else
            local cok, cerr = pcall(c.Step, c, settings)
            if not cok then toast(c.name, cerr, "Error") end
        end
    end
end))

-- 15. Live loop: status rows. Slow loop: autosave and footer status.
local function text(value, fallback) return value ~= nil and tostring(value) or fallback end
local function show(row, visible)
    if row.Instance.Visible ~= visible then row.Instance.Visible = visible end
end
local function count(n) return n and tostring(math.floor(n)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") or "?" end
local wasRecording = false
workers:Loop("Live", 0.5, function()
    local waiting = not app.ready and "Waiting for game" or (not adapter.loaded and "Waiting for game data") or "Off"
    -- Macro tab: the selected recording, or what recording / playback / team equip is doing.
    if recordToggle then recordToggle:Set(macro.recording ~= nil, true) end
    if wasRecording and not macro.recording and macro.lastSaved then
        safe(function() commit("MacroFile", macro.lastSaved); refreshRecordings() end)()
    end
    wasRecording = macro.recording ~= nil
    local macroText = recordingSummary
    if macro.recording then macroText = macro.status
    elseif settings.MacroAutoEquip and adapter.teamReady == false then macroText = equipCtl.status
    elseif macroCtl.enabled then macroText = macroCtl.status end
    live.macro:Set(macroText)
    -- Feature rows only show while that feature is on.
    local paused = settings.MacroPlay and not macro.recording and "Paused while a macro plays"
    show(live.match, settings.AutoStart or settings.AutoSkip or settings.EndAction ~= "Off" or settings.RestartWave > 0 or settings.AutoSkipPopups or settings.GameSpeed ~= "Off")
    local matchText = matchCtl.enabled and matchCtl.status or waiting
    if popupCtl.enabled and (popupCtl.feature.clicks or 0) > 0 then matchText = matchText .. " - " .. popupCtl.feature.clicks .. " popups skipped" end
    live.match:Set(matchText)
    show(live.place, settings.Autoplay)
    live.place:Set(paused or (placeCtl.enabled and placeCtl.status or waiting))
    show(live.upgrade, settings.AutoUpgrade)
    live.upgrade:Set(paused or (upgradeCtl.enabled and upgradeCtl.status or waiting))
    local rotating = settings.AutoErwin or settings.AutoWendy or settings.AutoKisuke
    show(live.ability, settings.AutoAbility or rotating)
    local abilityParts = {}
    if settings.AutoAbility then table.insert(abilityParts, paused or (abilityCtl.enabled and abilityCtl.status or waiting)) end
    if rotating then table.insert(abilityParts, erwinCtl.enabled and erwinCtl.status or waiting) end
    live.ability:Set(table.concat(abilityParts, " | "))
    show(live.lobby, settings.AutoJoin)
    live.lobby:Set(lobbyCtl.enabled and lobbyCtl.status or waiting)
    show(live.map, settings.DeleteMap)
    live.map:Set(mapCtl.enabled and mapCtl.status or waiting)
    show(live.rewards, settings.AutoClaimQuests or settings.AutoClaimPass)
    live.rewards:Set(rewardCtl.enabled and rewardCtl.status or waiting)
    live.webhook:Set(webhookCtl.enabled and webhookCtl.status
        or (settings.WebhookEnabled and "Paste a valid webhook URL" or (settings.WebhookURL ~= "" and "Off - URL saved" or "Off")))
    if not adapter.loaded then return end
    -- Game row: ready, plus any game module that's still loading or unavailable.
    local issues = {}
    for name, err in pairs(adapter.moduleErrors) do table.insert(issues, name .. " " .. err) end
    table.sort(issues)
    connection:Set(#issues == 0 and "Ready" or ("Ready (" .. table.concat(issues, ", ") .. ")"))
    local r = adapter:Read()
    if r.State then
        live.matchInfo:Set(string.format("%s - wave %s/%s - %s cash - %d units", tostring(r.Title or r.Location or "?"),
            text(r.Wave, "0"), text(r.WaveCount, "?"), count(r.Money), r.MyUnits))
    else
        live.matchInfo:Set(r.InRoom and "In a lobby room" or "Lobby")
    end
    if type(adapter.gameSettings) == "table" then
        for kind, control in pairs(serverToggles) do
            local current, pending = adapter.gameSettings[kind], serverPending[kind]
            if pending and (current == pending.Value or os.clock() - pending.At > 3) then serverPending[kind] = nil; pending = nil end
            if not pending and type(current) == "boolean" then control:Set(current, true) end
        end
    end
    if adapter.catalogVersion ~= levelVersion then refreshLevels() end
    refreshAbilityUnits()
    if not stagesFilled then fillModes() end
end)
workers:Loop("Status", 2, function()
    saveAutosave()
    local active = 0
    for _, c in ipairs(controllers) do if c.enabled then active = active + 1 end end
    window:SetStatusPill(active == 0 and "Idle" or (active .. (active == 1 and " task active" or " tasks active")))
end)

-- 16. Bounded game detection, then load game data. Features stay off if the game doesn't match.
workers:Give(task.spawn(function()
    local deadline = os.clock() + Profile.DetectTimeout
    local matched = adapter:Matches()
    while app.alive and not matched and os.clock() < deadline do
        task.wait(0.25); matched = adapter:Matches()
    end
    if not app.alive then return end
    if matched then
        app.ready = true
        detectStatus:Set("Supported"); window:SetStatus("Ready")
        loadData()
    else
        detectStatus:Set("Not detected", window.Theme.Danger); window:SetStatus("Unsupported game", "Off")
        toast(Profile.Name, "This game's remotes don't match the profile. Features stay off.", "Error")
    end
end))

return window
