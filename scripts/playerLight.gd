extends AnimatedSprite2D

func _process(_delta: float) -> void:
	await RenderingServer.frame_post_draw
	
	var brightness = clampf((get_color_difference().get_luminance() + 0.165) * 8.7, 0.0, 1.0)
	var indicator = get_node("../Camera2D/CanvasLayer/lightIndicator")
	indicator.value = brightness
	indicator.tint_progress.a = brightness
	#var colorT = get_color_difference()
	#print("light: %f" % colorT.get_luminance())

func get_color_difference() -> Color:
	var sprite = get_node(".")
	# Note that sprite referes to an AnimatedSprite.
	
	var view_img: Image = get_viewport().get_texture().get_image()
	var sprite_tex: Texture2D = sprite.sprite_frames.get_frame_texture(sprite.animation, sprite.frame)
	#var viewport_scale: Vector2 = sprite.get_viewport_transform().get_scale()
	var viewport_scale: Vector2 = Vector2(1, 1)
	var sreen_pos = sprite.get_screen_transform().origin * viewport_scale
	var crop_rect = Rect2i(sreen_pos-((sprite_tex.get_size()/2.0)*viewport_scale * 3.5), sprite_tex.get_size()*viewport_scale * 3.5)
	# crop the viewport image to the sprites rect.
	
	view_img = view_img.get_region(crop_rect)
	view_img.resize(sprite_tex.get_size().x, sprite_tex.get_size().y)
	#view_img.save_png("res://test2.png")
	view_img.convert(Image.FORMAT_RGBA8)
	var final_img: Image = Image.create_empty(sprite_tex.get_size().x, sprite_tex.get_size().y, false, Image.FORMAT_RGBA8)
	var sprite_img: Image = sprite_tex.get_image()

	# Use the sprite_img to mask now.
	final_img.blit_rect_mask(view_img, sprite_img, Rect2i(Vector2i(), sprite_tex.get_size()), Vector2i())
	# Important! if the alpha isn't fixed, the final color will be off, and the whole thing will break.
	final_img.fix_alpha_edges()
	
	# Resize the images, this is the slowest interpolation method, you may be able to use others.
	final_img.resize(1, 1, Image.INTERPOLATE_LANCZOS)
	sprite_img.resize(1, 1, Image.INTERPOLATE_LANCZOS)
	# Get the view_color
	var final_color = final_img.get_pixel(0, 0)
	# Get the sprites color as well, this way we can compare light levels.
	var base_color = sprite_img.get_pixel(0, 0)
	# We need to divide the colors by their alpha, otherwise the color will be muted from empty space.
	# We then need to subtract the base_color to compare the two colors.
	final_color = (final_color/final_color.a) - (base_color/base_color.a)
	
	return final_color
