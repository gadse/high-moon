extends TextureRect

func _ready():
	$itsHighMoon.play()

func _on_GunShotTimer_timeout():
	$GunShot.play()
