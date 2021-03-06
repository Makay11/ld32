class Entity
	constructor: (renderer, @textureURL, @horizontalTiles = 1) ->
		@width = 1
		@height = 1.5

		@animationTimer = 0
		@animationDuration = 500 / @horizontalTiles

		@maxAnisotropy = renderer.getMaxAnisotropy()

		if @textureURL
			@texture = @loadTexture(@textureURL)
			@texture.repeat.x = 1 / @horizontalTiles

			@geometry = new THREE.PlaneBufferGeometry(@width, @height)
			@material = new THREE.MeshBasicMaterial(map: @texture)

			@createMesh(@geometry, @material)

	createMesh: (@geometry, @material) ->
		@mesh = new THREE.Mesh(@geometry, @material)

		@mesh.position.z = @height / 2

		@mesh.rotateOnAxis(new THREE.Vector3(1, 0, 0), Math.PI / 2)

		THREEx.Transparency.init([@mesh])

	update: (delta) ->
		if @horizontalTiles > 1
			@animationTimer += delta or 0
			if @animationTimer >= @animationDuration
				@animationTimer -= @animationDuration
				@texture.offset.x = (@texture.offset.x + 1 / @horizontalTiles) % 1

	render: (camera) ->
		THREEx.Transparency.update([@mesh], camera)

	reset: ->

	loadTexture: (textureURL) ->
		texture = THREE.ImageUtils.loadTexture(textureURL)
		texture.minFilter = THREE.LinearFilter
		texture.anisotropy = @maxAnisotropy
		texture

	setTexture: (@texture, @horizontalTiles = 1, @animationDuration) ->
		@texture.repeat.x = 1 / @horizontalTiles
		@texture.offset.x = 0
		@material.map = @texture
		@animationTimer = 0
		THREEx.Transparency.init([@mesh])
