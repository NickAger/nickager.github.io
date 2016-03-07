---
layout: page
title: About
permalink: /about/
---
<style>
div#images {
  position: relative;
  height: 480px;
}

img#cycleImage1, img#cycleImage2 {
opacity:1;
transition: opacity 1s;
position: absolute;
}

img#cycleImage1.fade,  img#cycleImage2.fade {
opacity:0;
}
</style>

This is the home of Nick Ager, software developer. I care a lot about usability and maintainability. My interests are in mobile development, embedded systems and the impending parallel programming crisis. I'm fascinated with programming languages and how they effect how you think about solving problems.

<div id="images"><img id="cycleImage1" src="/images/About/KikaOffYemen.jpeg"/><img id="cycleImage2" src="/images/About/NickAndOrangutan.jpeg" /></div>
<br />

To read about Nick Ager sailor, have a look at [http://kikasailing.blogspot.com](http://kikasailing.blogspot.com)



<script>
(function () {
    var div = document.getElementById('images');
    var imgs = div.getElementsByTagName('img'),
        index = 0;
    imgs[0].class = 'fade';
    setInterval(function () {
        imgs[index].className = '';
        index = (index + 1) % imgs.length;
        imgs[index].className = 'fade';
    }, 4000);
}());
</script>
