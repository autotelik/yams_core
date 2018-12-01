# frozen_string_literal: true

class SearchPresenter < YamsCore::Presenter

  def initialize(results, view)
    super(results, view)
  end

  # Search Results are a Hash of index = > [results] - we want the total number of results
  def count
    search_results.values.collect(&:size).sum
  end

  alias search_results model

end
