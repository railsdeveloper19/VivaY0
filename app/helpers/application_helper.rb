module ApplicationHelper
  def paypal_url(return_url) 
    values = { 
    :business => 'railsdeveloper19@gmail.com',
        :cmd => '_cart',
    :upload => 1,
    :return => return_url,
    }   
    values.merge!({ 
    "amount_1" => '100',
    "item_name_1" => 'Donation',
    "item_number_1" => 'MO-675',
    "quantity_1" => '1'
    })
         # For test transactions use this URL
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end 
end
