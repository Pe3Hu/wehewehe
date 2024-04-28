extends MarginContainer


#region vars
@onready var spells = $Pages/Spells
@onready var mantras = $Pages/Mantras

var god = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	god = input_.god
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_pages()


func init_pages() -> void:
	var input = {}
	input.grimoire = self
	
	for type in Global.arr.page:
		input.type = type
		var page = get(type+"s")
		page.set_attributes(input)
#endregion
