class CommentsController < ApplicationController
    before_action :require_login, only: %i[create, edit, update, destroy]

    def create
        @commnet = current_user.comments.build(comment_params).save
    end

    def edit 
        @comment = current_user.comments.find(params[:id])
    end

    def update
        @comment = Comemnt.find(parmas[:id])
        @comment.update(comment_update_params)
    end

    def destroy
        @comment = Comment.find(params[:id])
        @comment.destroy!
    end

    private 

    def comment_params
        params.require(:comment).permit(:body).merge(post_id: params[:post_id])
    end

    def comment_update_params
        params.require(:comment).permit(:body)
    end

end
