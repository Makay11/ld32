class Road
	constructor: (scene, renderer) ->
		@geometry = new THREE.PlaneBufferGeometry(6, 20)
		@texture = THREE.ImageUtils.loadTexture("/images/road.png")
		@texture.minFilter = THREE.LinearFilter
		@texture.anisotropy = renderer.getMaxAnisotropy()
		@material = new THREE.MeshBasicMaterial(map: @texture)

		@tiles = []

		for i in [0...4]
			tile = new THREE.Mesh(@geometry, @material)
			tile.position.y = i * 20
			@tiles.push(tile)
			scene.add(tile)

	update: (delta) ->
		for tile in @tiles
			tile.position.y -= 3 / 1000 * delta
			if tile.position.y <= -20
				tile.position.y += @tiles.length * 20
