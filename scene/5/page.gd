extends MarginContainer


#region vars
@onready var paragraphs = $Paragraphs

var grimoire = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	grimoire = input_.grimoire
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_paragraphs()


func init_paragraphs() -> void:
	pass
#endregion
