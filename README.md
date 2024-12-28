# RV32IM Pipelined-Processor
Design and implement a 32-bit RISC-V processor supporting the RV32IM instruction set, developed as part of the Advanced Computer Architecture course (CO502). Webpage: https://cepdnaclk.github.io/e20-co502-RV32IM_Pipelined_Processor

# Tutorial

## Install GHDL and GTKWave on Windows
1. Go to the GHDL official Github repo: https://github.com/ghdl/ghdl/releases
2. Download the latest version of **ghdl-MINGW32.ZIP** (for Windows)
3. Save it to your preferred directory of your Windows PC.
4. Unzip the **ghdl-MINGW32.ZIP**
5. Copy the bin directory path of the GHDL file
6. Add it as a new environment variable path and save. (If you add a new path as **System Variables** then it will be available for all users for your PC)
7. Save path.
Reference Video Tutorial (*Credits to original creater*) :
<!DOCTYPE html>
<html>
  <body>
    <!-- 1. The <iframe> (and video player) will replace this <div> tag. -->
    <iframe width="560" height="315" src="https://www.youtube.com/embed/0JJku1vTu78?si=lBeh6OnTvlOcce4z" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

    <script>
      // 2. This code loads the IFrame Player API code asynchronously.
      var tag = document.createElement('script');

      tag.src = "https://www.youtube.com/iframe_api";
      var firstScriptTag = document.getElementsByTagName('script')[0];
      firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

      // 3. This function creates an <iframe> (and YouTube player)
      //    after the API code downloads.
      var player;
      function onYouTubeIframeAPIReady() {
        player = new YT.Player('player', {
          height: '390',
          width: '640',
          videoId: 'M7lc1UVf-VE',
          playerVars: {
            'playsinline': 1
          },
          events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange
          }
        });
      }

      // 4. The API will call this function when the video player is ready.
      function onPlayerReady(event) {
        event.target.playVideo();
      }

      // 5. The API calls this function when the player's state changes.
      //    The function indicates that when playing a video (state=1),
      //    the player should play for six seconds and then stop.
      var done = false;
      function onPlayerStateChange(event) {
        if (event.data == YT.PlayerState.PLAYING && !done) {
          setTimeout(stopVideo, 6000);
          done = true;
        }
      }
      function stopVideo() {
        player.stopVideo();
      }
    </script>
  </body>
</html>


## Setup VS Code for VHDL
Install VHDL extension from the VS Code marketplace 
#### Recommended Extensions: 
![image](https://github.com/user-attachments/assets/f0c666ed-292b-4f0f-9406-d04bd1d81eb2)
![image](https://github.com/user-attachments/assets/b01c1c1c-f8d2-4884-b93e-b0623caf82e4) 
**Note:** Second extension is more advanced. 


## Create the first VHDL program
https://youtu.be/3klKQeY9pII?si=iBLLtT2DBe56PyF-

## Create the testBench, run the first program and analyse the waveform with GTKWave
https://youtu.be/N5kdRets-mc?si=uI3-pO94W8QOHnbV

## Concurrent statements in VHDL
https://youtu.be/hjBp430joQg?si=EdEYl6V8jFVSsV5t
