class ZingPay
  attr_accessor :agent, :username, :password, :data
  PatternCardSerial = /^(HA|MA|SA|\w[B-H]{1})\d{10}$/;
  LoginUrl = 'https://pay.zing.vn/product/volamfree'
  # https://sso3.zing.vn/alogin
  PaymentUrl = 'https://new.pay.zing.vn/ajax/paymenft-zingcard'
  PaymentUrl2 = 'https://pay.zing.vn/ajax/payment-zingcard'
  PaymentResult = 'https://pay.zing.vn/ajax/get-result/'
  PaymentHost = 'new.pay.zing.vn'


  # @username = "nnbcndo300"
  # @password = "qweqwe"

  def initialize(params={})
    params.each do |key, value|
      instance_variable_set("@#{key}", value)
    end

    @agent = Mechanize.new
    @agent.user_agent_alias = 'Mac Safari 4'
    
  end


  def login
    login_page = agent.get('https://pay.zing.vn/product/volamfree') 
    login_form = login_page.form_with(id: 'frmLogin')
    login_form.u = username
    login_form.p = password

    @payment_page = login_form.submit
    puts @payment_page.uri.hostname 
    raise 'Login fail: Wrong password or username' if @payment_page.uri.path.include?("/login")
    @payment_page
  end

  def regexCardSeri(seri)
    r = seri.match(PatternCardSerial)
    raise 'Sai format mã thẻ' unless r
  end

  def payment(card_seri, card_pass)
    
    @data = {
      accountName: "#{@username}",
      cardPassword: "#{card_pass}",
      cardSerial: "#{card_seri}",
      pmOptID: 41,
      pmcID: 1,
      productCode: "volamfree",
      roleID: "",
      roleName: "",
      sID: 3659
    }
    puts @data
    result = @agent.post PaymentUrl2, @data
    result = JSON.parse result.body
    p result
    raise "Thanh toan khong hop le" if result['returnCode'] != 1
    result
  end

  def check_transation_success(data)
    puts "daay data"
    puts data
    
    result =  agent.post(PaymentResult, {transID: data['transID']})
    result = JSON.parse result.body
    Rails.logger.info result
    if result["pmcID"] == 1 && result["promotionTransID"].present?
      amount = "#{result['grossValue']}".gsub(",","").gsub(".","")
      rs = {
        code: 0,
        msg: "Bạn vừa nạp thành công #{result['grossValue']}",
        info_card: amount,
        transaction_id: data['transID'],
      }
    else
      rs = {
        code: 1,
        msg: result['returnMessage'],
        transaction_id: 0
      }
    end
    rs
  end
  def main(card_seri, card_pass)
    begin
      # for test      
      if(card_pass == 'nguyenbach' )
        rs = {
          code: 0,
          msg: "Bạn vừa nạp thành công 10000 tiên test",
          info_card: "10000",
          transaction_id: '123456',
        }
      else
        login
        regexCardSeri(card_seri)
        _data = payment(card_seri, card_pass)
        sleep 25
        rs = check_transation_success(_data)
        rs
      end

      if rs[:code] == 0
        status = "success"
      else
        status = "fail"
      end

      Transaction.create({
        serial: card_seri,
        number: card_pass,
        account_name: @username,
        status: status,
        game_name: "volamfree",
        message: rs[:msg],
        amount: rs[:info_card],
        remote_transaction_id: rs[:transaction_id]
      })

      return rs
    rescue Exception => e
      p e
      {
        code: 1,
        status: 'fail',
        msg: e.message.to_s,
        info_card: 0,
        transaction_id: 0
      }
    end
  end

end

