class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @user_ratings = []
    @movies = Movie.all.order(params["sort"])
    
    @sort = params[:sort] || session[:sort]
    @ratings = params[:ratings]  || session[:ratings] || @all_ratings
    @movies = Movie.where( { rating: @ratings } ).order(params["sort"])
    session[:sort] = @sort
    session[:ratings] = @ratings

    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      flash.keep
      redirect_to movies_path sort: @sort, ratings: @ratings
    end
    
    if params["ratings"] and params["sort"]
      params[:ratings].each {|rating, checked| @user_ratings << rating}
      @movies = Movie.with_ratings(@user_ratings).order(params["sort"])
      if params["sort"] == 'title'
        @title = 'hilite'
      elsif params["sort"] == 'release_date'
        @release_date = 'hilite'
      end
    elsif params["ratings"]
      params[:ratings].each {|rating, checked| @user_ratings << rating}
      @movies = Movie.with_ratings(@user_ratings)
    elsif params["sort"] == 'title'
      @title = 'hilite'
    elsif params["sort"] == 'release_date'
      @release_date = 'hilite'
    end
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

end
