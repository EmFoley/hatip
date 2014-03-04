class TipsController < ApplicationController
  def create
  	order = params['order']
  	custom_info = eval(order['custom']) # results in hash
  	user = User.find(custom_info[:user_id])

    tip_info = {
    	coinbase_id: 			order['id'],
      post_id: 					custom_info[:post_id],
      fiat_iso: 				order['total_native']['currency_iso'],
      fiat_cents: 			order['total_native']['cents'],
      crypto_iso: 			order['total_btc']['currency_iso'],
      crypto_cents: 		order['total_btc']['cents'],
      tx_hash: 					order['transaction']['hash'],
      tx_id: 						order['transaction']['id'],
      status: 					order['status'],
      receive_address: 	order['receive_address']
    }
    puts tip_info

    tip = Tip.create(tip_info)
    user.tips << tip
    render json: { success: "success" }
  end

  def create_stripe_tip
    Stripe.api_key = "sk_test_BQokikJOvBiI2HlWgH4olfQ2"
    # Get the credit card details submitted by the form
    token = params[:stripe_token][:id]
    email = params[:email]
    amount = params[:amount]
    user_id = params[:id]

    # Create the charge on Stripe's servers - this will charge the user's card
    begin
      charge = Stripe::Charge.create(
        :amount => amount, # amount in cents, again
        :currency => "usd",
        :card => token,
        :description => email
      )
      User.find(user_id).tips.create(fiat_cents: amount, stripe_email: email, stripe_token: token)
      render json: { success: "success" }
    rescue Stripe::CardError => e
      puts e
      render json: { error: "error" }
    end
  end
end


###################
# Coinbase callback data looks like this:

# {"order"=>
	# {	"id"=>"ATNON22I",
	# 	"created_at"=>"2014-03-01T16:46:37-08:00",
	# 	"status"=>"completed",
	# 	"total_btc"=>
	# 		{
	# 	  	"cents"=>43650,
	# 	   	"currency_iso"=>"BTC"
	# 		},
	# 	"total_native"=>

	# 		{
	# 			"cents"=>25,
	# 			"currency_iso"=>"USD"
	# 		},
	# 	"custom"=>"#user{ self.user.id }-post{ self.id }",
	# 	"receive_address"=>"1JVPjWF9igFFzSdYCSegpWZX2XdJv3p945",
	# 	"button"=>
	# 		{
	# 			"type"=>"donation",
	# 			"name"=>"Tip for Alicia Hartmann",
	# 			"description"=>"Tip",
	# 			"id"=>"f6b64e664a9d6c05d5d236f301d560dc"
	# 			},
	# 	"transaction"=>
	# 			{
	# 				"id"=>"5312800a4ed082d08a0045ea",
	# 			"hash"=>"6c7e54414d613d5a0323bfa0caa93b232ce2a1fea1bbcc94630e860db5c805c4",
	# 			"confirmations"=>0
	# 		}
	# },
	# "action"=>"create",
	# "controller"=>"tips",
	# "tip"=>{}
# }