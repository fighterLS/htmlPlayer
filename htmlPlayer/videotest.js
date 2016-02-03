/**
 * Created by lisai on 16/1/19.
 */


$(document).ready(function(){
    $('video').attr('webkit-playsinline', '');
    $('video').bind('play',function(){
        $('video')[0].pause();
        var videoSource=$('video').attr('src');
       // var videoTitle =$('*').html();
    document.location="objc://"+"URL"+":/"+videoSource; //cmd代表objective-c中的的方法名，parameter1自然就是参数了
    });
});

(function () {
 var head = document.getElementsByTagName('head');
 var script = document.createElement('script');
 script.src='http://code.jquery.com/jquery-2.2.0.min.js';
 head.appendChild(script);
})();