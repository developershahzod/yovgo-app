import { useState, useEffect } from "react";
import LandingOriginal from "../imports/Landing1920";

type Language = 'uz' | 'ru' | 'en';

const langLabels: Record<Language, { name: string; flag: string }> = {
  uz: { name: "O'zb", flag: '🇺🇿' },
  ru: { name: 'Рус', flag: '🇷🇺' },
  en: { name: 'Eng', flag: '🇬🇧' },
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
            {[
              { q: "Qanday qilib YUVGOdan foydalanish mumkin?", a: "YUVGO ilovasidan foydalanish uchun avval ilovani yuklab oling, ro'yxatdan o'ting va obuna sotib oling. Keyin QR kodni skanerlang va avtomobilingizni yuvishni boshlang." },
              { q: "Obuna muddati necha oy", a: "Obuna muddati 30, 60 yoki 90 kun bo'lishi mumkin. Siz o'zingizga qulay bo'lgan muddatni tanlashingiz mumkin." },
              { q: "Qanday qilib karta qo'shish mumkin?", a: "Ilovada 'Profil' bo'limiga o'ting, 'To'lov kartalari' ni tanlang va yangi karta qo'shing." },
              { q: "Obuna to'lovini bo'lib to'lash imkoniyati bormi?", a: "Ha, siz obuna to'lovini bo'lib to'lash imkoniyatidan foydalanishingiz mumkin." },
              { q: "Qanday qilib yangi avtomobil qo'shish mumkin", a: "Ilovada 'Profil' bo'limiga o'ting, 'Mening mashinalarim' ni tanlang va yangi avtomobil qo'shing." },
            ].map((faq, index) => (
              <div 
                key={index}
                className="mb-[16px] cursor-pointer"
                onClick={() => setOpenFaqIndex(openFaqIndex === index ? -1 : index)}
              >
                <div className="bg-[#f2f2f2] rounded-[20px] overflow-hidden transition-all duration-300">
                  <div className="flex items-center justify-between p-[24px]">
                    <span className="text-[20px] font-black text-[#0a0c13]" style={{ fontFamily: "'Mulish', sans-serif" }}>
                      {faq.q}
                    </span>
                    <svg 
                      className={`w-6 h-6 transition-transform duration-300 flex-shrink-0 ${openFaqIndex === index ? '' : 'rotate-180'}`} 
                      viewBox="0 0 24 24" 
                      fill="none" 
                      stroke="#0A0C13" 
                      strokeWidth="1.5"
                    >
                      <path d="M16 14L12 10L8 14" strokeLinecap="round" strokeLinejoin="round"/>
                    </svg>
                  </div>
                  {openFaqIndex === index && (
                    <div className="px-[24px] pb-[24px] text-[15px] text-[#646d79]" style={{ fontFamily: "'Mulish', sans-serif" }}>
                      {faq.a}
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>

          {/* Footer Links */}
          <div className="absolute bottom-0 left-[240px] w-[1440px] h-[424px]" style={{ zIndex: 1000 }}>
            {/* Hamkorlik section */}
            <div className="absolute left-[170px] top-[80px]">
              <a 
                href="mailto:partners@yuvgo.uz" 
                className="block w-[250px] h-[35px] cursor-pointer"
                style={{ background: 'transparent' }}
              />
              <button 
                onClick={() => scrollToPosition(SECTION_POSITIONS.faq)}
                className="block w-[200px] h-[35px] cursor-pointer mt-[8px]"
                style={{ background: 'transparent' }}
              />
            </div>

            {/* Hujjatlar section */}
            <div className="absolute left-[460px] top-[80px]">
              <a href="/terms" className="block w-[200px] h-[30px] cursor-pointer" style={{ background: 'transparent' }} />
              <a href="/offer" className="block w-[150px] h-[30px] cursor-pointer mt-[8px]" style={{ background: 'transparent' }} />
              <a href="/privacy" className="block w-[150px] h-[30px] cursor-pointer mt-[8px]" style={{ background: 'transparent' }} />
              <a href="/agreement" className="block w-[180px] h-[30px] cursor-pointer mt-[8px]" style={{ background: 'transparent' }} />
            </div>

            {/* Kontaktlar section */}
            <div className="absolute left-[750px] top-[80px]">
              <a href="tel:+998789566961" className="block w-[180px] h-[30px] cursor-pointer" style={{ background: 'transparent' }} />
            </div>

            {/* Social links */}
            <div className="absolute left-[750px] top-[200px] flex gap-[12px]">
              <a 
                href="https://instagram.com/yuvgo.uz" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="w-[40px] h-[40px] cursor-pointer"
                style={{ background: 'transparent' }}
              />
              <a 
                href="https://t.me/yuvgo_support" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="w-[40px] h-[40px] cursor-pointer"
                style={{ background: 'transparent' }}
              />
              <a 
                href="https://youtube.com/@yuvgo" 
                target="_blank" 
                rel="noopener noreferrer" 
                className="w-[40px] h-[40px] cursor-pointer"
                style={{ background: 'transparent' }}
              />
            </div>

            {/* Footer App Store buttons */}
            <div className="absolute left-[1060px] top-[80px] flex gap-[16px]">
              <button 
                onClick={() => window.open('https://apps.apple.com/app/yuvgo', '_blank')}
                className="w-[180px] h-[56px] cursor-pointer"
                style={{ background: 'transparent' }}
              />
              <button 
                onClick={() => window.open('https://play.google.com/store/apps/details?id=uz.yuvgo.app', '_blank')}
                className="w-[180px] h-[56px] cursor-pointer"
                style={{ background: 'transparent' }}
              />
            </div>
          </div>
        </div>
      </div>

    </div>
  );
}