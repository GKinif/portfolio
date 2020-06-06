const baseUrl =
  process.env.NODE_ENV === "production"
    ? "https://www.guillaumekinif.be"
    : "http://localhost:4000";

export const uploadPhoto = (photo) => {
  const albumId = document.getElementById("album-id").value;
  const url = `${baseUrl}/api/photoupload`;
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
    .then((response) => response.json());
};
