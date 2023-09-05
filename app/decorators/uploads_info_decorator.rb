module UploadsInfoDecorator
  extend ActiveSupport::Concern
  included do
    def static_info_block
      { 'streaming_statistics' =>

      { duration: duration,
        marking: name,
        other: description,
        send_to: user&.email } }
    end
  end
end
