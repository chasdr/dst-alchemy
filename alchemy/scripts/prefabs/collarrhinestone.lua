local assets=
{
	Asset("ANIM", "anim/collarrhinestone.zip"),
	Asset("IMAGE", "images/inventoryimages/collarrhinestone.tex"),
	Asset("ATLAS", "images/inventoryimages/collarrhinestone.xml"),
}

local function onperish(inst)
	inst:Remove()
end


local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "collarrhinestone", "swap_body")
    inst.components.fueled:StartConsuming()
	
	local day = TheWorld.state.isday
	if day then 
		
		local light = inst.entity:AddLight()
		light:SetFalloff(0.8)
		light:SetIntensity(0.7)
		light:SetRadius(1)
		light:SetColour(255/255, 255/255, 255/255)
		light:Enable(true)
	else	
	
		local light = inst.entity:AddLight()
		light:SetFalloff(0.5)
		light:SetIntensity(.3)
		light:SetRadius(1)
		light:SetColour(255/255, 255/255, 255/255)
		light:Enable(true)

	end
	
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
	
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
	inst:AddTag("collarrhinestone")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
    
    anim:SetBank("collarrhinestone")
    anim:SetBuild("collarrhinestone")
    anim:PlayAnimation("anim")
	
	MakeHauntableLaunch(inst)
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/collarrhinestone.xml"

	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = "USAGE"
	inst.components.fueled:InitializeFuelLevel(TUNING.WINTERHAT_PERISHTIME)
	inst.components.fueled:SetDepletedFn(onperish)
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
	inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	
	local day = TheWorld.state.isday
	if day then 
		
		local light = inst.entity:AddLight()
		light:SetFalloff(1)
		light:SetIntensity(0.7)
		light:SetRadius(2)
		light:SetColour(255/255, 255/255, 255/255)
		light:Enable(true)
	else	
	
		local light = inst.entity:AddLight()
		light:SetFalloff(0.4)
		light:SetIntensity(.3)
		light:SetRadius(2)
		light:SetColour(255/255, 255/255, 255/255)
		light:Enable(true)

	end
	
    
    return inst
end


return Prefab( "common/inventory/collarrhinestone", fn, assets) 
