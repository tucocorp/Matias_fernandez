class CommentsController < ApplicationController
  before_filter :set_data, except: [:destroy]

  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      respond_to do |format|
        format.html do
          flash[:success] = 'El comentario se ha creado exitosamente.'
          redirect_to @redirect_to
        end

        format.json { render json: @comment }
      end
    else
      respond_to do |format|
        format.html do
          flash[:danger] = 'Hubo problemas al crear un mensaje.'
          render 'new'
        end

        format.json { render json: { errors: @comment.errors } }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])

    if @comment.destroy
      respond_to do |format|
        format.json { render nothing: true, status: 204 }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @comment.errors } }
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(
      :content, :commentable_id, :commentable_type
    )
  end

  def set_data
    klass = comment_params[:commentable_type]
    @commentable = klass.classify.constantize.find(comment_params[:commentable_id])
    @redirect_to = params[:redirect_to]
  end
end
