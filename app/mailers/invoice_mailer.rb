class InvoiceMailer < ApplicationMailer
  def invoice_email_admin
    @order = params[:order]

    I18n.with_locale(I18n.locale) do
      mail(
        to: "atieethatie@gmail.com",
        subject: t(".subject"),
        reply_to: "atieethatie@gmail.com"
      )
    end
  end

  def invoice_email_customer
    @order = params[:order]

    I18n.with_locale(I18n.locale) do
      mail(
        to: params[:order].email,
        subject: t(".subject"),
        reply_to: "atieethatie@gmail.com"
      )
    end
  end
end
