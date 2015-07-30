local assets =
{
	Asset("ANIM", "anim/catrope.zip"),
    Asset("ATLAS", "images/inventoryimages/catrope.xml")
}


local function HeatFn(inst, observer)
	return inst.components.temperature:GetCurrent()
end


-- Still does nothing. Dunno what it should do...
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
	inst:AddTag("catrope")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
    
    
    anim:SetBank("catrope")
    anim:SetBuild("catrope")
    anim:PlayAnimation("idle")
	
	
    MakeHauntableLaunch(inst)
	inst:AddComponent("temperature")
	inst.components.temperature.inherentinsulation = TUNING.INSULATION_SMALL
	inst.components.temperature.maxtemp = 15
	inst.components.temperature.mintemp = 15
	inst.components.temperature.current = 15
	
	inst:AddComponent("heater")
	inst.components.heater.heatfn = HeatFn
	inst.components.heater.carriedheatfn = HeatFn
	
	
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/catrope.xml"
	
	
    
    return inst
end

return Prefab( "common/inventory/catrope", fn, assets) 

