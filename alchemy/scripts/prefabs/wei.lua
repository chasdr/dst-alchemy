local MakePlayerCharacter = require "prefabs/player_common"
local easing = require "easing"


local assets = {

		Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/wei.zip" ),
        Asset( "ANIM", "anim/ghost_wei_build.zip" ),
}

local prefabs =
{
  "catrope",
	"collarbell",
	"collarbug",
	"collarrhinestone",
	"collartricky",
	"collarwei",
	"fishyconcoction",
	"flan",
	"freshricotta",
	"hairball",
	"snootysnack",
	"poshsweatervest"
}

local start_inv =
{
	"collarwei",
	"catrope",
	"freshricotta",
	"snootysnack",
	"snootysnack",
	"snootysnack",
	"snootysnack",
	"snootysnack",
	"fishingrod",
  "gears",
}


local vomitchance = 3
local function vomitfn(inst, food)
	if food and food.components.edible and food.components.edible.foodtype == "VEGGIE" then
	if math.random(0,10) > vomitchance then
		--inst.components.health:DoDelta(25)
		--inst.components.sanity:DoDelta(25)
		--inst.components.hunger:DoDelta(25)
		inst.SoundEmitter:PlaySound("dontstarve/characters/wei/death_voice")
		inst.components.talker:Say("Ehck!")
		SpawnPrefab("hairball").Transform:SetPosition(inst:GetPosition():Get())
	else
		-- inst.components.health:DoDelta(25)
		-- inst.components.sanity:DoDelta(25)
		-- inst.components.hunger:DoDelta(25)
		end
  end
  if food and food.components.edible and food.components.edible.foodtype == "SEEDS" then
	if math.random(0,10) > vomitchance then
		--inst.components.health:DoDelta(25)
		--inst.components.sanity:DoDelta(25)
		--inst.components.hunger:DoDelta(25)
		inst.SoundEmitter:PlaySound("dontstarve/characters/wei/death_voice")
		inst.components.talker:Say("Ehck!")
		SpawnPrefab("hairball").Transform:SetPosition(inst:GetPosition():Get())
	else
		--inst.components.health:DoDelta(25)
		--inst.components.sanity:DoDelta(25)
		--inst.components.hunger:DoDelta(25)
		end
  end
end

  --nightvision

local function onsanitychange(inst, data)

	if inst.components.sanity.current > 40 then
		local light = inst.entity:AddLight()
		light:SetIntensity(.3)
		light:SetRadius(6)
		light:SetFalloff(1)
		light:Enable(true)
		light:SetColour(0/255, 150/255, 130/255)

		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED)
		inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.2)


	elseif inst.components.sanity.current < 40 then

		local light = inst.entity:AddLight()
		light:SetIntensity(.2)
		light:SetRadius(3)
		light:SetFalloff(0.7)
		light:Enable(true)
		light:SetColour(0/255,150/255, 130/255)

		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.4)
		inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 0.6)


	elseif inst.components.sanity.current > 30 then
		local light = inst.entity:AddLight()
		light:SetIntensity(.1)
		light:SetRadius(1)
		light:SetFalloff(0.3)
		light:Enable(true)
		light:SetColour(0/255, 150/255, 130/255)

		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.6)
		inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 0.4)


	elseif inst.components.sanity.current < 30 then
		local light = inst.entity:AddLight()
		light:SetIntensity(0)
		light:SetRadius(0)
		light:SetFalloff(0)
		light:Enable(false)
		light:SetColour(0/255, 0/255, 0/255)

		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.8)
		inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 0.2)

	end
end

local function BackToWei(inst)
	inst:DoTaskInTime(3, function(inst)

	-- inst.components.health:SetMaxHealth(150)
	-- inst.components.hunger:SetMax(150)
	-- inst.components.sanity:SetMax(150)
	-- inst.components.combat.min_attack_period = 1
	-- inst.components.combat.damagemultiplier = 1.5
	-- inst.components.sanity.night_drain_mult = .2
	-- inst.components.eater.stale_hunger = 0.2
 --  inst.components.eater.stale_health = 0
 --  inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.2)


	local light = inst.entity:AddLight()
	light:SetIntensity(0)
	light:SetRadius(0)
	light:SetFalloff(0)
	light:Enable(false)
	light:SetColour(0/255, 0/255, 0/255)

	inst.components.eater:SetOnEatFn(vomitfn)
	inst:ListenForEvent("sanitydelta", onsanitychange)

    inst.components.health.penalty = 0
    inst.components.health.numrevives = 0
    inst.components.health:SetMaxHealth(150)
    inst.components.hunger:SetMax(150)
    inst.components.sanity:SetMax(150)
    inst.components.sanity.night_drain_mult = 0.1
    inst.components.sanity.neg_aura_mult = 1.8

    inst.components.temperature.inherentinsulation =(TUNING.INSULATION_PER_BEARD_BIT * 4)
    inst.components.locomotor.walkspeed = 5
    inst.components.locomotor.runspeed = 7

    inst.components.combat.min_attack_period = 1
    inst.components.combat.damagemultiplier = 2

    -- inst.components.sanity.night_drain_mult = 02.
    inst.components.eater.stale_hunger = 0.2
    inst.components.eater.stale_health = 0
    -- inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.1)
    inst.components.temperature.mintemp = -15
    inst.components.temperature.maxtemp = 20
    inst.components.health:SetPercent(100)
	end, inst)

end

local function weiondeath(inst)
    inst.components.health.penalty = 0
    inst.components.health.numrevives = 0
    inst:DoTaskInTime(10, function(inst)
      inst.components.locomotor.walkspeed = 30
      inst.components.locomotor.runspeed = 30
    end, inst)
end

local function setBaseStats(inst)
  inst.components.health:SetMaxHealth(150)
  inst.components.hunger:SetMax(150)
  inst.components.sanity:SetMax(150)
  inst.components.sanity.night_drain_mult = 0.1
  inst.components.sanity.neg_aura_mult = 1.8

  inst.components.temperature.inherentinsulation =(TUNING.INSULATION_PER_BEARD_BIT * 4)
  inst.components.locomotor.walkspeed = 5
  inst.components.locomotor.runspeed = 7

  inst.components.combat.min_attack_period = 1
  inst.components.combat.damagemultiplier = 2

  -- inst.components.sanity.night_drain_mult = 02.
  inst.components.eater.stale_hunger = 0.2
  inst.components.eater.stale_health = 0
  -- inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.1)
  inst.components.temperature.mintemp = -15
  inst.components.temperature.maxtemp = 20
end

local common_postinit = function(inst)
	inst.soundsname = "wei"
	inst.MiniMapEntity:SetIcon( "wei.tex" )

    inst:AddTag("kittystuff")
    inst:AddTag("kittyeyes")
    inst:AddTag("kittystuffwei")
end


local master_postinit = function(inst)

  setBaseStats(inst)

	-- inst.components.health:SetMaxHealth(150)
	-- inst.components.hunger:SetMax(150)
	-- inst.components.sanity:SetMax(150)

	-- inst.components.combat.min_attack_period = 1
	-- inst.components.combat.damagemultiplier = 1.5

	-- inst.components.sanity.night_drain_mult = 0.2
	-- inst.components.eater.stale_hunger = 0.2
 --  inst.components.eater.stale_health = 0
	-- inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.1)
	-- inst.components.temperature.mintemp = -15

	local light = inst.entity:AddLight()
	light:SetIntensity(0)
	light:SetRadius(0)
	light:SetFalloff(0)
	light:Enable(false)
	light:SetColour(0/255, 0/255, 0/255)

	inst.components.eater:SetOnEatFn(vomitfn)

	inst:ListenForEvent("sanitydelta", onsanitychange)
	inst:ListenForEvent("respawnfromghost", BackToWei)
	inst:ListenForEvent("death", weiondeath)

	--beard stuff

	inst:AddComponent("beard")
    inst.components.beard.onreset = function()
        inst.AnimState:ClearOverrideSymbol("beard")
    end
    inst.components.beard.prize = "beardhair"

    --tune the beard economy...
	local beard_days = {5, 10, 20}
	local beard_bits = {1, 2, 3}

    inst.components.beard:AddCallback(beard_days[1], function()
        inst.components.beard.bits = beard_bits[1]

    end)

    inst.components.beard:AddCallback(beard_days[2], function()
        inst.components.beard.bits = beard_bits[2]

    end)

    inst.components.beard:AddCallback(beard_days[3], function()
        inst.components.beard.bits = beard_bits[3]

    end)





   end

-- strings! Any "WOD" below would have to be replaced by the prefab name of your character.

-- First up, the character select screen lines
-- note: these are lower-case character name
STRINGS.CHARACTER_TITLES.wei = "The Housecat"
STRINGS.CHARACTER_NAMES.wei = "Wei"
STRINGS.CHARACTER_DESCRIPTIONS.wei = "*Declawed and neurotic, but well prepared. \n*Comes with 'nightvison'. \n*Can't handle spoiled foods or non-meats well."
STRINGS.CHARACTER_QUOTES.wei = "\"Mieumieu!!\""

-- You can also add any kind of custom dialogue that you would like. Don't forget to make
-- categores that don't exist yet using = {}
-- note: these are UPPER-CASE charcacter name
STRINGS.CHARACTERS.WEI = require "speech_wei"


return MakePlayerCharacter("wei", prefabs, assets, common_postinit, master_postinit, start_inv)
