# myweng 1.0

push:
	git add -A && git commit -m "deploy" && git push origin source || exit 0

deploy:
	hexo generate
	hexo deploy

all:deploy push
