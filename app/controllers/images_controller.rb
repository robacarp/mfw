class ImagesController < ApplicationController
  def index
    @random_image = Image.rand
  end

  def show
    @random_image = Image.find params[:id]
    render :index
  end

  def update
    @random_image = Image.find params[:id]
    @random_image.update(image_params)

    redirect_to @random_image
  end

  private
  def image_params
    params.require(:image).permit(:tag_group)
  end
end
