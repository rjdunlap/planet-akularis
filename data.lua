--data.lua
local asteroid_util = require("__space-age__.prototypes.planet.asteroid-spawn-definitions")


--START MAP GEN
function MapGen_Akularis()
    -- Nauvis-based generation
    local map_gen_setting = table.deepcopy(data.raw.planet.nauvis.map_gen_settings)

    --map_gen_setting.terrain_segmentation = "very-high"

    map_gen_setting.autoplace_controls = {
        ["stone"] = { frequency = 0, size = 0, richness = 0},
        ["iron-ore"] = { frequency = 0, size = 0, richness = 0},
        ["coal"] = { frequency = 0, size = 0, richness = 0},
        ["copper-ore"] = { frequency = 0, size = 0, richness = 0},
        ["crude-oil"] = { frequency = 4, size = 4, richness = 4},
        ["trees"] = { frequency = 1, size = 1, richness = 1 },
        ["rocks"] = { frequency = 200, size = 20, richness = 20},
        ["water"] = { frequency = 0, size = 0, richness = 0 },
        ["uranium-ore"] = { frequency = 0, size = 0, richness = 0 },
    }
    return map_gen_setting
end
-- increse stone patch size in start area
-- data.raw["resource"]["stone"]["autoplace"]["starting_area_size"] = 5500 * (0.005 / 3)

--END MAP GEN

local nauvis = data.raw["planet"]["nauvis"]
local planet_lib = require("__PlanetsLib__.lib.planet")

local akularis= 
{
    type = "planet",
    name = "akularis", 
    solar_power_in_space = nauvis.solar_power_in_space,
    icon = "__planet-akularis__/graphics/planet-akularis.png",
    icon_size = 512,
    label_orientation = 0.55,
    starmap_icon = "__planet-akularis__/graphics/planet-akularis.png",
    starmap_icon_size = 512,
    magnitude = nauvis.magnitude,
    surface_properties = {
        ["solar-power"] = 100,
        ["pressure"] = nauvis.surface_properties["pressure"],
        ["magnetic-field"] = nauvis.surface_properties["magnetic-field"],
        ["day-night-cycle"] = nauvis.surface_properties["day-night-cycle"],
    },
    map_gen_settings = MapGen_Akularis()
}

akularis.orbit = {
    parent = {
        type = "space-location",
        name = "star",
    },
    distance = 0.75,
    orientation = 0.44
}

local akularis_connection = {
    type = "space-connection",
    name = "nauvis-akularis",
    from = "nauvis",
    to = "akularis",
    subgroup = data.raw["space-connection"]["nauvis-vulcanus"].subgroup,
    length = 15000,
    asteroid_spawn_definitions = asteroid_util.spawn_definitions(asteroid_util.nauvis_gleba),
  }

PlanetsLib:extend({akularis})

data:extend{akularis_connection}

data:extend {{
    type = "technology",
    name = "planet-discovery-akularis",
    icons = util.technology_icon_constant_planet("__planet-akularis__/graphics/planet-akularis.png"),
    icon_size = 256,
    essential = true,
    localised_description = {"space-location-description.akularis"},
    effects = {
        {
            type = "unlock-space-location",
            space_location = "akularis",
            use_icon_overlay_constant = true
        },
    },
    prerequisites = {
        "space-science-pack",
    },
    unit = {
        count = 200,
        ingredients = {
            {"automation-science-pack",      1},
            {"logistic-science-pack",        1},
            {"chemical-science-pack",        1},
            {"space-science-pack",           1}
        },
        time = 60,
    },
    order = "ea[akularis]",
}}


APS.add_planet{name = "akularis", filename = "__planet-akularis__/akularis.lua", technology = "planet-discovery-akularis"}