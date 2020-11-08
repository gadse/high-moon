extends TextureRect

func _ready():
	$GunShot.connect("finished", self, "queue_free")
	$itsHighMoon.play()

func _on_GunShotTimer_timeout():
	$GunShot.play()
