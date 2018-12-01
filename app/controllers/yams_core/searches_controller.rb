# frozen_string_literal: true

module YamsCore
  class SearchesController < ApplicationController

    def show
      query = search_params[:q].to_s.strip

=begin  TODO benchmark different query forms e.g.

        @results = Searchkick.search(
            "rails",
            page: params[:page],
            per_page: PER_PAGE,
            index_name: [Track, Album],
            fields: ['name', 'description', 'first_name', 'last_name'],
            aggs: {terms: {field: '_type'}}
            highlight: {tag: '<mark>'}
=end

      results = {
          track: YamsCore::Track.search(query, operator: "or", page: params[:page], per_page: 20),
          album: YamsCore::Album.search(query, operator: "or", page: params[:page], per_page: 20)
      }

      @search_results = SearchPresenter.new(results, view_context)
    end

    private

    def search_params
      params.require(:searches).permit(:q)
    end

  end
end
