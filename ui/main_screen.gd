extends Control

@onready var vp_blue = $GridContainer/SubViewportContainer_blue/SubViewport_blue
@onready var vp_red = $GridContainer/SubViewportContainer_red/SubViewport_red
@onready var vp_green = $GridContainer/SubViewportContainer_green/SubViewport_green
@onready var vp_yellow = $GridContainer/SubViewportContainer_yellow/SubViewport_yellow

# Preload Scene Pertemuan Final (Fasa 2)
var world_purple_scene = preload("res://levels/purple_level.tscn")
var world_orange_scene = preload("res://levels/orange_level.tscn")

# Counter untuk mencatat berapa karakter yang sudah menyentuh Area2D finish
var completed_characters: Array = []

func _ready() -> void:
	# Hubungkan sinyal finish_zone dari masing-world ke fungsi _on_character_finished
	_setup_level_signals()

func _setup_level_signals() -> void:
	# Ambil node FinishZone dari masing-masing level yang ada di Viewport
	var finish_biru = vp_blue.get_node("BlueLevel/FinishZone")
	var finish_merah = vp_red.get_node("RedLevel/FinishZone")
	var finish_hijau = vp_green.get_node("GreenLevel/FinishZone")
	var finish_kuning = vp_yellow.get_node("YellowLevel/FinishZone")

	finish_biru.level_completed.connect(_on_character_finished)
	finish_merah.level_completed.connect(_on_character_finished)
	finish_hijau.level_completed.connect(_on_character_finished)
	finish_kuning.level_completed.connect(_on_character_finished)

func _on_character_finished(character_color: String) -> void:
	if not completed_characters.has(character_color):
		completed_characters.append(character_color)
		print("Karakter ", character_color, " telah mencapai garis finish! Total: ", completed_characters.size())

	# Jika keempatnya sudah menyentuh Area2D finish masing-masing, lakukan transisi!
	if completed_characters.size() >= 4:
		transition_to_final_world()

func transition_to_final_world() -> void:
	# 1. Bersihkan level-level lama di Viewport
	for child in vp_blue.get_children():
		child.queue_free()
	for child in vp_red.get_children():
		child.queue_free()
	for child in vp_green.get_children():
		child.queue_free()
	for child in vp_yellow.get_children():
		child.queue_free()

	# 2. Pasang level purple (red + blue) di Viewport merah & biru dengan world yang sama
	var purple_instance = world_purple_scene.instantiate()
	vp_red.add_child(purple_instance)
	vp_blue.world_2d = vp_red.world_2d
	_setup_merge_camera(purple_instance, ["PlayerRed", "PlayerBlue"], [vp_red, vp_blue])

	# 3. Pasang level orange (yellow + green) di Viewport kuning & hijau dengan world yang sama
	var orange_instance = world_orange_scene.instantiate()
	vp_yellow.add_child(orange_instance)
	vp_green.world_2d = vp_yellow.world_2d
	_setup_merge_camera(orange_instance, ["PlayerYellow", "PlayerGreen"], [vp_yellow, vp_green])

func _setup_merge_camera(world_instance: Node2D, player_names: Array, target_viewports: Array) -> void:
	# Nonaktifkan kamera default pada masing-masing pemain
	var targets: Array = []
	for name in player_names:
		var player = world_instance.get_node_or_null(name)
		if player != null:
			var cam: Camera2D = player.get_node_or_null("PlayerBase/Camera2D")
			if cam != null:
				cam.enabled = false
			targets.append(player)

	# Tambahkan MergeCamera untuk mengikuti kedua pemain sekaligus
	var merge_cam = MergeCamera.new()
	world_instance.add_child(merge_cam)
	merge_cam.setup(targets, target_viewports)
