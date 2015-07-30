local assets =
{
	Asset("ANIM", "anim/flan.zip"),
    Asset("ATLAS", "images/inventoryimages/flan.xml")
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
    
	inst:AddTag("flan")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
    
    inst.AnimState:SetBank("flan")
    inst.AnimState:SetBuild("flan")
    inst.AnimState:PlayAnimation("idle", false)
	
    MakeHauntableLaunch(inst)
	inst:AddTag("preparedfood")
    inst:AddComponent("inspectable")
	
	inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
	
	inst:AddComponent("edible")
	inst.components.edible.foodtype = "MEAT"
	inst.components.edible.healthvalue = 0
	inst.components.edible.hungervalue = TUNING.CALORIES_HUGE*3
	inst.components.edible.sanityvalue = TUNING.SANITY_HUGE*2
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"
	
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/flan.xml"
	
    return inst
end

return Prefab( "common/inventory/flan", fn, assets) 

