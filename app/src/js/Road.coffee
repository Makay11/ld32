class Road
	constructor: (scene, renderer) ->
		@tiles = 4

		@roadTiles = []
		@leftSideWalkTiles = []
		@rightSideWalkTiles = []

		geometry = new THREE.PlaneBufferGeometry(6, 20)
		texture = THREE.ImageUtils.loadTexture("/images/road.png")
		texture.minFilter = THREE.LinearFilter
		texture.anisotropy = renderer.getMaxAnisotropy()
		material = new THREE.MeshBasicMaterial(map: texture)

		for i in [0...@tiles]
			tile = new THREE.Mesh(geometry, material)
			tile.position.y = i * 20
			@roadTiles.push(tile)
			scene.add(tile)

		geometry = new THREE.PlaneBufferGeometry(1.5, 20)
		texture = THREE.ImageUtils.loadTexture("/images/sidewalk.png")
		texture.minFilter = THREE.LinearFilter
		texture.anisotropy = renderer.getMaxAnisotropy()
		material = new THREE.MeshBasicMaterial(map: texture)

		for array, index in [@leftSideWalkTiles, @rightSideWalkTiles]
			for i in [0...@tiles]
				tile = new THREE.Mesh(geometry, material)
				tile.position.x = -3 - 1.5 / 2 + index * (6 + 1.5)
				tile.position.y = i * 20
				array.push(tile)
				scene.add(tile)


	update: (delta) ->
		for array in [@roadTiles, @leftSideWalkTiles, @rightSideWalkTiles]
			for tile in array
				tile.position.y -= 3 / 1000 * delta
				if tile.position.y <= -20
					tile.position.y += @tiles * 20
