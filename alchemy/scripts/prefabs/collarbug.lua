local assets=
{
	Asset("ANIM", "anim/collarbug.zip"),
	Asset("IMAGE", "images/inventoryimages/collarbug.tex"),
	Asset("ATLAS", "images/inventoryimages/collarbug.xml"),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour") 
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "collarbug", "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
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
    
	inst:AddTag("collarbug")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
    
    anim:SetBank("collarbug")
    anim:SetBuild("collarbug")
    anim:PlayAnimation("anim")
	
    MakeHauntableLaunch(inst)
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/collarbug.xml"
	
	
	inst:AddComponent("armor")
	inst.components.armor:InitCondition(500, 1)
	inst.components.armor:SetTags({"bee"})
	inst.components.armor:SetTags({"mosquito"})
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
	
    
    return inst
end


return Prefab( "common/inventory/collarbug", fn, assets) 
