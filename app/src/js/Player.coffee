#= require Entity

class Player extends Entity
	constructor: (renderer) ->
		super(renderer, "/images/runner.png")

		@position = 0
		@moving = false

		@energy = 100

		@movementSpeed = 1 / 200

	updateEnergy: (value) ->
		if @energy <= 0
			return
		@energy += value

	moveLeft: ->
		if @moving then return
		if @position > -1
			@moving = "left"

	moveRight: ->
		if @moving then return
		if @position < 1
			@moving = "right"

	update: (delta) ->
		if @moving
			if @moving == "left"
				@mesh.position.x -= @movementSpeed * delta
				if @mesh.position.x <= @position - 2
					@position = @position - 2
					@mesh.position.x = @position
					@moving = false
			else if @moving == "right"
				@mesh.position.x += @movementSpeed * delta
				if @mesh.position.x >= @position + 2
					@position = @position + 2
					@mesh.position.x = @position
					@moving = false
