module YamsCore
  module FormHelper

    include Rails.application.routes.url_helpers

    # Create an icon tag with text, placed either before or after the icon
    def icon_tag(icon, text: nil, text_front: true)
      icon = "<i class=\"icon_tag #{icon}\"></i>"
      if text_front
        raw("#{text} #{icon}")
      else
        raw("#{icon} #{text}")
      end
    end

    # Text then icon
    def back_icon_tag(icon, text: nil)
      icon_tag(icon, text: text, text_front: false)
    end

    # TODO - paperclip[ had nice support for different sizes, bit broken by switch to Actrive Storage
    # - how to mimic thumbs via variants ?? e.g rails_representation_path(track.cover_image.variant(resize: '120x120'))

    def cover_image_tag(cover, size: :thumb, css: 'img-fluid rounded')
      if cover.attached?
        view.image_tag(rails_blob_url(cover.image, only_path: true), class: css)
      else
        default = DefaultCover.for_track
        view.image_tag(rails_blob_url(default.image), class: css) if default.attached?
      end
    end

    # icon represents complete deletion from system
    #
    def delete_icon(model, text: nil, html_options: {})
      options = { method: :delete, remote: true, id: "delete-icon-#{model.class}-#{model.id}", data: { confirm: I18n.t(:delete_confirm, scope: :global) } }

      path = polymorphic_path([view.yams_core, model])

      if text
        view.link_to back_icon_tag('icon-trash', text: text), path, options.merge(html_options)
      else
        view.link_to icon_tag('icon-trash'), path, options.merge(html_options)
      end
    end

    # icon represents removal of an item only from a list - item remains in DB, i.e not deletion of that item from system
    #
    def remove_icon(model, text: nil, confirm: I18n.t(:remove_confirm, scope: :global), html_options: {})
      options = { method: :delete, remote: true, id: "delete-icon-#{model.class}-#{model.id}", data: { confirm: confirm } }

      path = polymorphic_path([yams_core, model])

      if text
        link_to back_icon_tag('icon-circle-with-cross', text: text), path, options.merge(html_options)
      else
        link_to icon_tag('icon-circle-with-cross'), path, options.merge(html_options)
      end
    end

    def edit_icon(model, text: nil, html_options: {})
      options = { id: "edit-icon-#{model.class}-#{model.id}" }

      path = polymorphic_path([view.yams_core, model], action: :edit)

      if text
        view.link_to back_icon_tag('icon-pencil', text: text), path, options.merge(html_options)
      else
        view.link_to icon_tag('icon-pencil'), path, options.merge(html_options)
      end
    end

    def custom_file_field(form, field, label, options: {}, additional: nil, content_for_label: nil)
      id = form.object.class.name.downcase + "-#{form.object.id}-file-input"

      content = raw "<label for='#{id}'>#{label}#{content_for_label}<i class='icon_tag icon-upload-to-cloud'></i></label>"

      content += content_tag(:span, additional, class: 'pl-1') if additional
      content += form.file_field(field, id: id, options: options)

      content_tag(:div, content, class: 'audio-upload')
    end

    def avatar_image_tag(user, html_options: { class: 'avatar avatar-lg' })
      if user.avatar.try(:attached?)
        image_tag(rails_blob_url(user.avatar), html_options)
      else
        default = DefaultCover.for_user
        Rails.logger.error('Default Cover missing for User') unless default
        image_tag(rails_blob_url(default.image), html_options) if default.try(:image)
      end
    end

  end
end
