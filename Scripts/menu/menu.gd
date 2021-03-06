extends Node2D

onready var rt = get_parent().get_owner()

var prefabs := {}

var content := {}
var set_blah := {}
var fps := {}

func _ready():
	
	hide()
	
	# work
	if true:
		
		content["resource_text"] = {}
		
		prefabs["resource_text"] = preload("res://Prefabs/menu/resource_text.tscn")
		
		fps["run_text"] = 0.0
		fps["resource_text"] = 0.0
		fps["base"] = 0.0
		
		var node = $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/fps
		node.add_item("1 fps") # 0
		node.add_item("5 fps")
		node.add_item("10 fps")
		node.add_item("15 fps") # 3
		node.add_item("20 fps") # 4
		node.add_item("25 fps") # 5
		node.add_item("30 fps") # 6
		node.add_item("60 fps") # 7
		node.select(gv.menu.option["FPS"])
		_on_fps_item_selected(gv.menu.option["FPS"])
		
		node = $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/notation_type
		node.add_item("engineering") # 0
		node.add_item("scientific") # 1
		node.add_item("logarithmic") # 2
		node.select(gv.menu.option["notation_type"])
	
	# ref
	if true:
		
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/b_runs.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/tutorial_pen.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/version.text = ProjectSettings.get_setting("application/config/Version")
		$ScrollContainer/MarginContainer/VBoxContainer/save.hide()
		
		$ScrollContainer/MarginContainer/VBoxContainer/stats.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs.hide()
		
		$ScrollContainer.rect_size.y = 390
		_on_ScrollContainer_resized()
		#position = Vector2(10, 10)#10 + 38 + 10)
		position = Vector2(800 / 2 - $ScrollContainer.rect_size.x / 2, 600 / 2 - $ScrollContainer.rect_size.y / 2)
		$ScrollContainer/MarginContainer/VBoxContainer/options.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips.hide()
		if not $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/resource_bar.pressed:
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/net.hide()
		if not $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers.pressed:
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only.hide()
		
		
		if "browser" in rt.PLATFORM:
			$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/import_save.hide()
			$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/export_save.hide()
		elif "pc" in rt.PLATFORM:
			$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_print_save.hide()
func init(f: Dictionary) -> void:
	
	# resources
	for x in gv.g:
		content["resource_text"][x] = prefabs["resource_text"].instance()
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/resources/CenterContainer/VBoxContainer.add_child(content["resource_text"][x])
		content["resource_text"][x].add_color_override("font_color", rt.r_lored_color(x))
	
	var i = 0
	for x in rt.tip:
		get_node("ScrollContainer/MarginContainer/VBoxContainer/tutorial_pen/CenterContainer/VBoxContainer/b" + str(i) + "/Label").text = x
		get_node(set_blah[x]).text = rt.tip[x]
		i += 1
	
	# fps
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/fps.select(f["FPS"])
	
	# notation_type
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/notation_type.select(f["notation_type"])
	
	# resource_bar
	if true:
		
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/resource_bar.pressed = f["resource_bar"]
		rt.get_node("misc/qol_displays/resource_bar").visible = f["resource_bar"]
		rt.get_node("misc/qol_displays/resource_bar").r_adjust()
		
		# net
		if true:
			
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/net.visible = f["resource_bar"]
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/net/CenterContainer/net.pressed = f["resource_bar_net"]
			
			# status_color
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/net/CenterContainer/status_color.pressed = f["status_color"]
	
	# performance // save cpu
	if rt.PLATFORM != "browser":
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/perf.pressed = f["performance"]
	else:
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/perf.hide()
	
	# tank_my_pc // Increase FPS
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tank_my_pc.pressed = f["tank_my_pc"]
	
	# flying_numbers
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers.pressed = f["flying_numbers"]
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only.visible = f["flying_numbers"]
	
	# crits_only
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only/CenterContainer/crits_only.pressed = f["crits_only"]
	
	# animations
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/animations.pressed = f["animations"]
	if not f["animations"]:
		for x in rt.get_node("map/loreds").lored:
			rt.get_node("map/loreds").lored[x].get_node("worker").animation = "ww"
			rt.get_node("map/loreds").lored[x].get_node("worker").playing = true
	
	# limit break
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/limit_break_text.pressed = f["limit_break_text"]
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/lb_flash.pressed = f["lb_flash"]
	if not gv.up["Limit Break"].active():
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/limit_break_text.hide()
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/lb_flash.hide()
	else:
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/limit_break_text.show()
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/lb_flash.show()
	
	# on_save
	if true:
		
		# halt
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save/CenterContainer/VBoxContainer/halt.pressed = f["on_save_halt"]
		
		# hold
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save/CenterContainer/VBoxContainer/hold.pressed = f["on_save_hold"]
		
		# menu options
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save/CenterContainer/VBoxContainer/menu_options.pressed = f["on_save_menu_options"]
	
	# tooltip_halt
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/halt.pressed = f["tooltip_halt"]
	
	# tooltip_hold
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/hold.pressed = f["tooltip_hold"]
	
	# tooltip_fuel
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/fuel.pressed = f["tooltip_fuel"]
	
	# tooltip_autobuyer
	$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/autobuyer.pressed = f["tooltip_autobuyer"]
	
	# ref
	if true:
		
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1count.add_color_override("font_color", rt.r_lored_color("malig"))
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1time.add_color_override("font_color", rt.r_lored_color("malig"))
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1last_time.add_color_override("font_color", rt.r_lored_color("malig"))
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2count.add_color_override("font_color", rt.r_lored_color("tum"))
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2time.add_color_override("font_color", rt.r_lored_color("tum"))
		$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2last_time.add_color_override("font_color", rt.r_lored_color("tum"))
		
		$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/on_save.hide()

func _physics_process(delta):
	
	# catches
	if not visible: return
	
	if $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/resources.visible:
		fps["resource_text"] += delta
		if fps["resource_text"] >= rt.FPS:
			fps["resource_text"] -= rt.FPS
			r_resource_text()
	
	if $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs.visible:
		fps["run_text"] += delta
		if fps["run_text"] >= 1.0:
			fps["run_text"] -= 1
			r_runs()
	
	if not $ScrollContainer/MarginContainer/VBoxContainer/save.visible: return
	
	fps["base"] += delta
	if fps["base"] < rt.FPS: return
	fps["base"] -= rt.FPS
	
	r_save_bar()

func r_resource_text() -> void:
	
	for x in gv.g:
		if not rt.get_node("map/loreds").lored[x].visible:
			content["resource_text"][x].hide()
			continue
		content["resource_text"][x].text = gv.stats.r_gained[x].toString() + " " + gv.g[x].name
		if not content["resource_text"][x].visible: content["resource_text"][x].show()
func r_runs() -> void:
	
	var node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1count
	node.text = "S1: on run " + fval.f(gv.stats.run[0])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1time
	node.text = "S1 run duration: " + int_to_time(gv.stats.last_reset_clock[0])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s1last_time
	node.text = "Last S1 run:\n" + int_to_time(gv.stats.last_run_dur[0], false)
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2count
	node.text = "S2: on run " + fval.f(gv.stats.run[1])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2time
	node.text = "S2 run duration: " + int_to_time(gv.stats.last_reset_clock[1])
	
	node = $ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/runs/CenterContainer/VBoxContainer/s2last_time
	node.text = "Last S2 run:\n" + int_to_time(gv.stats.last_run_dur[1], false)
func int_to_time(clock, diff:=true) -> String:
	
	if clock == 0: return "~"
	
	var dif = rt.cur_clock - clock
	if not diff: dif = clock
	
	if dif > 3600 * 24 * 365:
		var years := int(dif /60 / 60 / 24 / 365)
		return str(years) + " years"
	if dif > 3600 * 24:
		var days:= int(dif /60 / 60 / 24)
		return str(days) + " days"
	if dif > 3600:
		var hours := int(dif / 60 / 60)
		return str(hours) + " hours"
	if dif > 60:
		var minutes := int(dif / 60)
		var sec := int(dif - (minutes * 60))
		return str(minutes) + " min, " + str(sec) + " sec"
	
	return String(int(dif)) + " sec"
func _on_button_down():
	rt.get_node("map").status = "no"

func _on_b_options_pressed():
	b_open_or_close_menu($ScrollContainer/MarginContainer/VBoxContainer/options)
func _on_b_tooltips_pressed():
	b_open_or_close_menu($ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips)
func _on_flying_numbers_pressed():
	b_open_or_close_menu($ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only)
	b_option_pressed("flying_numbers", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/flying_numbers)
func _on_b_pressed(extra_arg_0):
	b_open_or_close_menu(get_node(extra_arg_0))
	if "er/runs" in extra_arg_0:
		if get_node(extra_arg_0).visible:
			r_runs()
	if "delete" in extra_arg_0:
		if not get_node(extra_arg_0).visible:
			hide_cascading_save_buttons()

func b_open_or_close_menu(node) -> void:
	if node.visible:
		node.hide()
	else:
		node.show()

func w_display_run(upgrade_complete: bool) -> void:
	if not upgrade_complete: return
	$ScrollContainer/MarginContainer/VBoxContainer/stats/CenterContainer/VBoxContainer/b_runs.show()

func _on_menu_hide():
	
	#$misc/menu/g/save/g/t0/g/textedit.text = ""
	#$misc/menu/g/save/g/t1/g/textedit.text = ""
	pass # Replace with function body.


func _on_fps_item_selected(id):
	gv.menu.option["FPS"] = id
	match id:
		0: rt.FPS = 1.0
		1: rt.FPS = 0.2
		2: rt.FPS = 0.1
		3: rt.FPS = 0.0666
		4: rt.FPS = 0.05
		5: rt.FPS = 0.04
		6: rt.FPS = 0.0333
		7: rt.FPS = 0.01666
func _on_notation_type_item_selected(id):
	gv.menu.option["notation_type"] = id
func _on_notation_for_item_selected(id):
	gv.menu.option["notation_for"] = id

func _on_crits_only_pressed():
	b_option_pressed("crits_only", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/crits_only/CenterContainer/crits_only)
func _on_animations_pressed():
	b_option_pressed("animations", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/animations)
func _on_halt_pressed():
	b_option_pressed("tooltip_halt", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/halt)
func _on_hold_pressed():
	b_option_pressed("tooltip_hold", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/hold)
func _on_fuel_pressed():
	b_option_pressed("tooltip_fuel", $ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/tooltips/CenterContainer/VBoxContainer/fuel)
func _on_option_pressed(option: String, node_path: String):
	b_option_pressed(option, get_node(node_path))

func b_option_pressed(option: String, node) -> void:
	
	gv.menu.option[option] = node.pressed
	
	match option:
		"tank_my_pc":
			if node.pressed:
				for x in gv.g:
					for v in rt.get_node("map/loreds").lored[x].fps:
						rt.get_node("map/loreds").lored[x].fps[v].t *= 0.1
			else:
				for x in gv.g:
					for v in rt.get_node("map/loreds").lored[x].fps:
						rt.get_node("map/loreds").lored[x].fps[v].t *= 10
		"performance":
			if rt.PLATFORM != "browser":
				OS.set_low_processor_usage_mode(node.pressed)
		"lb_flash":
			rt.get_node("map/loreds").r_update_lb_flash()
		"status_color":
			if not gv.menu.option[option]:
				for x in gv.g:
					rt.get_node("misc/qol_displays/resource_bar").content[x].add_color_override("font_color", rt.r_lored_color(x))
		"held_window":
			rt.instances["qol"]["held"].visible = gv.menu.option[option]
			rt.get_node("misc/qol_displays").rect_size.x = 1
		"resource_bar":
			rt.get_node("misc/qol_displays/resource_bar").visible = gv.menu.option[option]
			$ScrollContainer/MarginContainer/VBoxContainer/options/CenterContainer/VBoxContainer/net.visible = gv.menu.option[option]
		"animations":
			for x in rt.get_node("map/loreds").lored:
				if not node.pressed:
					rt.get_node("map/loreds").lored[x].get_node("worker").animation = "ww"
					rt.get_node("map/loreds").lored[x].get_node("worker").playing = true
					continue
				if gv.g[x].progress.f.isLargerThan(0): rt.get_node("map/loreds").lored[x].get_node("worker").animation = "ff"
				rt.get_node("map/loreds").lored[x].get_node("worker").playing = false

func _on_ScrollContainer_resized():
	$bg.rect_size = $ScrollContainer.rect_size

func _on_Label_ready(extra_arg_0, extra_arg_1):
	set_blah[extra_arg_1] = extra_arg_0

func _on_menu_visibility_changed():
	if not visible:
		hide_cascading_save_buttons()
		return
	if not $ScrollContainer/MarginContainer/VBoxContainer/save.visible: return
	r_save_bar()

func r_save_bar(f = get_node("ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/CenterContainer/TextureProgress")) -> void:
	f.value = rt.save_fps * 10

func _on_b_save_now_pressed():
	rt.save_fps = 10.0

func _on_delete_pressed():
	
	rt.b_reset(0)
	rt.get_node("misc/task").w_complete_reset()
	rt.b_tabkey(KEY_ESCAPE)
	rt.b_tabkey(KEY_1)
	gv.menu.option["resource_bar"] = false
	rt.get_node("misc/qol_displays/resource_bar").hide()
	rt.save_fps = 0.0
	
	var save_file = File.new()
	if save_file.file_exists(rt.SAVE_LOC):
		var dir = Directory.new()
		dir.remove(rt.SAVE_LOC)

func hide_cascading_save_buttons()->void:
	
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_delete_save_now3.hide()
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_delete_save_now4.hide()
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/b_delete_save_now5.hide()
	$ScrollContainer/MarginContainer/VBoxContainer/save/CenterContainer/VBoxContainer/delete.hide()


func _on_b_print_save_pressed():
	rt.e_save("print to console")



func _on_export_save_pressed() -> void:
	$FileDialog.popup()
func _on_import_save_pressed() -> void:
	$Import.popup()

func _on_FileDialog_file_selected(path: String) -> void:
	rt.e_save("export", path)
func _on_Import_file_selected(path: String) -> void:
	rt.game_start(rt.e_load(path))


func _on_Discord_pressed() -> void:
	OS.shell_open("https://discord.gg/xJeBZxt")
