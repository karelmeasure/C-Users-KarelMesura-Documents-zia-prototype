extends Camera2D
class_name GameCamera

const BASE_OFFSET = Vector2.ZERO 

func _ready():
	offset = BASE_OFFSET 
	
func shake(intensity: float = 4.0, duration: float = 0.05, count: int = 1):
	
	if has_meta("shake_tween"):
		var existing_tween = get_meta("shake_tween")
		if existing_tween and is_instance_valid(existing_tween):
			existing_tween.kill()
		
	var shake_tween = create_tween()
	set_meta("shake_tween", shake_tween) # Simpan referensi Tween
	
	shake_tween.set_parallel(false) # Pastikan animasi berurutan
	
	for i in range(count):
		var random_offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
		shake_tween.tween_property(self, "offset", random_offset, duration)
		shake_tween.tween_property(self, "offset", BASE_OFFSET, duration)
		
	await shake_tween.finished
	offset = BASE_OFFSET
