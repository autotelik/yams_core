# frozen_string_literal: true

module YamsCore
  class PlaylistPresenter < YamsCore::Presenter

    def initialize(playlist, view)
      super(playlist, view)
    end

    def bootstrap_actions_dropdown(except: [])
      except_list = *except

      html = <<-EOS
    <div class="dropdown">
      <button class="btn btn-dropdown dropdown-toggle btn-dropdown-toggle-no-arrow" type="button" id="dropdownMenuButton-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="icon-dots-three-horizontal"></i>
      </button>
      <div class="dropdown-menu dropdown-menu-sm" aria-labelledby="dropdownMenuButton">
        #{view.link_to back_icon_tag('icon-pencil', text: I18n.t(:edit, scope: :global)), view.yams_core.edit_playlist_path(playlist), { id: "edit-icon-#{model.class}-#{model.id}", class: 'dropdown-item' }  unless except_list.include? :edit}
        <div class="dropdown-divider"></div>
        #{delete_icon(model, text: 'Delete', html_options: { class: 'dropdown-item' }) unless except_list.include? :delete}
      </div>
    </div>
      EOS
      raw(html)
    end

    def cover_image(size: :thumb)
      # Use first Track's cover if possible
      return YamsCore::TrackPresenter.new(playlist_tracks.first.track, view).cover_image(size: size) if playlist_tracks.present?
      DefaultCover.for_playlist.try(:image)
    end

    alias_method :playlist, :model

  end
end
