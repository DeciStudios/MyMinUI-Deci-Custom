local text = "No text provided"

function love.load(arg)
	text = arg[1] or "No text provided"
	-- Set up font
	font = love.graphics.newFont(20)
	love.graphics.setFont(font)

	-- Enable text wrapping
	textWidth = love.graphics.getWidth() - 40
	wrappedText = love.graphics.newText(font)
	wrappedText:setf(text, textWidth, "left")
end

function love.draw()
	-- Set background color (dark gray)
	love.graphics.setBackgroundColor(0.2, 0.2, 0.2)

	-- Draw text (white)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(wrappedText, 20, 20)
end

function love.keypressed(key)
	-- Exit on any key press
	if key then
		love.event.quit()
	end
end

function love.gamepadpressed()
	-- Exit on any gamepad button press
	love.event.quit()
end
