<style>
    .container {
        /* Never limit the container height here */
        max-width: 100%;
        max-height: 300px;
    }
</style>

<script>
  import { onMount } from "svelte";
  import Cropper from "cropperjs";

  export let file;
  let canvas;

  export let thumbX = 0;
  export let thumbY = 0;
  export let thumbSize = 0;

  onMount(async () => {
    const reader = new FileReader();
    reader.readAsDataURL(file);

    reader.onloadend = function (e) {
      let image = new Image();
      image.src = reader.result;

      image.onload = function () {
        canvas.width = image.width;
        canvas.height = image.height;
        const ctx = canvas.getContext("2d");
        ctx.drawImage(image, 0, 0);

        const cropper = new Cropper(canvas, {
          aspectRatio: 1,
          viewMode: 1,
          zoomable: false,
          crop(event) {
            thumbX = Math.round(event.detail.x);
            thumbY = Math.round(event.detail.y);
            thumbSize = Math.round(event.detail.width);
          },
        });
      };
    };
  });
</script>

<div>
  <div class="container">
      <canvas bind:this="{canvas}"></canvas>
  </div>
</div>
