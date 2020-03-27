class Api::V1::SnippetsController < ApiController
  before_action :set_snippet, only: [:show]

  # ActiveRecordのレコードが見つからなければ404 not foundを応答する
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: { error: '404 not found' }, status: 404
  end

  def index
    snippets = Snippet.all
    render json: snippets
  end

  def show
    render json: @snippet
  end

  private

    def set_snippet
      @snippet = Snippet.find(params[:id])
    end
end
