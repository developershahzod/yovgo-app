import { useNavigate } from "react-router";

export default function NotFoundPage() {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-[#0a0c13] flex flex-col items-center justify-center px-6 text-center relative overflow-hidden">
      {/* Background glow effects */}
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-[#00bffe] blur-[200px] opacity-15 rounded-full pointer-events-none" />
      <div className="absolute bottom-0 right-0 w-[300px] h-[300px] bg-[#ffd600] blur-[180px] opacity-10 rounded-full pointer-events-none" />

      {/* 404 large text */}
      <div className="relative">
        <h1 className="text-[150px] md:text-[220px] lg:text-[280px] font-black leading-none text-transparent bg-clip-text bg-gradient-to-b from-[#00bffe] to-[#0a0c13] select-none">
          404
        </h1>
        {/* Car wash icon overlay */}
        <div className="absolute inset-0 flex items-center justify-center">
          <svg
            width="80"
            height="80"
            viewBox="0 0 24 24"
            fill="none"
            className="opacity-60"
          >
            {/* Water droplet */}
            <path
              d="M12 2C12 2 5 10 5 14.5C5 18.09 8.13 21 12 21C15.87 21 19 18.09 19 14.5C19 10 12 2 12 2Z"
              fill="#00bffe"
              fillOpacity="0.3"
              stroke="#00bffe"
              strokeWidth="1.5"
              strokeLinecap="round"
              strokeLinejoin="round"
            />
            <path
              d="M12 18C14.21 18 16 16.43 16 14.5"
              stroke="#00bffe"
              strokeWidth="1.5"
              strokeLinecap="round"
            />
          </svg>
        </div>
      </div>

      {/* Message */}
      <h2 className="text-[24px] md:text-[32px] font-bold text-white mt-2">
        Sahifa topilmadi
      </h2>
      <p className="text-[15px] md:text-[17px] text-[#646d79] mt-3 max-w-[460px] leading-relaxed">
        Kechirasiz, siz qidirayotgan sahifa mavjud emas yoki ko'chirilgan. Bosh sahifaga qaytib, davom eting.
      </p>

      {/* Buttons */}
      <div className="flex flex-col sm:flex-row items-center gap-4 mt-10">
        <button
          onClick={() => navigate("/")}
          className="px-8 py-4 bg-[#ffd600] hover:bg-[#ffca00] text-[#0a0c13] rounded-2xl text-[15px] font-bold transition-all cursor-pointer shadow-[0px_2px_20px_0px_rgba(255,214,0,0.25)] hover:shadow-[0px_4px_30px_0px_rgba(255,214,0,0.35)] active:scale-95"
        >
          Bosh sahifaga qaytish
        </button>
        <button
          onClick={() => navigate(-1)}
          className="px-8 py-4 bg-transparent border border-[#2a2d35] hover:border-[#00bffe] text-white rounded-2xl text-[15px] font-bold transition-all cursor-pointer hover:shadow-[0px_2px_20px_0px_rgba(0,191,254,0.15)] active:scale-95"
        >
          Orqaga qaytish
        </button>
      </div>

      {/* Footer hint */}
      <div className="absolute bottom-8 flex items-center gap-2 text-[#646d79] text-[13px]">
        <span className="font-bold text-[#00bffe]">YuvGO</span>
        <span>•</span>
        <span>Avtomobilingiz tozaligiga bo'lgan ishonchli yo'lingiz</span>
      </div>
    </div>
  );
}
