class LottosController < ApplicationController
  before_action :set_lotto, only: [:show, :edit, :update, :destroy]

  # GET /lottos
  # GET /lottos.json
  def index
    @lottos = Lotto.all
    if current_user && current_user.admin?
      Lotto.all
    else
      redirect_to user_session_path
    end
    
  end

  # GET /lottos/1
  # GET /lottos/1.json
  def show
    @result = @lotto.result
    @array = (1..@lotto.totalnum.to_i).to_a   
    
    #[index]를 +3씩 해줘야함 create액션 주석참고
    @firstwinner = Voter.find_by(id: @result[1].to_i).attributes.slice('studentid').to_s.gsub('{"studentid"=>','').gsub('}','')
    @secondwinner = Voter.find_by(id: @result[4].to_i).attributes.slice('studentid').to_s.gsub('{"studentid"=>','').gsub('}','')
    @thirdwinner = Voter.find_by(id: @result[7].to_i).attributes.slice('studentid').to_s.gsub('{"studentid"=>','').gsub('}','')
    @fourthwinner = Voter.find_by(id: @result[10].to_i).attributes.slice('studentid').to_s.gsub('{"studentid"=>','').gsub('}','')
    @fifthwinner = Voter.find_by(id: @result[13].to_i).attributes.slice('studentid').to_s.gsub('{"studentid"=>','').gsub('}','')


    ## 테스트코드..
    auto_arrays = Array.new
    while auto_arrays.size < @lotto.winnum
      auto_arrays << @array.sample
    end
    auto_arrays.uniq!

    @auto_array = auto_arrays

    #for n in 0..@lotto.winnum.to_i
    #  instance_variable_set "@lot_#{n}" , @array.sample
    #end   

   
  end

  # GET /lottos/new
  def new
    @lotto = Lotto.new
  end

  # GET /lottos/1/edit
  def edit
  end

  # POST /lottos
  # POST /lottos.json
  def create
    @lotto = Lotto.new(lotto_params)
    @array = (1..@lotto.totalnum.to_i).to_a
  
  # 추첨배열을 저장, 대신 string으로 저장된다. index주의
    @lotto.result = @array.sample(5).sort
    #@lotto.result =@array.sample(@lotto.winnum.to_i).sort

  # 당첨자를 저장 xxx
   # @result = @array.sample(5).sort.to_a
   # @lotto.firstwinner = Voter.find_by(id: @result[1].to_i).attributes.slice('studentid').to_s.gsub('{"studentid"=>','').gsub('}','')

  ## 테스트코드..
    auto_arrays = Array.new
    while auto_arrays.size < @lotto.winnum
      auto_arrays << @array.sample
    end
    auto_arrays.uniq!
   
    @auto_array = auto_arrays

    respond_to do |format|
      if @lotto.save
        format.html { redirect_to @lotto, notice: 'Lotto was successfully created.' }
        format.json { render :show, status: :created, location: @lotto }
      else
        format.html { render :new }
        format.json { render json: @lotto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lottos/1
  # PATCH/PUT /lottos/1.json
  def update
    respond_to do |format|
      if @lotto.update(lotto_params)
        format.html { redirect_to @lotto, notice: 'Lotto was successfully updated.' }
        format.json { render :show, status: :ok, location: @lotto }
      else
        format.html { render :edit }
        format.json { render json: @lotto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lottos/1
  # DELETE /lottos/1.json
  def destroy
    @lotto.destroy
    respond_to do |format|
      format.html { redirect_to lottos_url, notice: 'Lotto was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lotto
      @lotto = Lotto.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def lotto_params
      params.require(:lotto).permit(:totalnum, :winnum, :result, :firstwinner, :resultnum)
    end
end
