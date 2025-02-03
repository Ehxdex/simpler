class TestsController < Simpler::Controller

  def index
    @tests = Test.all
  end

  def create; end

  def show
    @test = Test.find(id: params[:id]) || render(plain: "Not Found")
  end
end
