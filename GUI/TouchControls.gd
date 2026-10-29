extends CanvasLayer
# On-screen controls for touch devices (Android/iOS).
# Built entirely from code so no scene file is needed.
# Left side : D-pad to move the camera, +/- to zoom.
# Right side: mode buttons (replace the K / D / S / C / O keyboard shortcuts).

const BTN := Vector2(84, 84)
const GAP := 8

var _panels = []
var _dir = Vector2.ZERO
var _object_cursor = null


func _ready():
	layer = 10
	_object_cursor = get_node_or_null("/root/World/Editor_Object")
	_build_dpad()
	_build_modes()
	visible = _is_touch_device()


func _is_touch_device() -> bool:
	return OS.has_touchscreen_ui_hint() or OS.get_name() in ["Android", "iOS"]


# Show/hide manually (handy for testing on desktop): press T
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo and event.scancode == KEY_T:
		visible = not visible


func _process(_delta):
	if _dir != Vector2.ZERO:
		Stats.move_camera(_dir)


###############################################################################
# D-pad + zoom
func _build_dpad():
	var panel = _make_panel(Control.PRESET_BOTTOM_LEFT, Vector2(3 * BTN.x + 4 * GAP, 3 * BTN.y + 4 * GAP))
	var grid = GridContainer.new()
	grid.columns = 3
	grid.add_constant_override("hseparation", GAP)
	grid.add_constant_override("vseparation", GAP)
	grid.rect_position = Vector2(GAP, GAP)
	panel.add_child(grid)

	_grid_cell(grid, "+", "_zoom", -1)
	_grid_cell(grid, "▲", "_hold", Vector2(0, -1))
	_grid_cell(grid, "−", "_zoom", 1)
	_grid_cell(grid, "◀", "_hold", Vector2(-1, 0))
	_grid_cell(grid, "", "", null)
	_grid_cell(grid, "▶", "_hold", Vector2(1, 0))
	_grid_cell(grid, "", "", null)
	_grid_cell(grid, "▼", "_hold", Vector2(0, 1))
	_grid_cell(grid, "", "", null)


func _grid_cell(grid, text, kind, arg):
	var b = _make_button(text)
	grid.add_child(b)
	if kind == "_hold":
		b.connect("button_down", self, "_set_dir", [arg])
		b.connect("button_up", self, "_set_dir", [Vector2.ZERO])
	elif kind == "_zoom":
		b.connect("pressed", Stats, "zoom_camera", [arg])
	else:
		b.disabled = true
		b.flat = true


func _set_dir(dir):
	_dir = dir


###############################################################################
# Mode buttons
func _build_modes():
	var panel = _make_panel(Control.PRESET_BOTTOM_RIGHT, Vector2(2 * BTN.x + 3 * GAP, 3 * BTN.y + 4 * GAP))
	var grid = GridContainer.new()
	grid.columns = 2
	grid.add_constant_override("hseparation", GAP)
	grid.add_constant_override("vseparation", GAP)
	grid.rect_position = Vector2(GAP, GAP)
	panel.add_child(grid)

	var modes = [
		["Tanam", Stats.mouse_states.ADD_CROP],
		["Penyakit", Stats.mouse_states.ADD_DISEASE],
		["Sebar", Stats.mouse_states.SPREAD],
		["Pantau", Stats.mouse_states.WATCH],
	]
	for m in modes:
		var b = _make_button(m[0])
		grid.add_child(b)
		b.connect("pressed", Stats, "set_mouse_state", [m[1]])

	var cycle = _make_button("Siklus ▶")
	grid.add_child(cycle)
	cycle.connect("pressed", self, "_on_cycle")


func _on_cycle():
	var field = get_node_or_null("/root/World/Ground/Field")
	if field:
		field.cycle()


###############################################################################
# Helpers
func _make_button(text: String) -> Button:
	var b = Button.new()
	b.text = text
	b.rect_min_size = BTN
	b.focus_mode = Control.FOCUS_NONE
	return b


func _make_panel(preset: int, size: Vector2) -> Control:
	var panel = Control.new()
	panel.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(panel)
	panel.set_anchors_and_margins_preset(preset)
	# anchor to the chosen corner with a fixed size
	if preset == Control.PRESET_BOTTOM_LEFT:
		panel.margin_left = 12
		panel.margin_right = 12 + size.x
	else:
		panel.margin_left = -12 - size.x
		panel.margin_right = -12
	panel.margin_top = -12 - size.y
	panel.margin_bottom = -12
	# don't place crops while the finger is on the controls (mirrors GUI/ScrollContainer.gd)
	panel.connect("mouse_entered", self, "_over_controls", [true])
	panel.connect("mouse_exited", self, "_over_controls", [false])
	_panels.append(panel)
	return panel


func _over_controls(over: bool):
	if _object_cursor:
		_object_cursor.can_place = not over
		if over:
			_object_cursor.hide()
		else:
			_object_cursor.show()
