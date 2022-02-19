if myHero.charName ~= "Karma" then return end

require "GGPrediction"

local GG_Target
local GG_Orbwalker
local GG_Object

Callback.Add("Load", function()
	GG_Target = _G.SDK.TargetSelector
	GG_Orbwalker = _G.SDK.Orbwalker
    GG_Object = _G.SDK.ObjectManager
end)

class "EasyKarma"

function EasyKarma:__init()
	self:LoadSpells()
	self:LoadMenu()

	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)

	PrintChat("EasyKarma v1.0 by ikkeflikkeri Loaded!")
end

function EasyKarma:Tick()
	self:Combo()
	self:Harass()
	self:Flee()
	self:Auto()
end

function EasyKarma:LoadSpells()
	self.spellPredictionQ = GGPrediction:SpellPrediction({Delay = 0.25, Radius = 80, Range = 875, Speed = 1700, Collision = false, Type = GGPrediction.SPELLTYPE_LINE})
end

function EasyKarma:LoadMenu()
	self.Menu = MenuElement({type = MENU, id = "easyKarma", name = "EasyKarma"})

    self.Menu:MenuElement({type = MENU, id = "Combo", name = "Combo Settings"})
	self.Menu.Combo:MenuElement({id = "useQ", name = "Use Q", value = true})
	self.Menu.Combo:MenuElement({id = "useW", name = "Use W", value = true})
	self.Menu.Combo:MenuElement({id = "useE", name = "Use E", value = true})
	self.Menu.Combo:MenuElement({id = "useESpellsAlly", name = "Use E on targeted spells ally", value = true})
	self.Menu.Combo:MenuElement({id = "useEAttackAlly", name = "Use E on targeted attack ally", value = true})
	self.Menu.Combo:MenuElement({id = "useESpellsSelf", name = "Use E on targeted spells self", value = true})
	self.Menu.Combo:MenuElement({id = "useEAttackSelf", name = "Use E on targeted attack self", value = false})
	self.Menu.Combo:MenuElement({id = "useRQ", name = "Use RQ", value = true})
	self.Menu.Combo:MenuElement({id = "useRQAllies", name = "Use RQ only when <3 allies", value = true})
	self.Menu.Combo:MenuElement({id = "useRE", name = "Use RE", value = true})
    self.Menu.Combo:MenuElement({id = "useREAllies", name = "Use RE only when >2 allies", value = true})

    self.Menu:MenuElement({type = MENU, id = "Harass", name = "Harass Settings"})
	self.Menu.Harass:MenuElement({id = "useQ", name = "Use Q", value = true})
	self.Menu.Harass:MenuElement({id = "useW", name = "Use W", value = true})
	self.Menu.Harass:MenuElement({id = "useE", name = "Use E", value = true})
	self.Menu.Harass:MenuElement({id = "useESpellsAlly", name = "Use E on targeted spells ally", value = true})
	self.Menu.Harass:MenuElement({id = "useEAttackAlly", name = "Use E on targeted attack ally", value = false})
	self.Menu.Harass:MenuElement({id = "useESpellsSelf", name = "Use E on targeted spells self", value = true})
	self.Menu.Harass:MenuElement({id = "useEAttackSelf", name = "Use E on targeted attack self", value = false})
	self.Menu.Harass:MenuElement({id = "useRQ", name = "Use RQ", value = true})
	self.Menu.Harass:MenuElement({id = "useRQAllies", name = "Use RQ only when <3 allies", value = false})
	self.Menu.Harass:MenuElement({id = "useRE", name = "Use RE", value = false})
    self.Menu.Harass:MenuElement({id = "useREAllies", name = "Use RE only when >2 allies", value = false})

    self.Menu:MenuElement({type = MENU, id = "Flee", name = "Flee Settings"})
	self.Menu.Flee:MenuElement({id = "useQ", name = "Use Q", value = true})
	self.Menu.Flee:MenuElement({id = "useW", name = "Use W", value = true})
	self.Menu.Flee:MenuElement({id = "useE", name = "Use E", value = true})
	self.Menu.Flee:MenuElement({id = "useESpellsAlly", name = "Use E on targeted spells ally", value = true})
	self.Menu.Flee:MenuElement({id = "useEAttackAlly", name = "Use E on targeted attack ally", value = true})
	self.Menu.Flee:MenuElement({id = "useESpellsSelf", name = "Use E on targeted spells self", value = true})
	self.Menu.Flee:MenuElement({id = "useEAttackSelf", name = "Use E on targeted attack self", value = true})
	self.Menu.Flee:MenuElement({id = "useRQ", name = "Use RQ", value = true})
	self.Menu.Flee:MenuElement({id = "useRQAllies", name = "Use RQ only when <3 allies", value = false})
	self.Menu.Flee:MenuElement({id = "useRE", name = "Use RE", value = false})
    self.Menu.Flee:MenuElement({id = "useREAllies", name = "Use RE only when >2 allies", value = false})

    self.Menu:MenuElement({type = MENU, id = "Auto", name = "Auto Settings"})
	self.Menu.Auto:MenuElement({id = "useE", name = "Use E", value = true})
	self.Menu.Auto:MenuElement({id = "useESpellsAlly", name = "Use E on targeted spells ally", value = true})
	self.Menu.Auto:MenuElement({id = "useEAttackAlly", name = "Use E on targeted attack ally", value = false})
	self.Menu.Auto:MenuElement({id = "useESpellsSelf", name = "Use E on targeted spells self", value = true})
	self.Menu.Auto:MenuElement({id = "useEAttackSelf", name = "Use E on targeted attack self", value = false})

	self.Menu:MenuElement({type = MENU, id = "Draw", name = "Draw Settings"})
	self.Menu.Draw:MenuElement({id = "drawQ", name = "Draw Q Range", value = true})
	self.Menu.Draw:MenuElement({id = "drawW", name = "Draw W Range", value = false})
	self.Menu.Draw:MenuElement({id = "drawE", name = "Draw E Range", value = true})
end

function EasyKarma:Draw()
	if self.Menu.Draw.drawQ:Value() then
		Draw.Circle(myHero.pos, self.spellPredictionQ.Range, 1, SpellDrawColor(_Q))
	end

    if self.Menu.Draw.drawW:Value() then
		Draw.Circle(myHero.pos, 650, 1, SpellDrawColor(_W))
	end

    if self.Menu.Draw.drawE:Value() then
		Draw.Circle(myHero.pos, 800, 1, SpellDrawColor(_E))
	end
end

function EasyKarma:Combo()
	if not IsInComboMode() then
		return
	end

    self:UseQ(self.Menu.Combo.useQ:Value(), self.Menu.Combo.useRQ:Value(), self.Menu.Combo.useRQAllies:Value(), _G.GGPrediction.HITCHANCE_NORMAL)
    self:UseW(self.Menu.Combo.useW:Value())
    self:UseE(self.Menu.Combo.useE:Value(), self.Menu.Combo.useRE:Value(), self.Menu.Combo.useREAllies:Value(), self.Menu.Combo.useESpellsAlly:Value(), self.Menu.Combo.useEAttackAlly:Value(), self.Menu.Combo.useESpellsSelf:Value(), self.Menu.Combo.useEAttackSelf:Value())
end

function EasyKarma:Harass()
	if not IsInHarassMode() then
		return
	end

    self:UseQ(self.Menu.Harass.useQ:Value(), self.Menu.Harass.useRQ:Value(), self.Menu.Harass.useRQAllies:Value(), _G.GGPrediction.HITCHANCE_HIGH)
    self:UseW(self.Menu.Harass.useW:Value())
    self:UseE(self.Menu.Harass.useE:Value(), self.Menu.Harass.useRE:Value(), self.Menu.Harass.useREAllies:Value(), self.Menu.Harass.useESpellsAlly:Value(), self.Menu.Harass.useEAttackAlly:Value(), self.Menu.Harass.useESpellsSelf:Value(), self.Menu.Harass.useEAttackSelf:Value())
end

function EasyKarma:Flee()
	if not IsInFleeMode() then
		return
	end

    self:UseQ(self.Menu.Flee.useQ:Value(), self.Menu.Flee.useRQ:Value(), self.Menu.Flee.useRQAllies:Value(), _G.GGPrediction.HITCHANCE_NORMAL)
    self:UseW(self.Menu.Flee.useW:Value())
    self:UseE(self.Menu.Flee.useE:Value(), self.Menu.Flee.useRE:Value(), self.Menu.Flee.useREAllies:Value(), self.Menu.Flee.useESpellsAlly:Value(), self.Menu.Flee.useEAttackAlly:Value(), self.Menu.Flee.useESpellsSelf:Value(), self.Menu.Flee.useEAttackSelf:Value())
end

function EasyKarma:Auto()
	if not IsInAutoMode() then
		return
	end

    self:UseE(self.Menu.Auto.useE:Value(), false, false, self.Menu.Auto.useESpellsAlly:Value(), self.Menu.Auto.useEAttackAlly:Value(), self.Menu.Auto.useESpellsSelf:Value(), self.Menu.Auto.useEAttackSelf:Value())
end

function EasyKarma:UseQ(useQ, useRQ, useRQAllies, hitchance)
	if useQ and IsSpellReady(_Q) then
        local useR = false
        if useRQ and IsSpellReady(_R) then
            if useRQAllies then
                if GetAllyCount(1000) < 3 then
                    useR = true
                end
            else
                useR = true
            end
        end

        if useR then
            self.spellPredictionQ.Range = 1000
        else
            self.spellPredictionQ.Range = 870
        end
        
        if IsInComboMode() then
            local qTargets = GetEnemyHeroes(self.spellPredictionQ.Range + 250)
            local qTarget = GG_Target:GetTarget(qTargets, DAMAGE_TYPE_MAGICAL)
            if IsValidTarget(qTarget) then
                self.spellPredictionQ:GetPrediction(qTarget, myHero)
                if self.spellPredictionQ:CanHit(hitchance) and GetCollisionCount(self.spellPredictionQ) < 1 then
                    self:CastSpell(HK_Q, useR, self.spellPredictionQ.CastPosition)
                end
            end
        end

        if IsInHarassMode() then
            local qTargets = GetEnemyHeroes(self.spellPredictionQ.Range + 250)
            for i, qTarget in ipairs(qTargets) do
                if IsValidTarget(qTarget) and IsSpellReady(_Q) then
                    self.spellPredictionQ:GetPrediction(qTarget, myHero)
                    if self.spellPredictionQ:CanHit(hitchance) and GetCollisionCount(self.spellPredictionQ) < 1 then
                        self:CastSpell(HK_Q, useR, self.spellPredictionQ.CastPosition)
                    end
                end
            end
        end
        
        if IsInFleeMode() then
            local qTarget = GetClosestEnemy(self.spellPredictionQ.Range + 250)
            if IsValidTarget(qTarget) then
                self.spellPredictionQ:GetPrediction(qTarget, myHero)
                if self.spellPredictionQ:CanHit(hitchance) and GetCollisionCount(self.spellPredictionQ) < 1 then
                    self:CastSpell(HK_Q, useR, self.spellPredictionQ.CastPosition)
                end
            end
        end
	end
end

function EasyKarma:UseW(useW)
    if useW and IsSpellReady(_W) then
		local wTarget = GetClosestEnemy(650)
		if IsValidTarget(wTarget) then
            Control.CastSpell(HK_W, wTarget)
		end
	end
end

function EasyKarma:UseE(useE, useRE, useREAllies, useESpellsAlly, useEAttackAlly, useESpellsSelf, useEAttackSelf)
    if useE and IsSpellReady(_E) then
        local useR = false
        if useRE and IsSpellReady(_R) then

            if useREAllies then
                if GetAllyCount(1000) > 2 then
                    useR = true
                end
            else
                useR = true
            end
        end

        for i, enemy in ipairs(GetEnemyHeroes(2500)) do
            if IsValidTarget(enemy) then
                for i, ally in pairs(GetAllyHeroes(800)) do
                    if IsValidTarget(ally) then
                        if ally.handle == myHero.handle then
                            if useESpellsSelf and enemy.activeSpell.target == ally.handle and IsSpellReady(_E) then
                                self:CastSpell(HK_E, useR, ally)
                            end
                            if useEAttackSelf and enemy.attackData.target == ally.handle and IsSpellReady(_E) then
                                self:CastSpell(HK_E, useR, ally)
                            end
                        else
                            if useESpellsAlly and enemy.activeSpell.target == ally.handle and IsSpellReady(_E) then
                                self:CastSpell(HK_E, useR, ally)
                            end
                            if useEAttackAlly and enemy.attackData.target == ally.handle and IsSpellReady(_E) then
                                self:CastSpell(HK_E, useR, ally)
                            end
                        end
                    end
                end
            end
        end
    end
end

function EasyKarma:CastSpell(spell, useR, target)
    if useR then
        Control.CastSpell(HK_R)
        DelayAction(function()
            Control.CastSpell(spell, target)
        end,0.05)
    else
        Control.CastSpell(spell, target)
    end
end

function OnLoad()
	EasyKarma()
end

function IsInComboMode()
	return GG_Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_COMBO]
end

function IsInHarassMode()
	return GG_Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_HARASS]
end

function IsInFleeMode()
	return GG_Orbwalker.Modes[_G.SDK.ORBWALKER_MODE_FLEE]
end

function IsInAutoMode()
	return not IsInComboMode() and not IsInHarassMode() and not IsInFleeMode()
end

function IsSpellReady(spell)
    return myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 and myHero:GetSpellData(spell).mana <= myHero.mana and Game.CanUseSpell(spell) == 0
end

function GetEnemyHeroes(range)
	local result = {}
	for i, unit in ipairs(GG_Object:GetEnemyHeroes(false, false, true)) do
		if unit.distance < range then
			table.insert(result, unit)
		end
	end
	return result
end

function GetAllyHeroes(range) 
	local result = {}
	for i, unit in ipairs(GG_Object:GetAllyHeroes(false, false, true)) do
		if unit.distance < range then
			table.insert(result, unit)
		end
	end
	return result
end

function GetClosestEnemy(range)
	local result = nil
	for i, unit in ipairs(GG_Object:GetEnemyHeroes(false, false, true)) do
		if unit.distance < range and (result == nil or unit.distance < result.distance) then
			result = unit
		end
	end
	return result
end

local getAllyCountBug = false
function GetAllyCount(range)
	local count = 0
	for i = 1, Game.HeroCount() do 
        local hero = Game.Hero(i)
        local Range = range * range
		if hero.isAlly and GetDistanceSqr(myHero.pos, hero.pos) < Range and IsValidTarget(hero) then
		    count = count + 1
		end
	end

    if count > 5 then
        getAllyCountBug = true
    end

    if getAllyCountBug then
        count = count / 2
    end

	return count
end

function IsValidTarget(unit)
    return unit and unit.valid and unit.isTargetable and unit.alive and unit.visible and unit.networkID and unit.health > 0
end

function GetDistanceSqr(p1, p2)
	local dx = p1.x - p2.x
	local dz = (p1.z or p1.y) - (p2.z or p2.y)
	return dx * dx + dz * dz
end

function GetCollisionCount(prediction)
	local isWall, collisionObjects, collisionCount = GGPrediction:GetCollision(prediction.Source, prediction.CastPosition, prediction.Speed, prediction.Delay, prediction.Radius, {0, 3})
	return collisionCount
end

function SpellDrawColor(spell)
	if myHero:GetSpellData(spell).currentCd == 0 and myHero:GetSpellData(spell).level > 0 then
		return Draw.Color(100,0,255,0)
	else
		return Draw.Color(100,255,0,0)
	end
end