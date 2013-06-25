class CombineItemsInCart < ActiveRecord::Migration
  def self.up
     # replace multiple items for a single product in a cart with a single item
     Cart.all.each do |cart|
       # count the number of each product in the cart
       items = LineItem.sum(:quantity, :conditions=>{:cart_id=>cart.id},
                            :group=>:product_id)
  
       items.each do |product, quantity|
         if quantity > 1
           # remove individual items
           LineItem.delete_all :cart_id=>cart.id, :product_id=>product
  
           # replace with a single item
           LineItem.create :cart_id=>cart.id, :product_id=>product,
                           :quantity=>quantity
         end
       end
     end
   end
  
   def self.down
     # split items with quantity>1 into multiple items
     LineItem.find(:all, :conditions => "quantity>1").each do |li|
       # add individual items
       li.quantity.times do 
         LineItem.create :cart_id=>li.cart_id, :product_id=>li.product_id,
                         :quantity=>1
       end
  
       # remove original item
       li.destroy
     end
   end
 end