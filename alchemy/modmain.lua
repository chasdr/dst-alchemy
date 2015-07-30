local require = GLOBAL.require

-- local STRINGS = GLOBAL.STRINGS
-- local RECIPETABS = GLOBAL.RECIPETABS
-- local Ingredient = GLOBAL.Ingredient

GetPlayer = GLOBAL.GetPlayer

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient

PrefabFiles = {
	"hungerpill",
	"sanitypill",
	"healthpill",
	"speedpill",
  "deathpill",
  "strengthpill",
}

-- invincibility
--nwolf repellant for camp or him or both

-- hungerpill
--   increase max hunger by 50
--   reduces rate of hunger loss by half
--   instantly replenishes 50 hunger
--   duration: until player death

-- sanity pill
--   increase sanity by 50
--   reduces rate of sanity loss by half
--   duration: until player death

-- health pill
--   increases health by 50
--   adds a slow regeneration when near campfire
--   duration: until player death

-- speed pill
--   temporarily increases movement rate
--   con: increases current hunger rate
--   duration: 2 minutes

-- death pill
--   on death movement speed set to insane
--   on revive penalties removed
--   on revive movement rate is insane for 30 seconds then set to normal
--   con: none
--   duration: kicks in on players death removed after revive

-- strength pill
--   doubles combat effectiveness
--   while active health is slowly drained
--   duration: 2 minutes



Assets = {

	Asset( "IMAGE", "images/tab_cats.tex" ),
	Asset( "ATLAS", "images/tab_cats.xml" ),

	Asset( "IMAGE", "images/inventoryimages/hairball.tex" ),
	Asset( "ATLAS", "images/inventoryimages/hairball.xml" ),

}


local resolvefilepath = GLOBAL.resolvefilepath
local TECH = GLOBAL.TECH
local CUSTOM_RECIPETABS = GLOBAL.CUSTOM_RECIPETABS

CUSTOM_RECIPETABS.DRUGSTAB = {
  str = "DRUGSTAB",
  sort=115,
  icon = "tab_cats.tex",
  icon_atlas = resolvefilepath("images/tab_cats.xml")
}


		local hairball = GLOBAL.Ingredient( "hairball", 1)
			hairball.atlas = "images/inventoryimages/hairball.xml"

		local hairballten = GLOBAL.Ingredient( "hairball", 10)
			hairballten.atlas = "images/inventoryimages/hairball.xml"


	local collarweicraft = Recipe("collarwei", {Ingredient("cutgrass", 8), Ingredient("petals", 5)}, CUSTOM_RECIPETABS.CATSTAB, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
		collarweicraft.atlas = resolvefilepath("images/inventoryimages/collarwei.xml")
		STRINGS.RECIPE_DESC.COLLARWEI = "Heartwarming; puts a spring in your step."

GLOBAL.STRINGS.NAMES.HUNGERPILL = "Hairball"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HUNGERPILL = "Ew, a hairball!"



AddClassPostConstruct("widgets/crafttabs", function(class)

  local v = CUSTOM_RECIPETABS.CATSTAB
  local k = #class.tab_order + 1
  local tab_bg = {
    normal = "tab_normal.tex",
    selected = "tab_selected.tex",
    highlight = "tab_highlight.tex",
    bufferedhighlight = "tab_place.tex",
    overlay = "tab_researchable.tex",
  }

  class.tabs.spacing = 750/k

  local tab = class.tabs:AddTab(STRINGS.TABS[v.str], resolvefilepath("images/hud.xml"), v.icon_atlas or resolvefilepath("images/hud.xml"), v.icon, tab_bg.normal, tab_bg.selected, tab_bg.highlight, tab_bg.bufferedhighlight, tab_bg.overlay,
    function() --select fn
      if not class.controllercraftingopen then

        if class.craft_idx_by_tab[k] then
           class.crafting.idx = class.craft_idx_by_tab[k]
        end
        class.crafting:SetFilter( function(recipe)
          local rec = GLOBAL.AllRecipes[recipe]
          return rec and rec.tab == v
        end)
        class.crafting:Open()
      end
    end,

    function() --deselect fn
      class.craft_idx_by_tab[k] = class.crafting.idx
      class.crafting:Close()
    end
  )

  tab.filter = v
  tab.icon = v.icon
  tab.icon_atlas = v.icon_atlas or resolvefilepath("images/hud.xml")
  tab.tabname = STRINGS.TABS[v.str]
  class.tabbyfilter[v] = tab
  table.insert(class.tab_order, tab)

end)



