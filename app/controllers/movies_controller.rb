class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings  # Get all possible ratings from the model
    # If no ratings or sorting params, use session values
    if params[:ratings].nil? && params[:sort].nil?
      @ratings_to_show_hash = session[:ratings] || [] # Use an array for ratings
      @column = session[:sort] || "id"  # Default to id if not set in session
    else    
      @ratings_to_show_hash = (params[:ratings] || session[:ratings] || {}).keys  # Get selected ratings or default to empty
      @column = params[:sort] || "id"  # Default to id if no sorting is specified
      # Update session to persist sorting and filtering preferences
      session[:sort] = @column
      session[:ratings] = @ratings_to_show_hash
    end
    @movies = Movie.with_ratings(@ratings_to_show_hash).order(@column)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

