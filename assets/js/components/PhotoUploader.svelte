<style>
  #drop-area {
    border: 2px dashed #ccc;
    border-radius: 20px;
    width: 480px;
    font-family: sans-serif;
    margin: 50px auto;
    padding: 20px;
  }

  #drop-area.highlight {
    border-color: purple;
  }

  p {
    margin-top: 0;
  }

  #svelte-input {
    display: none;
  }
</style>

<script>
  import PhotoCropper from "./PhotoCropper.svelte";
  import TrashIcon from "./icons/Trash.svelte";
  import LoaderSvg from "./icons/Loader.svelte";
  import CheckMarkSvg from "./icons/CheckMark.svelte";

  let overed = false;
  /**
   * Photo
   * @type {{description: String, featured: Boolean, file: Object}[]}
   */
  let photoList = [];
  let uploadPromise;

  $: console.log("promise: ", uploadPromise);

  const uploadPhoto = (photo) => {
    const albumId = document.getElementById("album-id").value;
    console.log("uploadPhoto: ", photo);
    const url = "http://localhost:4000/api/photoupload";
    const formData = new FormData();

    formData.append("image", photo.file);
    formData.append("description", photo.description);
    formData.append("featured", photo.featured);
    formData.append("thumb_x", photo.thumbX);
    formData.append("thumb_y", photo.thumbY);
    formData.append("thumb_size", photo.thumbSize);
    formData.append("album_id", albumId);

    return fetch(url, {
      method: "POST",
      body: formData,
    })
      .then((response) => response.json())
      .then((data) => console.log(data))
      .catch((e) => {
        console.log("error: ", e);
      });
  };

  const handleUpload = () => {
    console.log("handleUpload: ", photoList);

    uploadPromise = Promise.all(photoList.map(uploadPhoto));
  };

  const handleFileInputChange = (event) => {
    const files = event.target.files;
    const photos = Array.from(files).map((file) => ({
      description: "",
      featured: false,
      file,
    }));
    photoList = [...photoList, ...photos];
  };

  const handleDragOver = () => {
    overed = true;
  };

  const handleDrop = (event) => {
    console.log("drop");
    overed = false;

    const files = event.dataTransfer.files;
    const photos = Array.from(files).map((file) => ({
      description: "",
      featured: false,
      file,
    }));
    photoList = [...photoList, ...photos];
  };

  const handleRemove = (fileName) => {
    photoList = photoList.filter((photo) => photo.file.name !== fileName);
  };
</script>

<div class="mb-4">
  <div
    id="drop-area"
    class:highlight="{overed === true}"
    on:dragenter|preventDefault|stopPropagation="{handleDragOver}"
    on:dragover|preventDefault|stopPropagation="{handleDragOver}"
    on:dragleave|preventDefault|stopPropagation="{() => (overed = false)}"
    on:drop|preventDefault|stopPropagation="{handleDrop}"
  >
    <p class="text-center">
      Upload multiple files with the file dialog or by dragging and dropping
      images into the dashed region
    </p>
    <label
      for="svelte-input"
      class="block border border-blackcurrant-500 rounded p-2 mt-4 flex text-xl
      justify-center items-center hover:bg-blackcurrant-500
      hover:text-blackcurrant-100"
    >
      Select some files
    </label>
    <input
      type="file"
      id="svelte-input"
      accept="image/*"
      multiple
      on:change="{handleFileInputChange}"
    />
  </div>

  <ul class="mb-8">
    {#each photoList as photo (photo.file.name)}
      <li class="flex border-b border-blackcurrant-500">
        <div class="w-1/2 p-4">
          <PhotoCropper
            file="{photo.file}"
            bind:thumbX="{photo.thumbX}"
            bind:thumbY="{photo.thumbY}"
            bind:thumbSize="{photo.thumbSize}"
          />
        </div>

        <div class="w-1/2 flex flex-col p-4">
          <div class="flex justify-end">
            <button
              type="button"
              on:click="{() => handleRemove(photo.file.name)}"
              class="bg-transparent hover:bg-red-500 text-red-500
              hover:text-white border border-red-500 hover:border-transparent
              rounded p-2 flex items-center justify-center"
            >
              <TrashIcon className="fill-current inline-block h-4 w-4" />
            </button>
          </div>

          <label
            class="block uppercase tracking-wide text-blackcurrant-400 text-xs
            font-bold mb-3"
          >
            Description:
            <input
              placeholder="Small description of the photo"
              bind:value="{photo.description}"
              class="shadow appearance-none border border-blackcurrant-500
              rounded w-full py-4 px-3 blackcurrant-500 mt-2 leading-tight"
            />
          </label>

          <label class="md:w-2/3 block text-blackcurrant-400 font-bold mb-3">
            <input
              class="mr-2 leading-tight"
              type="checkbox"
              bind:checked="{photo.featured}"
            />
            <span class="text-sm">Featured?</span>
          </label>

          <div
            class="mb-3 {photo.thumbSize < 500 ? 'text-red-500' : 'text-blackcurrant-500'}"
            class:text-red-500="{photo.thumbSize < 500}"
          >
            Size: {photo.thumbSize}
          </div>
        </div>
      </li>
    {/each}
  </ul>

  {#if uploadPromise}
    {#await uploadPromise}
      <button
        type="button"
        class="flex justify-center border border-blackcurrant-500 rounded p-4
        w-48"
        disabled
      >
        <LoaderSvg className="fill-current text-blackcurrant-500 h-8 w-8" />
      </button>
    {:then upload}
      <button
        type="button"
        class="flex justify-center items-center border border-green-500 rounded
        p-4 w-48"
        disabled
      >
        <CheckMarkSvg className="fill-current text-green-700 h-8 w-8 mr-4" />
        <span class="text-green-700">Success</span>
      </button>
    {:catch error}
      <p style="color: red">{error.message}</p>
      <button
        type="button"
        on:click="{handleUpload}"
        class="border border-blackcurrant-500 rounded p-4
        hover:bg-blackcurrant-500 hover:text-blackcurrant-100"
      >
        Upload photos
      </button>
    {/await}
  {:else if photoList.length}
    <button
      type="button"
      on:click="{handleUpload}"
      class="border border-blackcurrant-500 rounded p-4
      hover:bg-blackcurrant-500 hover:text-blackcurrant-100"
    >
      Upload photos
    </button>
  {/if}
</div>
