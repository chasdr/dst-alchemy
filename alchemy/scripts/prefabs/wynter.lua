local MakePlayerCharacter = require "prefabs/player_common"


local assets = { Asset( "ANIM", "anim/player_basic.zip" ),
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

		-- Don't forget to include your character's custom assets!
        Asset( "ANIM", "anim/wynter.zip" ),
		Asset( "ANIM", "anim/wynterhalf.zip" ),		
		Asset( "ANIM", "anim/wynterfull.zip" ),
        Asset( "ANIM", "anim/ghost_wynter_build.zip" ),
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
	"freshricotta",
	"flan",
}
	


 local function barfrandom(inst, dt)
    inst.barf_time = inst.barf_time - dt  
	 
      if inst.barf_time <= 0 then
       inst.barf_time = 50+math.random(1,140)*5
		inst.components.health:DoDelta(20)
		inst.components.sanity:DoDelta(-7)
		inst.components.hunger:DoDelta(-20)
		inst.SoundEmitter:PlaySound("dontstarve/characters/winter/death_voice") 
		inst.components.talker:Say("Ack!")
		SpawnPrefab("hairball").Transform:SetPosition(inst:GetPosition():Get())
      end
end
  
local vomitchance = 8
local function vomitfn(inst, food)
	if food and food.components.edible and food.components.edible.foodtype == "VEGGIE" then
	if math.random(0,10) > vomitchance then
		inst.components.health:DoDelta(10)
		inst.components.sanity:DoDelta(0)
		inst.components.hunger:DoDelta(-25)
		inst.SoundEmitter:PlaySound("dontstarve/characters/winter/death_voice") 
		inst.components.talker:Say("Ack!")
		SpawnPrefab("hairball").Transform:SetPosition(inst:GetPosition():Get())
	else
		inst.components.health:DoDelta(-20)
		inst.components.sanity:DoDelta(-10)
		inst.components.hunger:DoDelta(2)

		end
  end
  if food and food.components.edible and food.components.edible.foodtype == "SEEDS" then
	if math.random(0,10) > vomitchance then
		inst.components.health:DoDelta(10)
		inst.components.sanity:DoDelta(0)
		inst.components.hunger:DoDelta(-25)
		inst.SoundEmitter:PlaySound("dontstarve/characters/winter/death_voice") 
		inst.components.talker:Say("Ack!")
		SpawnPrefab("hairball").Transform:SetPosition(inst:GetPosition():Get())
		
	else
		inst.components.health:DoDelta(-20)
		inst.components.sanity:DoDelta(-10)
		inst.components.hunger:DoDelta(2)

		end
  end
end
 
 
 local function BackToWynter(inst)
	inst:DoTaskInTime(3, function(inst)
	
	inst.components.health:SetMaxHealth(200)
	inst.components.hunger:SetMax(300)
	inst.components.sanity:SetMax(100)
	inst.components.combat.min_attack_period = 0.7
	inst.components.combat.damagemultiplier = 1.5
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 0.9)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 0.9)
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.15)
	inst.components.sanity.night_drain_mult = 0.9
    inst.components.eater.stale_health = .5
	
	inst.components.temperature.overheattemp = 65
	
	-- Normal barfs	
	inst.components.eater:SetOnEatFn(vomitfn)
	-- Random barfs
	inst:DoPeriodicTask(1/10, function() barfrandom(inst, 1/10) end)
	inst.barf_time = 50
	
	end, inst)
end
 
local common_postinit = function(inst) 
	inst.soundsname = "winter"
	inst.MiniMapEntity:SetIcon( "wynter.tex" )
	
	inst:AddTag("kittystuff")
	inst:AddTag("kittystuffwynter")
end
 
local master_postinit = function(inst)
	
	inst.components.health:SetMaxHealth(200)
	inst.components.hunger:SetMax(300)
	inst.components.sanity:SetMax(100)
	inst.components.combat.min_attack_period = 0.7
	inst.components.combat.damagemultiplier = 1.5
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 0.9)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 0.9)
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * 1.15)
	inst.components.sanity.night_drain_mult = 0.9
    inst.components.eater.stale_health = .5
	
	
	-- Normal barfs	
	inst.components.eater:SetOnEatFn(vomitfn)
	-- Random barfs
	inst:DoPeriodicTask(1/10, function() barfrandom(inst, 1/10) end)
	inst.barf_time = 50
	
	
	inst:ListenForEvent("respawnfromghost", BackToWynter)
	
	
	inst:AddComponent("beard")
	inst.components.beard.bits = 24
	inst.AnimState:SetBuild("wynterfull")
    inst.components.beard.onreset = function()
		inst.AnimState:SetBuild("wynter")
    end
    inst.components.beard.prize = "beardhair"

    --tune the beard economy...
	local beard_days = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
	local beard_bits = {1, 2, 4, 6, 9, 12, 15, 18, 21, 24}
	
    
    inst.components.beard:AddCallback(beard_days[1], function()
        inst.components.beard.bits = beard_bits[1]
		

    end)
    
    inst.components.beard:AddCallback(beard_days[2], function()
        inst.components.beard.bits = beard_bits[2]

    end)
    
    inst.components.beard:AddCallback(beard_days[3], function()
        inst.components.beard.bits = beard_bits[3]
		inst.AnimState:SetBuild("wynterhalf")

    end)
	
	inst.components.beard:AddCallback(beard_days[4], function()
        inst.components.beard.bits = beard_bits[4]

    end)
	
	inst.components.beard:AddCallback(beard_days[5], function()
        inst.components.beard.bits = beard_bits[5]

    end)
	
    inst.components.beard:AddCallback(beard_days[6], function()
        inst.components.beard.bits = beard_bits[6]

    end)
    
    inst.components.beard:AddCallback(beard_days[7], function()
        inst.components.beard.bits = beard_bits[7]

    end)
    
    inst.components.beard:AddCallback(beard_days[8], function()
        inst.components.beard.bits = beard_bits[8]
		
    end)
	
	inst.components.beard:AddCallback(beard_days[9], function()
        inst.components.beard.bits = beard_bits[9]
		inst.AnimState:SetBuild("wynterfull")
		
    end)
	
	inst.components.beard:AddCallback(beard_days[10], function()
        inst.components.beard.bits = beard_bits[10]

    end)
	
   end

-- strings! Any "WOD" below would have to be replaced by the prefab name of your character.

-- First up, the character select screen lines 
-- note: these are lower-case character name
STRINGS.CHARACTER_TITLES.wynter = "The longhair"
STRINGS.CHARACTER_NAMES.wynter = "Wynter"
STRINGS.CHARACTER_DESCRIPTIONS.wynter = "*She's tough, but slow. \n*Luxurious coat of fur and a hairball problem. \n*Needs a lotta food and veggies make her sick."
STRINGS.CHARACTER_QUOTES.wynter = "\"Mrrrow...\""

-- You can also add any kind of custom dialogue that you would like. Don't forget to make
-- categores that don't exist yet using = {}
-- note: these are UPPER-CASE charcacter name
STRINGS.CHARACTERS.WYNTER = require "speech_wynter"


return MakePlayerCharacter("wynter", prefabs, assets, common_postinit, master_postinit, start_inv)
