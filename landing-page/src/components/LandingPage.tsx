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
import imgIPhoneFrame from "figma:asset/614ed18f9655de59ca6019a83f0bb3044c50f676.png";
import imgScreen2 from "figma:asset/e68b5abe5ca6a65e951a1c703a75f6fcd1fbb31b.png";
import imgScreen3 from "figma:asset/8c8bc1f316ba39aaca52b4473656e190781d39eb.png";

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
        "Shahar bo'ylab premium avtomobil yuvish markazlariga bitta QR kod orqali kiring. Naqd pul yo'q, kutish yo'q, cheklovlar yo'q. Inqilobga qo'shiling.",
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
          <svg className="h-[24px] w-auto" viewBox="0 0 111 24" fill="none">
            <path d="M12.2179 16.6162V23.6547H7.04979V16.6959L0 5.0625H5.85716L9.67358 11.8354L13.5165 5.0625H19.2677L12.2179 16.6162Z" fill="#00BFFE"/>
            <path d="M22.6836 21.8752C21.1995 20.4586 20.4574 18.3338 20.4574 15.5007V5.0625H25.6785V15.3945C25.6785 16.7048 25.9788 17.6964 26.5796 18.3692C27.1803 19.0244 28.0196 19.3519 29.0974 19.3519C30.1928 19.3519 31.0321 19.0421 31.6151 18.4223C32.2159 17.7849 32.5162 16.8199 32.5162 15.5273V5.0625H37.7373V15.3679C37.7373 18.2718 36.9687 20.4409 35.4316 21.8752C33.9121 23.2917 31.783 24 29.0444 24C26.3057 24 24.1855 23.2917 22.6836 21.8752Z" fill="#00BFFE"/>
            <path d="M38.9515 5.0625H44.7026L48.9166 16.8287L53.1306 5.0625H58.7757L51.2489 23.7875H46.4783L38.9515 5.0625Z" fill="#00BFFE"/>
            <path d="M75.0463 17.5714C76.059 16.9341 76.6754 15.989 76.8955 14.7363H72.3384L73.164 10.0549H83.7973L83.5661 11.3736C82.7736 15.9011 81.1775 19.1429 78.7778 21.0989C76.3782 23.033 73.6703 24 70.6543 24C68.739 24 67.0218 23.5934 65.5028 22.7802C63.9837 21.9451 62.7949 20.7912 61.9363 19.3187C61.0777 17.8462 60.6484 16.1648 60.6484 14.2747C60.6484 13.5495 60.7145 12.7912 60.8466 12C61.2428 9.78022 62.1345 7.75824 63.5214 5.93407C64.9304 4.08791 66.6696 2.63736 68.739 1.58242C70.8304 0.527473 73.0539 0 75.4095 0C76.5323 0 77.633 0.0989011 78.7118 0.296703C79.8125 0.494506 80.7372 0.769231 81.4857 1.12088L80.2969 7.87912C79.5704 7.17582 78.7338 6.63736 77.7871 6.26374C76.8405 5.89011 75.8278 5.7033 74.7491 5.7033C73.5603 5.7033 72.4375 5.98901 71.3808 6.56044C70.324 7.10989 69.4434 7.86813 68.739 8.83517C68.0565 9.8022 67.6162 10.8681 67.4181 12.033C67.33 12.4725 67.286 12.9451 67.286 13.4506C67.286 14.9451 67.7153 16.1648 68.5739 17.1099C69.4545 18.033 70.5772 18.4945 71.9422 18.4945C73.0209 18.4945 74.0556 18.1868 75.0463 17.5714Z" fill="#03142A"/>
            <path d="M103.175 22.4176C101.149 23.4725 98.8266 24 96.2068 24C94.1374 24 92.2991 23.5714 90.692 22.7143C89.1069 21.8571 87.8741 20.6813 86.9935 19.1868C86.1349 17.6923 85.7056 16.011 85.7056 14.1429C85.7056 13.4396 85.7716 12.7253 85.9037 12C86.278 9.82418 87.1696 7.82418 88.5786 6C89.9875 4.15385 91.7377 2.69231 93.8291 1.61539C95.9206 0.538462 98.1331 0 100.467 0C102.514 0 104.33 0.417582 105.915 1.25275C107.523 2.08791 108.766 3.25275 109.647 4.74725C110.55 6.24176 111.001 7.92308 111.001 9.79121C111.001 10.5165 110.913 11.3407 110.737 12.2637C110.296 14.3956 109.438 16.3516 108.161 18.1319C106.884 19.9121 105.222 21.3407 103.175 22.4176ZM103.108 7.15385C102.294 6.23077 101.061 5.76923 99.41 5.76923C98.2652 5.76923 97.1974 6.05495 96.2068 6.62637C95.2381 7.17582 94.4236 7.92308 93.7631 8.86813C93.1027 9.79121 92.6734 10.8132 92.4752 11.9341C92.4092 12.3297 92.3762 12.7363 92.3762 13.1538C92.3762 14.6044 92.8165 15.8132 93.6971 16.7802C94.5777 17.7473 95.7555 18.2308 97.2305 18.2308C98.3753 18.2308 99.443 17.9451 100.434 17.3736C101.446 16.8022 102.283 16.044 102.943 15.0989C103.604 14.1319 104.033 13.0989 104.231 12C104.319 11.3846 104.363 10.9341 104.363 10.6484C104.363 9.21978 103.945 8.05495 103.108 7.15385Z" fill="#03142A"/>
          </svg>

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

          <div className="flex-1 relative max-w-[600px] w-full flex items-center justify-center" style={{ overflow: 'visible' }}>
            {/* Cyan glow behind phone */}
            <div className="absolute w-[350px] h-[350px] bg-[#00bffe] blur-[180px] opacity-30 rounded-full z-0" />
            {/* Single iPhone mockup with floating badges */}
            <div className="relative z-10 flex items-center justify-center" style={{ minHeight: '520px', overflow: 'visible' }}>
              {/* Phone */}
              <div className="relative" style={{ width: '280px', zIndex: 20 }}>
                <img src={imgIPhoneFrame} alt="" style={{ width: '100%', height: 'auto', display: 'block', position: 'relative', zIndex: 10 }} />
                <div style={{ position: 'absolute', top: '2.8%', left: '5.8%', right: '5.8%', bottom: '2.8%', borderRadius: '32px', overflow: 'hidden', zIndex: 5 }}>
                  <img src={imgPasteYourContent6} alt="YuvGO App" style={{ width: '100%', height: '100%', objectFit: 'cover' }} />
                </div>
              </div>

              {/* Floating badge: Car washes - top right */}
              <div className="hidden md:flex absolute items-center gap-2 bg-white rounded-full shadow-lg px-4 py-2.5 z-30"
                style={{ top: '20px', right: '0px' }}>
                <span className="text-[18px]">🚗</span>
                <span className="text-[13px] font-bold text-[#0a0c13] whitespace-nowrap">{t.stats.carWashes}</span>
              </div>

              {/* Floating badge: Wash rating - left middle */}
              <div className="hidden md:flex absolute items-center gap-2 bg-white rounded-full shadow-lg px-4 py-2.5 z-30"
                style={{ top: '42%', left: '-60px' }}>
                <span className="text-[18px]">✨</span>
                <span className="text-[13px] font-bold text-[#0a0c13] whitespace-nowrap">{t.stats.washRating}</span>
              </div>

              {/* Floating badge: Premium washes - bottom left */}
              <div className="hidden md:flex absolute items-center gap-2 bg-white rounded-full shadow-lg px-4 py-2.5 z-30"
                style={{ bottom: '60px', left: '-30px' }}>
                <span className="text-[18px]">🏆</span>
                <span className="text-[13px] font-bold text-[#0a0c13] whitespace-nowrap">{t.stats.premiumWashes}</span>
              </div>

              {/* Floating badge: Subscribers - bottom right */}
              <div className="hidden md:flex absolute items-center gap-2 bg-white rounded-full shadow-lg px-4 py-2.5 z-30"
                style={{ bottom: '30px', right: '-20px' }}>
                <span className="text-[18px]">👥</span>
                <span className="text-[13px] font-bold text-[#0a0c13] whitespace-nowrap">{t.stats.subscribers}</span>
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
          <div className="flex items-center justify-center gap-8 md:gap-16 flex-wrap">
            {/* Uzcard */}
            <div className="flex items-center gap-2 flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity">
              <svg className="h-8" viewBox="0 0 22 32" fill="none">
                <path clipRule="evenodd" d="M20.6044 10.0184H13.9044V0.574703C13.9044 0.259317 14.1572 0 14.4646 0H15.4679C15.4702 1.54736 16.0697 3.03147 17.1372 4.12721C18.2075 5.22226 19.6541 5.83747 21.1646 5.83747V10.0184H20.6044ZM21.1646 13.3519C21.1646 17.2904 20.2877 20.2254 18.5331 22.1383C16.7792 24.0511 14.0702 25.0051 10.4172 25.0051C7.00277 25.0051 4.41309 24.0511 2.64732 22.1383C0.881713 20.2254 0 17.3422 0 13.4857V0.548732C0 0.247189 0.238589 0 0.534823 0H6.72469C7.0186 0.0024 7.26018 0.247189 7.26018 0.548732V13.7686C7.26018 15.342 7.54476 16.5553 8.12074 17.408C9.01412 18.6213 10.6123 19.0266 11.9507 18.3806C12.3821 18.1714 12.7613 17.8651 13.0598 17.4858C13.6247 16.6825 13.9044 15.5023 13.9044 13.938V11.465H21.1646V13.3519Z" fillRule="evenodd" fill="#0F3560"/>
                <path clipRule="evenodd" d="M16.8963 0H20.6044C20.9142 0 21.1646 0.259317 21.1646 0.574703V4.38413C18.8088 4.38413 16.8963 2.42412 16.8963 0.0047869V0Z" fillRule="evenodd" fill="#F4821F"/>
              </svg>
              <span className="text-[14px] font-bold text-[#0a0c13]">UZCARD</span>
            </div>
            {/* Visa */}
            <div className="flex items-center flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity">
              <svg className="h-7" viewBox="0 0 50 32" fill="none">
                <rect width="50" height="32" rx="3" fill="#00579F"/>
                <path d="M22.467 21.235H19.388L21.314 10.2H24.392L22.467 21.235Z" fill="white"/>
                <path d="M33.626 10.47C33.018 10.247 32.055 10 30.865 10C27.825 10 25.684 11.503 25.671 13.651C25.646 15.236 27.204 16.116 28.369 16.645C29.56 17.185 29.965 17.537 29.965 18.019C29.953 18.758 29.002 19.099 28.116 19.099C26.887 19.099 26.229 18.923 25.228 18.512L24.822 18.335L24.392 20.813C25.114 21.118 26.444 21.388 27.825 21.4C31.055 21.4 33.158 19.921 33.182 17.631C33.195 16.375 32.372 15.412 30.599 14.626C29.522 14.121 28.863 13.78 28.863 13.264C28.875 12.794 29.42 12.313 30.636 12.313C31.636 12.29 32.372 12.512 32.929 12.736L33.207 12.853L33.626 10.47Z" fill="white"/>
                <path d="M37.717 17.326C37.97 16.692 38.946 14.238 38.946 14.238C38.933 14.262 39.199 13.593 39.351 13.182L39.566 14.133C39.566 14.133 40.149 16.774 40.276 17.326C39.794 17.326 38.325 17.326 37.717 17.326ZM41.517 10.2H39.136C38.401 10.2 37.844 10.399 37.527 11.116L32.954 21.235H36.184C36.184 21.235 36.716 19.873 36.83 19.58C37.185 19.58 40.327 19.58 40.783 19.58C40.871 19.967 41.15 21.235 41.15 21.235H44L41.517 10.2Z" fill="white"/>
                <path d="M16.817 10.2H13.803L13.473 16.199C12.916 14.438 11.168 12.525 9.217 11.573L11.979 21.224H15.234L20.072 10.2H16.817Z" fill="white"/>
                <path d="M11.003 10.2H6.051L6 10.423C9.863 11.339 12.422 13.546 13.473 16.199L12.397 11.128C12.219 10.423 11.675 10.223 11.003 10.2Z" fill="#FAA61A"/>
              </svg>
            </div>
            {/* MasterCard */}
            <div className="flex items-center flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity">
              <svg className="h-7" viewBox="0 0 50 32" fill="none">
                <rect width="50" height="32" rx="3" fill="#0F3560"/>
                <circle cx="20" cy="16" r="8" fill="#EB001B"/>
                <circle cx="30" cy="16" r="8" fill="#F79E1B"/>
                <path d="M25 10.072A7.97 7.97 0 0 1 28 16a7.97 7.97 0 0 1-3 5.928A7.97 7.97 0 0 1 22 16a7.97 7.97 0 0 1 3-5.928Z" fill="#FF5F00"/>
              </svg>
            </div>
            {/* Humo */}
            <div className="flex items-center flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity">
              <div className="bg-[#003B73] rounded-md px-3 py-1.5">
                <span className="text-white text-[14px] font-black tracking-wide">HUMO</span>
              </div>
            </div>
            {/* Payme */}
            <div className="flex items-center flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity">
              <div className="bg-[#33CCCC] rounded-md px-3 py-1.5">
                <span className="text-white text-[14px] font-black">Payme</span>
              </div>
            </div>
            {/* Click */}
            <div className="flex items-center flex-shrink-0 opacity-60 hover:opacity-100 transition-opacity">
              <div className="bg-[#00B4E6] rounded-md px-3 py-1.5">
                <span className="text-white text-[14px] font-black">Click</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* ===== FEATURES (3 cards) ===== */}
      <section className="max-w-[1440px] mx-auto px-6 md:px-10 lg:px-20 py-16 md:py-24">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 lg:gap-8">
          {t.features.items.map((item, i) => (
            <div
              key={i}
              className="bg-white rounded-[40px] md:rounded-[56px] p-8 relative overflow-hidden min-h-[280px] md:min-h-[320px] border border-gray-100 shadow-sm hover:shadow-md transition-shadow flex flex-col justify-end"
            >
              <div className="absolute top-[20px] right-[-10px] w-[140px] h-[140px] md:w-[170px] md:h-[170px] rounded-2xl overflow-hidden opacity-90">
                <img
                  src={featureImages[i]}
                  alt=""
                  className="w-full h-full object-cover"
                />
              </div>
              <div className="relative z-10">
                <h3 className="text-[22px] md:text-[26px] font-black text-[#0a0c13] leading-[1.2]">
                  {item.title}
                </h3>
                <p className="mt-3 text-[14px] md:text-[16px] text-[#8f96a0] leading-[1.5] max-w-[220px]">
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
            <svg className="h-[24px] w-auto" viewBox="0 0 148 32" fill="none">
              <path d="M16.2905 22.155V31.5396L9.39972 31.5396L9.39972 22.2612L0 6.75L7.80954 6.75L12.8981 15.7805L18.022 6.75L25.6902 6.75L16.2905 22.155Z" fill="#00BFFE"/>
              <path d="M30.2449 29.1669C28.266 27.2782 27.2765 24.4451 27.2765 20.6676V6.75L34.238 6.75V20.5259C34.238 22.273 34.6385 23.5951 35.4394 24.4923C36.2404 25.3658 37.3594 25.8026 38.7965 25.8026C40.2571 25.8026 41.3761 25.3894 42.1535 24.5631C42.9545 23.7132 43.355 22.4265 43.355 20.703V6.75L50.3164 6.75V20.4905C50.3164 24.3624 49.2917 27.2546 47.2421 29.1669C45.2161 31.0556 42.3773 32 38.7258 32C35.0743 32 32.2473 31.0556 30.2449 29.1669Z" fill="#00BFFE"/>
              <path d="M51.9353 6.75L59.6035 6.75L65.2221 22.4383L70.8408 6.75L78.3676 6.75L68.3318 31.7167H61.9711L51.9353 6.75Z" fill="#00BFFE"/>
              <path d="M100.06 23.4286C101.411 22.5788 102.233 21.3187 102.526 19.6484H96.4499L97.5507 13.4066L111.728 13.4066L111.42 15.1648C110.363 21.2015 108.235 25.5238 105.036 28.1319C101.836 30.7106 98.2258 32 94.2044 32C91.6507 32 89.3611 31.4579 87.3357 30.3736C85.3103 29.2601 83.7252 27.7216 82.5805 25.7582C81.4357 23.7949 80.8633 21.5531 80.8633 19.033C80.8633 18.0659 80.9513 17.0549 81.1275 16C81.6558 13.0403 82.8446 10.3443 84.6939 7.91209C86.5725 5.45055 88.8914 3.51648 91.6507 2.10989C94.4392 0.703297 97.4039 0 100.545 0C102.042 0 103.509 0.131868 104.948 0.395605C106.415 0.659341 107.648 1.02564 108.646 1.49451L107.061 10.5055C106.093 9.56777 104.977 8.84982 103.715 8.35165C102.453 7.85348 101.102 7.6044 99.6641 7.6044C98.079 7.6044 96.582 7.98535 95.1731 8.74725C93.7641 9.47985 92.59 10.4908 91.6507 11.7802C90.7407 13.0696 90.1536 14.4908 89.8894 16.044C89.772 16.63 89.7133 17.2601 89.7133 17.9341C89.7133 19.9267 90.2857 21.5531 91.4305 22.8132C92.6046 24.044 94.1017 24.6593 95.9216 24.6593C97.3599 24.6593 98.7395 24.2491 100.06 23.4286Z" fill="white"/>
              <path d="M137.565 29.8901C134.864 31.2967 131.767 32 128.274 32C125.515 32 123.064 31.4286 120.921 30.2857C118.808 29.1429 117.164 27.5751 115.99 25.5824C114.845 23.5897 114.273 21.348 114.273 18.8571C114.273 17.9194 114.361 16.967 114.537 16C115.036 13.0989 116.225 10.4322 118.103 8C119.982 5.53846 122.316 3.58974 125.104 2.15385C127.893 0.717949 130.843 0 133.954 0C136.684 0 139.106 0.556776 141.219 1.67033C143.362 2.78388 145.021 4.337 146.195 6.32967C147.398 8.32234 148 10.5641 148 13.0549C148 14.022 147.882 15.1209 147.648 16.3517C147.061 19.1941 145.916 21.8022 144.213 24.1758C142.511 26.5495 140.295 28.4542 137.565 29.8901ZM137.477 9.53846C136.391 8.30769 134.747 7.69231 132.545 7.69231C131.019 7.69231 129.595 8.07326 128.274 8.83517C126.983 9.56777 125.897 10.5641 125.016 11.8242C124.136 13.0549 123.563 14.4176 123.299 15.9121C123.211 16.4396 123.167 16.9817 123.167 17.5385C123.167 19.4725 123.754 21.0843 124.928 22.3736C126.102 23.663 127.673 24.3077 129.639 24.3077C131.166 24.3077 132.589 23.9267 133.91 23.1648C135.261 22.4029 136.376 21.3919 137.257 20.1319C138.137 18.8425 138.71 17.4652 138.974 16C139.091 15.1795 139.15 14.5788 139.15 14.1978C139.15 12.293 138.592 10.7399 137.477 9.53846Z" fill="white"/>
            </svg>
            <p className="text-[13px] text-white/50">
              &copy; {new Date().getFullYear()} YuvGO. All rights reserved.
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
}
