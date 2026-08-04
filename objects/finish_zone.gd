extends Area2D

# Sinyal untuk memberitahu bahwa karakter telah mencapai titik akhir levelnya
signal level_completed(character_name: String)



@export var character_color: String = "blue" # Diisi sesuai warna dunia ("biru", "merah", "hijau", "kuning")

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print(character_color, "reach finish")
		# Nonaktifkan collision agar tidak ter-trigger berulang kali
		monitoring = false
		# Pancarkan sinyal bahwa level warna ini telah selesai
		level_completed.emit(character_color)
