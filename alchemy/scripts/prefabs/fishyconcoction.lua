local assets =
{
	Asset("ANIM", "anim/fishyconcoction.zip"),
    Asset("ATLAS", "images/inventoryimages/fishyconcoction.xml")
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
    
	inst:AddTag("fishyconcoction")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
    
    
    inst.AnimState:SetBank("fishyconcoction")
    inst.AnimState:SetBuild("fishyconcoction")
    inst.AnimState:PlayAnimation("idle")
	
    MakeHauntableLaunch(inst)
	inst:AddTag("preparedfood")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("edible")
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible.healthvalue = TUNING.HEALING_HUGE*4
	inst.components.edible.hungervalue = TUNING.CALORIES_HUGE
	inst.components.edible.sanityvalue = 0
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fishyconcoction.xml"
    
    return inst
end

return Prefab( "common/inventory/fishyconcoction", fn, assets) 

