# Deployment
export image := `aws lightsail get-container-images --service-name websocket-lightsail | jq -r '.containerImages[0].image'`

build:
	docker rmi app
	docker build . -t app

push:
	aws lightsail push-container-image --service-name websocket-lightsail --label app --image app

deploy:
	jq --arg image $(image) '.containers.app.image = $$image' container.tpl.json > ./container.json
	cat ./container.json | jq
	aws lightsail create-container-service-deployment --service-name websocket-lightsail --cli-input-json file://$$(pwd)/container.json

.PHONY: build push deploy
