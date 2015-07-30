local assets=
{
	Asset("ANIM", "anim/collartricky.zip"),
	Asset("IMAGE", "images/inventoryimages/collartricky.tex"),
	Asset("ATLAS", "images/inventoryimages/collartricky.xml"),
}

local function OnBlocked(owner) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour") 
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "collartricky", "swap_body")
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
end

local function getrandomposition(inst)
    local ground = GetWorld()
    local centers = {}
	local charpos = GetPlayer():GetPosition()
	
    for i,node in ipairs(ground.topology.nodes) do
        local tile = GetWorld().Map:GetTileAtPoint(node.x, 0, node.y)
        if tile and tile ~= GROUND.IMPASSABLE then
			table.insert(centers, {x = node.x, z = node.y})
		end
    end
    if #centers > 0 then
		local pos = centers[math.random(#centers)]
		return Point(pos.x, 0, pos.z)
	else
		return GetPlayer():GetPosition()
	end
end

local function teleportcharacter(inst, caster, teletarget)
    local ground = GetWorld()
    local newpos = getrandomposition()
    local teleportee = teletarget
    local pt = teleportee:GetPosition()
	
    if teleportee.components.locomotor then
        teleportee.components.locomotor:StopMoving()
    end

    if ground.topology.level_type == "cave" then
        TheCamera:Shake("FULL", 0.3, 0.02, .5, 40)
        ground.components.quaker:MiniQuake(3, 5, 1.5, teleportee)     
        return
    end

    if teleportee.components.health then
        teleportee.components.health:SetInvincible(true)
    end
    
    local preventburning = teleportee.components.burnable ~= nil and not teleportee.components.burnable.burning
    if preventburning then
        teleportee.components.burnable.burning = true
    end
    ground:PushEvent("ms_sendlightningstrike", pt)
    if preventburning then
        teleportee.components.burnable.burning = false
    end

    teleportee:Hide()

    if caster and caster.components.sanity then
        caster.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
    end

    ground:PushEvent("ms_forceprecipitation", true)

    local isplayer = teleportee:HasTag("player")
    if isplayer then
        teleportee.components.playercontroller:Enable(false)
        teleportee:ScreenFade(false, 2)
        Sleep(3)
    end

    teleportee.Transform:SetPosition(newpos.x, 0, newpos.z)

    if isplayer then
        teleportee:SnapCamera()
        teleportee:ScreenFade(true, 1)
        Sleep(1)
        teleportee.components.playercontroller:Enable(true)
    end

    preventburning = teleportee.components.burnable ~= nil and not teleportee.components.burnable.burning
    if preventburning then
        teleportee.components.burnable.burning = true
    end
	
    ground:PushEvent("ms_sendlightningstrike", newpos)
    if preventburning then
        teleportee.components.burnable.burning = false
    end

    teleportee:Show()
    if teleportee.components.health then
        teleportee.components.health:SetInvincible(false)
    end

    if isplayer then
        teleportee.sg:GoToState("wakeup")
        teleportee.SoundEmitter:PlaySound("dontstarve/common/staffteleport")
    end
end

local function teleport_func(inst)
    local caster = inst.components.inventoryitem.owner
    local tar = caster

    inst.task = inst:StartThread(function() teleportcharacter(inst, caster, tar) end)

end

local function OnDamageTaken(inst)

teleport_func(inst)

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
    
	inst:AddTag("collartricky")
	
    if not TheWorld.ismastersim then
        return inst
    end
	
	inst.entity:SetPristine() 
	
    anim:SetBank("collartricky")
    anim:SetBuild("collartricky")
    anim:PlayAnimation("anim")
	
    MakeHauntableLaunch(inst)
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/collartricky.xml"
  
  
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(100, 0.70)
	
    inst.components.armor.ontakedamage = OnDamageTaken
	
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	
    
    return inst
end


return Prefab( "common/inventory/collartricky", fn, assets) 
