extends Object

const PLUGIN_BUNDLE_NAME: StringName = "aseprite_importers"
const ASEPRITE_EXECUTABLE_PATH_SETTING_NAME: StringName = PLUGIN_BUNDLE_NAME + "/aseprite_executable_path"

enum CompressMode {
	LOSSLESS,
	LOSSY,
	VRAM_COMPRESSED,
	VRAM_UNCOMPRESSED,
	BASIS_UNIVERSAL
}
const COMPRESS_MODES_NAMES: PackedStringArray = [
	"Lossless",
	"Lossy",
	"VRAM Compressed",
	"VRAM Uncompressed",
	"Basis Universal"
]

# ONLY FOR VRAM_COMPRESSED
enum HdrCompression {
	DISABLED,
	OPAQUE_ONLY,
	ALWAYS
}
const HDR_COMPRESSION_NAMES: PackedStringArray = [
	"Disabled",
	"Opaque Only",
	"Always"
]

# EXCEPT LOSSLESS
enum NormalMap {
	DETECT,
	ENABLE,
	DISABLED
}
const NORMAL_MAP_NAMES: PackedStringArray = [
	"Detect",
	"Enable",
	"Disabled"
]

enum ChannelPack {
	SRGB_FRIENDLY,
	OPTIMIZED
}
const CHANNEL_PACK_NAMES: PackedStringArray = [
	"sRGB Friendly",
	"Optimized"
]

enum Roughness {
	DETECT,
	DISABLED,
	RED,
	GREEN,
	BLUE,
	ALPHA,
	GRAY
}
const ROUGHNESS_NAMES: PackedStringArray = [
	"Detect",
	"Disabled",
	"Red",
	"Green",
	"Blue",
	"Alpha",
	"Gray"
]

enum CompressMode3D {
	DISABLED,
	VRAM_COMPRESSED,
	BASIS_UNIVERSAL
}
const COMPRESS_MODE_3D_NAMES: PackedStringArray = [
	"Disabled",
	"VRAM Compressed",
	"Basis Universal"
]

const EMPTY_CALLABLE: Callable = Callable()

static func create_option(
	name: String,
	default_value: Variant,
	property_hint: PropertyHint = PROPERTY_HINT_NONE,
	hint_string: String = "",
	usage: PropertyUsageFlags = PROPERTY_USAGE_NONE,
	get_is_visible: Callable = EMPTY_CALLABLE
	) -> Dictionary:
	var option_data: Dictionary = {
		name = name,
		default_value = default_value,
	}
	if hint_string: option_data["hint_string"] = hint_string
	if property_hint: option_data["property_hint"] = property_hint
	if usage: option_data["usage"] = usage
	if get_is_visible != EMPTY_CALLABLE: option_data["get_is_visible"] = get_is_visible
	return option_data

enum BorderType {
	None = 0,
	Transparent = 1,
	Extruded = 2
}
const SPRITESHEET_BORDER_TYPES: PackedStringArray = ["None", "Transparent", "Extruded"]

enum AnimationDirection {
	FORWARD = 0,
	REVERSE = 1,
	PING_PONG = 2,
	PING_PONG_REVERSE = 3
}
const ASEPRITE_OUTPUT_ANIMATION_DIRECTIONS: PackedStringArray = [
	"forward", "reverse", "pingpong", "pingpong_reverse" ]
const PRESET_OPTIONS_ANIMATION_DIRECTIONS: PackedStringArray = [
	"Forward", "Reverse", "Ping-pong", "Ping-pong reverse" ]

enum SpritesheetLayout { PACKED, BY_ROWS, BY_COLUMNS }
const SPRITESHEET_LAYOUTS: PackedStringArray = ["Packed", "By rows", "By columns"]

const OPTION_SPRITESHEET_BORDER_TYPE: String = "spritesheet/border_type"
const OPTION_SPRITESHEET_TRIM: String = "spritesheet/trim"
const OPTION_SPRITESHEET_IGNORE_EMPTY: String = "spritesheet/ignore_empty"
const OPTION_SPRITESHEET_MERGE_DUPLICATES: String = "spritesheet/merge_duplicates"
const OPTION_SPRITESHEET_LAYOUT: String = "spritesheet/layout"
const OPTION_ANIMATION_DEFAULT_NAME: String = "animation/default/name"
const OPTION_ANIMATION_DEFAULT_DIRECTION: String = "animation/default/direction"
const OPTION_ANIMATION_DEFAULT_REPEAT_COUNT: String = "animation/default/repeat_count"
const OPTION_ANIMATION_AUTOPLAY_NAME: String = "animation/autoplay"
const OPTION_ANIMATION_STRATEGY: String = "animation/strategy"
const OPTION_LAYERS_INCLUDE_REG_EX: String = "layers/include_reg_ex"
const OPTION_LAYERS_EXCLUDE_REG_EX: String = "layers/exclude_reg_ex"
const OPTION_TAGS_INCLUDE_REG_EX: String = "tags/include_reg_ex"
const OPTION_TAGS_EXCLUDE_REG_EX: String = "tags/exclude_reg_ex"
const SPRITESHEET_FIXED_ROWS_COUNT: String = "spritesheet/fixed_rows_count"
const SPRITESHEET_FIXED_COLUMNS_COUNT: String = "spritesheet/fixed_columns_count"



class ParsedAnimationOptions:
	var border_type: BorderType
	var trim: bool
	var ignore_empty: bool
	var merge_duplicates: bool
	var spritesheet_layout: SpritesheetLayout
	var spritesheet_fixed_rows_count: int
	var spritesheet_fixed_columns_count: int
	var default_animation_name: String
	var default_animation_direction: AnimationDirection
	var default_animation_repeat_count: int
	var animation_autoplay_name: String
	#var layers_include_regex: String
	#var layers_exclude_regex: String
	#var tags_include_regex: String
	#var tags_exclude_regex: String
	func _init(options: Dictionary) -> void:
		border_type = SPRITESHEET_BORDER_TYPES.find(options[OPTION_SPRITESHEET_BORDER_TYPE])
		trim = options[OPTION_SPRITESHEET_TRIM]
		ignore_empty = options[OPTION_SPRITESHEET_IGNORE_EMPTY]
		merge_duplicates = options[OPTION_SPRITESHEET_MERGE_DUPLICATES]
		spritesheet_layout = SPRITESHEET_LAYOUTS.find(options[OPTION_SPRITESHEET_LAYOUT])
		spritesheet_fixed_rows_count = options[SPRITESHEET_FIXED_ROWS_COUNT]
		spritesheet_fixed_columns_count = options[SPRITESHEET_FIXED_COLUMNS_COUNT]
		default_animation_name = options[OPTION_ANIMATION_DEFAULT_NAME].strip_edges().strip_escapes()
		if default_animation_name.is_empty(): default_animation_name = "default"
		default_animation_direction = PRESET_OPTIONS_ANIMATION_DIRECTIONS.find(options[OPTION_ANIMATION_DEFAULT_DIRECTION])
		default_animation_repeat_count = options[OPTION_ANIMATION_DEFAULT_REPEAT_COUNT]
		animation_autoplay_name = options[OPTION_ANIMATION_AUTOPLAY_NAME].strip_edges().strip_escapes()
#		layers_include_regex = options[OPTION_LAYERS_INCLUDE_REG_EX]
#		layers_exclude_regex = options[OPTION_LAYERS_EXCLUDE_REG_EX]
#		tags_include_regex = options[OPTION_TAGS_INCLUDE_REG_EX]
#		tags_exclude_regex = options[OPTION_TAGS_EXCLUDE_REG_EX]

# It's a pity, but options typed PROPERTY_HINT_ENUM cannot be cast to a numeric type today (2023.04.09),
# because there is some kind of bug in the engine. Because of it, the first initialization
# with a default value occurs with string value of the first element passed in the HintString.
# After changing the option in the editor, the normal numeric value is already set. Hope this gets fixed soon.
# The problem is located here:
# https://github.com/godotengine/godot/blob/e9c7b8d2246bd0797af100808419c994fa43a9d2/editor/editor_file_system.cpp#L1855
static func create_common_animation_options() -> Array[Dictionary]:
	return [
		create_option(OPTION_SPRITESHEET_LAYOUT, SPRITESHEET_LAYOUTS[SpritesheetLayout.PACKED], PROPERTY_HINT_ENUM, ",".join(SPRITESHEET_LAYOUTS), PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED ),
		create_option(SPRITESHEET_FIXED_ROWS_COUNT, 1, PROPERTY_HINT_RANGE, "1,32,1,or_greater", PROPERTY_USAGE_EDITOR,
			func(options): return options[OPTION_SPRITESHEET_LAYOUT] == SPRITESHEET_LAYOUTS[SpritesheetLayout.BY_COLUMNS]),
		create_option(SPRITESHEET_FIXED_COLUMNS_COUNT, 1, PROPERTY_HINT_RANGE, "1,32,1,or_greater", PROPERTY_USAGE_EDITOR,
			func(options): return options[OPTION_SPRITESHEET_LAYOUT] == SPRITESHEET_LAYOUTS[SpritesheetLayout.BY_ROWS]),
		create_option(OPTION_SPRITESHEET_BORDER_TYPE, SPRITESHEET_BORDER_TYPES[BorderType.None], PROPERTY_HINT_ENUM, ",".join(SPRITESHEET_BORDER_TYPES), PROPERTY_USAGE_EDITOR),
		create_option(OPTION_SPRITESHEET_TRIM, false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR,
			func(options): return options[OPTION_SPRITESHEET_LAYOUT] != SPRITESHEET_LAYOUTS[SpritesheetLayout.PACKED]),
		create_option(OPTION_SPRITESHEET_IGNORE_EMPTY, false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_SPRITESHEET_MERGE_DUPLICATES, false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_ANIMATION_DEFAULT_NAME, "default", PROPERTY_HINT_PLACEHOLDER_TEXT, "default", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_ANIMATION_DEFAULT_DIRECTION, PRESET_OPTIONS_ANIMATION_DIRECTIONS[0], PROPERTY_HINT_ENUM, ",".join(PRESET_OPTIONS_ANIMATION_DIRECTIONS), PROPERTY_USAGE_EDITOR),
		create_option(OPTION_ANIMATION_DEFAULT_REPEAT_COUNT, 0, PROPERTY_HINT_RANGE, "0,32,1,or_greater", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_ANIMATION_AUTOPLAY_NAME, "", PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_LAYERS_INCLUDE_REG_EX, "*", PROPERTY_HINT_PLACEHOLDER_TEXT, "*", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_LAYERS_EXCLUDE_REG_EX, "", PROPERTY_HINT_PLACEHOLDER_TEXT, "", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_TAGS_INCLUDE_REG_EX, "*", PROPERTY_HINT_PLACEHOLDER_TEXT, "*", PROPERTY_USAGE_EDITOR),
		create_option(OPTION_TAGS_EXCLUDE_REG_EX, "", PROPERTY_HINT_PLACEHOLDER_TEXT, "", PROPERTY_USAGE_EDITOR)
	]

static func create_texture_2d_options() -> Array[Dictionary]:
	return [
		create_option("compress/mode", COMPRESS_MODES_NAMES[CompressMode.LOSSLESS], PROPERTY_HINT_ENUM, ",".join(COMPRESS_MODES_NAMES),
			PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED),
		create_option("compress/high_quality", false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR,
			func(options): return options["compress/mode"] == COMPRESS_MODES_NAMES[CompressMode.VRAM_COMPRESSED]),
		create_option("compress/lossy_quality", 0.7, PROPERTY_HINT_RANGE, "0,1,0.01", PROPERTY_USAGE_EDITOR,
			func(options): return options["compress/mode"] == COMPRESS_MODES_NAMES[CompressMode.LOSSY]),
		create_option("compress/hdr_compression", HDR_COMPRESSION_NAMES[HdrCompression.DISABLED], PROPERTY_HINT_ENUM, ",".join(HDR_COMPRESSION_NAMES), PROPERTY_USAGE_EDITOR,
			func(options): return options["compress/mode"] == COMPRESS_MODES_NAMES[CompressMode.VRAM_COMPRESSED]),
		create_option("compress/normal_map", NORMAL_MAP_NAMES[NormalMap.DETECT], PROPERTY_HINT_ENUM, ",".join(NORMAL_MAP_NAMES), PROPERTY_USAGE_EDITOR,
			func(options): return options["compress/mode"] != COMPRESS_MODES_NAMES[CompressMode.LOSSLESS]),
		create_option("compress/channel_pack", ChannelPack.SRGB_FRIENDLY, PROPERTY_HINT_ENUM, ",".join(CHANNEL_PACK_NAMES),
			PROPERTY_USAGE_EDITOR),

		create_option("mipmaps/generate", false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		# STRANGE! Appears only on 3D preset. Independently from other properties
		create_option("mipmaps/limit", -1, PROPERTY_HINT_RANGE, "-1,256,1", PROPERTY_USAGE_EDITOR),

		create_option("roughness/mode", ROUGHNESS_NAMES[Roughness.DETECT], PROPERTY_HINT_ENUM, ",".join(ROUGHNESS_NAMES),
			PROPERTY_USAGE_EDITOR),
		create_option("roughness/src_normal", "", PROPERTY_HINT_FILE,
			"*.bmp,*.dds,*.exr,*.jpeg,*.jpg,*.hdr,*.png,*.svg,*.tga,*.webp", PROPERTY_USAGE_EDITOR),

		create_option("process/fix_alpha_border", true, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option("process/premult_alpha", false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option("process/normal_map_invert_y", false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option("process/hdr_as_srgb", false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option("process/hdr_clamp_exposure", false, PROPERTY_HINT_NONE, "", PROPERTY_USAGE_EDITOR),
		create_option("process/size_limit", 0, PROPERTY_HINT_RANGE, "0,4096,1", PROPERTY_USAGE_EDITOR),

		create_option("detect_3d/compress_to", COMPRESS_MODE_3D_NAMES[CompressMode3D.VRAM_COMPRESSED],
			PROPERTY_HINT_ENUM, ",".join(COMPRESS_MODE_3D_NAMES), PROPERTY_USAGE_EDITOR),
	]
