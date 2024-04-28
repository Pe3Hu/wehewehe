extends MarginContainer


#region vars
@onready var charges = $HBox/Charges

var grimoire = null
var type = null
#endregion


#region init
func set_attributes(input_: Dictionary) -> void:
	grimoire = input_.grimoire
	type = input_.type
	
	init_basic_setting()


func init_basic_setting() -> void:
	init_charges()


func init_charges() -> void:
	pass
