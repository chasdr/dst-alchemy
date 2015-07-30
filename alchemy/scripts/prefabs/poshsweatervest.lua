local assets=
{
	Asset("ANIM", "anim/poshsweatervest.zip"),
	Asset("IMAGE", "images/inventoryimages/poshsweatervest.tex"),
	Asset("ATLAS", "images/inventoryimages/poshsweatervest.xml"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "poshsweatervest", "swap_body")
    inst.components.fueled:StartConsuming()
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst.components.fueled:StopConsuming()
end

local function onperish(inst)
	inst:Remove()
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
    
	inst:AddTag("poshsweatervest")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
    
    
    anim:SetBank("poshsweatervest")
    anim:SetBuild("poshsweatervest")
    anim:PlayAnimation("anim")
	
    MakeHauntableLaunch(inst)
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/poshsweatervest.xml"
  
	
	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = "USAGE"
	inst.components.fueled:InitializeFuelLevel(TUNING.EARMUFF_PERISHTIME)
	inst.components.fueled:SetDepletedFn(onperish)
	
	
    inst:AddComponent("insulator")
    inst.components.insulator.insulation = TUNING.INSULATION_LARGE
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_SMALL
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
    
    return inst
end


return Prefab( "common/inventory/poshsweatervest", fn, assets) 
