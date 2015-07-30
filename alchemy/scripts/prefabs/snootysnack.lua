local assets =
{
	Asset("ANIM", "anim/snootysnack.zip"),
    Asset("ATLAS", "images/inventoryimages/snootysnack.xml")
}

local prefabs = 
{
	"spoiled_food",
}

-- Still does nothing. Dunno what it should do...
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
	inst:AddTag("snootysnack")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
    
    inst.AnimState:SetBank("snootysnack")
    inst.AnimState:SetBuild("snootysnack")
    inst.AnimState:PlayAnimation("idle", false)
	
    MakeHauntableLaunch(inst)
	inst:AddTag("preparedfood")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible.healthvalue = TUNING.HEALING_MED
	inst.components.edible.hungervalue = TUNING.CALORIES_MED*2
	inst.components.edible.sanityvalue = TUNING.SANITY_MED
	
	if IsDLCEnabled(REIGN_OF_GIANTS) then 
		inst.components.edible.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP 
		else 
	end
	if IsDLCEnabled(REIGN_OF_GIANTS) then 
		inst.components.edible.temperatureduration = TUNING.FOOD_TEMP_BRIEF 
		else 
	end
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/snootysnack.xml"
	
    
    return inst
end

return Prefab( "common/inventory/snootysnack", fn, assets) 

