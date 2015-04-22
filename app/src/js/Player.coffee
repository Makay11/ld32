#= require Entity

class Player extends Entity
	constructor: (renderer) ->
		super(renderer, "/images/running_sprite.png", 8)

		@energy = 100

		@position = 0

		@runningSprite = @texture
		@runningSpriteTiles = 8
		@runningAnimationDuration = 200 / @runningSpriteTiles

		@setRunning()

		@jumpSpriteTiles = 6
		@jumpAnimationDuration = 300 / @jumpSpriteTiles

		@jumpLeftSprite = @loadTexture("/images/jump_left_sprite.png")
		@jumpLeftSprite.repeat.x = 1 / @jumpSpriteTiles

		@jumpRightSprite = @loadTexture("/images/jump_right_sprite.png")
		@jumpRightSprite.repeat.x = 1 / @jumpSpriteTiles

		@jumpSpeed = 2 / (@jumpAnimationDuration * @jumpSpriteTiles)

	moveLeft: ->
		if @moving then return
		if @position > -1
			@setTexture(@jumpLeftSprite, @jumpSpriteTiles, @jumpAnimationDuration)
			@moving = "left"

	moveRight: ->
		if @moving then return
		if @position < 1
			@setTexture(@jumpRightSprite, @jumpSpriteTiles, @jumpAnimationDuration)
			@moving = "right"

	update: (delta) ->
		super(delta)

		if @moving
			if @moving == "left"
				@mesh.position.x -= @jumpSpeed * delta
				if @mesh.position.x <= @position - 2
					@position = @position - 2
					@mesh.position.x = @position
					@setRunning()
			else if @moving == "right"
				@mesh.position.x += @jumpSpeed * delta
				if @mesh.position.x >= @position + 2
					@position = @position + 2
					@mesh.position.x = @position
					@setRunning()

		return @updateEnergy(-10 / 1000 * delta)

	setRunning: ->
		@setTexture(@runningSprite, @runningSpriteTiles, @runningAnimationDuration)
		@moving = false

	updateEnergy: (value) ->
		@energy += value

		if @energy > 100
			@energy = 100
		else if @energy < 0
			@energy = 0

		$(".energy").width(@energy + "%")

		return @energy

	reset: ->
		@setRunning()
		@updateEnergy(100)
		@position = 0
		@mesh.position.x = 0
