# frozen_string_literal: true
require 'carrierwave/processing/mini_magick'
class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  IMAGE_EXTENSIONS = %w(jpg jpeg gif png).freeze
  DOCUMENT_EXTENSIONS = %w(exe pdf doc docm xls).freeze # define new if needed here

  def store_dir
    "#{Rails.configuration.attachments_dir}/#{model.id}/original/"
  end

  def url
    "tasks/#{model.task.id}/attachments/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/cache/carrierwave/#{Rails.env}/"
  end

  def extension_white_list
    IMAGE_EXTENSIONS + DOCUMENT_EXTENSIONS
  end

  version :preview, if: :image? do
    process resize_to_fit: [120, 1800]
  end

  version :thumb, if: :image? do
    process resize_to_fill: [35, 35]
  end

  protected

  def image?(new_file)
    new_file&.content_type =~ %r{image\/.*}
  end
end
