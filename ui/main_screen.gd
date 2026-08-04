extends Control

@onready var vp_blue = $GridContainer/SubViewportContainer_blue/SubViewport_blue
@onready var vp_red = $GridContainer/SubViewportContainer_red/SubViewport_red
@onready var vp_green = $GridContainer/SubViewportContainer_green/SubViewport_green
@onready var vp_yellow = $GridContainer/SubViewportContainer_yellow/SubViewport_yellow

# Preload Scene Pertemuan Final (Fasa 2)
var world_final_scene = preload("res://levels/main_level.tscn")

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

	# 2. Instantiate scene world_final ke Viewport 1 (Viewport Biru)
	var final_world_instance = world_final_scene.instantiate()
	vp_blue.add_child(final_world_instance)

	# 3. Bagikan World2D dari Viewport 1 ke Viewport 2, 3, dan 4
	# (Menjadikan keempat viewport melihat satu dunia fisik yang sama di Fasa 2)
	vp_red.world_2d = vp_blue.world_2d
	vp_green.world_2d = vp_blue.world_2d
	vp_yellow.world_2d = vp_blue.world_2d
