# myweng 1.0

push:
	git add -A && git commit -m "deploy" && git push origin source || exit 0

deploy:push
	hexo generate
	hexo deploy
