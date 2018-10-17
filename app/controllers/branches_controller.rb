class BranchesController < ApplicationController
  def index
    @back_path = school_postcode_question_path(
      params.permit(:postcode, :nominated_worker, :hire_via_agency)
    )

    if params[:postcode].nil?
      @branches = all_branch_results
    else
      @location = Location.new(params[:postcode])

      unless @location.valid?
        display_error(@location.error)
        return
      end

      @branches = branch_results_near(@location.point)
    end

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: Spreadsheet.new(@branches).to_xlsx, filename: 'branches' }
    end
  end

  private

  def branch_results_near(point)
    Branch.search(point).map do |branch|
      search_result_for(branch).tap do |result|
        result.rate = branch.supplier.nominated_worker_rate
        result.distance = point.distance(branch.location)
      end
    end
  end

  def all_branch_results
    Branch.includes(:supplier).all.map do |branch|
      search_result_for(branch)
    end
  end

  def search_result_for(branch)
    BranchSearchResult.new(
      supplier_name: branch.supplier.name,
      name: helpers.display_name_for_branch(branch),
      contact_name: branch.contact_name,
      telephone_number: branch.telephone_number,
      contact_email: branch.contact_email
    )
  end

  def display_error(message)
    path = school_postcode_question_path(
      params.permit(:postcode, :nominated_worker, :hire_via_agency)
    )
    redirect_to path, flash: { error: message }
  end
end
