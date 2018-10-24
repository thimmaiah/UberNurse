module Admin
  class ShiftsController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    def index
      if params[:search].present?
        search(Shift)
      else
        super
        @resources = Shift.page(params[:page]).per(10)
      end
    end

    # PATCH/PUT /shifts/1
    def update

      regenerate_payment = false
      if(requested_resource.payment)
        # This has already been closed & payment has been generated
        requested_resource.payment.really_destroy!
        regenerate_payment = true
      end

      if requested_resource.update(resource_params)
        # regenrate the payment if required
        requested_resource.close_shift(true) if regenerate_payment

        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource("update.success"),
        )
      else
        render :edit, locals: {
          page: Administrate::Page::Form.new(dashboard, requested_resource),
        }
      end
    end

  end
end
