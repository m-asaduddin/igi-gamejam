class_name MergeCamera
extends Node2D

# Daftar target (pemain) yang harus diikuti oleh kamera gabungan
var targets: Array = []

# Daftar viewport yang harus memperlihatkan tampilan kamera gabungan yang sama
var viewports: Array = []

# Margin tambahan agar pemain tidak menempel di tepi layar
@export var margin: float = 250.0

func setup(target_nodes: Array, target_viewports: Array) -> void:
	targets = target_nodes
	viewports = target_viewports

func _process(_delta: float) -> void:
	if targets.is_empty() or viewports.is_empty():
		return

	var min_x: float = INF
	var max_x: float = -INF
	var min_y: float = INF
	var max_y: float = -INF
	var valid := false

	for t in targets:
		if t == null or not is_instance_valid(t):
			continue
		var p: Vector2 = t.global_position
		min_x = min(min_x, p.x)
		max_x = max(max_x, p.x)
		min_y = min(min_y, p.y)
		max_y = max(max_y, p.y)
		valid = true

	if not valid:
		return

	# Posisi tengah-tengah kedua pemain (camera merge)
	var center: Vector2 = Vector2((min_x + max_x) * 0.5, (min_y + max_y) * 0.5)

	# Hitung zoom agar kedua pemain muat di layar
	var horizontal_span: float = max_x - min_x + margin
	var vertical_span: float = max_y - min_y + margin
	var viewport_size: Vector2 = viewports[0].get_visible_rect().size
	var scale_factor: float = 1.0
	if horizontal_span > 0.0 and vertical_span > 0.0 and viewport_size.x > 0.0 and viewport_size.y > 0.0:
		scale_factor = min(viewport_size.x / horizontal_span, viewport_size.y / vertical_span)

	# Terapkan transform kanvas yang sama ke semua viewport dalam satu tim
	var canvas_transform := Transform2D()
	canvas_transform = canvas_transform.scaled(Vector2(scale_factor, scale_factor))
	canvas_transform.origin = -center * scale_factor + viewport_size * 0.5
	for vp in viewports:
		if vp != null and is_instance_valid(vp):
			vp.canvas_transform = canvas_transform
