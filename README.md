# htmlPlayer
webPage loading Local videoPlayer like  UC
加载的优酷、爱奇艺、搜狐等页面，通过简单js脚本注入，绑定html<video>标签的play方法，获取视频播放地址，用自定义播放器播放视频。

缺点：1.js脚本绑定方法是用JQuery写的，已经做过不管何种情况都引入Jquery库的处理，但还存在问题，如华数。
2.只是简单的通过获取video的src属性，腾讯和乐视播放的都是几分钟的广告和视频。
3.js了解不深，实现比较粗。
