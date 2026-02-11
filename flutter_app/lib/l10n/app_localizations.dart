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
};
