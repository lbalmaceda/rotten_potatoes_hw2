class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #init the hash
    params[:ratings] ||= Hash.new
    session[:ratings] ||= Hash.new

    p ">>P.ORDER #{params[:order]}"
    p ">>P.RATINGS #{params[:ratings]}"
    p ">>S.ORDER #{session[:order]}"
    p ">>S.RATINGS #{session[:ratings]}"
    
    @all_ratings = Movie.all_ratings
    session[:order] = params[:order]

    if params[:ratings].value?("1")
      #at least 1 checked checkbox.
      session[:ratings] = params[:ratings]
      @movies = Movie.where(:rating=>params[:ratings].keys)
    elsif session[:ratings].value? ("1")
      flash.keep
      redirect_to movies_path(:ratings => session[:ratings], :order => session[:order])
     # @movies = Movie.where(:rating=>session[:ratings].keys)
    else
      @movies = Movie.all
    end

    if @movies 
      if (params[:order]=="release_date")
        @movies = @movies.order("release_date ASC")
      elsif (params[:order]=="title")
        @movies = @movies.order("title ASC")
      end
    end
    
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
