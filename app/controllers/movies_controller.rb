class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    do_redirect = false
    if not params[:ratings] and session[:ratings]
      do_redirect = true
      params[:ratings] = session[:ratings]
    end
    if not params[:sort_by] and session[:sort_by]
      do_redirect = true
      params[:sort_by] = session[:sort_by]
    end

    if do_redirect
      flash.keep
      redirect_to movies_path + "?" + params.to_query
    end
    
    if params[:ratings]
      rating_filter = params[:ratings].select {|k,v| v == '1'}.keys
    else
      rating_filter = @all_ratings
    end

    session[:ratings] = params[:ratings]
    session[:sort_by] = params[:sort_by]

    @movies = Movie.where(rating: rating_filter).order(params[:sort_by])
    @params = params
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
