class Movie < ActiveRecord::Base
  def self.with_ratings(ratings_list)
    if ratings_list.present?  # Check if ratings_list is not nil/empty
      Movie.where(rating: ratings_list)  # Filter by ratings in the list
    else
      Movie.all  # Retrieve all movies
    end
  end
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']  # Define all possible rating values
  end
end