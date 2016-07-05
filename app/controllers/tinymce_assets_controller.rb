class TinymceAssetsController < ApplicationController
  def create
    # Take upload from params[:file] and store it somehow...
    @datafile = Photo.create(:data => params[:file].read,:name=>params[:file].original_filename ,:filename => params[:file].original_filename,:mime_type=>params[:file].content_type,:photable_type=>'Post') if !params[:file].blank?
    render json: {
      image: {
        url: @datafile.file.url(:medium)
      }
    }, content_type: "text/html"
  end
end
