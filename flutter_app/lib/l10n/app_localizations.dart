import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ru'),
    Locale('uz'),
  ];

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': _enTranslations,
    'ru': _ruTranslations,
    'uz': _uzTranslations,
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get languageCode => locale.languageCode;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'uz'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

// English Translations
const Map<String, String> _enTranslations = {
  // Common
  'loading': 'Loading...',
  'save': 'Save',
  'cancel': 'Cancel',
  'delete': 'Delete',
  'edit': 'Edit',
  'add': 'Add',
  'search': 'Search',
  'refresh': 'Refresh',
  'back': 'Back',
  'next': 'Next',
  'done': 'Done',
  'yes': 'Yes',
  'no': 'No',
  'ok': 'OK',
  'error': 'Error',
  'success': 'Success',
  'retry': 'Retry',

  // Navigation
  'nav_home': 'Home',
  'nav_map': 'Map',
  'nav_scan': 'Scan',
  'nav_saved': 'Saved',
  'nav_profile': 'Profile',

  // Home Screen
  'home_title': 'YuvGO',
  'home_greeting': 'Hello',
  'home_premium_title': 'Premium Subscription',
  'home_premium_desc': 'Unlimited car washes',
  'home_get_premium': 'Get Premium',
  'home_weather_title': 'Weather',
  'home_weather_good': 'Good day for car wash!',
  'home_weather_bad': 'Not recommended today',
  'home_categories': 'Categories',
  'home_nearest': 'Nearest Car Washes',
  'home_recent': 'Recent Visits',
  'home_see_all': 'See All',
  'home_no_recent': 'No recent visits',

  // Categories
  'category_all': 'All',
  'category_premium': 'Premium',
  'category_standard': 'Standard',
  'category_express': 'Express',
  'category_self': 'Self-Service',

  // Map Screen
  'map_title': 'Car Washes Map',
  'map_search': 'Search car washes...',
  'map_nearby': 'Nearby',
  'map_open_now': 'Open Now',
  'map_directions': 'Directions',
  'map_details': 'Details',

  // QR Scanner
  'qr_title': 'QR Scanner',
  'qr_subtitle': 'Scan QR code to check-in',
  'qr_scanning': 'Scanning...',
  'qr_success': 'Check-in Successful!',
  'qr_failed': 'Check-in Failed',
  'qr_select_car': 'Select Your Car',
  'qr_no_subscription': 'No active subscription',
  'qr_get_subscription': 'Get Subscription',
  'qr_cooldown': 'Please wait before next visit',
  'qr_visits_remaining': 'Visits remaining',
  'qr_unlimited': 'Unlimited',

  // Saved
  'saved_title': 'Saved',
  'saved_subtitle': 'Your favorite car washes',
  'saved_empty': 'No saved car washes',
  'saved_add_hint': 'Tap the heart icon to save',

  // Profile
  'profile_title': 'Profile',
  'profile_edit': 'Edit Profile',
  'profile_name': 'Name',
  'profile_phone': 'Phone',
  'profile_email': 'Email',
  'profile_vehicles': 'My Vehicles',
  'profile_add_vehicle': 'Add Vehicle',
  'profile_subscription': 'Subscription',
  'profile_no_subscription': 'No active subscription',
  'profile_payment_methods': 'Payment Methods',
  'profile_history': 'Visit History',
  'profile_notifications': 'Notifications',
  'profile_language': 'Language',
  'profile_settings': 'Settings',
  'profile_help': 'Help & Support',
  'profile_about': 'About',
  'profile_logout': 'Logout',
  'profile_login': 'Login',

  // Subscription
  'sub_title': 'Subscription',
  'sub_choose_plan': 'Choose Your Plan',
  'sub_monthly': '30 Days',
  'sub_quarterly': '90 Days',
  'sub_yearly': '365 Days',
  'sub_visits': 'visits',
  'sub_unlimited': 'Unlimited',
  'sub_per_month': '/month',
  'sub_popular': 'Popular',
  'sub_best_value': 'Best Value',
  'sub_subscribe': 'Subscribe',
  'sub_current': 'Current Plan',
  'sub_expires': 'Expires',
  'sub_renew': 'Renew',
  'sub_cancel': 'Cancel Subscription',
  'sub_freeze': 'Freeze Subscription',
  'sub_faq': 'FAQ',

  // Vehicles
  'vehicle_title': 'My Vehicles',
  'vehicle_add': 'Add Vehicle',
  'vehicle_plate': 'License Plate',
  'vehicle_brand': 'Brand',
  'vehicle_model': 'Model',
  'vehicle_color': 'Color',
  'vehicle_year': 'Year',
  'vehicle_active': 'Active',
  'vehicle_delete_confirm': 'Delete this vehicle?',

  // Notifications
  'notif_title': 'Notifications',
  'notif_empty': 'No notifications',
  'notif_mark_read': 'Mark all as read',

  // Payment
  'payment': 'Payment',
  'close': 'Close',
  'payment_cancel_title': 'Cancel Payment?',
  'payment_cancel_desc': 'Are you sure you want to cancel the payment?',
  'payment_title': 'Payment',
  'payment_methods': 'Payment Methods',
  'payment_add_card': 'Add Card',
  'payment_saved_cards': 'Saved Cards',
  'payment_pay': 'Pay',
  'payment_success': 'Payment Successful!',
  'payment_failed': 'Payment Failed',
  'payment_processing': 'Processing...',

  // Settings
  'settings_title': 'Settings',
  'settings_language': 'Language',
  'settings_english': 'English',
  'settings_russian': 'Russian',
  'settings_uzbek': 'Uzbek',
  'settings_notifications': 'Notifications',
  'settings_push': 'Push Notifications',
  'settings_sms': 'SMS Notifications',
  'settings_email': 'Email Notifications',
  'settings_theme': 'Theme',
  'settings_dark': 'Dark Mode',
  'settings_privacy': 'Privacy Policy',
  'settings_terms': 'Terms of Service',

  // Auth
  'auth_login': 'Login',
  'auth_register': 'Register',
  'auth_phone': 'Phone Number',
  'auth_code': 'Verification Code',
  'auth_send_code': 'Send Code',
  'auth_verify': 'Verify',
  'auth_resend': 'Resend Code',
  'auth_logout': 'Logout',
  'auth_logout_confirm': 'Are you sure you want to logout?',

  // Errors
  'error_network': 'Network error. Please try again.',
  'error_server': 'Server error. Please try later.',
  'error_unknown': 'Something went wrong.',
  'error_invalid_qr': 'Invalid QR code',
  'error_expired_qr': 'QR code expired',
  'error_no_subscription': 'No active subscription',

  // Car Wash Detail
  'detail_wash_time': 'WASH TIME',
  'detail_rating': 'RATING',
  'detail_call': 'CALL',
  'detail_amenities': 'Amenities',
  'detail_services': 'Additional Services',
  'detail_address': 'Address',
  'detail_working_hours': 'Working Hours',
  'detail_route': 'Route',
  'detail_scan_qr': 'Scan QR Code',
  'detail_open': 'OPEN',
  'detail_closed': 'CLOSED',
  'detail_open_24': 'OPEN 24/7',
  'detail_mon_fri': 'Monday - Friday',
  'detail_sat': 'Saturday',
  'detail_sun': 'Sunday',
  'detail_waiting_room': 'Waiting Room',
  'detail_games': 'Entertainment Games',
  'detail_shop': 'Shop',
  'detail_cafe': 'Cafe',
  'detail_detailing': 'Detailing',
  'detail_workshop': 'Workshop',
  'detail_oil_change': 'Oil Change',
  'detail_fuel': 'Fuel Station',
  'detail_ev_charge': 'EV Charging Station',

  // QR Scanner (additional)
  'qr_login_required': 'Login Required',
  'qr_login_desc': 'Please login or register to scan QR codes.',
  'qr_login_btn': 'Login',
  'qr_later': 'Later',
  'qr_sub_required': 'Subscription Required',
  'qr_sub_desc': 'You need a subscription to visit car washes.',
  'qr_view_plans': 'View Plans',
  'qr_change_car': 'Change car',

  // Additional Home
  'currency': 'sum',
  'saved_money': 'Saved money',
  'monthly_visits': 'Monthly visits',
  'premium_car_washes': 'Premium car\nwashes',
  'new_car_washes': 'New car\nwashes',
  'open_until': 'OPEN UNTIL',
  'closed_until': 'CLOSED UNTIL',
  'register_desc': 'Register to use all app features',
  'home_subscribe_title': 'Special discount\non subscription!',
  'home_subscribe_desc': 'Subscribe and save on car washes',
  'home_subscribe_btn': 'Subscribe',

  // My Subscription
  'my_subscription': 'My Subscription',
  'guest_subscriber': 'Guest Subscriber',
  'sub_paid_info': 'Learn more about paid subscriptions',
  'sub_buy': 'Buy Subscription',
  'sub_save_desc': 'Save up to 50% with our subscription!',
  'sub_expired': 'Subscription expired',
  'sub_remaining': 'Remaining:',
  'days': 'days',
  'sub_renew_action': 'Renew subscription',
  'sub_renewable': 'Renewable',

  // Subscription Plans
  'sub_plans_title': 'Subscriptions',
  'sub_banner_title': 'Save your expenses\nwith YuvGO!',
  'sub_banner_desc': 'Choose the subscription that suits you',
  'view_car_washes': 'View car washes',
  'car_wash_count': '+ 60 car washes',

  // Car Wash Detail
  'wash_prices': 'Wash Prices',
  'services_note': 'Additional services are not included in the subscription and require separate payment',
  'currently_open': 'Open now',
  'closed_opens_tomorrow': 'Closed — opens tomorrow at',
  'reviews': 'Reviews',
  'rate': 'Rate',
  'review_hint': 'Leave a comment (optional)',
  'submit': 'Submit',
  'review_submitted': 'Your review has been submitted!',
  'review_error': 'Error occurred. Please login first.',
  'no_reviews': 'No reviews yet',
  'be_first_reviewer': 'Be the first to review!',
  'see_all_reviews': 'See all reviews',
  'added_to_saved': 'Added to saved',
  'removed_from_saved': 'Removed from saved',
  'copied': 'Copied!',
  'which_app': 'Which app to open?',
  'go_back': 'Back',

  // Profile
  'subscriber': 'SUBSCRIBER',
  'visits_count': 'Visits',
  'saved_count': 'Saved',
  'privacy_policy': 'Privacy Policy',
  'help_center': 'Help Center',
  'telegram_error': 'Could not open Telegram',
  'no_visits': 'No visits yet',

  // Checkout
  'checkout_title': 'Checkout',
  'plan_details': 'Plan Details',
  'duration': 'Duration',
  'price': 'Price',
  'total': 'Total',
  'pay_now': 'Pay Now',
  'payment_secure': 'Secure payment',

  // Weather
  'wash_rating': 'Wash Rating',
  'weather_forecast': 'Weather Forecast',

  // Visit History
  'visit_history': 'Visit History',

  // Days of week
  'monday': 'Monday',
  'tuesday': 'Tuesday',
  'wednesday': 'Wednesday',
  'thursday': 'Thursday',
  'friday': 'Friday',
  'saturday': 'Saturday',
  'sunday': 'Sunday',
  'mon_fri': 'Monday - Friday',

  // Checkout
  'checkout_buy_sub': 'Buy Subscription',
  'activation_date': 'Subscription activation date',
  'promo_code': 'Promo code',
  'promo_have': 'Have a promo code?',
  'promo_enter': 'Enter promo code',
  'promo_expired': 'Expired',
  'payment_method': 'Payment method',
  'card_payment': 'Card payment',
  'card_types': 'Uzcard, Humo, Visa, Mastercard',
  'sub_price': 'Subscription price',
  'discount_label': 'Discount',
  'amount': 'Amount',
  'full_payment': 'Full payment',
  'make_payment': 'Make Payment',
  'payment_pending': 'Payment Pending',
  'payment_pending_desc': 'Payment page opened. Complete the payment and return to the app.',
  'success_title': 'Success!',
  'sub_activated': 'Subscription activated successfully!',
  'already_active_sub': 'You already have an active subscription!',
  'login_first': 'Please login first',
  'plan_not_found': 'Subscription plan not found',
  'payment_create_error': 'Payment creation error. Please try again.',
  'sub_create_error': 'Subscription creation error',

  // Saved Screen
  'saved_favorites': 'Favorites',

  // Notifications
  'notif_today': 'Today',
  'notif_earlier': 'Earlier',

  // Visit History
  'visit_no_visits': 'No visits yet',
  'visit_start': 'Start using car washes to see your visit history',
  'visit_find': 'Find Car Washes',

  // Onboarding
  'onboarding_skip': 'Skip',
  'onboarding_start': 'Get Started',

  // Map screen
  'search_history': 'History',
  'clear_all': 'Clear all',
  'delete_item': 'Delete',
  'nothing_found': 'Nothing found',
  'nothing_found_desc': 'Nothing found for',
  'location_permission_title': 'Allow your\nlocation',
  'location_permission_desc': 'Allow location access in settings to see nearby car washes',
  'not_now': 'Not now',
  'open_settings': 'Open Settings',
  'open_24_7': '24/7 OPEN',
  'open_until': 'OPEN UNTIL',
  'closed_until': 'CLOSED UNTIL',
  'status_open': 'OPEN',
  'status_closed': 'CLOSED',
  'car_wash_default': 'Car Wash',

  // Visit dates & statuses
  'today': 'Today',
  'yesterday': 'Yesterday',
  'days_ago': 'days ago',
  'status_completed': 'Completed',
  'status_in_progress': 'In progress',

  // Settings
  'settings_app_language': 'App Language',
};

// Russian Translations
const Map<String, String> _ruTranslations = {
  // Common
  'loading': 'Загрузка...',
  'save': 'Сохранить',
  'cancel': 'Отмена',
  'delete': 'Удалить',
  'edit': 'Редактировать',
  'add': 'Добавить',
  'search': 'Поиск',
  'refresh': 'Обновить',
  'back': 'Назад',
  'next': 'Далее',
  'done': 'Готово',
  'yes': 'Да',
  'no': 'Нет',
  'ok': 'ОК',
  'error': 'Ошибка',
  'success': 'Успешно',
  'retry': 'Повторить',

  // Navigation
  'nav_home': 'Главная',
  'nav_map': 'Карта',
  'nav_scan': 'Скан',
  'nav_saved': 'Избранное',
  'nav_profile': 'Профиль',

  // Home Screen
  'home_title': 'YuvGO',
  'home_greeting': 'Привет',
  'home_premium_title': 'Премиум подписка',
  'home_premium_desc': 'Безлимитные автомойки',
  'home_get_premium': 'Получить Премиум',
  'home_weather_title': 'Погода',
  'home_weather_good': 'Хороший день для мойки!',
  'home_weather_bad': 'Сегодня не рекомендуется',
  'home_categories': 'Категории',
  'home_nearest': 'Ближайшие автомойки',
  'home_recent': 'Недавние посещения',
  'home_see_all': 'Все',
  'home_no_recent': 'Нет недавних посещений',

  // Categories
  'category_all': 'Все',
  'category_premium': 'Премиум',
  'category_standard': 'Стандарт',
  'category_express': 'Экспресс',
  'category_self': 'Самообслуживание',

  // Map Screen
  'map_title': 'Карта автомоек',
  'map_search': 'Поиск автомоек...',
  'map_nearby': 'Рядом',
  'map_open_now': 'Открыто сейчас',
  'map_directions': 'Маршрут',
  'map_details': 'Подробнее',

  // QR Scanner
  'qr_title': 'QR Сканер',
  'qr_subtitle': 'Сканируйте QR для регистрации',
  'qr_scanning': 'Сканирование...',
  'qr_success': 'Регистрация успешна!',
  'qr_failed': 'Ошибка регистрации',
  'qr_select_car': 'Выберите автомобиль',
  'qr_no_subscription': 'Нет активной подписки',
  'qr_get_subscription': 'Оформить подписку',
  'qr_cooldown': 'Подождите до следующего посещения',
  'qr_visits_remaining': 'Осталось посещений',
  'qr_unlimited': 'Безлимит',

  // Saved
  'saved_title': 'Избранное',
  'saved_subtitle': 'Ваши любимые автомойки',
  'saved_empty': 'Нет сохраненных автомоек',
  'saved_add_hint': 'Нажмите на сердечко для сохранения',

  // Profile
  'profile_title': 'Профиль',
  'profile_edit': 'Редактировать',
  'profile_name': 'Имя',
  'profile_phone': 'Телефон',
  'profile_email': 'Email',
  'profile_vehicles': 'Мои автомобили',
  'profile_add_vehicle': 'Добавить авто',
  'profile_subscription': 'Подписка',
  'profile_no_subscription': 'Нет активной подписки',
  'profile_payment_methods': 'Способы оплаты',
  'profile_history': 'История посещений',
  'profile_notifications': 'Уведомления',
  'profile_language': 'Язык',
  'profile_settings': 'Настройки',
  'profile_help': 'Помощь',
  'profile_about': 'О приложении',
  'profile_logout': 'Выход',
  'profile_login': 'Войти',

  // Subscription
  'sub_title': 'Подписка',
  'sub_choose_plan': 'Выберите тариф',
  'sub_monthly': '30 дней',
  'sub_quarterly': '90 дней',
  'sub_yearly': '365 дней',
  'sub_visits': 'посещений',
  'sub_unlimited': 'Безлимит',
  'sub_per_month': '/месяц',
  'sub_popular': 'Популярный',
  'sub_best_value': 'Выгодный',
  'sub_subscribe': 'Оформить',
  'sub_current': 'Текущий тариф',
  'sub_expires': 'Истекает',
  'sub_renew': 'Продлить',
  'sub_cancel': 'Отменить подписку',
  'sub_freeze': 'Заморозить',
  'sub_faq': 'Вопросы и ответы',

  // Vehicles
  'vehicle_title': 'Мои автомобили',
  'vehicle_add': 'Добавить авто',
  'vehicle_plate': 'Гос. номер',
  'vehicle_brand': 'Марка',
  'vehicle_model': 'Модель',
  'vehicle_color': 'Цвет',
  'vehicle_year': 'Год',
  'vehicle_active': 'Активный',
  'vehicle_delete_confirm': 'Удалить этот автомобиль?',

  // Notifications
  'notif_title': 'Уведомления',
  'notif_empty': 'Нет уведомлений',
  'notif_mark_read': 'Отметить все как прочитанные',

  // Payment
  'payment': 'Оплата',
  'close': 'Закрыть',
  'payment_cancel_title': 'Отменить оплату?',
  'payment_cancel_desc': 'Вы уверены, что хотите отменить оплату?',
  'payment_title': 'Оплата',
  'payment_methods': 'Способы оплаты',
  'payment_add_card': 'Добавить карту',
  'payment_saved_cards': 'Сохраненные карты',
  'payment_pay': 'Оплатить',
  'payment_success': 'Оплата успешна!',
  'payment_failed': 'Ошибка оплаты',
  'payment_processing': 'Обработка...',

  // Settings
  'settings_title': 'Настройки',
  'settings_language': 'Язык',
  'settings_english': 'Английский',
  'settings_russian': 'Русский',
  'settings_uzbek': 'Узбекский',
  'settings_notifications': 'Уведомления',
  'settings_push': 'Push-уведомления',
  'settings_sms': 'SMS-уведомления',
  'settings_email': 'Email-уведомления',
  'settings_theme': 'Тема',
  'settings_dark': 'Темная тема',
  'settings_privacy': 'Политика конфиденциальности',
  'settings_terms': 'Условия использования',

  // Auth
  'auth_login': 'Вход',
  'auth_register': 'Регистрация',
  'auth_phone': 'Номер телефона',
  'auth_code': 'Код подтверждения',
  'auth_send_code': 'Отправить код',
  'auth_verify': 'Подтвердить',
  'auth_resend': 'Отправить снова',
  'auth_logout': 'Выход',
  'auth_logout_confirm': 'Вы уверены, что хотите выйти?',

  // Errors
  'error_network': 'Ошибка сети. Попробуйте снова.',
  'error_server': 'Ошибка сервера. Попробуйте позже.',
  'error_unknown': 'Что-то пошло не так.',
  'error_invalid_qr': 'Неверный QR-код',
  'error_expired_qr': 'QR-код истек',
  'error_no_subscription': 'Нет активной подписки',

  // Car Wash Detail
  'detail_wash_time': 'ВРЕМЯ МОЙКИ',
  'detail_rating': 'РЕЙТИНГ',
  'detail_call': 'ПОЗВОНИТЬ',
  'detail_amenities': 'Удобства',
  'detail_services': 'Дополнительные услуги',
  'detail_address': 'Адрес',
  'detail_working_hours': 'Режим работы',
  'detail_route': 'Маршрут',
  'detail_scan_qr': 'Сканировать QR',
  'detail_open': 'ОТКРЫТО',
  'detail_closed': 'ЗАКРЫТО',
  'detail_open_24': 'ОТКРЫТО 24/7',
  'detail_mon_fri': 'Понедельник - Пятница',
  'detail_sat': 'Суббота',
  'detail_sun': 'Воскресенье',
  'detail_waiting_room': 'Зал ожидания',
  'detail_games': 'Развлекательные игры',
  'detail_shop': 'Магазин',
  'detail_cafe': 'Кафе',
  'detail_detailing': 'Детейлинг',
  'detail_workshop': 'Мастерская',
  'detail_oil_change': 'Замена масла',
  'detail_fuel': 'АЗС',
  'detail_ev_charge': 'Зарядка электромобилей',

  // QR Scanner (additional)
  'qr_login_required': 'Требуется вход',
  'qr_login_desc': 'Войдите или зарегистрируйтесь для сканирования QR-кодов.',
  'qr_login_btn': 'Войти',
  'qr_later': 'Позже',
  'qr_sub_required': 'Требуется подписка',
  'qr_sub_desc': 'Для посещения автомоек нужна подписка.',
  'qr_view_plans': 'Смотреть тарифы',
  'qr_change_car': 'Сменить авто',

  // Additional Home
  'currency': 'сум',
  'saved_money': 'Сэкономлено',
  'monthly_visits': 'Посещения за месяц',
  'premium_car_washes': 'Премиум\nавтомойки',
  'new_car_washes': 'Новые\nавтомойки',
  'open_until': 'ОТКРЫТО ДО',
  'closed_until': 'ЗАКРЫТО ДО',
  'register_desc': 'Зарегистрируйтесь для доступа ко всем функциям',
  'home_subscribe_title': 'Специальная скидка\nна подписку!',
  'home_subscribe_desc': 'Подпишитесь и экономьте на автомойках',
  'home_subscribe_btn': 'Подписаться',

  // My Subscription
  'my_subscription': 'Моя подписка',
  'guest_subscriber': 'Гостевой подписчик',
  'sub_paid_info': 'Подробнее о платных подписках',
  'sub_buy': 'Купить подписку',
  'sub_save_desc': 'Экономьте до 50% с нашей подпиской!',
  'sub_expired': 'Подписка истекла',
  'sub_remaining': 'Осталось:',
  'days': 'дней',
  'sub_renew_action': 'Продлить подписку',
  'sub_renewable': 'Можно продлить',

  // Subscription Plans
  'sub_plans_title': 'Подписки',
  'sub_banner_title': 'Экономьте расходы\nс YuvGO!',
  'sub_banner_desc': 'Выберите подходящую подписку',
  'view_car_washes': 'Посмотреть автомойки',
  'car_wash_count': '+ 60 автомоек',

  // Car Wash Detail
  'wash_prices': 'Цены на мойку',
  'services_note': 'Дополнительные услуги не входят в подписку и оплачиваются отдельно',
  'currently_open': 'Сейчас открыто',
  'closed_opens_tomorrow': 'Закрыто — откроется завтра в',
  'reviews': 'Отзывы',
  'rate': 'Оценить',
  'review_hint': 'Оставьте комментарий (необязательно)',
  'submit': 'Отправить',
  'review_submitted': 'Ваш отзыв принят!',
  'review_error': 'Произошла ошибка. Сначала войдите в систему.',
  'no_reviews': 'Пока нет отзывов',
  'be_first_reviewer': 'Будьте первым!',
  'see_all_reviews': 'Смотреть все отзывы',
  'added_to_saved': 'Добавлено в избранное',
  'removed_from_saved': 'Удалено из избранного',
  'copied': 'Скопировано!',
  'which_app': 'В каком приложении открыть?',
  'go_back': 'Назад',

  // Profile
  'subscriber': 'ПОДПИСЧИК',
  'visits_count': 'Посещения',
  'saved_count': 'Избранное',
  'privacy_policy': 'Политика конфиденциальности',
  'help_center': 'Центр помощи',
  'telegram_error': 'Не удалось открыть Telegram',
  'no_visits': 'Посещений пока нет',

  // Checkout
  'checkout_title': 'Оплата',
  'plan_details': 'Детали тарифа',
  'duration': 'Длительность',
  'price': 'Цена',
  'total': 'Итого',
  'pay_now': 'Оплатить',
  'payment_secure': 'Безопасная оплата',

  // Weather
  'wash_rating': 'Рейтинг мойки',
  'weather_forecast': 'Прогноз погоды',

  // Visit History
  'visit_history': 'История посещений',

  // Days of week
  'monday': 'Понедельник',
  'tuesday': 'Вторник',
  'wednesday': 'Среда',
  'thursday': 'Четверг',
  'friday': 'Пятница',
  'saturday': 'Суббота',
  'sunday': 'Воскресенье',
  'mon_fri': 'Понедельник - Пятница',

  // Checkout
  'checkout_buy_sub': 'Купить подписку',
  'activation_date': 'Дата активации подписки',
  'promo_code': 'Промокод',
  'promo_have': 'Есть промокод?',
  'promo_enter': 'Введите промокод',
  'promo_expired': 'Истек',
  'payment_method': 'Способ оплаты',
  'card_payment': 'Оплата картой',
  'card_types': 'Uzcard, Humo, Visa, Mastercard',
  'sub_price': 'Цена подписки',
  'discount_label': 'Скидка',
  'amount': 'Сумма',
  'full_payment': 'Полная оплата',
  'make_payment': 'Оплатить',
  'payment_pending': 'Ожидание оплаты',
  'payment_pending_desc': 'Страница оплаты открыта. Завершите оплату и вернитесь в приложение.',
  'success_title': 'Успешно!',
  'sub_activated': 'Подписка успешно активирована!',
  'already_active_sub': 'У вас уже есть активная подписка!',
  'login_first': 'Сначала войдите в систему',
  'plan_not_found': 'Тариф не найден',
  'payment_create_error': 'Ошибка создания платежа. Попробуйте снова.',
  'sub_create_error': 'Ошибка создания подписки',

  // Saved Screen
  'saved_favorites': 'Избранное',

  // Notifications
  'notif_today': 'Сегодня',
  'notif_earlier': 'Ранее',

  // Visit History
  'visit_no_visits': 'Посещений пока нет',
  'visit_start': 'Начните пользоваться автомойками, чтобы увидеть историю',
  'visit_find': 'Найти автомойки',

  // Onboarding
  'onboarding_skip': 'Пропустить',
  'onboarding_start': 'Начать',

  // Map screen
  'search_history': 'История',
  'clear_all': 'Очистить все',
  'delete_item': 'Удалить',
  'nothing_found': 'Ничего не найдено',
  'nothing_found_desc': 'Ничего не найдено по запросу',
  'location_permission_title': 'Разрешите\nгеолокацию',
  'location_permission_desc': 'Разрешите доступ к местоположению в настройках, чтобы видеть ближайшие автомойки',
  'not_now': 'Не сейчас',
  'open_settings': 'Открыть настройки',
  'open_24_7': '24/7 ОТКРЫТО',
  'open_until': 'ОТКРЫТО ДО',
  'closed_until': 'ЗАКРЫТО ДО',
  'status_open': 'ОТКРЫТО',
  'status_closed': 'ЗАКРЫТО',
  'car_wash_default': 'Автомойка',

  // Visit dates & statuses
  'today': 'Сегодня',
  'yesterday': 'Вчера',
  'days_ago': 'дней назад',
  'status_completed': 'Завершено',
  'status_in_progress': 'В процессе',

  // Settings
  'settings_app_language': 'Язык приложения',
};

// Uzbek Translations
const Map<String, String> _uzTranslations = {
  // Common
  'loading': 'Yuklanmoqda...',
  'save': 'Saqlash',
  'cancel': 'Bekor qilish',
  'delete': "O'chirish",
  'edit': 'Tahrirlash',
  'add': "Qo'shish",
  'search': 'Qidirish',
  'refresh': 'Yangilash',
  'back': 'Orqaga',
  'next': 'Keyingi',
  'done': 'Tayyor',
  'yes': 'Ha',
  'no': "Yo'q",
  'ok': 'OK',
  'error': 'Xatolik',
  'success': 'Muvaffaqiyatli',
  'retry': 'Qayta urinish',

  // Navigation
  'nav_home': 'Asosiy',
  'nav_map': 'Xarita',
  'nav_scan': 'Skanerlash',
  'nav_saved': 'Saqlangan',
  'nav_profile': 'Profil',

  // Home Screen
  'home_title': 'YuvGO',
  'home_greeting': 'Salom',
  'home_premium_title': 'Premium obuna',
  'home_premium_desc': 'Cheksiz avtomoyqalar',
  'home_get_premium': 'Premium olish',
  'home_weather_title': "Ob-havo",
  'home_weather_good': "Avtomoyqa uchun yaxshi kun!",
  'home_weather_bad': "Bugun tavsiya etilmaydi",
  'home_categories': 'Kategoriyalar',
  'home_nearest': 'Eng yaqin avtomoyqalar',
  'home_recent': "So'nggi tashriflar",
  'home_see_all': 'Barchasi',
  'home_no_recent': "So'nggi tashriflar yo'q",

  // Categories
  'category_all': 'Barchasi',
  'category_premium': 'Premium',
  'category_standard': 'Standart',
  'category_express': 'Ekspress',
  'category_self': "O'z-o'ziga xizmat",

  // Map Screen
  'map_title': 'Avtomoyqalar xaritasi',
  'map_search': 'Avtomoyqalarni qidirish...',
  'map_nearby': 'Yaqinda',
  'map_open_now': 'Hozir ochiq',
  'map_directions': "Yo'nalish",
  'map_details': "Batafsil",

  // QR Scanner
  'qr_title': 'QR Skaner',
  'qr_subtitle': "Tashrif uchun QR kodni skanerlang",
  'qr_scanning': 'Skanerlanmoqda...',
  'qr_success': "Tashrif muvaffaqiyatli!",
  'qr_failed': 'Tashrif xatosi',
  'qr_select_car': 'Avtomobilingizni tanlang',
  'qr_no_subscription': "Faol obuna yo'q",
  'qr_get_subscription': 'Obuna olish',
  'qr_cooldown': 'Keyingi tashrifgacha kuting',
  'qr_visits_remaining': 'Qolgan tashriflar',
  'qr_unlimited': 'Cheksiz',

  // Saved
  'saved_title': 'Saqlangan',
  'saved_subtitle': 'Sevimli avtomoyqalaringiz',
  'saved_empty': "Saqlangan avtomoyqalar yo'q",
  'saved_add_hint': "Saqlash uchun yurak belgisini bosing",

  // Profile
  'profile_title': 'Profil',
  'profile_edit': 'Tahrirlash',
  'profile_name': 'Ism',
  'profile_phone': 'Telefon',
  'profile_email': 'Email',
  'profile_vehicles': 'Avtomobillarim',
  'profile_add_vehicle': "Avtomobil qo'shish",
  'profile_subscription': 'Obuna',
  'profile_no_subscription': "Faol obuna yo'q",
  'profile_payment_methods': "To'lov usullari",
  'profile_history': 'Tashriflar tarixi',
  'profile_notifications': 'Bildirishnomalar',
  'profile_language': 'Til',
  'profile_settings': 'Sozlamalar',
  'profile_help': 'Yordam',
  'profile_about': 'Ilova haqida',
  'profile_logout': 'Chiqish',
  'profile_login': 'Kirish',

  // Subscription
  'sub_title': 'Obuna',
  'sub_choose_plan': 'Tarifni tanlang',
  'sub_monthly': '30 kun',
  'sub_quarterly': '90 kun',
  'sub_yearly': '365 kun',
  'sub_visits': 'tashrif',
  'sub_unlimited': 'Cheksiz',
  'sub_per_month': '/oy',
  'sub_popular': 'Mashhur',
  'sub_best_value': 'Eng foydali',
  'sub_subscribe': 'Obuna bo\'lish',
  'sub_current': 'Joriy tarif',
  'sub_expires': 'Tugaydi',
  'sub_renew': 'Yangilash',
  'sub_cancel': 'Obunani bekor qilish',
  'sub_freeze': 'Obunani muzlatish',
  'sub_faq': "Ko'p so'raladigan savollar",

  // Vehicles
  'vehicle_title': 'Avtomobillarim',
  'vehicle_add': "Avtomobil qo'shish",
  'vehicle_plate': 'Davlat raqami',
  'vehicle_brand': 'Marka',
  'vehicle_model': 'Model',
  'vehicle_color': 'Rang',
  'vehicle_year': 'Yil',
  'vehicle_active': 'Faol',
  'vehicle_delete_confirm': "Bu avtomobilni o'chirishni xohlaysizmi?",

  // Notifications
  'notif_title': 'Bildirishnomalar',
  'notif_empty': "Bildirishnomalar yo'q",
  'notif_mark_read': "Barchasini o'qilgan deb belgilash",

  // Payment
  'payment': "To'lov",
  'close': 'Yopish',
  'payment_cancel_title': "To'lovni bekor qilasizmi?",
  'payment_cancel_desc': "To'lovni bekor qilmoqchimisiz?",
  'payment_title': "To'lov",
  'payment_methods': "To'lov usullari",
  'payment_add_card': "Karta qo'shish",
  'payment_saved_cards': 'Saqlangan kartalar',
  'payment_pay': "To'lash",
  'payment_success': "To'lov muvaffaqiyatli!",
  'payment_failed': "To'lov xatosi",
  'payment_processing': "Jarayonda...",

  // Settings
  'settings_title': 'Sozlamalar',
  'settings_language': 'Til',
  'settings_english': 'Inglizcha',
  'settings_russian': 'Ruscha',
  'settings_uzbek': "O'zbekcha",
  'settings_notifications': 'Bildirishnomalar',
  'settings_push': 'Push bildirishnomalar',
  'settings_sms': 'SMS bildirishnomalar',
  'settings_email': 'Email bildirishnomalar',
  'settings_theme': 'Mavzu',
  'settings_dark': "Qorong'u rejim",
  'settings_privacy': 'Maxfiylik siyosati',
  'settings_terms': "Foydalanish shartlari",

  // Auth
  'auth_login': 'Kirish',
  'auth_register': "Ro'yxatdan o'tish",
  'auth_phone': 'Telefon raqami',
  'auth_code': 'Tasdiqlash kodi',
  'auth_send_code': "Kod jo'natish",
  'auth_verify': 'Tasdiqlash',
  'auth_resend': "Qayta jo'natish",
  'auth_logout': 'Chiqish',
  'auth_logout_confirm': "Chiqishni xohlaysizmi?",

  // Errors
  'error_network': "Tarmoq xatosi. Qayta urinib ko'ring.",
  'error_server': "Server xatosi. Keyinroq urinib ko'ring.",
  'error_unknown': "Nimadir noto'g'ri ketdi.",
  'error_invalid_qr': "Noto'g'ri QR kod",
  'error_expired_qr': 'QR kod muddati tugagan',
  'error_no_subscription': "Faol obuna yo'q",

  // Car Wash Detail
  'detail_wash_time': 'YUVISH VAQTI',
  'detail_rating': 'REYTING',
  'detail_call': "QO'NG'IROQ QILISH",
  'detail_amenities': 'Qulayliklari',
  'detail_services': "Qo'shimcha xizmatlar",
  'detail_address': 'Manzil',
  'detail_working_hours': 'Ish vaqti',
  'detail_route': 'Marshrut',
  'detail_scan_qr': 'QR kodni skanerlash',
  'detail_open': 'OCHIQ',
  'detail_closed': 'YOPIQ',
  'detail_open_24': '24/7 OCHIQ',
  'detail_mon_fri': 'Dushanba - Juma',
  'detail_sat': 'Shanba',
  'detail_sun': 'Yakshanba',
  'detail_waiting_room': 'Kutish zali',
  'detail_games': "Ko'ngilochar o'yinlar",
  'detail_shop': "Do'kon",
  'detail_cafe': 'Cafe',
  'detail_detailing': 'Detailing',
  'detail_workshop': 'Ustaxona',
  'detail_oil_change': 'Moy almashtirish',
  'detail_fuel': "Yoqilg'i quyish",
  'detail_ev_charge': 'Elektr zaryadlash stansiyasi',

  // QR Scanner (additional)
  'qr_login_required': "Ro'yxatdan o'ting",
  'qr_login_desc': "QR kodni skanerlash uchun avval tizimga kiring.",
  'qr_login_btn': 'Tizimga kirish',
  'qr_later': 'Keyinroq',
  'qr_sub_required': 'Obuna kerak',
  'qr_sub_desc': 'Avtomoykalarga tashrif uchun obuna sotib oling.',
  'qr_view_plans': "Obunalarni ko'rish",
  'qr_change_car': 'Mashinani almashtirish',

  // Additional Home
  'currency': 'so\'m',
  'saved_money': 'Tejalgan pul',
  'monthly_visits': 'Shu oy tashriflari',
  'premium_car_washes': 'Premium avto\nmoykalar',
  'new_car_washes': 'Yangi avto\nmoykalar',
  'open_until': 'GACHA OCHIQ',
  'closed_until': 'GACHA YOPIQ',
  'register_desc': 'Ilovaning barcha qulayliklaridan foydalanish uchun ro\'yxatdan o\'ting',
  'home_subscribe_title': 'Obunaga maxsus\nchegirma!',
  'home_subscribe_desc': 'Obuna bo\'ling va avtomoykada tejang',
  'home_subscribe_btn': 'Obuna bo\'lish',

  // My Subscription
  'my_subscription': 'Mening obunam',
  'guest_subscriber': 'Mehmon obunachi',
  'sub_paid_info': 'Pullik obunalar haqida batafsil ma\'lumot',
  'sub_buy': 'Obuna sotib oling',
  'sub_save_desc': 'Bizning obuna orqali 50% gacha pul tejaysiz!',
  'sub_expired': 'Obuna tugadi',
  'sub_remaining': 'Qoldi:',
  'days': 'kun',
  'sub_renew_action': 'Obunani qayta rasmiylashtirish',
  'sub_renewable': 'Qayta rasmiylashtirish mumkin',

  // Subscription Plans
  'sub_plans_title': 'Obunalar',
  'sub_banner_title': 'YuvGO bilan\nxarajatlaringizni tejang!',
  'sub_banner_desc': 'Sizga mos keladigan obuna turini tanlang',
  'view_car_washes': 'Avtomoykalarni ko\'rish',
  'car_wash_count': '+ 60 avtomoykalar',

  // Car Wash Detail
  'wash_prices': 'Moyka narxlari',
  'services_note': 'Qo\'shimcha servislar obuna tarifiga kirmaydi va alohida to\'lov talab qilinadi',
  'currently_open': 'Hozir ochiq',
  'closed_opens_tomorrow': 'Yopiq — ertaga',
  'reviews': 'Baholar',
  'rate': 'Baholash',
  'review_hint': 'Izoh qoldiring (ixtiyoriy)',
  'submit': 'Yuborish',
  'review_submitted': 'Bahoingiz qabul qilindi!',
  'review_error': 'Xatolik yuz berdi. Avval tizimga kiring.',
  'no_reviews': 'Hali baholar yo\'q',
  'be_first_reviewer': 'Birinchi bo\'lib baholang!',
  'see_all_reviews': 'Barcha baholarni ko\'rish',
  'added_to_saved': 'Saqlanganlarga qo\'shildi',
  'removed_from_saved': 'Saqlanganlardan o\'chirildi',
  'copied': 'Nusxalandi!',
  'which_app': 'Qaysi ilovada ko\'rishni xohlaysiz?',
  'go_back': 'Ortga',

  // Profile
  'subscriber': 'OBUNACHI',
  'visits_count': 'Tashriflar',
  'saved_count': 'Saqlangan',
  'privacy_policy': 'Maxfiylik siyosati',
  'help_center': 'Yordam markazi',
  'telegram_error': 'Telegram ochilmadi',
  'no_visits': 'Tashriflar hali yo\'q',

  // Checkout
  'checkout_title': 'To\'lov',
  'plan_details': 'Tarif tafsilotlari',
  'duration': 'Muddat',
  'price': 'Narx',
  'total': 'Jami',
  'pay_now': 'To\'lash',
  'payment_secure': 'Xavfsiz to\'lov',

  // Weather
  'wash_rating': 'Yuvish reytingi',
  'weather_forecast': 'Ob-havo prognozi',

  // Visit History
  'visit_history': 'Tashriflar tarixi',

  // Days of week
  'monday': 'Dushanba',
  'tuesday': 'Seshanba',
  'wednesday': 'Chorshanba',
  'thursday': 'Payshanba',
  'friday': 'Juma',
  'saturday': 'Shanba',
  'sunday': 'Yakshanba',
  'mon_fri': 'Dushanba - Juma',

  // Checkout
  'checkout_buy_sub': 'Obunani sotib olish',
  'activation_date': 'Obunani faollashtirish sanasi',
  'promo_code': 'Promokod',
  'promo_have': 'Promokod bormi?',
  'promo_enter': 'Promokodni kiriting',
  'promo_expired': 'Muddati o\'tgan',
  'payment_method': 'To\'lov usuli',
  'card_payment': 'Karta orqali to\'lov',
  'card_types': 'Uzcard, Humo, Visa, Mastercard',
  'sub_price': 'Obuna narxi',
  'discount_label': 'Chegirma',
  'amount': 'Summa',
  'full_payment': 'To\'liq to\'lov',
  'make_payment': 'To\'lov qilish',
  'payment_pending': 'To\'lov kutilmoqda',
  'payment_pending_desc': 'To\'lov sahifasi ochildi. To\'lovni amalga oshiring va ilovaga qayting.',
  'success_title': 'Muvaffaqiyatli!',
  'sub_activated': 'Obuna muvaffaqiyatli faollashtirildi!',
  'already_active_sub': 'Sizda allaqachon faol obuna mavjud!',
  'login_first': 'Iltimos, avval tizimga kiring',
  'plan_not_found': 'Obuna rejasi topilmadi',
  'payment_create_error': 'To\'lov yaratishda xatolik. Qayta urinib ko\'ring.',
  'sub_create_error': 'Obuna yaratishda xatolik',

  // Saved Screen
  'saved_favorites': 'Sevimlilar',

  // Notifications
  'notif_today': 'Bugun',
  'notif_earlier': 'Oldingi',

  // Visit History
  'visit_no_visits': 'Tashriflar hali yo\'q',
  'visit_start': 'Tashriflar tarixini ko\'rish uchun avtomoykalardan foydalaning',
  'visit_find': 'Avtomoykalarni topish',

  // Onboarding
  'onboarding_skip': 'O\'tkazib yuborish',
  'onboarding_start': 'Boshlash',

  // Map screen
  'search_history': 'Tarix',
  'clear_all': 'Hammasini o\'chirish',
  'delete_item': 'O\'chirish',
  'nothing_found': 'Hech narsa topilmadi',
  'nothing_found_desc': 'so\'roviga aloqador hech narsa topilmadi',
  'location_permission_title': 'Geolokatsiyangizga\nruxsat bering',
  'location_permission_desc': 'Sizga yaqin avtomoykalarni ko\'rishimiz uchun sozlamalarda joylashuv ma\'lumotiga ruxsat bering',
  'not_now': 'Hozir emas',
  'open_settings': 'Sozlamalarni ochish',
  'open_24_7': '24/7 OCHIQ',
  'open_until': 'GACHA OCHIQ',
  'closed_until': 'GACHA YOPIQ',
  'status_open': 'OCHIQ',
  'status_closed': 'YOPIQ',
  'car_wash_default': 'Avtomoyqa',

  // Visit dates & statuses
  'today': 'Bugun',
  'yesterday': 'Kecha',
  'days_ago': 'kun oldin',
  'status_completed': 'Yakunlangan',
  'status_in_progress': 'Jarayonda',

  // Settings
  'settings_app_language': 'Ilova tili',
};
