# GIT
st:
	git add .
	git stash
pop:
	git stash pop
up:
	docker-compose up
deploy:
	git push heroku main --force
	