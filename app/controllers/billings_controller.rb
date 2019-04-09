class BillingsController < ApplicationController

def pre_pay
   
  
   
     #Redirige a PayPal

     orders = current_user.orders.where(payed: false)
     total = orders.pluck("price * quantity").sum()
     items = orders.map do |order|
        item = {}
        item[:name] = order.product.name
        item[:sku] = order.id.to_s
        item[:price] = order.price.to_s
        item[:currency] = 'USD'
        item[:quantity] = order.quantity
        item
     end

     # Build Payment object
    @payment = PayPal::SDK::REST::Payment.new({
    :intent =>  "sale",
    :payer =>  {
      :payment_method =>  "paypal" },
    :redirect_urls => {
      :return_url => "http://localhost:3000/billings/execute",
      :cancel_url => "http://localhost:3000/" },
    :transactions =>  [{
      :item_list => {
        :items => items
      },
      :amount =>  {
        :total =>  total,
        :currency =>  "USD" },
      :description =>  "Carrito de compra" }]})

     
      
      if @payment.create

        render json: @payment.to_json

      else
        @payment.error
          
      end
      

   

end


end
