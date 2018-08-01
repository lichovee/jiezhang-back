class Api::IconController < Api::ApiController
  def assets
    render json: asset.each_slice(40)
  end

  def categories
    render json: category.each_slice(40)
  end

  private

  ['asset', 'category'].each do |method|
    define_method method do
      key = "@#{method}icon_list#{current_user.id}@"
      cache = Rails.cache.read(key)
      return cache if cache.present?

      assets = []
      if File.directory?(file_path(method))
        Dir.foreach(file_path(method)) do |file|
          if file != "." && file != ".."
            assets << "/images/#{method}/#{file}"
          end
        end
      end
      Rails.cache.write(key, assets, expires_in: 7.days)
      assets
    end
  end

  def file_path(dir)
    Rails.public_path.join('images', dir)
  end

end