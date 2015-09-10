module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?


    render partial: 'devise/error_messages',
           locals: {messages: resource.errors.full_messages,
                    sentence: resource_error_sentence(resource)}
  end

  private

  def resource_error_sentence(resource)
    I18n.t('errors.messages.not_saved',
           count: resource.errors.count,
           resource: resource.class.model_name.human.downcase)
  end
end
