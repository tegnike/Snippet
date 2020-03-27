class Api::V1::SnippetsController < ApiController
  before_action :set_snippet, only: [:show, :update, :destroy]

  # 拾えなかったExceptionが発生したら500 Internal server errorを応答する
  rescue_from Exception, with: :render_status_500

  # ActiveRecordのレコードが見つからなければ404 not foundを応答する
  rescue_from ActiveRecord::RecordNotFound, with: :render_status_400

  def index
    snippets = Snippet.all
    render json: snippets
  end

  def show
    render json: @snippet
  end

  def create
    snippet = Snippet.new(snippet_params)
    if snippet.save
      render json: snippet, status: :created
    else
      render json: { errors: snippet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @snippet.update_attributes(snippet_params)
      head :no_content
    else
      render json: { errors: @snippet.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @snippet.destroy!
    head :no_content
  end

  private

    def set_snippet
      @snippet = Snippet.find(params[:id])
    end

    def snippet_params
      params.fetch(:snippet, {}).permit(:title, :language, :contents)
    end

    def render_status_404(exception)
      render json: { errors: [exception] }, status: 404
    end

    def render_status_500(exception)
      render json: { errors: [exception] }, status: 500
    end
end
