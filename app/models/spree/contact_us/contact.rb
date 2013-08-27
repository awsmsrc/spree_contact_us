module Spree
  module ContactUs
    class Contact
      include ActiveModel::Conversion
      include ActiveModel::Validations
      extend ActiveModel::Naming

      AVAILABLE_FIELDS = [:email, :address, :body, :message, :name, :telephone, :address, :postcode, :company, :awareness]

      attr_accessor *AVAILABLE_FIELDS

      validates :email,   :format => { :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i },
                          :presence => true
      validates :message, :presence => true
      validates :name,    :presence => true

      def initialize(attributes = {})
        AVAILABLE_FIELDS.each do |attribute|
          self.send("#{attribute}=", attributes[attribute.to_s]) if attributes and attributes.has_key?(attribute)
        end
      end

      def save
        if self.valid?
          Spree::ContactUs::ContactMailer.contact_email(self).deliver
          return true
        end
        return false
      end

      def persisted?
        false
      end
    end
  end
end
