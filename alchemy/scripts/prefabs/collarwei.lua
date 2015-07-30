local assets=
{
	Asset("ANIM", "anim/collarwei.zip"),
	Asset("IMAGE", "images/inventoryimages/collarwei.tex"),
	Asset("ATLAS", "images/inventoryimages/collarwei.xml"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "collarwei", "swap_body")
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

	inst:AddTag("collarwei")

  if not TheWorld.ismastersim then
      return inst
  end

	inst.entity:SetPristine()

  anim:SetBank("collarwei")
  anim:SetBuild("collarwei")
  anim:PlayAnimation("anim")

  MakeHauntableLaunch(inst)
  inst:AddComponent("inspectable")
  inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/collarwei.xml"

	inst:AddComponent("fueled")
	inst.components.fueled.fueltype = "USAGE"
	inst.components.fueled:InitializeFuelLevel(TUNING.WINTERHAT_PERISHTIME*2)
	inst.components.fueled:SetDepletedFn(onperish)

  inst:AddComponent("equippable")
  inst.components.equippable.equipslot = EQUIPSLOTS.BODY
  inst.components.equippable:SetOnEquip( onequip )
  inst.components.equippable:SetOnUnequip( onunequip )
  inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT

  inst:AddComponent("container")
  inst.components.container:WidgetSetup("backpack")

  return inst
end


return Prefab( "common/inventory/collarwei", fn, assets)
