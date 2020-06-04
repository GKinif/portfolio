const fieldGroupContainer = document.getElementById("field-group-container");
const createRequiredFields = (file, index) => {
  fieldGroupContainer.appendChild();
};

const uploadFile = (file) => {
  let url = "http://localhost:4000/api/photoupload";
  let formData = new FormData();

  formData.append("file", file);

  fetch(url, {
    method: "POST",
    body: formData,
  })
    .then((response) => response.json())
    .then((data) => console.log(data))
    .catch((e) => {
      console.log("error: ", e);
    });
};

const handleFiles = (files) => {
  console.log("files: ", files);
  [...files].forEach(uploadFile);
};

const fileInput = document.getElementById("file-input");
if (fileInput) {
  fileInput.addEventListener("change", (e) => {
    handleFiles(e.target.files);
  });
}

const dropArea = document.getElementById("drop-area");

if (dropArea) {
  ["dragenter", "dragover", "dragleave", "drop"].forEach((eventName) => {
    dropArea.addEventListener(
      eventName,
      (e) => {
        e.preventDefault();
        e.stopPropagation();
      },
      false
    );
  });

  ["dragenter", "dragover"].forEach((eventName) => {
    dropArea.addEventListener(
      eventName,
      () => {
        dropArea.classList.add("highlight");
      },
      false
    );
  });

  [("dragleave", "drop")].forEach((eventName) => {
    dropArea.addEventListener(
      eventName,
      () => {
        dropArea.classList.remove("highlight");
      },
      false
    );
  });

  dropArea.addEventListener(
    "drop",
    (e) => {
      const files = e.dataTransfer.files;

      handleFiles(files);
    },
    false
  );
}
