extends MarginContainer

onready var rt = get_node("/root/Root")

var src := {
	upgrade_block = preload("res://Prefabs/tooltip/upgrade_block.tscn"),
}
var cont := {}


func init(_lored: String) -> int:
	
	# returns the height of this MarginContainer
	
	if not gv.menu.option["tooltip_autobuyer"]:
		hide_set_key()
		return int(rect_size.y)
	else:
		if " " + _lored + " " in rt.DEFAULT_KEY_LOREDS:
			$VBoxContainer/set_key/HBoxContainer2/default.text = "Default: true"
	
	if not gv.g[_lored].active:
		$VBoxContainer/inactive.show()
		rect_size.y = 0
		return int(rect_size.y)
	
#	if too_much_malig(_lored):
#		return int(rect_size.y)
	
	if fuel_check(_lored):
		return int(rect_size.y)
	
	if upgrade_check(_lored):
		hide_set_key()
		return int(rect_size.y)
	
	if gv.g[_lored].b.size() > 0:
		$VBoxContainer/ingredient_net.show()
	
	if key_check(gv.g[_lored].key_lored):
		return int(rect_size.y)
	
	$VBoxContainer/net.show()
	
	if gv.g[_lored].type[1] in gv.overcharge_list:
		$VBoxContainer/limitbreak.show()
	
	rect_size.y = 0
	
	return int(rect_size.y)


func hide_set_key() -> void:
	$VBoxContainer/Panel.hide()
	$VBoxContainer/set_key.hide()
	rect_size.y = 0

func fuel_check(x: String) -> bool:
	
	var max_fuel = gv.g[x].f.t
	
	if gv.g[x].f.f.isLessThan(Big.new(max_fuel).m(0.1)):
		$VBoxContainer/low_fuel.show()
		rect_size.y = 0
		return true
	
	return false


func key_check(key: bool) -> bool:
	
	if key:
		$VBoxContainer/key_lored.show()
		rect_size.y = 0
		return true
	
	return false


func upgrade_check(_lored: String) -> bool:
	
	var x = "don't take candy from babies" if gv.up["don't take candy from babies"].active() else ""
	if not "1" == gv.g[_lored].type[1] or gv.g[_lored].level > 5:
		x = ""
	
	if x != "" and gv.g[_lored].level < 6:
		$VBoxContainer/level.show()
	
	if x == "":
		match _lored:
			"malig":
				x = "THE WITCH OF LOREDELITH"
			"coal":
				x = "wait that's not fair"
			"iron", "cop":
				x = "IT'S SPREADIN ON ME"
			"irono":
				x = "I RUN"
			"copo":
				x = "THE THIRD"
	
	if x == "":
		return false
	
	if gv.up[x].active():
		upgrade_init(x)
		rect_size.y = 0
		return true
	
	return false

func upgrade_init(key: String) -> void:
	
	$VBoxContainer/upgrade.show()
	
	cont[key] = src.upgrade_block.instance()
	$VBoxContainer/upgrade.add_child(cont[key])
	cont[key].init(key)
	$VBoxContainer/upgrade.move_child(cont[key], 1)

func too_much_malig(key: String) -> bool:
	
	if "s2" in gv.g[key].type:
		return false
	
	if gv.g["malig"].r.isLessThan(gv.up["ROUTINE"].cost["malig"].t):
		return false
	
	$VBoxContainer/toomuchmalig.show()
	return true
