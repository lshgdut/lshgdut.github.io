title: sass-context-no-such-file
date: 2017-12-14 00:03:36
tags:
	- hexo
	- sass
---

安装 node-sass 过程中出现 `fatal error: sass/context.h: No such file or directory`

解决办法：

```
LIBSASS_EXT="no" npm install
```

摘自： https://github.com/sass/node-sass/issues/2010