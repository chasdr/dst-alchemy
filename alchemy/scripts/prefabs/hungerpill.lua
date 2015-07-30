local assets=
{
	Asset("ANIM", "anim/hairball.zip"),
    Asset("ATLAS", "images/inventoryimages/hairball.xml")
}


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	inst:AddTag("hungerpill")

    if not TheWorld.ismastersim then
        return inst
    end

	inst.entity:SetPristine()

    anim:SetBank("HUNGERPILL")
    anim:SetBuild("hungerpill")
    anim:PlayAnimation("idle")

    MakeHauntableLaunch(inst)
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hairball.xml"

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM


    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)



    return inst
end

return Prefab( "common/inventory/hairball", fn, assets)
