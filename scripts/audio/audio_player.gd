class_name AudioPlayer
extends AudioStreamPlayer3D

enum PlayMode {Sequencial, Randomized }

@export var playmode : PlayMode
@export var clipPlaylist : Array[AudioStreamWAV]

var currentIndex : int

func adv_play() -> void:
	if PlayMode.Randomized:
		if playing:
			return
		currentIndex = randi_range(0, clipPlaylist.size() - 1)
		stream = clipPlaylist[currentIndex]
		play()
		return
