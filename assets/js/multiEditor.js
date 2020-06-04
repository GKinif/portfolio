import Cropper from "cropperjs";
import "cropperjs/dist/cropper.min.css";
import '../css/adminPhoto.scss';

import "./photoDropper";

let fileInput = document.getElementById("file-input");

if (fileInput) {
  fileInput.addEventListener("change", function (ev) {
    if (ev.target.files) {
      console.log("files: ", ev.target.files);
      const file = ev.target.files[0];
      const reader = new FileReader();

      reader.readAsDataURL(file);

      reader.onloadend = function (e) {
        let image = new Image();
        image.src = e.target.result;

        image.onload = function (ev) {
          const canvas = document.getElementById("canvas");
          const inputX = document.getElementById("thumb-x");
          const inputY = document.getElementById("thumb-y");
          const inputSize = document.getElementById("thumb-size");
          const xDisplay = document.getElementById("x-display");
          const yDisplay = document.getElementById("y-display");
          const sizeDisplay = document.getElementById("size-display");
          canvas.width = image.width;
          canvas.height = image.height;
          const ctx = canvas.getContext("2d");
          ctx.drawImage(image, 0, 0);

          const cropper = new Cropper(canvas, {
            aspectRatio: 1,
            zoomable: false,
            crop(event) {
              inputX.value = Math.round(event.detail.x);
              inputY.value = Math.round(event.detail.y);
              inputSize.value = Math.round(event.detail.width);

              xDisplay.innerText = Math.round(event.detail.x);
              yDisplay.innerText = Math.round(event.detail.y);
              sizeDisplay.innerText = Math.round(event.detail.width);

              if (Math.round(event.detail.width) < 500) {
                sizeDisplay.classList.add("text-red-500");
              } else {
                sizeDisplay.classList.remove("text-red-500");
              }
            },
          });
        };
      };
    }
  });
}

/*Dropzone.options.photoDropzone = {
  url: 'fake-url',
  autoQueue: false,
  autoProcessQueue: false,
  addRemoveLinks: true,
  hiddenInputContainer: '#file-input'
};*/

import App from './components/PhotoUploader.svelte';

new App({
  target: document.getElementById('svelte-container'),
});
