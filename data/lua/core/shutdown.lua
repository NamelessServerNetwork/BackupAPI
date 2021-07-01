function love.quit()
	log("SHUTTING DOWN")
	
	env.userDB:close() --ToDo: add proper shutdown routines.
	
	love.update() --printing the terminal a last time
end