class Administrator < ActiveRecord::Base
   
   attr_accessible :adminPw, :adminEmail
   
   validates :adminEmail, :email => true

end