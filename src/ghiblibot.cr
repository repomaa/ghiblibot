require "mastodon"
require "yaml"

module Ghiblibot
  VERSION = "0.1.0"

  struct Movie
    include YAML::Serializable

    getter title : String
    getter id : String
  end

  IMAGES = Dir["images/*.jpg"]
  MOVIES = File.open("movies.yml") { |f| Hash(String, Movie).from_yaml(f) }

  client = Mastodon::REST::Client.new(
    url: ENV["MASTODON_URL"],
    access_token: ENV["ACCESS_TOKEN"],
  )

  image_file = IMAGES.sample
  movie = MOVIES[File.basename(image_file)[/.+(?=\d{3})/]]
  message = String.build do |builder|
    builder << "From the movie “" << movie.title << "”"
    builder.puts
    builder << "https://www.themoviedb.org/movie/" << movie.id
  end

  image = client.media_upload(image_file)
  client.create_status(message, media_ids: [image.id])
end
