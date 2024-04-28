extends MarginContainer


#region vars
@onready var bg = $BG
@onready var hbox = $HBox
@onready var sockets = $HBox/Sockets

var proprietor = null
var area = null
var capacity = null
var selected = false
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	proprietor = input_.proprietor
	area = input_.area
	
	init_basic_setting()


func init_basic_setting() -> void:
	custom_minimum_size = Global.vec.size.stone
	#init_tokens(input_)
	init_bg()


func init_sockets(input_: Dictionary) -> void:
	var input = {}
	input.proprietor = self
	input.type = "socket"
	
	for subtype in input_.resources:
		input.subtype = subtype
		input.value = input_.resources[subtype]
		
		var token = Global.scene.token.instantiate()
		sockets.add_child(token)
		token.set_attributes(input)


func init_bg() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.SLATE_GRAY
	bg.set("theme_override_styles/panel", style)
	set_selected(false)


func advance_area() -> void:
	var stonestack = null
	
	if area == null:
		area = Global.dict.area.next[area]
		advance_area()
	else:
		stonestack = proprietor.get(area)
		stonestack.stones.remove_child(self)
	
		area = Global.dict.area.next[area]
		stonestack = proprietor.get(area)
		stonestack.stones.add_child(self)


func set_bag_as_proprietor(bag_: MarginContainer) -> void:
	var stonestack = proprietor.get(area)
	var market = false
	
	if stonestack == null:
		stonestack = proprietor
		market = true
	
	stonestack.stones.remove_child(self)
	proprietor = bag_
	area = "discharged"
	
	stonestack = proprietor.get(area)
	stonestack.stones.add_child(self)
	
	custom_minimum_size = Global.vec.size.stone
	size = Global.vec.size.stone
	set_selected(false)
	
	if !market:
		advance_area()


func set_selected(selected_: bool) -> void:
	selected = selected_
	var style = bg.get("theme_override_styles/panel")
	style.bg_color = Global.color.stone.selected[selected_]
#endregion
