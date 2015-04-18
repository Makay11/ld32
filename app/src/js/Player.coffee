class Player
	constructor: (renderer) ->
		@width = 1
		@height = 1.5

		@position = 0
		@moving = false
		
		@energy = 100
		
		@movementSpeed = 1 / 200

		@texture = THREE.ImageUtils.loadTexture("/images/runner.png")
		@texture.minFilter = THREE.LinearFilter
		@texture.anisotropy = renderer.getMaxAnisotropy()

		@geometry = new THREE.PlaneBufferGeometry(@width, @height)
		@material = new THREE.MeshBasicMaterial(map: @texture)
		@mesh = new THREE.Mesh(@geometry, @material)

		@mesh.position.z = @height / 2

		@mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)
		
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
