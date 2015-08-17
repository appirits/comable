AwesomeAdminLayout.define(only: Comable::Admin::ApplicationController) do |controller|
  comable = controller.comable
  current_comable_user = controller.current_comable_user

  navigation :admin do
    brand Comable.app_name do
      external_link comable.root_path
    end

    item Comable.t('admin.nav.dashboard') do
      link comable.admin_root_path
      icon 'dashboard'
    end

    item Comable.t('admin.nav.order') do
      link comable.admin_orders_path
      icon 'shopping-cart'
    end

    item Comable.t('admin.nav.product') do
      nest :products
      icon 'cube'
    end

    item Comable.t('admin.nav.user') do
      link comable.admin_users_path
      icon 'user'
      active controller.controller_name == 'users' && controller.action_name != 'profile'
    end

    divider

    item Comable.t('admin.nav.store') do
      nest :store
      icon 'home'
    end

    flex_divider

    item current_comable_user.email do
      nest :profile
      icon 'gift'
    end
  end

  navigation :products do
    brand Comable.t('admin.nav.product')

    item Comable.t('admin.nav.products.list') do
      link comable.admin_products_path(hoge: 112)
    end

    item Comable.t('admin.nav.stock') do
      link comable.admin_stocks_path
    end

    item Comable.t('admin.nav.category') do
      link comable.admin_categories_path
    end
  end

  navigation :store do
    brand Comable.t('admin.nav.store') do
      external_link comable.root_path
    end

    item Comable.t('admin.nav.theme') do
      link comable.admin_themes_path
    end

    item Comable.t('admin.nav.page') do
      link comable.admin_pages_path
    end

    item Comable.t('admin.nav.navigation') do
      link comable.admin_navigations_path
    end

    divider

    item Comable.t('admin.nav.shipment_method') do
      link comable.admin_shipment_methods_path
    end

    item Comable.t('admin.nav.payment_method') do
      link comable.admin_payment_methods_path
    end

    item Comable.t('admin.nav.tracker') do
      link comable.admin_trackers_path
    end

    divider

    item Comable.t('admin.nav.store') do
      link comable.admin_store_path
    end
  end

  navigation :profile do
    brand current_comable_user.email

    item Comable.t('admin.edit_profile') do
      link comable.admin_profile_path
      active controller.controller_name == 'users' && controller.action_name == 'profile'
    end

    divider

    item Comable.t('admin.sign_out') do
      link comable.destroy_admin_user_session_path, method: :delete
    end
  end
end
