import { useState, useRef } from "react";
import imgRectangle4332 from "figma:asset/c91aad55e0a7c45259aa2971fb1ac9c1c529049a.png";
import imgRectangle4333 from "figma:asset/8b79995ed9c32093cc71f0ebd10090b8417d6fbf.png";
import imgRectangle4334 from "figma:asset/872c08ea19e3457c9be8bb455ea7747d26327a0c.png";
import imgTest from "figma:asset/dfccd867d7793e0a10160c137de9c203db6460d4.png";
import imgImage from "figma:asset/620144e0289da3d891ce8be6f4c0c82a66781265.png";
import imgImage1 from "figma:asset/4abf48994a2f652be5ec22c68102357c4388dde7.png";
import imgImage2 from "figma:asset/79fbe369f87e3052171dd27a35c85180e1dd870c.png";
import imgImage12 from "figma:asset/c22416c54393bfea53da65c75321cdc015b47ddb.png";
import imgIPhone15Pro from "figma:asset/84d36470f489cbe0bb0fc3c1b521e3344b4bf44f.png";
import imgAvatarTypes from "figma:asset/0508ea27d05a8dc4316ccd256ac7039446c310df.png";
import imgAvatarTypes1 from "figma:asset/c7b246a5037197b6fe77e7f07f740aa91d25369d.png";
import imgAvatarTypes2 from "figma:asset/bac8c07288e46be335c840e90a85d8fd17f58599.png";
import imgPasteYourContent6 from "figma:asset/a5c9adb28805fcd3ca3257a199e296fcdcc6dd39.png";

type Language = "uz" | "ru" | "en";

const langLabels: Record<Language, { name: string; flag: string }> = {
  uz: { name: "O'zbekcha", flag: "🇺🇿" },
  ru: { name: "Русский", flag: "🇷🇺" },
  en: { name: "English", flag: "🇬🇧" },
};

const translations: Record<
  Language,
  {
    nav: { partners: string; pricing: string; faq: string; download: string };
    hero: {
      titleBlack: string;
      titleCyan: string;
      subtitle: string;
      downloadBtn: string;
      clients: string;
    };
    features: {
      items: { title: string; desc: string }[];
    };
    moreFeatures: { title: string; desc: string }[];
    pricing: {
      title: string;
      subtitle: string;
      plans: {
        period: string;
        price: string;
        oldPrice: string;
        discount: string;
      }[];
      badge1: string;
      badge2: string;
      buyBtn: string;
    };
    washPlan: {
      title: string;
      subtitle: string;
      info1title: string;
      info1desc: string;
      info2title: string;
      info2desc: string;
    };
    faq: { title: string; items: { q: string; a: string }[] };
    footer: {
      partnership: string;
      partnerEmail: string;
      faqLink: string;
      documents: string;
      terms: string;
      offer: string;
      privacy: string;
      agreement: string;
      contacts: string;
      phone: string;
      download: string;
    };
    stats: {
      washRating: string;
      subscribers: string;
      carWashes: string;
      premiumWashes: string;
    };
  }
> = {
  uz: {
    nav: {
      partners: "Hamkorlarga",
      pricing: "Narxlar",
      faq: "Savollar va javoblar",
      download: "Yuklab olish",
    },
    hero: {
      titleBlack: "Avtomobilingiz tozaligiga bo'lgan ",
      titleCyan: "ishonchli yo'lingiz",
      subtitle:
        "Shahar bo'ylab premium avtomobil yuvish markazlariga bitta QR kod orqali kiring. Naqd pul yo'q, kutish yo'q, cheklovlar yo'q.",
      downloadBtn: "Ilovani yuklab olish",
      clients: "ishonch bildirgan mijozlar",
    },
    features: {
      items: [
        {
          title: "Premium avtomoykalar",
          desc: "Yuqori sifatli avtomobil yuvish xizmatlari va avtomobilingizga ehtiyotkor munosabat",
        },
        {
          title: "Bo'lib to'lash",
          desc: "Xohish o'zingizda, istasangiz bo'lib to'lang istasangiz hammasini to'lang",
        },
        {
          title: "Biz bilan pulingizni tejang",
          desc: "Obuna xizmatidan foydalanib, avtomobil yuvishda kamroq xarajat qiling va muntazam pul tejang",
        },
      ],
    },
    moreFeatures: [
      {
        title: "Ilovani yuklab oling",
        desc: "O'zingizga mos obuna turini sotib oling",
      },
      {
        title: "Qayerga borishni tanlang",
        desc: "O'zingizga yoqqan yoki yaqin bo'lgan avtomoykalardan birini tanlang",
      },
      {
        title: "QR-code ni skanerlang",
        desc: "Avtomoyka QR-code ni scanerlang va mashinangizni yuvdirish xizmatidan foydalaning.",
      },
      {
        title: "YuvGO AI: Aqlli tahlil",
        desc: "Sun'iy intellekt tahlili asosida mashinangizni yuvish uchun bugun qanchalik to'g'ri vaqt ekanligini bilib oling.",
      },
    ],
    pricing: {
      title: "O'zingizning obunangizni tanlang",
      subtitle:
        "Har bir obuna turida qayta rasmiylashtirish va premium avtomoykalarga kirish imkoni mavjud",
      plans: [
        {
          period: "30 kunlik",
          price: "1 200 000 so'm",
          oldPrice: "18 000 000 so'm",
          discount: "-20%",
        },
        {
          period: "90 kunlik",
          price: "3 150 000 so'm",
          oldPrice: "18 000 000 so'm",
          discount: "-30%",
        },
        {
          period: "365 kunlik",
          price: "10 800 000 so'm",
          oldPrice: "18 000 000 so'm",
          discount: "-40%",
        },
      ],
      badge1: "Qayta rasmiylashtirish",
      badge2: "Premium avtomoykalar",
      buyBtn: "Ilovani yuklab olish",
    },
    washPlan: {
      title:
        "Mashinangizni yuvishga arziydimi? YuvGO AI tahlil qiladi",
      subtitle:
        "Shunchaki ob-havoni ko'rmang. Wash Score algoritmi yaqin kunlardagi yog'ingarchilik va changni hisobga olib, mashina yuvish uchun eng ideal vaqtni ko'rsatib beradi.",
      info1title: "AI Ob-havo xabarlari",
      info1desc:
        "Ob-havo ilovasini tekshirishga vaqt sarflamang. YuvGO AI sizni havo yuvish uchun ideal bo'lishi bilan xabardor qiladi",
      info2title: "Shaxsiy yuvish rejasi",
      info2desc:
        "Shunchaki prognoz emas, aniq yechim. YuvGO AI haftaning qaysi kuni va soatida mashina yuvish eng foydali ekanligini hisoblab beradi",
    },
    faq: {
      title: "Savollarga Javoblar",
      items: [
        {
          q: "Qanday qilib YUVGOdan foydalanish mumkin?",
          a: "YUVGO ilovasidan foydalanish uchun avval ilovani yuklab oling, ro'yxatdan o'ting va obuna sotib oling. Keyin QR kodni skanerlang va avtomobilingizni yuvishni boshlang.",
        },
        {
          q: "Obuna muddati necha oy",
          a: "Obuna muddati 30, 60 yoki 90 kun bo'lishi mumkin. Siz o'zingizga qulay bo'lgan muddatni tanlashingiz mumkin.",
        },
        {
          q: "Qanday qilib karta qo'shish mumkin?",
          a: "Ilovada 'Profil' bo'limiga o'ting, 'To'lov kartalari' ni tanlang va yangi karta qo'shing.",
        },
        {
          q: "Obuna to'lovini bo'lib to'lash imkoniyati bormi?",
          a: "Ha, siz obuna to'lovini bo'lib to'lash imkoniyatidan foydalanishingiz mumkin.",
        },
        {
          q: "Qanday qilib yangi avtomobil qo'shish mumkin",
          a: "Ilovada 'Profil' bo'limiga o'ting, 'Mening mashinalarim' ni tanlang va yangi avtomobil qo'shing.",
        },
      ],
    },
    footer: {
      partnership: "Hamkorlik",
      partnerEmail: "partners@yuvgo.uz",
      faqLink: "Savollar va javoblar",
      documents: "Hujjatlar",
      terms: "Foydalanish shartlari",
      offer: "Oferta",
      privacy: "Maxfiylik siyosati",
      agreement: "Foydalanuvchi shartnomasi",
      contacts: "Kontaktlar",
      phone: "+998 78 956 69 61",
      download: "Yuklab olish",
    },
    stats: {
      washRating: "Aqlli Yuvish reytingi",
      subscribers: "100+ Faol obunachilar",
      carWashes: "60+ Avtomoykalar",
      premiumWashes: "10+ Premium avtomoykalar",
    },
  },
  ru: {
    nav: {
      partners: "Партнёрам",
      pricing: "Цены",
      faq: "Вопросы и ответы",
      download: "Скачать",
    },
    hero: {
      titleBlack: "Надёжный путь к чистоте ",
      titleCyan: "вашего автомобиля",
      subtitle:
        "Входите в премиум автомойки по всему городу с одним QR-кодом. Без наличных, без ожидания, без ограничений.",
      downloadBtn: "Скачать приложение",
      clients: "довольных клиентов",
    },
    features: {
      items: [
        {
          title: "Премиум автомойки",
          desc: "Высококачественные услуги мойки и бережное отношение к вашему автомобилю",
        },
        {
          title: "Рассрочка",
          desc: "Выбор за вами — платите в рассрочку или сразу",
        },
        {
          title: "Экономьте с нами",
          desc: "Используя подписку, тратьте меньше на мойку автомобиля и регулярно экономьте",
        },
      ],
    },
    moreFeatures: [
      {
        title: "Скачайте приложение",
        desc: "Купите подходящий тип подписки",
      },
      {
        title: "Выберите куда поехать",
        desc: "Выберите понравившуюся или ближайшую автомойку",
      },
      {
        title: "Сканируйте QR-код",
        desc: "Сканируйте QR-код автомойки и воспользуйтесь услугой мойки.",
      },
      {
        title: "YuvGO AI: Умный анализ",
        desc: "Узнайте на основе ИИ-анализа, насколько сегодня подходящее время для мойки.",
      },
    ],
    pricing: {
      title: "Выберите свою подписку",
      subtitle:
        "Каждый тип подписки включает продление и доступ к премиум автомойкам",
      plans: [
        {
          period: "30 дней",
          price: "1 200 000 сум",
          oldPrice: "18 000 000 сум",
          discount: "-20%",
        },
        {
          period: "90 дней",
          price: "3 150 000 сум",
          oldPrice: "18 000 000 сум",
          discount: "-30%",
        },
        {
          period: "365 дней",
          price: "10 800 000 сум",
          oldPrice: "18 000 000 сум",
          discount: "-40%",
        },
      ],
      badge1: "Продление",
      badge2: "Премиум автомойки",
      buyBtn: "Скачать приложение",
    },
    washPlan: {
      title: "Стоит ли мыть машину? YuvGO AI анализирует",
      subtitle:
        "Не просто смотрите погоду. Алгоритм Wash Score учитывает осадки и пыль ближайших дней и показывает идеальное время для мойки.",
      info1title: "AI Погодные уведомления",
      info1desc:
        "Не тратьте время на проверку погоды. YuvGO AI уведомит вас, когда погода идеальна для мойки",
      info2title: "Персональный план мойки",
      info2desc:
        "Не просто прогноз, а точное решение. YuvGO AI рассчитает, в какой день и час мыть машину выгоднее всего",
    },
    faq: {
      title: "Вопросы и ответы",
      items: [
        {
          q: "Как пользоваться YUVGO?",
          a: "Скачайте приложение, зарегистрируйтесь и купите подписку. Затем отсканируйте QR-код и начните мыть свой автомобиль.",
        },
        {
          q: "Какой срок подписки?",
          a: "Срок подписки может составлять 30, 90 или 365 дней. Вы можете выбрать удобный для вас срок.",
        },
        {
          q: "Как добавить карту?",
          a: "В приложении перейдите в раздел 'Профиль', выберите 'Платёжные карты' и добавьте новую карту.",
        },
        {
          q: "Можно ли оплатить в рассрочку?",
          a: "Да, вы можете воспользоваться возможностью оплаты подписки в рассрочку.",
        },
        {
          q: "Как добавить новый автомобиль?",
          a: "В приложении перейдите в раздел 'Профиль', выберите 'Мои автомобили' и добавьте новый автомобиль.",
        },
      ],
    },
    footer: {
      partnership: "Партнёрство",
      partnerEmail: "partners@yuvgo.uz",
      faqLink: "Вопросы и ответы",
      documents: "Документы",
      terms: "Условия использования",
      offer: "Оферта",
      privacy: "Политика конфиденциальности",
      agreement: "Пользовательское соглашение",
      contacts: "Контакты",
      phone: "+998 78 956 69 61",
      download: "Скачать",
    },
    stats: {
      washRating: "Умный рейтинг мойки",
      subscribers: "100+ Активных подписчиков",
      carWashes: "60+ Автомоек",
      premiumWashes: "10+ Премиум автомоек",
    },
  },
  en: {
    nav: {
      partners: "Partners",
      pricing: "Pricing",
      faq: "FAQ",
      download: "Download",
    },
    hero: {
      titleBlack: "Your trusted path to a ",
      titleCyan: "clean car",
      subtitle:
        "Access premium car washes across the city with a single QR code. No cash, no waiting, no limits.",
      downloadBtn: "Download the app",
      clients: "trusted clients",
    },
    features: {
      items: [
        {
          title: "Premium car washes",
          desc: "High-quality car washing services and careful treatment of your car",
        },
        {
          title: "Installment payment",
          desc: "Your choice — pay in installments or all at once",
        },
        {
          title: "Save money with us",
          desc: "Using a subscription, spend less on car washing and save regularly",
        },
      ],
    },
    moreFeatures: [
      {
        title: "Download the app",
        desc: "Buy the subscription type that suits you",
      },
      {
        title: "Choose where to go",
        desc: "Choose a car wash you like or one nearby",
      },
      {
        title: "Scan the QR code",
        desc: "Scan the car wash QR code and use the washing service.",
      },
      {
        title: "YuvGO AI: Smart analysis",
        desc: "Find out based on AI analysis how suitable today is for washing.",
      },
    ],
    pricing: {
      title: "Choose your subscription",
      subtitle:
        "Every subscription type includes renewal and access to premium car washes",
      plans: [
        {
          period: "30 days",
          price: "1,200,000 UZS",
          oldPrice: "18,000,000 UZS",
          discount: "-20%",
        },
        {
          period: "90 days",
          price: "3,150,000 UZS",
          oldPrice: "18,000,000 UZS",
          discount: "-30%",
        },
        {
          period: "365 days",
          price: "10,800,000 UZS",
          oldPrice: "18,000,000 UZS",
          discount: "-40%",
        },
      ],
      badge1: "Renewal",
      badge2: "Premium car washes",
      buyBtn: "Download the app",
    },
    washPlan: {
      title: "Is it worth washing your car? YuvGO AI analyzes",
      subtitle:
        "Don't just check the weather. The Wash Score algorithm considers upcoming rain and dust to show the ideal time for washing.",
      info1title: "AI Weather notifications",
      info1desc:
        "Don't waste time checking weather. YuvGO AI will notify you when the weather is ideal for washing",
      info2title: "Personal wash plan",
      info2desc:
        "Not just a forecast, but an exact solution. YuvGO AI calculates which day and hour is most beneficial for washing",
    },
    faq: {
      title: "Frequently Asked Questions",
      items: [
        {
          q: "How to use YUVGO?",
          a: "Download the app, register and buy a subscription. Then scan the QR code and start washing your car.",
        },
        {
          q: "What is the subscription period?",
          a: "The subscription period can be 30, 90 or 365 days. You can choose the period that suits you.",
        },
        {
          q: "How to add a card?",
          a: "In the app, go to 'Profile', select 'Payment cards' and add a new card.",
        },
        {
          q: "Can I pay in installments?",
          a: "Yes, you can use the installment payment option for the subscription.",
        },
        {
          q: "How to add a new car?",
          a: "In the app, go to 'Profile', select 'My cars' and add a new car.",
        },
      ],
    },
    footer: {
      partnership: "Partnership",
      partnerEmail: "partners@yuvgo.uz",
      faqLink: "FAQ",
      documents: "Documents",
      terms: "Terms of use",
      offer: "Offer",
      privacy: "Privacy policy",
      agreement: "User agreement",
      contacts: "Contacts",
      phone: "+998 78 956 69 61",
      download: "Download",
    },
    stats: {
      washRating: "Smart Wash Rating",
      subscribers: "100+ Active subscribers",
      carWashes: "60+ Car washes",
      premiumWashes: "10+ Premium car washes",
    },
  },
};

const featureImages = [imgRectangle4332, imgRectangle4333, imgRectangle4334];
const moreFeatureImages = [imgTest, imgImage, imgImage1, imgImage2];

export default function LandingPage() {
  const [lang, setLang] = useState<Language>("uz");
  const [showLangDropdown, setShowLangDropdown] = useState(false);
  const [openFaqIndex, setOpenFaqIndex] = useState(0);

  const partnersRef = useRef<HTMLDivElement>(null);
  const pricingRef = useRef<HTMLDivElement>(null);
  const faqRef = useRef<HTMLDivElement>(null);

  const t = translations[lang];

  const scrollTo = (ref: React.RefObject<HTMLDivElement | null>) => {
    ref.current?.scrollIntoView({ behavior: "smooth" });
  };

  const handleDownload = () => {
    const ua = navigator.userAgent.toLowerCase();
    if (/iphone|ipad|ipod/.test(ua)) {
      window.open("https://apps.apple.com/app/yuvgo", "_blank");
    } else {
      window.open(
        "https://play.google.com/store/apps/details?id=uz.yuvgo.app",
        "_blank"
      );
    }
  };

  return (
    <div className="w-full bg-white overflow-x-hidden font-['Mulish',sans-serif]">
      {/* ===== HEADER ===== */}
      <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
        <div className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 h-[72px] flex items-center justify-between">
          <span className="text-[24px] md:text-[28px] font-black tracking-tight"><span className="text-[#00bffe]">Yuv</span><span className="text-[#0a0c13]">GO</span></span>

          <nav className="hidden md:flex items-center gap-6 lg:gap-8">
            <button
              onClick={() => scrollTo(partnersRef)}
              className="text-[15px] font-bold text-[#0a0c13] hover:text-[#00bffe] transition-colors cursor-pointer"
            >
              {t.nav.partners}
            </button>
            <button
              onClick={() => scrollTo(pricingRef)}
              className="text-[15px] font-bold text-[#0a0c13] hover:text-[#00bffe] transition-colors cursor-pointer"
            >
              {t.nav.pricing}
            </button>
            <button
              onClick={() => scrollTo(faqRef)}
              className="text-[15px] font-bold text-[#0a0c13] hover:text-[#00bffe] transition-colors cursor-pointer"
            >
              {t.nav.faq}
            </button>
          </nav>

          <div className="flex items-center gap-3">
            {/* Language Selector */}
            <div className="relative">
              <button
                onClick={() => setShowLangDropdown(!showLangDropdown)}
                className="flex items-center gap-2 px-3 py-2 rounded-lg bg-gray-50 hover:bg-gray-100 transition-colors cursor-pointer text-sm font-semibold"
              >
                <span>{langLabels[lang].flag}</span>
                <span className="hidden sm:inline">{langLabels[lang].name}</span>
                <svg
                  className={`w-4 h-4 transition-transform ${showLangDropdown ? "rotate-180" : ""}`}
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  strokeWidth="2"
                >
                  <path d="M6 9l6 6 6-6" />
                </svg>
              </button>
              {showLangDropdown && (
                <>
                  <div
                    className="fixed inset-0 z-40"
                    onClick={() => setShowLangDropdown(false)}
                  />
                  <div className="absolute right-0 top-full mt-2 bg-white rounded-xl shadow-xl border border-gray-100 overflow-hidden min-w-[160px] z-50">
                    {(["uz", "ru", "en"] as Language[]).map((l) => (
                      <button
                        key={l}
                        onClick={() => {
                          setLang(l);
                          setShowLangDropdown(false);
                        }}
                        className={`w-full px-4 py-3 flex items-center gap-3 hover:bg-gray-50 transition-colors cursor-pointer ${lang === l ? "bg-[#00bffe]/10" : ""}`}
                      >
                        <span className="text-lg">{langLabels[l].flag}</span>
                        <span className="text-[14px] font-semibold text-[#0a0c13]">
                          {langLabels[l].name}
                        </span>
                        {lang === l && (
                          <svg className="w-4 h-4 ml-auto text-[#00bffe]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5">
                            <path d="M5 13l4 4L19 7" />
                          </svg>
                        )}
                      </button>
                    ))}
                  </div>
                </>
              )}
            </div>

            {/* Download Button */}
            <button
              onClick={handleDownload}
              className="hidden sm:flex items-center gap-2 px-5 py-2.5 bg-[#ffd600] hover:bg-[#ffca00] text-[#0a0c13] rounded-2xl text-[14px] font-bold transition-colors cursor-pointer shadow-[0px_2px_20px_0px_rgba(255,214,0,0.25)]"
            >
              {t.nav.download}
            </button>
          </div>
        </div>
      </header>

      {/* ===== HERO ===== */}
      <section className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 py-10 md:py-16 lg:py-20">
        <div className="flex flex-col lg:flex-row items-center gap-10 lg:gap-16">
          <div className="flex-1 max-w-[560px]">
            <h1 className="text-[32px] md:text-[44px] lg:text-[56px] font-bold leading-[1.2] text-[#0a0c13]">
              {t.hero.titleBlack}
              <span className="text-[#00bffe]">{t.hero.titleCyan}</span>
            </h1>
            <p className="mt-4 text-[15px] text-[#646d79] leading-[1.5]">
              {t.hero.subtitle}
            </p>
            <button
              onClick={handleDownload}
              className="mt-8 px-8 py-4 bg-[#ffd600] hover:bg-[#ffca00] text-[#0a0c13] rounded-[20px] text-[15px] font-bold transition-colors cursor-pointer shadow-[0px_2px_20px_0px_rgba(255,214,0,0.25)]"
            >
              {t.hero.downloadBtn}
            </button>
            <div className="mt-8 flex items-center gap-3">
              <div className="flex -space-x-2">
                <img
                  src={imgAvatarTypes}
                  alt=""
                  className="w-9 h-9 rounded-full border-2 border-white"
                />
                <img
                  src={imgAvatarTypes1}
                  alt=""
                  className="w-9 h-9 rounded-full border-2 border-white"
                />
                <img
                  src={imgAvatarTypes2}
                  alt=""
                  className="w-9 h-9 rounded-full border-2 border-white"
                />
              </div>
              <div>
                <p className="text-[20px] font-bold text-[#0a0c13]">500+</p>
                <p className="text-[12px] text-[#0a0c13]">
                  {t.hero.clients}
                </p>
              </div>
            </div>
          </div>

          <div className="flex-1 relative max-w-[600px] w-full">
            <img
              src={imgPasteYourContent6}
              alt="YuvGO App"
              className="w-full h-auto max-h-[500px] object-contain"
            />
            {/* Floating stat badges */}
            <div className="absolute top-4 right-4 md:top-8 md:right-0 flex flex-col gap-3">
              <div className="bg-[#03142a] backdrop-blur-sm text-white px-4 py-2.5 rounded-xl shadow-lg text-[13px] font-bold flex items-center gap-2">
                <svg className="w-5 h-5 text-[#00bffe]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                  <path d="M12 3v18M8 6l4-3 4 3M4 7.38l16 9.24M20 16.62l-16-9.24" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
                {t.stats.washRating}
              </div>
              <div className="bg-[#03142a] backdrop-blur-sm text-white px-4 py-2.5 rounded-xl shadow-lg text-[13px] font-bold flex items-center gap-2">
                <svg className="w-5 h-5 text-[#00bffe]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                  <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2M9 7a4 4 0 1 0 0-8 4 4 0 0 0 0 8zM23 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
                {t.stats.subscribers}
              </div>
            </div>
            <div className="absolute bottom-4 left-4 md:bottom-8 md:left-0 flex flex-col gap-3">
              <div className="bg-[#03142a] backdrop-blur-sm text-white px-4 py-2.5 rounded-xl shadow-lg text-[13px] font-bold flex items-center gap-2">
                <svg className="w-5 h-5 text-[#00bffe]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                  <circle cx="12" cy="12" r="10" />
                  <path d="M12 6v6l4 2" strokeLinecap="round" strokeLinejoin="round" />
                </svg>
                {t.stats.carWashes}
              </div>
              <div className="bg-[#03142a] backdrop-blur-sm text-white px-4 py-2.5 rounded-xl shadow-lg text-[13px] font-bold flex items-center gap-2">
                <svg className="w-5 h-5 text-[#00bffe]" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5">
                  <path d="M12 2l2.4 7.4H22l-6.2 4.5 2.4 7.4L12 16.8l-6.2 4.5 2.4-7.4L2 9.4h7.6z" />
                </svg>
                {t.stats.premiumWashes}
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ===== PARTNERS LOGOS ===== */}
      <div
        ref={partnersRef}
        className="border-t border-b border-[#d9dde3] overflow-hidden"
      >
        <div className="max-w-[1440px] mx-auto px-6 md:px-16 py-6">
          <div className="flex items-center justify-center gap-8 md:gap-16 opacity-30 animate-scroll-logos">
            {[...Array(8)].map((_, i) => (
              <div
                key={i}
                className="h-10 w-[140px] bg-gray-300 rounded-lg flex-shrink-0"
              />
            ))}
          </div>
        </div>
      </div>

      {/* ===== FEATURES (3 cards) ===== */}
      <section className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 py-16 md:py-24">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 lg:gap-8">
          {t.features.items.map((item, i) => (
            <div
              key={i}
              className="bg-white rounded-[40px] md:rounded-[56px] p-8 relative overflow-hidden min-h-[220px] border border-gray-100 shadow-sm hover:shadow-md transition-shadow"
            >
              <div className="absolute top-[60px] right-[-16px] w-[160px] h-[160px] md:w-[200px] md:h-[200px] rounded-lg overflow-hidden">
                <img
                  src={featureImages[i]}
                  alt=""
                  className="w-full h-full object-cover"
                />
              </div>
              <div className="relative z-10 mt-auto pt-[100px] md:pt-[120px]">
                <h3 className="text-[22px] md:text-[26px] font-black text-[#0a0c13] leading-[1.2]">
                  {item.title}
                </h3>
                <p className="mt-3 text-[14px] md:text-[16px] text-[#8f96a0] leading-[1.4] max-w-[256px]">
                  {item.desc}
                </p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* ===== MORE FEATURES (2x2 grid) ===== */}
      <section className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 pb-16 md:pb-24">
        <div className="bg-white rounded-[40px] md:rounded-[56px] p-6 md:p-8 shadow-sm border border-gray-100">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6 lg:gap-8">
            {t.moreFeatures.map((item, i) => (
              <div
                key={i}
                className="bg-[#f2f2f2] rounded-[28px] md:rounded-[40px] overflow-hidden flex flex-col"
              >
                <div className="p-6 md:p-10 pb-4">
                  <h3 className="text-[28px] md:text-[36px] font-black text-[#0a0c13] leading-[1.2]">
                    {item.title}
                  </h3>
                  <p className="mt-3 text-[16px] md:text-[20px] text-[#646d79] leading-[1.3]">
                    {item.desc}
                  </p>
                </div>
                <div className="flex-1 min-h-[250px] md:min-h-[350px] relative overflow-hidden">
                  <img
                    src={moreFeatureImages[i]}
                    alt={item.title}
                    className="w-full h-full object-cover object-top"
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===== AI WASH PLAN ===== */}
      <section className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 pb-16 md:pb-24">
        <div className="bg-[#03142a] rounded-[40px] md:rounded-[80px] overflow-hidden relative">
          <div className="absolute top-[-200px] right-[-100px] w-[600px] h-[400px] bg-[#00bffe] blur-[190px] opacity-30 rounded-full" />
          <div className="absolute bottom-[-200px] left-[-150px] w-[400px] h-[400px] bg-[#00bffe] blur-[200px] opacity-20 rounded-full" />

          <div className="relative z-10 flex flex-col lg:flex-row items-center gap-8 lg:gap-0">
            <div className="flex-1 p-8 md:p-12 lg:p-20 lg:pr-8">
              <h2 className="text-[24px] md:text-[32px] font-black text-white leading-[1.2]">
                {t.washPlan.title}
              </h2>
              <p className="mt-4 text-[14px] md:text-[16px] text-white/60 leading-[1.4]">
                {t.washPlan.subtitle}
              </p>

              <div className="mt-8 flex flex-col gap-8">
                <div className="flex items-start gap-4">
                  <div className="bg-white rounded-full p-2.5 shadow flex-shrink-0">
                    <svg className="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="#0A0C13" strokeWidth="1.5">
                      <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9M13.73 21a2 2 0 0 1-3.46 0" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                  </div>
                  <div>
                    <h4 className="text-[20px] md:text-[23px] font-bold text-white">
                      {t.washPlan.info1title}
                    </h4>
                    <p className="mt-2 text-[14px] md:text-[16px] text-white/60 leading-[1.4]">
                      {t.washPlan.info1desc}
                    </p>
                  </div>
                </div>
                <div className="flex items-start gap-4">
                  <div className="bg-white rounded-full p-2.5 shadow flex-shrink-0">
                    <svg className="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="#0A0C13" strokeWidth="1.5">
                      <circle cx="12" cy="12" r="10" />
                      <path d="M8 14s1.5 2 4 2 4-2 4-2M9 9h.01M15 9h.01" strokeLinecap="round" strokeLinejoin="round" />
                    </svg>
                  </div>
                  <div>
                    <h4 className="text-[20px] md:text-[23px] font-bold text-white">
                      {t.washPlan.info2title}
                    </h4>
                    <p className="mt-2 text-[14px] md:text-[16px] text-white/60 leading-[1.4]">
                      {t.washPlan.info2desc}
                    </p>
                  </div>
                </div>
              </div>
            </div>

            <div className="flex-1 flex justify-center lg:justify-end">
              <img
                src={imgIPhone15Pro}
                alt="YuvGO AI"
                className="w-[300px] md:w-[400px] lg:w-[450px] h-auto object-contain"
              />
            </div>
          </div>
        </div>
      </section>

      {/* ===== PRICING ===== */}
      <section
        ref={pricingRef}
        className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 pb-16 md:pb-24"
      >
        <div className="bg-[#00bffe] rounded-[28px] md:rounded-[40px] p-6 md:p-10 lg:p-20 shadow-[0px_4px_14px_0px_rgba(0,191,254,0.3),0px_10px_15px_0px_rgba(0,122,255,0.2)] relative overflow-hidden">
          <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_0px_10px_18px_0px_rgba(255,255,255,0.1),inset_0px_4px_40px_0px_rgba(255,255,255,0.1)]" />

          <div className="text-center mb-10 relative z-10">
            <h2 className="text-[28px] md:text-[40px] font-black text-white leading-[1.2]">
              {t.pricing.title}
            </h2>
            <p className="mt-3 text-[14px] md:text-[15px] text-white/90">
              {t.pricing.subtitle}
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 relative z-10">
            {t.pricing.plans.map((plan, i) => (
              <div
                key={i}
                className="bg-white rounded-[24px] md:rounded-[32px] p-6 flex flex-col"
              >
                <div className="h-[140px] md:h-[180px] rounded-[18px] md:rounded-[24px] overflow-hidden mb-4">
                  <img
                    src={imgImage12}
                    alt=""
                    className="w-full h-full object-cover"
                  />
                </div>
                <h3 className="text-[20px] md:text-[23px] font-black text-[#0a0c13]">
                  {plan.period}
                </h3>
                <div className="mt-3 flex items-center gap-2">
                  <span className="text-[18px] md:text-[20px] font-black text-[#00bffe]">
                    {plan.price}
                  </span>
                  <span className="bg-[#0a0c13] text-white text-[12px] px-1.5 py-0.5 rounded-full font-bold">
                    {plan.discount}
                  </span>
                </div>
                <p className="text-[12px] text-[#8f96a0] font-bold mt-0.5">
                  {plan.oldPrice}
                </p>

                <div className="mt-4 border border-black/5 rounded-[15px] p-3 flex flex-col gap-3">
                  <div className="flex items-center gap-2">
                    <div className="bg-[#e5f9ff] rounded-lg p-1">
                      <svg className="w-5 h-5 text-[#00bffe]" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
                        <path d="M10 2a8 8 0 1 0 0 16 8 8 0 0 0 0-16z" strokeLinecap="round" />
                        <path d="M10 6v4l2.5 1.5" strokeLinecap="round" strokeLinejoin="round" />
                      </svg>
                    </div>
                    <span className="text-[14px] font-bold text-[#0a0c13]">
                      {t.pricing.badge1}
                    </span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="bg-[#e5f9ff] rounded-lg p-1">
                      <svg className="w-5 h-5 text-[#00bffe]" viewBox="0 0 20 20" fill="none" stroke="currentColor" strokeWidth="1.5">
                        <path d="M10 2l2 6h6l-5 3.5 2 6.5-5-4-5 4 2-6.5L2 8h6z" />
                      </svg>
                    </div>
                    <span className="text-[14px] font-bold text-[#0a0c13]">
                      {t.pricing.badge2}
                    </span>
                  </div>
                </div>

                <button
                  onClick={handleDownload}
                  className="mt-4 w-full py-3 bg-[#03142a] hover:bg-[#0a1f3a] text-white rounded-xl text-[15px] font-bold transition-colors cursor-pointer shadow-[0px_2px_20px_0px_rgba(0,0,0,0.25)]"
                >
                  {t.pricing.buyBtn}
                </button>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* ===== FAQ ===== */}
      <section
        ref={faqRef}
        className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 pb-16 md:pb-24"
      >
        <h2 className="text-[28px] md:text-[40px] font-black text-[#0a0c13] text-center mb-10">
          {t.faq.title}
        </h2>
        <div className="max-w-[856px] mx-auto flex flex-col gap-4">
          {t.faq.items.map((item, i) => (
            <div
              key={i}
              className="bg-[#f2f2f2] rounded-[20px] overflow-hidden cursor-pointer transition-shadow hover:shadow-md"
              onClick={() => setOpenFaqIndex(openFaqIndex === i ? -1 : i)}
            >
              <div className="flex items-center justify-between p-5 md:p-6">
                <span className="text-[16px] md:text-[20px] font-black text-[#0a0c13] leading-[1.3] pr-4">
                  {item.q}
                </span>
                <svg
                  className={`w-6 h-6 flex-shrink-0 transition-transform duration-300 ${openFaqIndex === i ? "" : "rotate-180"}`}
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="#0A0C13"
                  strokeWidth="1.5"
                >
                  <path
                    d="M16 14L12 10L8 14"
                    strokeLinecap="round"
                    strokeLinejoin="round"
                  />
                </svg>
              </div>
              <div
                className="overflow-hidden transition-all duration-300"
                style={{
                  maxHeight: openFaqIndex === i ? "500px" : "0px",
                }}
              >
                <p className="px-5 md:px-6 pb-5 md:pb-6 text-[14px] md:text-[15px] text-[#646d79] leading-[1.6]">
                  {item.a}
                </p>
              </div>
            </div>
          ))}
        </div>
      </section>

      {/* ===== CTA ===== */}
      <section className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 pb-16 md:pb-24">
        <div className="bg-[#03142a] rounded-[40px] md:rounded-[64px] p-8 md:p-16 overflow-hidden relative">
          <div className="absolute top-[-100px] right-[-100px] w-[400px] h-[400px] bg-[#00bffe] blur-[200px] opacity-20 rounded-full" />
          <div className="relative z-10 flex flex-col lg:flex-row items-center gap-8">
            <div className="flex-1">
              <h2 className="text-[28px] md:text-[36px] font-black text-white leading-[1.2]">
                {lang === "uz"
                  ? "Ilovani yuklab oling va mashinangizni biz bilan yuving"
                  : lang === "ru"
                    ? "Скачайте приложение и мойте машину вместе с нами"
                    : "Download the app and wash your car with us"}
              </h2>
              <div className="mt-8 flex flex-wrap gap-4">
                <button
                  onClick={() =>
                    window.open(
                      "https://apps.apple.com/app/yuvgo",
                      "_blank"
                    )
                  }
                  className="bg-white rounded-2xl px-6 py-3.5 flex items-center gap-3 hover:bg-gray-50 transition-colors cursor-pointer"
                >
                  <svg className="w-7 h-7" viewBox="0 0 24 24" fill="black">
                    <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
                  </svg>
                  <div className="text-left">
                    <p className="text-[10px] text-gray-500">Download on the</p>
                    <p className="text-[16px] font-bold text-[#0a0c13] -mt-0.5">
                      App Store
                    </p>
                  </div>
                </button>
                <button
                  onClick={() =>
                    window.open(
                      "https://play.google.com/store/apps/details?id=uz.yuvgo.app",
                      "_blank"
                    )
                  }
                  className="bg-white rounded-2xl px-6 py-3.5 flex items-center gap-3 hover:bg-gray-50 transition-colors cursor-pointer"
                >
                  <svg className="w-7 h-7" viewBox="0 0 24 24">
                    <path d="M3.609 1.814L13.792 12 3.61 22.186a.996.996 0 0 1-.61-.92V2.734a1 1 0 0 1 .609-.92z" fill="#00C3FF" />
                    <path d="M17.556 8.236l-3.764 3.764 3.764 3.764 4.252-2.42c.72-.41.72-1.108 0-1.517l-4.252-2.42z" fill="#FFCE00" />
                    <path d="M13.792 12L3.61 1.814l13.946 6.422L13.792 12z" fill="#00F076" />
                    <path d="M13.792 12l3.764 3.764L3.61 22.186 13.792 12z" fill="#F33C50" />
                  </svg>
                  <div className="text-left">
                    <p className="text-[10px] text-gray-500">Get it on</p>
                    <p className="text-[16px] font-bold text-[#0a0c13] -mt-0.5">
                      Google Play
                    </p>
                  </div>
                </button>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* ===== FOOTER ===== */}
      <footer className="bg-[#03142a] text-white">
        <div className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 py-12 md:py-16">
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-10">
            {/* Column 1: Partnership */}
            <div>
              <h4 className="text-[16px] font-black mb-4">
                {t.footer.partnership}
              </h4>
              <a
                href="mailto:partners@yuvgo.uz"
                className="block text-[14px] text-white/70 hover:text-[#00bffe] transition-colors mb-2"
              >
                {t.footer.partnerEmail}
              </a>
              <button
                onClick={() => scrollTo(faqRef)}
                className="block text-[14px] text-white/70 hover:text-[#00bffe] transition-colors cursor-pointer"
              >
                {t.footer.faqLink}
              </button>
            </div>

            {/* Column 2: Documents */}
            <div>
              <h4 className="text-[16px] font-black mb-4">
                {t.footer.documents}
              </h4>
              <a
                href="/terms"
                className="block text-[14px] text-white/70 hover:text-[#00bffe] transition-colors mb-2"
              >
                {t.footer.terms}
              </a>
              <a
                href="/offer"
                className="block text-[14px] text-white/70 hover:text-[#00bffe] transition-colors mb-2"
              >
                {t.footer.offer}
              </a>
              <a
                href="/privacy"
                className="block text-[14px] text-white/70 hover:text-[#00bffe] transition-colors mb-2"
              >
                {t.footer.privacy}
              </a>
              <a
                href="/agreement"
                className="block text-[14px] text-white/70 hover:text-[#00bffe] transition-colors"
              >
                {t.footer.agreement}
              </a>
            </div>

            {/* Column 3: Contacts */}
            <div>
              <h4 className="text-[16px] font-black mb-4">
                {t.footer.contacts}
              </h4>
              <a
                href="tel:+998789566961"
                className="block text-[14px] text-white/70 hover:text-[#00bffe] transition-colors mb-4"
              >
                {t.footer.phone}
              </a>
              <div className="flex gap-4">
                <a
                  href="https://instagram.com/yuvgo.uz"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center hover:bg-[#00bffe]/20 transition-colors"
                >
                  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="white">
                    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zM12 0C8.741 0 8.333.014 7.053.072 2.695.272.273 2.69.073 7.052.014 8.333 0 8.741 0 12c0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98C8.333 23.986 8.741 24 12 24c3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98C15.668.014 15.259 0 12 0zm0 5.838a6.162 6.162 0 100 12.324 6.162 6.162 0 000-12.324zM12 16a4 4 0 110-8 4 4 0 010 8zm6.406-11.845a1.44 1.44 0 100 2.881 1.44 1.44 0 000-2.881z" />
                  </svg>
                </a>
                <a
                  href="https://t.me/yuvgo_support"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center hover:bg-[#00bffe]/20 transition-colors"
                >
                  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="white">
                    <path d="M11.944 0A12 12 0 0 0 0 12a12 12 0 0 0 12 12 12 12 0 0 0 12-12A12 12 0 0 0 12 0a12 12 0 0 0-.056 0zm4.962 7.224c.1-.002.321.023.465.14a.506.506 0 0 1 .171.325c.016.093.036.306.02.472-.18 1.898-.962 6.502-1.36 8.627-.168.9-.499 1.201-.82 1.23-.696.065-1.225-.46-1.9-.902-1.056-.693-1.653-1.124-2.678-1.8-1.185-.78-.417-1.21.258-1.91.177-.184 3.247-2.977 3.307-3.23.007-.032.014-.15-.056-.212s-.174-.041-.249-.024c-.106.024-1.793 1.14-5.061 3.345-.479.33-.913.49-1.302.48-.428-.008-1.252-.241-1.865-.44-.752-.245-1.349-.374-1.297-.789.027-.216.325-.437.893-.663 3.498-1.524 5.83-2.529 6.998-3.014 3.332-1.386 4.025-1.627 4.476-1.635z" />
                  </svg>
                </a>
                <a
                  href="https://youtube.com/@yuvgo"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="w-10 h-10 bg-white/10 rounded-full flex items-center justify-center hover:bg-[#00bffe]/20 transition-colors"
                >
                  <svg className="w-5 h-5" viewBox="0 0 24 24" fill="white">
                    <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
                  </svg>
                </a>
              </div>
            </div>

            {/* Column 4: Download */}
            <div>
              <h4 className="text-[16px] font-black mb-4">
                {t.footer.download}
              </h4>
              <div className="flex flex-col gap-3">
                <button
                  onClick={() =>
                    window.open(
                      "https://apps.apple.com/app/yuvgo",
                      "_blank"
                    )
                  }
                  className="bg-white/10 rounded-2xl px-5 py-3 flex items-center gap-3 hover:bg-white/20 transition-colors cursor-pointer w-fit"
                >
                  <svg className="w-6 h-6" viewBox="0 0 24 24" fill="white">
                    <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
                  </svg>
                  <span className="text-[14px] font-bold">App Store</span>
                </button>
                <button
                  onClick={() =>
                    window.open(
                      "https://play.google.com/store/apps/details?id=uz.yuvgo.app",
                      "_blank"
                    )
                  }
                  className="bg-white/10 rounded-2xl px-5 py-3 flex items-center gap-3 hover:bg-white/20 transition-colors cursor-pointer w-fit"
                >
                  <svg className="w-6 h-6" viewBox="0 0 24 24">
                    <path d="M3.609 1.814L13.792 12 3.61 22.186a.996.996 0 0 1-.61-.92V2.734a1 1 0 0 1 .609-.92z" fill="#00C3FF" />
                    <path d="M17.556 8.236l-3.764 3.764 3.764 3.764 4.252-2.42c.72-.41.72-1.108 0-1.517l-4.252-2.42z" fill="#FFCE00" />
                    <path d="M13.792 12L3.61 1.814l13.946 6.422L13.792 12z" fill="#00F076" />
                    <path d="M13.792 12l3.764 3.764L3.61 22.186 13.792 12z" fill="#F33C50" />
                  </svg>
                  <span className="text-[14px] font-bold">Google Play</span>
                </button>
              </div>
            </div>
          </div>

          <div className="mt-12 pt-8 border-t border-white/10 flex flex-col md:flex-row items-center justify-between gap-4">
            <span className="text-[24px] font-black tracking-tight"><span className="text-[#00bffe]">Yuv</span><span className="text-white">GO</span></span>
            <p className="text-[13px] text-white/50">
              &copy; {new Date().getFullYear()} YuvGO. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
