defmodule Portfolio.Uploaders.AlbumCoverUploader do
  use Waffle.Definition

  # Include ecto support (requires package waffle_ecto installed):
  use Waffle.Ecto.Definition

  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  @versions [:original, :thumb]

  # To add a thumbnail version:
  # @versions [:original, :thumb]

  # Override the bucket on a per definition basis:
  # def bucket do
  #   :custom_bucket_name
  # end

   # Whitelist file extensions:
  def validate({file, _}) do
    file_extension = file.file_name |> Path.extname() |> String.downcase()
    Enum.member?(@extension_whitelist, file_extension)
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 500x500^ -gravity center -extent 500x500 -format jpg -limit area 10MB -limit disk 100MB", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, scope) do
    {_image, schema} = scope
    "#{schema.id}_#{version}"
  end

  # Override the storage directory:
   def storage_dir(_version, {_file, schema}) do
     "uploads/albums/#{schema.id}/cover"
   end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: MIME.from_path(file.file_name)]
  # end
end
