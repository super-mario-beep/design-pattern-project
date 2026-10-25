class PhotosController < ApplicationController
  allow_unauthenticated_access only: %i[ show file thumbnail ]
  before_action :set_photo, except: %i[ new create ]
  before_action :require_manage_permission, only: %i[ edit update destroy ]
  helper_method :can_manage?

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
  end

  def edit
  end

  def update
    changes = params.expect(photo: [ :description, :hashtag_list ])

    if @photo.update(changes)
      EventBus.publish("photo.updated", user: Current.user, subject: @photo, details: changes.to_h)
      redirect_to @photo, notice: "Photo updated."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @photo.destroy
    EventBus.publish("photo.deleted", user: Current.user, subject: @photo,
      details: { owner: @photo.user.name, description: @photo.description })
    redirect_to root_path, notice: "Photo deleted."
  end

  def file
    send_data StorageAdapter.current.read(@photo.storage_key),
      type: Marcel::MimeType.for(extension: @photo.format), disposition: :inline
  rescue StorageAdapter::FileNotFound
    head :not_found
  end

  def thumbnail
    Tempfile.create([ "photo", ".#{@photo.format}" ], binmode: true) do |source|
      source.write(StorageAdapter.current.read(@photo.storage_key))
      source.flush
      thumbnail = FormatFilter.new(ResizeFilter.new(OriginalImage.new(source), 480, 480), "jpg").process
      expires_in 1.year, public: true
      send_data File.binread(thumbnail.path), type: "image/jpeg", disposition: :inline
    ensure
      thumbnail&.close!
    end
  rescue StorageAdapter::FileNotFound
    head :not_found
  end

  private
    def set_photo
      @photo = Photo.find(params[:id])
    end

    def can_manage?(photo)
      current_user.present? && (photo.user_id == current_user.id || current_user.admin?)
    end

    def require_manage_permission
      redirect_to @photo, alert: "You can only change your own photos." unless can_manage?(@photo)
    end
end
