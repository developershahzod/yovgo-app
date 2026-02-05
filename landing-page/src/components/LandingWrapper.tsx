import { useState, useEffect } from "react";
import LandingOriginal from "../imports/Landing1920";

type Language = 'uz' | 'ru' | 'en';

const langLabels: Record<Language, { name: string; flag: string }> = {
  uz: { name: "O'zb", flag: '🇺🇿' },
  ru: { name: 'Рус', flag: '🇷🇺' },
  en: { name: 'Eng', flag: '🇬🇧' },
};

// Translations for all text content
const translations: Record<Language, {
  nav: { partners: string; pricing: string; faq: string; download: string };
  hero: { title: string; subtitle: string; downloadBtn: string };
  features: { title: string; items: { title: string; desc: string }[] };
  pricing: { title: string; plans: { period: string; price: string; washes: string }[]; buyBtn: string; popular: string };
  faq: { title: string; items: { q: string; a: string }[] };
  cta: { title: string; subtitle: string };
  footer: { partnership: string; partnerEmail: string; faqLink: string; documents: string; terms: string; offer: string; privacy: string; agreement: string; contacts: string; download: string };
}> = {
  uz: {
    nav: { partners: 'Hamkorlarga', pricing: 'Narxlar', faq: 'Savollar va javoblar', download: 'Yuklab olish' },
    hero: { 
      title: "Avtomobilingizni yuvish uchun eng qulay ilova", 
      subtitle: "YUVGO - bu avtomobilingizni tez va sifatli yuvish uchun mo'ljallangan mobil ilova. Obuna sotib oling va istalgan vaqtda yuvishingiz mumkin.",
      downloadBtn: "Ilovani yuklab olish"
    },
    features: {
      title: "Nima uchun YUVGO?",
      items: [
        { title: "Premium avtomoykalar", desc: "Yuqori sifatli avtomobil yuvish xizmatlari va avtomobilingizga ehtiyotkor munosabat" },
        { title: "Bo'lib to'lash", desc: "Xohish o'zingizda, istasangiz bo'lib to'lang istasangiz hammasini to'lang" },
        { title: "Tez va qulay", desc: "Bir necha daqiqada obuna sotib oling va darhol foydalanishni boshlang" },
      ]
    },
    pricing: {
      title: "Narxlar",
      plans: [
        { period: "30 kun", price: "299,000", washes: "30 marta yuvish" },
        { period: "60 kun", price: "549,000", washes: "60 marta yuvish" },
        { period: "90 kun", price: "799,000", washes: "90 marta yuvish" },
      ],
      buyBtn: "Sotib olish",
      popular: "Mashhur"
    },
    faq: {
      title: "Savollar va javoblar",
      items: [
        { q: "Qanday qilib YUVGOdan foydalanish mumkin?", a: "YUVGO ilovasidan foydalanish uchun avval ilovani yuklab oling, ro'yxatdan o'ting va obuna sotib oling. Keyin QR kodni skanerlang va avtomobilingizni yuvishni boshlang." },
        { q: "Obuna muddati necha oy", a: "Obuna muddati 30, 60 yoki 90 kun bo'lishi mumkin. Siz o'zingizga qulay bo'lgan muddatni tanlashingiz mumkin." },
        { q: "Qanday qilib karta qo'shish mumkin?", a: "Ilovada 'Profil' bo'limiga o'ting, 'To'lov kartalari' ni tanlang va yangi karta qo'shing." },
        { q: "Obuna to'lovini bo'lib to'lash imkoniyati bormi?", a: "Ha, siz obuna to'lovini bo'lib to'lash imkoniyatidan foydalanishingiz mumkin." },
        { q: "Qanday qilib yangi avtomobil qo'shish mumkin", a: "Ilovada 'Profil' bo'limiga o'ting, 'Mening mashinalarim' ni tanlang va yangi avtomobil qo'shing." },
      ]
    },
    cta: { title: "Hoziroq boshlang!", subtitle: "YUVGO ilovasini yuklab oling va avtomobilingizni professional darajada yuvishdan bahramand bo'ling" },
    footer: { partnership: "Hamkorlik", partnerEmail: "partners@yuvgo.uz", faqLink: "Savollar va javoblar", documents: "Hujjatlar", terms: "Foydalanish shartlari", offer: "Oferta", privacy: "Maxfiylik siyosati", agreement: "Foydalanuvchi shartnomasi", contacts: "Kontaktlar", download: "Yuklab olish" }
  },
  ru: {
    nav: { partners: 'Партнёрам', pricing: 'Цены', faq: 'Вопросы и ответы', download: 'Скачать' },
    hero: { 
      title: "Самое удобное приложение для мойки автомобиля", 
      subtitle: "YUVGO - это мобильное приложение для быстрой и качественной мойки вашего автомобиля. Купите подписку и мойте в любое время.",
      downloadBtn: "Скачать приложение"
    },
    features: {
      title: "Почему YUVGO?",
      items: [
        { title: "Премиум автомойки", desc: "Высококачественные услуги мойки и бережное отношение к вашему автомобилю" },
        { title: "Рассрочка", desc: "Выбор за вами - платите в рассрочку или сразу" },
        { title: "Быстро и удобно", desc: "Купите подписку за несколько минут и начните пользоваться сразу" },
      ]
    },
    pricing: {
      title: "Цены",
      plans: [
        { period: "30 дней", price: "299,000", washes: "30 моек" },
        { period: "60 дней", price: "549,000", washes: "60 моек" },
        { period: "90 дней", price: "799,000", washes: "90 моек" },
      ],
      buyBtn: "Купить",
      popular: "Популярный"
    },
    faq: {
      title: "Вопросы и ответы",
      items: [
        { q: "Как пользоваться YUVGO?", a: "Чтобы использовать приложение YUVGO, сначала скачайте его, зарегистрируйтесь и купите подписку. Затем отсканируйте QR-код и начните мыть свой автомобиль." },
        { q: "Какой срок подписки?", a: "Срок подписки может составлять 30, 60 или 90 дней. Вы можете выбрать удобный для вас срок." },
        { q: "Как добавить карту?", a: "В приложении перейдите в раздел 'Профиль', выберите 'Платёжные карты' и добавьте новую карту." },
        { q: "Можно ли оплатить подписку в рассрочку?", a: "Да, вы можете воспользоваться возможностью оплаты подписки в рассрочку." },
        { q: "Как добавить новый автомобиль?", a: "В приложении перейдите в раздел 'Профиль', выберите 'Мои автомобили' и добавьте новый автомобиль." },
      ]
    },
    cta: { title: "Начните прямо сейчас!", subtitle: "Скачайте приложение YUVGO и наслаждайтесь профессиональной мойкой вашего автомобиля" },
    footer: { partnership: "Партнёрство", partnerEmail: "partners@yuvgo.uz", faqLink: "Вопросы и ответы", documents: "Документы", terms: "Условия использования", offer: "Оферта", privacy: "Политика конфиденциальности", agreement: "Пользовательское соглашение", contacts: "Контакты", download: "Скачать" }
  },
  en: {
    nav: { partners: 'Partners', pricing: 'Pricing', faq: 'FAQ', download: 'Download' },
    hero: { 
      title: "The most convenient app for car washing", 
      subtitle: "YUVGO is a mobile app for fast and quality car washing. Buy a subscription and wash anytime.",
      downloadBtn: "Download the app"
    },
    features: {
      title: "Why YUVGO?",
      items: [
        { title: "Premium car washes", desc: "High-quality car washing services and careful treatment of your car" },
        { title: "Installment payment", desc: "Your choice - pay in installments or all at once" },
        { title: "Fast and convenient", desc: "Buy a subscription in minutes and start using it right away" },
      ]
    },
    pricing: {
      title: "Pricing",
      plans: [
        { period: "30 days", price: "299,000", washes: "30 washes" },
        { period: "60 days", price: "549,000", washes: "60 washes" },
        { period: "90 days", price: "799,000", washes: "90 washes" },
      ],
      buyBtn: "Buy now",
      popular: "Popular"
    },
    faq: {
      title: "Frequently Asked Questions",
      items: [
        { q: "How to use YUVGO?", a: "To use the YUVGO app, first download it, register and buy a subscription. Then scan the QR code and start washing your car." },
        { q: "What is the subscription period?", a: "The subscription period can be 30, 60 or 90 days. You can choose the period that suits you." },
        { q: "How to add a card?", a: "In the app, go to 'Profile', select 'Payment cards' and add a new card." },
        { q: "Can I pay for the subscription in installments?", a: "Yes, you can use the installment payment option for the subscription." },
        { q: "How to add a new car?", a: "In the app, go to 'Profile', select 'My cars' and add a new car." },
      ]
    },
    cta: { title: "Start now!", subtitle: "Download the YUVGO app and enjoy professional car washing" },
    footer: { partnership: "Partnership", partnerEmail: "partners@yuvgo.uz", faqLink: "FAQ", documents: "Documents", terms: "Terms of use", offer: "Offer", privacy: "Privacy policy", agreement: "User agreement", contacts: "Contacts", download: "Download" }
  }
};

// Section positions in the original 1920px design (in pixels)
const SECTION_POSITIONS = {
  partners: 737,
  pricing: 2800,
  faq: 4953,
};

export default function LandingWrapper() {
  const [scale, setScale] = useState(1);
  const [openFaqIndex, setOpenFaqIndex] = useState(0);
  const [lang, setLang] = useState<Language>('uz');
  const [showLangDropdown, setShowLangDropdown] = useState(false);
  
  const t = translations[lang];

  useEffect(() => {
    const updateScale = () => {
      const windowWidth = window.innerWidth;
      const designWidth = 1920;
      const newScale = Math.min(windowWidth / designWidth, 1);
      setScale(newScale);
    };

    updateScale();
    window.addEventListener('resize', updateScale);
    return () => window.removeEventListener('resize', updateScale);
  }, []);

  const scrollToPosition = (position: number) => {
    const scaledPosition = position * scale;
    window.scrollTo({ top: scaledPosition, behavior: 'smooth' });
  };

  const handleDownload = () => {
    const userAgent = navigator.userAgent.toLowerCase();
    if (/iphone|ipad|ipod/.test(userAgent)) {
      window.open('https://apps.apple.com/app/yuvgo', '_blank');
    } else {
      window.open('https://play.google.com/store/apps/details?id=uz.yuvgo.app', '_blank');
    }
  };

  return (
    <div className="w-full bg-white overflow-x-hidden">
      {/* Scaled Landing Page - Original Design with Click Overlays */}
      <div 
        style={{
          transform: `scale(${scale})`,
          transformOrigin: 'top left',
          width: '1920px',
          height: `${6003 * scale}px`,
        }}
      >
        <div className="w-[1920px] h-[6003px] relative">
          {/* Original Figma Design */}
          <LandingOriginal />
          
          {/* ===== HEADER CLICK OVERLAYS ===== */}
          
          {/* Hamkorlarga button */}
          <button 
            onClick={() => scrollToPosition(SECTION_POSITIONS.partners)}
            className="absolute cursor-pointer"
            style={{ 
              top: '16px', 
              left: '271px', 
              width: '120px', 
              height: '50px', 
              background: 'transparent',
              zIndex: 1000 
            }}
            aria-label="Hamkorlarga"
          />
          
          {/* Narxlar button */}
          <button 
            onClick={() => scrollToPosition(SECTION_POSITIONS.pricing)}
            className="absolute cursor-pointer"
            style={{ 
              top: '16px', 
              left: '391px', 
              width: '80px', 
              height: '50px', 
              background: 'transparent',
              zIndex: 1000 
            }}
            aria-label="Narxlar"
          />
          
          {/* Savollar va javoblar button */}
          <button 
            onClick={() => scrollToPosition(SECTION_POSITIONS.faq)}
            className="absolute cursor-pointer"
            style={{ 
              top: '16px', 
              left: '471px', 
              width: '200px', 
              height: '50px', 
              background: 'transparent',
              zIndex: 1000 
            }}
            aria-label="Savollar va javoblar"
          />
          
          {/* Language Selector */}
          <div 
            className="absolute"
            style={{ top: '16px', right: '296px', zIndex: 1000 }}
          >
            <button 
              onClick={() => setShowLangDropdown(!showLangDropdown)}
              className="cursor-pointer"
              style={{ 
                width: '100px', 
                height: '50px', 
                background: 'transparent'
              }}
              aria-label="Change language"
            />
            
            {showLangDropdown && (
              <div className="absolute top-full right-0 mt-2 bg-white rounded-xl shadow-lg border border-gray-100 overflow-hidden min-w-[140px]">
                {(['uz', 'ru', 'en'] as Language[]).map((l) => (
                  <button
                    key={l}
                    onClick={() => { setLang(l); setShowLangDropdown(false); }}
                    className={`w-full px-4 py-3 flex items-center gap-3 hover:bg-gray-50 transition-colors cursor-pointer ${lang === l ? 'bg-[#00BFFE]/10' : ''}`}
                  >
                    <span className="text-lg">{langLabels[l].flag}</span>
                    <span className="text-[15px] font-semibold text-[#0a0c13]" style={{ fontFamily: "'Mulish', sans-serif" }}>{langLabels[l].name}</span>
                  </button>
                ))}
              </div>
            )}
          </div>

          {/* Download button (Yuklab olish) */}
          <button 
            onClick={handleDownload}
            className="absolute cursor-pointer rounded-[16px]"
            style={{ 
              top: '16px', 
              right: '80px', 
              width: '196px', 
              height: '50px', 
              background: 'transparent',
              zIndex: 1000 
            }}
            aria-label="Yuklab olish"
          />

          {/* Hero Section - "Ilovani yuklab olish" button */}
          <div className="absolute top-[350px] left-[80px]" style={{ zIndex: 1000 }}>
            <button 
              onClick={handleDownload}
              className="w-[220px] h-[56px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="Ilovani yuklab olish"
            />
          </div>

          {/* Hero Section - App Store badges */}
          <div className="absolute top-[430px] left-[80px] flex gap-[16px]" style={{ zIndex: 1000 }}>
            <button 
              onClick={() => window.open('https://apps.apple.com/app/yuvgo', '_blank')}
              className="w-[180px] h-[56px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="App Store"
            />
            <button 
              onClick={() => window.open('https://play.google.com/store/apps/details?id=uz.yuvgo.app', '_blank')}
              className="w-[180px] h-[56px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="Google Play"
            />
          </div>

          {/* CTA Section Download Buttons (around y=4400) */}
          <div className="absolute top-[4450px] left-[700px] flex gap-[16px]" style={{ zIndex: 1000 }}>
            <button 
              onClick={() => window.open('https://apps.apple.com/app/yuvgo', '_blank')}
              className="w-[180px] h-[56px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="App Store"
            />
            <button 
              onClick={() => window.open('https://play.google.com/store/apps/details?id=uz.yuvgo.app', '_blank')}
              className="w-[180px] h-[56px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="Google Play"
            />
          </div>

          {/* FAQ Section - Interactive accordion overlay */}
          <div className="absolute top-[5041px] left-[532px] w-[856px]" style={{ zIndex: 1000 }}>
            {t.faq.items.map((faq, index) => (
              <div 
                key={index}
                className="cursor-pointer"
                style={{ marginBottom: '20px' }}
                onClick={() => setOpenFaqIndex(openFaqIndex === index ? -1 : index)}
              >
                <div 
                  className="rounded-[20px] overflow-hidden transition-all duration-300"
                  style={{ 
                    backgroundColor: '#f2f2f2',
                    boxShadow: openFaqIndex === index ? '0 4px 12px rgba(0,0,0,0.1)' : 'none'
                  }}
                >
                  <div 
                    className="flex items-center justify-between"
                    style={{ padding: '24px 28px' }}
                  >
                    <span 
                      className="font-black text-[#0a0c13]" 
                      style={{ 
                        fontFamily: "'Mulish', sans-serif",
                        fontSize: '20px',
                        lineHeight: '1.3',
                        paddingRight: '16px'
                      }}
                    >
                      {faq.q}
                    </span>
                    <svg 
                      className="flex-shrink-0 transition-transform duration-300" 
                      style={{
                        width: '24px',
                        height: '24px',
                        transform: openFaqIndex === index ? 'rotate(0deg)' : 'rotate(180deg)'
                      }}
                      viewBox="0 0 24 24" 
                      fill="none" 
                      stroke="#0A0C13" 
                      strokeWidth="1.5"
                    >
                      <path d="M16 14L12 10L8 14" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                  </div>
                  <div 
                    style={{ 
                      maxHeight: openFaqIndex === index ? '500px' : '0px',
                      overflow: 'hidden',
                      transition: 'max-height 0.3s ease-in-out'
                    }}
                  >
                    <div 
                      className="text-[#646d79]" 
                      style={{ 
                        fontFamily: "'Mulish', sans-serif",
                        fontSize: '16px',
                        lineHeight: '1.6',
                        padding: '0 28px 24px 28px'
                      }}
                    >
                      {faq.a}
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>

          {/* Footer Links - positioned at bottom of page (6003px - 424px = 5579px) */}
          <div className="absolute" style={{ top: '5579px', left: '80px', width: '1760px', height: '424px', zIndex: 1000 }}>
            
            {/* Hamkorlik section - Column 1 */}
            <div className="absolute" style={{ left: '0px', top: '100px' }}>
              <a 
                href="mailto:partners@yuvgo.uz" 
                className="block cursor-pointer"
                style={{ width: '280px', height: '40px', background: 'transparent' }}
              />
              <button 
                onClick={() => scrollToPosition(SECTION_POSITIONS.faq)}
                className="block cursor-pointer"
                style={{ width: '220px', height: '40px', marginTop: '12px', background: 'transparent' }}
              />
            </div>

            {/* Hujjatlar section - Column 2 */}
            <div className="absolute" style={{ left: '350px', top: '100px' }}>
              <a href="/terms" className="block cursor-pointer" style={{ width: '220px', height: '35px', background: 'transparent' }} />
              <a href="/offer" className="block cursor-pointer" style={{ width: '180px', height: '35px', marginTop: '10px', background: 'transparent' }} />
              <a href="/privacy" className="block cursor-pointer" style={{ width: '200px', height: '35px', marginTop: '10px', background: 'transparent' }} />
              <a href="/agreement" className="block cursor-pointer" style={{ width: '220px', height: '35px', marginTop: '10px', background: 'transparent' }} />
            </div>

            {/* Kontaktlar section - Column 3 */}
            <div className="absolute" style={{ left: '700px', top: '100px' }}>
              <a href="tel:+998789566961" className="block cursor-pointer" style={{ width: '200px', height: '35px', background: 'transparent' }} />
            </div>

            {/* Social links - Column 3 bottom */}
            <div className="absolute flex" style={{ left: '700px', top: '180px', gap: '16px' }}>
              <a 
                href="https://instagram.com/yuvgo.uz" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="cursor-pointer"
                style={{ width: '48px', height: '48px', background: 'transparent' }}
              />
              <a 
                href="https://t.me/yuvgo_support" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="cursor-pointer"
                style={{ width: '48px', height: '48px', background: 'transparent' }}
              />
              <a 
                href="https://youtube.com/@yuvgo" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="cursor-pointer"
                style={{ width: '48px', height: '48px', background: 'transparent' }}
              />
            </div>

            {/* Footer App Store buttons - Column 4 */}
            <div className="absolute flex" style={{ left: '1100px', top: '100px', gap: '20px' }}>
              <button 
                onClick={() => window.open('https://apps.apple.com/app/yuvgo', '_blank')}
                className="cursor-pointer"
                style={{ width: '200px', height: '60px', background: 'transparent' }}
              />
              <button 
                onClick={() => window.open('https://play.google.com/store/apps/details?id=uz.yuvgo.app', '_blank')}
                className="cursor-pointer"
                style={{ width: '200px', height: '60px', background: 'transparent' }}
              />
            </div>
          </div>
        </div>
      </div>

    </div>
  );
}