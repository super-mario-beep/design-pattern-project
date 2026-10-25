class PhotosController < ApplicationController
  allow_unauthenticated_access only: %i[ show file ]

  def new
    @upload = {}
  end

  def create
    @upload = params.fetch(:photo, {}).permit(:file, :description, :hashtags, :resize_width, :resize_height, :sepia, :blur, :format)

    if @upload[:file].blank?
      flash.now[:alert] = "Choose a photo to upload"
      return render :new, status: :unprocessable_content
    end

    result = PhotoUploadService.new(Current.user).upload(
      @upload[:file],
      description: @upload[:description],
      hashtags: @upload[:hashtags],
      options: @upload.slice(:resize_width, :resize_height, :sepia, :blur, :format)
    )

    if result.photo
      redirect_to result.photo, notice: "Photo uploaded."
    else
      flash.now[:alert] = result.error
      render :new, status: :unprocessable_content
    end
  end

  def show
    @photo = Photo.find(params[:id])
  end

  def file
    photo = Photo.find(params[:id])
    send_data StorageAdapter.current.read(photo.storage_key),
      type: Marcel::MimeType.for(extension: photo.format), disposition: :inline
  rescue StorageAdapter::FileNotFound
    head :not_found
  end
end
