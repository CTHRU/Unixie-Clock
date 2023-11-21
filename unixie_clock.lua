require "cairo"
require "nixie_tube_clock"
require "nixie_tube"
require "nixie_tube_state"

local IMAGE_SET="alt"

local DIGIT_OFF = "OFF"

--[[
    Digits 0 to 9 must be in sequence at the beginning of the table.
    The OFF digit must be added directly after the 9 digit.
    Any other digits can be added after the OFF digit.
]]
local NIXIE_DIGITS = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, DIGIT_OFF }

local NIXIE_IMAGES = {}

local CLOCK_BASE_IMAGE

local nixie_tubes = {}

local working_dir

local init_complete = true

local scale = 1


function open_png_image(image_filename)
    local image = cairo_image_surface_create_from_png(image_filename)

    if cairo_surface_status(image) ~= CAIRO_STATUS_SUCCESS then
        print("open_png_image - Failed to open image file " ..
            image_filename .. " (" .. cairo_surface_status(image) .. ")")
        cairo_surface_destroy(image)
        return nil
    end

    return image
end

function scale_image(image, scale_percent)
    -- print("scale_image - Scaling image")

    local image_width = cairo_image_surface_get_width(image)
    local image_height = cairo_image_surface_get_height(image)

    local scale = scale_percent / 100.0

    local scaled_image = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, image_width * scale, image_height * scale)
    local scaled_image_context = cairo_create(scaled_image)

    cairo_scale(scaled_image_context, scale, scale)
    cairo_set_source_surface(scaled_image_context, image, 0, 0)
    cairo_paint(scaled_image_context)

    cairo_destroy(scaled_image_context)

    if cairo_surface_status(scaled_image) ~= CAIRO_STATUS_SUCCESS then
        print("scale_image - Failed to scale image (" .. cairo_surface_status(image) .. ")")
        cairo_surface_destroy(scaled_image)
        return
    end

    return scaled_image
end

function init_nixie_tube_images(scale_percent)
    local image_dir = working_dir .. "resources/" .. IMAGE_SET .. "/"
    local image_filename
    local image

    for i, digit in ipairs(NIXIE_DIGITS) do
        image_filename = image_dir .. digit .. ".png"
        image = open_png_image(image_filename)
        if image ~= nil then
            if (scale_percent == 100) then
                NIXIE_IMAGES[digit] = image
            else
                NIXIE_IMAGES[digit] = scale_image(image, scale_percent)
                cairo_surface_destroy(image)
            end
        else
            print("init_nixie_tube_images - Failed to open image file " .. image_filename)
        end
    end
end

function init_clock_base_image(scale_percent)
    local image_dir = working_dir .. "resources/" .. IMAGE_SET .. "/"
    local image_filename
    local image

    image_filename = image_dir .. "base.png"
    image = open_png_image(image_filename)
    if image ~= nil then
        if (scale_percent == 100) then
            CLOCK_BASE_IMAGE = image
        else
            CLOCK_BASE_IMAGE = scale_image(image, scale_percent)
            cairo_surface_destroy(image)
        end
    else
        print("init_clock_base_image - Failed to open image file " .. image_filename)
    end
end

function draw_nixie_tube_clock(cc, x, y, scale, transition)
    -- Default transition parameter is true
    if transition == nil then transition = true end

    local CLOCK = "CLOCK"

    local nixie_tube_clock = nixie_tubes[CLOCK]

    if nixie_tube_clock == nil then
        -- Initialize
        math.randomseed(os.time())
        nixie_tube_clock = NixieTubeClock:new(CLOCK, cc, NIXIE_DIGITS, NIXIE_IMAGES, CLOCK_BASE_IMAGE, x, y, scale)
        nixie_tubes[CLOCK] = nixie_tube_clock

        -- Default transition parameter is true
        if transition == nil then transition = true end

        nixie_tube_clock:set_transition(transition)
    end

    nixie_tube_clock:draw()
end

function conky_config(config_working_directory, scale_percent)
    init_complete = false

    print("conky_config - Setting working directory to " .. config_working_directory)
    working_dir = config_working_directory

    if scale_percent == nil then
        scale_percent = 100
    end
        
    scale = scale_percent / 100
        
    print("conky_config - Initializing nixie tube images")
    init_nixie_tube_images(scale_percent)
    init_clock_base_image(scale_percent)

    init_complete = true
end

function conky_main()
    if conky_window == nil then
        print("conky_main - No conky window")
        return
    elseif init_complete == false then
        print("conky_main - Waiting for initialization to complete")
        return
    end

    -- Create an Xlib surface
    local cs = cairo_xlib_surface_create(
        conky_window.display,
        conky_window.drawable,
        conky_window.visual,
        conky_window.width,
        conky_window.height
    )

    -- Create a drawing context
    local cc = cairo_create(cs)

    draw_nixie_tube_clock(cc, 0, 0, scale)
    -- draw_nixie_tube_clock(cc, 0, 0, scale, false)    -- Draw Nixie Tube Clock without digit transition.

    -- draw_nixie_tube_random_demo(cc, 0, 340)
    -- draw_nixie_tube_anti_cathode_poisoning_demo(cc, 140, 340)
    -- draw_nixie_tube_transition_demo(cc, 300, 340)

    -- Cleanup context and surface
    cairo_destroy(cc)
    cairo_surface_destroy(cs)
end
