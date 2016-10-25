require "variables"

player = { x = 0, y = 0, width = 20, height = 20, image = nil, texture = nil }
constBullet = { image = nil, width = 5, height = 5 }
shootDelay = 0.4
lastShot = 0
enemies = {}
bullets = {}
upgrade = {}
movementSpeed = 500
screen = { width = 800, height = 600, flags = nil}
success = love.window.setMode( screen.width, screen.height, screen.flags )
love.window.setTitle( "title" )

-- Load some default values for our rectangle.
function love.load()
	love.graphics.setBackgroundColor( 0, 255, 0 )
	player.image = love.graphics.newImage("assets/player.png")
	constBullet.image = love.graphics.newImage("assets/bullet.png")
	print(table.getn(bullets))
	print("123")
end

-- Increase the size of the rectangle every frame.
function love.update(delta_time)
    handleInput(delta_time)
end
 
-- Draw a coloured rectangle.
function love.draw()

	love.graphics.draw(player.image, player.x, player.y, 0, 1, 1, player.width / 2, player.height / 2, 0, 0)
	love.graphics.printf(table.getn(bullets), 20, 20, 50, "left" )
	--love.graphics.printf(love.timer.getTime(), 20, 20, 50, "left" )
	if table.getn(bullets) > 0 then
		print(table.getn(bullets))
		--for bullet in bullets do
			-- print(bullet == nil)
			-- print(constBullet.width)
			-- print(constBullet.height)
			-- print(bullet.x)
			-- print(bullet.y)
			-- love.graphics.draw(constBullet.image, bullet.x, bullet.y, 0, 1, 1, constBullet.width / 2, constBullet.height / 2, 0, 0)
		--end
	end
end

function handleInput(delta_time)

	local movementY = 0
	local movementX = 0
	
	if love.keyboard.isDown("up") then
	    movementY = -delta_time * movementSpeed
	end
	if love.keyboard.isDown("down") then
		movementY = movementY + delta_time * movementSpeed
	end
	if love.keyboard.isDown("left") then
	    movementX = -delta_time * movementSpeed
	end
	if love.keyboard.isDown("right") then
	    movementX = movementX + delta_time * movementSpeed
	end
	if love.keyboard.isDown("escape") then
		love.event.quit();
	end
	if love.keyboard.isDown("lctrl") or love.keyboard.isDown("space") then
		shoot()
	end

	player.x = math.min(math.max(player.x + movementX, 0 + player.width / 2), 800 - player.width / 2)
	player.y = math.min(math.max(player.y + movementY, 0 + player.height / 2), 600 - player.height / 2)

end

function shoot()
	local canShoot = (love.timer.getTime() - lastShot) > shootDelay
	if (canShoot) then
		bullet = { x = player.x, y = player.y - 30 }
		table.insert(bullets, bullet)
		lastShot = love.timer.getTime()
	end
end