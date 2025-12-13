pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- picochet
--
-- this is a breakout clone.
-- i am learning how to make
-- games in pico-8 by following
-- a youtube tutorial by
-- @lazydevs.

function _init()
	-- colours
	black=0
	dark_blue=1
	purple=2
	gray=6
	white=7
	red=8
	orange=9
	yellow=10
	paddle_colour=white

	-- paddle
	paddle_x=5
	paddle_y=120
	paddle_width=20
	paddle_height=3
	paddle_deltax=0

	-- ball
	ball_x=50
	ball_y=100
	ball_deltax=1
	ball_deltay=1
	ball_radius=2

	-- screen
	screen_top=2
	screen_bottom=125
	screen_left=2
	screen_right=125
end

function has_ball_collided(
		box_x,
		box_y,
		box_width,
		box_height
	)
	-- top of ball bellow paddle
	if ball_y-ball_radius >
				box_y+box_height then
		return false -- no collision
	end
	-- bottom of ball above paddle
	if ball_y+ball_radius <
				box_y then
		return false -- no collision
	end
	-- left of ball right of paddle
	if ball_x-ball_radius >
				box_x+box_width then
		return false -- no collision
	end
	-- right of ball left of paddle
	if ball_x+ball_radius <
				box_x then
		return false -- no collision
	end

	return true
end

function _update()
	-- move the paddle
	local is_button_pressed=false
	if btn(⬅️) then
		paddle_deltax=-5
		is_button_pressed=true
	end

	if btn(➡️) then
		paddle_deltax=5
		is_button_pressed=true
	end

	if not(is_button_pressed) then
		paddle_deltax=paddle_deltax/2
	end
	paddle_x=paddle_x+paddle_deltax

	-- move the ball
	ball_x=ball_x+ball_deltax
	ball_y=ball_y+ball_deltay

	if ball_x > screen_right or
		ball_x < screen_left then
		ball_deltax=-ball_deltax
		sfx(0)
	end

	if ball_y > screen_bottom or
		ball_y < screen_top then
		ball_deltay=-ball_deltay
		sfx(0)
	end

	paddle_colour=white
	if has_ball_collided(
			paddle_x,
			paddle_y,
			paddle_width,
			paddle_height
		) then
		-- do something
			paddle_colour=orange
			sfx(0)
			ball_deltay=-ball_deltay
	end
end

function _draw()
	cls()
	rectfill(0,0,127,127,purple)
	circfill(
		ball_x,
		ball_y,
		ball_radius,
		yellow
	)
	rectfill(
		paddle_x,
		paddle_y,
		paddle_x+paddle_width,
		paddle_y+paddle_height,
		paddle_colour
	)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000705007050070501005010050100500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0001000029010200100e0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
