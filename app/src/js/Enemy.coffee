#= require Entity

class Enemy extends Entity
	constructor: (renderer, textureURL) ->
		super(renderer, textureURL)

		@movementSpeed = 3 / 1000

		@collided = false

		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 20

	update: (delta) ->
		@mesh.position.y -= @movementSpeed * delta

	reset: ->
		@mesh.position.x = Math.random() * 3 // 1 * 2 - 2
		@mesh.position.y = 20
		@collided = false

class Enemy_C69 extends Enemy
	constructor: (renderer) ->
		super(renderer, "/images/c69.png")

class Enemy_Minibot extends Enemy
	constructor: (renderer) ->
		super(renderer, "/images/minibot.png")
