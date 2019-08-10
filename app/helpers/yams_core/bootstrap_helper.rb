# frozen_string_literal: true

module YamsCore
  module BootstrapHelper

    def map_flash_bootstrap( name )
      if name.to_s == 'notice'
        'success'
      elsif name == 'response'
        'info'
      else
        'danger'
      end
    end

    def bootstrap_actions_dropdown(model, except: [])
      html = <<-EOS
    <div class="dropdown">
      <button class="btn btn-sm btn-outline-primary dropdown-toggle dropdown-toggle-no-arrow" type="button" id="dropdownMenuButton-1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        <i class="icon-dots-three-horizontal"></i>
      </button>
      <div class="dropdown-menu dropdown-menu-sm" aria-labelledby="dropdownMenuButton">
        <a class="dropdown-item" href="#">Download</a>
        #{'<a class="dropdown-item" href="#">Share</a>' unless except.include? :delete}
        # TODO - Commentable  #{link_to('Comment', model) unless except.include? :delete}
        <div class="dropdown-divider"></div>
        #{delete_icon(model, text: I18n.t(:delete, scope: :global), html_options: { class: 'dropdown-item' }) unless except.include? :delete}
      </div>
    </div>
      EOS
      raw(html)
    end

    def bootstrap_card_header(heading, width: 10, &block)
      html = <<-EOS
    <div class="card-header">
      <div class="row">
        <div class="col-#{width}">
         <h5 class="text-light">#{heading}</h5>
        </div>
        #{capture(&block) if block_given?}
      </div>
    </div>
      EOS
      raw(html)
    end

    def bootstrap_card_header_edit(heading, edit_path)
      html = <<-EOS
    <div class="card-header">
      <div class="row">
        <div class="col-10">
         <h5 class=".text-light">#{heading}</h5>
        </div>
        <div class="col-2">
          #{link_to icon_tag('icon-pencil', text: I18n.t(:edit, scope: :global), text_front: false), edit_path, class: 'float-right'}
        </div>
      </div>
    </div>
      EOS
      raw(html)
    end

    def bootstrap_submit(form:, text:, css: 'btn btn-block btn-lg float-right')
      content_tag(:div, class: 'form-row form-group float-right') do
        content_tag(:div, class: 'col') do
          form.submit(text, class: css, data: { disable_with: false })
        end
      end
    end

  end
end