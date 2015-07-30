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
        Asset( "ANIM", "anim/wisp.zip" ), 
        Asset( "ANIM", "anim/ghost_wisp_build.zip" ),
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
	
local start_inv = {
	"axe",        
	"spear",
}

local vomitchance = 5
local function vomitfn(inst, food)
	if food and food.components.edible and food.components.edible.foodtype == "MEAT" and food.name == "Petals" then
	if math.random(0,10) > vomitchance then
		inst.components.health:DoDelta(10)
		inst.components.sanity:DoDelta(5)
		inst.components.hunger:DoDelta(-15)
		inst.SoundEmitter:PlaySound("dontstarve/characters/wisp/death_voice") 
		inst.components.talker:Say("Hork!")
		SpawnPrefab("hairball").Transform:SetPosition(inst:GetPosition():Get())
	else
		inst.components.health:DoDelta(-15)
		inst.components.sanity:DoDelta(-10)
		inst.components.hunger:DoDelta(2)

		end
  end
end
 
 

local function BackToWisp(inst)
	inst:DoTaskInTime(3, function(inst)
	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(175)
	inst.components.combat.min_attack_period = 0.5
	inst.components.combat.damagemultiplier = 2
	inst.components.combat.attackrange = 3.6
	inst.components.combat.hitrange = 2.5
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.1)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.1)
	inst.components.sanity.night_drain_mult = 0.5
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * .25)
	inst.components.eater.stale_hunger = 1
    inst.components.eater.stale_health = 1
	
	
	inst.components.eater:SetOnEatFn(vomitfn)
	
	inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT })
	inst.components.eater.strongstomach = true
	
	end, inst)
end
 
local function wispondeath(inst)
    inst.components.health.numrevives = 0
end

local common_postinit = function(inst) 
	inst.soundsname = "wisp"
	inst.MiniMapEntity:SetIcon( "wisp.tex" )
	
	inst:AddTag("kittystuffwisp")
end
 

 
 
 
local master_postinit = function(inst)

	-- todo: Add an example special power here.
	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(175)
	inst.components.combat.min_attack_period = 0.5
	inst.components.combat.damagemultiplier = 2
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.1)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.1)
	inst.components.sanity.night_drain_mult = 0.5
	inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * .25)
	inst.components.eater.stale_hunger = 1
    inst.components.eater.stale_health = 1
	
	
	inst:ListenForEvent("respawnfromghost", BackToWisp)
	inst:ListenForEvent("death", wispondeath)
	
	inst.components.eater:SetOnEatFn(vomitfn)
	
	--inst.components.eater:SetDiet({ FOODGROUP.OMNI }, { FOODTYPE.MEAT })
	inst.components.eater.strongstomach = true
	
	
		inst:AddComponent("beard")
    inst.components.beard.onreset = function()
        inst.AnimState:ClearOverrideSymbol("beard")
    end
    inst.components.beard.prize = "beardhair"
    
    --tune the beard economy...
	local beard_days = {2, 8, 15, 22, 30}
	local beard_bits = {1, 2, 4, 6, 8}
    
    inst.components.beard:AddCallback(beard_days[1], function()
        inst.components.beard.bits = beard_bits[1]
		
    end)
    
    inst.components.beard:AddCallback(beard_days[2], function()
        inst.components.beard.bits = beard_bits[2]

    end)
    
    inst.components.beard:AddCallback(beard_days[3], function()
        inst.components.beard.bits = beard_bits[3]

    end)
	
	inst.components.beard:AddCallback(beard_days[4], function()
        inst.components.beard.bits = beard_bits[4]

    end)
	
	inst.components.beard:AddCallback(beard_days[5], function()
        inst.components.beard.bits = beard_bits[5]

    end)
	
   end

-- strings! Any "WOD" below would have to be replaced by the prefab name of your character.

-- First up, the character select screen lines 
-- note: these are lower-case character name
STRINGS.CHARACTER_TITLES.wisp = "The Stray"
STRINGS.CHARACTER_NAMES.wisp = "Wisp"
STRINGS.CHARACTER_DESCRIPTIONS.wisp = "*She's a scruffy fighter. \n*Supercarnivore: eats only meats. \n*Stray: ANY meats."
STRINGS.CHARACTER_QUOTES.wisp = "\"Prrt!\""

-- You can also add any kind of custom dialogue that you would like. Don't forget to make
-- categores that don't exist yet using = {}
-- note: these are UPPER-CASE charcacter name
STRINGS.CHARACTERS.WISP = require "speech_wisp"


return MakePlayerCharacter("wisp", prefabs, assets, common_postinit, master_postinit, start_inv)
