local assets=
{
	Asset("ANIM", "anim/collarbell.zip"),
	Asset("IMAGE", "images/inventoryimages/collarbell.tex"),
	Asset("ATLAS", "images/inventoryimages/collarbell.xml"),
	
	Asset("SOUNDPACKAGE", "sound/collarbell.fev"),
    Asset("SOUND", "sound/collarbell.fsb"),
	
	-- Sound paths
	-- owner.SoundEmitter:PlaySound("dontstarve/common/collarbell/jinglejingle", "collarbell/collarbell/jinglejingle") 
}

local function OnAttacked(owner)
	owner.SoundEmitter:PlaySound("dontstarve/common/collarbell/jinglejingle") 
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "collarbell", "swap_body")
    inst:ListenForEvent("attacked", OnAttacked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("attacked", OnAttacked, owner)
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
    
	inst:AddTag("collarbell")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
	
    anim:SetBank("collarbell")
    anim:SetBuild("collarbell")
    anim:PlayAnimation("anim")
	
	
    MakeHauntableLaunch(inst)
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/collarbell.xml"
	
	
	
	inst:AddComponent("armor")
	inst.components.armor:InitCondition(100, 1)
		inst.components.armor:SetTags({"ghost"})
		inst.components.armor:SetTags({"crawlinghorror"})
		inst.components.armor:SetTags({"crawlingnightmare"})
		inst.components.armor:SetTags({"terrorbeak"})
		inst.components.armor:SetTags({"shadowcreature"})
		inst.components.armor:SetTags({"shadowcreature1"})
		inst.components.armor:SetTags({"shadowcreature2"})


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
    
    return inst
end


return Prefab( "common/inventory/collarbell", fn, assets) 
