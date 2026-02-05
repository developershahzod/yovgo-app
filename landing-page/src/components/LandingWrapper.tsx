import { useState, useEffect } from "react";
import LandingOriginal from "../imports/Landing1920";

// Section positions in the original 1920px design (in pixels)
const SECTION_POSITIONS = {
  partners: 737,
  pricing: 2800,
  faq: 4953,
};

export default function LandingWrapper() {
  const [scale, setScale] = useState(1);
  const [openFaqIndex, setOpenFaqIndex] = useState(0);

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
          
          {/* ===== INVISIBLE CLICK OVERLAYS ===== */}
          
          {/* Header Navigation Buttons - Invisible overlays on top of original */}
          <div className="absolute top-[16px] left-[271px] flex items-center gap-[8px]" style={{ zIndex: 1000 }}>
            <button 
              onClick={() => scrollToPosition(SECTION_POSITIONS.partners)}
              className="w-[110px] h-[50px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="Hamkorlarga"
            />
            <button 
              onClick={() => scrollToPosition(SECTION_POSITIONS.pricing)}
              className="w-[70px] h-[50px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="Narxlar"
            />
            <button 
              onClick={() => scrollToPosition(SECTION_POSITIONS.faq)}
              className="w-[180px] h-[50px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="Savollar va javoblar"
            />
          </div>

          {/* Header Download Button (Yuklab olish) */}
          <div className="absolute top-[16px] right-[80px]" style={{ zIndex: 1000 }}>
            <button 
              onClick={handleDownload}
              className="w-[196px] h-[50px] cursor-pointer"
              style={{ background: 'transparent' }}
              aria-label="Yuklab olish"
            />
          </div>

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

          {/* FAQ Section - Click overlays for accordion */}
          <div className="absolute top-[5041px] left-[532px] w-[856px]" style={{ zIndex: 1000 }}>
            {[0, 1, 2, 3, 4].map((index) => (
              <button
                key={index}
                onClick={() => setOpenFaqIndex(openFaqIndex === index ? -1 : index)}
                className="w-full h-[80px] mb-[16px] cursor-pointer"
                style={{ background: 'transparent' }}
                aria-label={`FAQ ${index + 1}`}
              />
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