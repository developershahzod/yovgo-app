import svgPaths from "./svg-lwp6fhrt4q";

function Battery() {
  return (
    <div className="absolute contents right-[14.67px] top-[calc(50%+1px)] translate-y-[-50%]" data-name="Battery">
      <div className="absolute h-[11.333px] right-[17px] top-[calc(50%+1px)] translate-y-[-50%] w-[22px]" data-name="Rectangle">
        <div className="absolute inset-0" style={{ "--stroke-0": "rgba(10, 12, 19, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 22 11.3333">
            <path d={svgPaths.p7e6b880} id="Rectangle" opacity="0.35" stroke="var(--stroke-0, #0A0C13)" />
          </svg>
        </div>
      </div>
      <div className="absolute h-[4px] right-[14.67px] top-[calc(50%+1px)] translate-y-[-50%] w-[1.328px]" data-name="Combined Shape">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(10, 12, 19, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 1.32804 4">
            <path d={svgPaths.p32d253c0} fill="var(--fill-0, #0A0C13)" id="Combined Shape" opacity="0.4" />
          </svg>
        </div>
      </div>
      <div className="absolute h-[7.333px] right-[19px] top-[calc(50%+1px)] translate-y-[-50%] w-[18px]" data-name="Rectangle">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(10, 12, 19, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 18 7.33333">
            <path d={svgPaths.p3544af00} fill="var(--fill-0, #0A0C13)" id="Rectangle" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function TimeStyle() {
  return (
    <div className="absolute h-[21px] left-[21px] top-[calc(50%+0.5px)] translate-y-[-50%] w-[54px]" data-name="Time Style">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 54 21">
        <g id="Time Style">
          <g id="9:41">
            <path d={svgPaths.p631ad00} fill="var(--fill-0, #0A0C13)" />
            <path d={svgPaths.p15c89100} fill="var(--fill-0, #0A0C13)" />
            <path d={svgPaths.p2e6b3780} fill="var(--fill-0, #0A0C13)" />
            <path d={svgPaths.p21e5500} fill="var(--fill-0, #0A0C13)" />
          </g>
        </g>
      </svg>
    </div>
  );
}

function Statusbar() {
  return (
    <div className="absolute h-[44px] left-0 overflow-clip right-0 top-0" data-name="statusbar">
      <Battery />
      <div className="absolute h-[10.966px] right-[44.03px] top-[calc(50%+0.81px)] translate-y-[-50%] w-[15.272px]" data-name="Wifi">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(10, 12, 19, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 15.2725 10.966">
            <path d={svgPaths.p14e03d00} fill="var(--fill-0, #0A0C13)" id="Wifi" />
          </svg>
        </div>
      </div>
      <div className="absolute h-[10.667px] right-[64.33px] top-[calc(50%+1px)] translate-y-[-50%] w-[17px]" data-name="Mobile Signal">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(10, 12, 19, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 17 10.667">
            <path d={svgPaths.p2abaf680} fill="var(--fill-0, #0A0C13)" id="Mobile Signal" />
          </svg>
        </div>
      </div>
      <TimeStyle />
    </div>
  );
}

function Navbar() {
  return (
    <div className="absolute bottom-0 h-[34px] left-0 right-0" data-name="navbar">
      <div className="absolute h-[5px] left-[calc(50%+0.5px)] top-[calc(50%+6.5px)] translate-x-[-50%] translate-y-[-50%] w-[134px]" data-name="Rectangle">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(10, 12, 19, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 134 5">
            <path clipRule="evenodd" d={svgPaths.p1b107900} fill="var(--fill-0, #0A0C13)" fillRule="evenodd" id="Rectangle" />
          </svg>
        </div>
      </div>
    </div>
  );
}

function ButtonMin() {
  return (
    <div className="absolute backdrop-blur-[10px] bg-[#03142a] bottom-[42px] content-stretch flex gap-[6px] h-[50px] items-center justify-center left-1/2 p-[16px] rounded-[16px] shadow-[0px_2px_20px_0px_rgba(0,0,0,0.25)] translate-x-[-50%] w-[343px]" data-name="button-min">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[15px] text-white">
        <p className="css-ew64yg leading-[1.2]">Начинать</p>
      </div>
    </div>
  );
}

function Crown() {
  return (
    <div className="relative shrink-0 size-[40px]" data-name="crown">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 40 40">
        <g id="crown">
          <path clipRule="evenodd" d={svgPaths.p1143e5f0} fillRule="evenodd" id="Vector" stroke="var(--stroke-0, #00BFFE)" strokeWidth="2" />
        </g>
      </svg>
    </div>
  );
}

function Icon() {
  return (
    <div className="bg-[rgba(255,255,255,0.64)] content-stretch flex items-center p-[20px] relative rounded-[100px] shrink-0" data-name="Icon">
      <Crown />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_-2px_-2px_3px_0px_white,inset_2px_2px_3px_0px_white]" />
    </div>
  );
}

function Container() {
  return (
    <div className="bg-[rgba(255,255,255,0.32)] content-stretch flex gap-[10px] items-center p-[20px] relative rounded-[100px] shrink-0" data-name="Container">
      <div className="absolute left-[calc(50%+0.5px)] size-[120px] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="Blur">
        <div className="absolute inset-[-20%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 168 168">
            <g filter="url(#filter0_f_7_1113)" id="Blur">
              <circle cx="84" cy="84" fill="var(--fill-0, white)" fillOpacity="0.4" r="60" />
            </g>
            <defs>
              <filter colorInterpolationFilters="sRGB" filterUnits="userSpaceOnUse" height="168" id="filter0_f_7_1113" width="168" x="0" y="0">
                <feFlood floodOpacity="0" result="BackgroundImageFix" />
                <feBlend in="SourceGraphic" in2="BackgroundImageFix" mode="normal" result="shape" />
                <feGaussianBlur result="effect1_foregroundBlur_7_1113" stdDeviation="12" />
              </filter>
            </defs>
          </svg>
        </div>
      </div>
      <Icon />
    </div>
  );
}

function Content() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start relative shrink-0 text-center text-white w-full" data-name="Content">
      <p className="css-4hzbpn font-['Mulish:Black',sans-serif] font-black leading-[1.2] relative shrink-0 text-[18px] w-full">Автомойки премиум-класса</p>
      <div className="flex flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] relative shrink-0 text-[14px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Высококачественные услуги автомойки и бережное отношение к вашему автомобилю.</p>
      </div>
    </div>
  );
}

function Card() {
  return (
    <div className="bg-[#00bffe] content-stretch flex flex-col h-[360px] items-center justify-between pb-[24px] pt-[64px] px-[20px] relative rounded-[24px] shadow-[0px_4px_14px_0px_rgba(0,191,254,0.3)] shrink-0 w-[303px]" data-name="Card">
      <Container />
      <Content />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_0px_10px_18px_0px_rgba(255,255,255,0.06)]" />
    </div>
  );
}

function Group() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 40 40">
        <g id="Group">
          <g id="Path" />
          <path clipRule="evenodd" d={svgPaths.p2dc3f00} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path clipRule="evenodd" d={svgPaths.pdef6d70} fillRule="evenodd" id="Path_3" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path clipRule="evenodd" d={svgPaths.pe758900} fillRule="evenodd" id="Path_4" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p357a5280} id="Path_5" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p3f3a7b00} id="Path_6" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p29cc1600} id="Path_7" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p2829f680} id="Path_8" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p1bce5880} id="Path_9" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p313f4f80} id="Path_10" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p1a85b00} id="Path_11" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p1f174b80} id="Path_12" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p18bb9a80} id="Path_13" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
        </g>
      </svg>
    </div>
  );
}

function ShoppingEcommerceQrCode() {
  return (
    <div className="relative shrink-0 size-[40px]" data-name="Shopping, Ecommerce/Qr code">
      <Group />
    </div>
  );
}

function Icon1() {
  return (
    <div className="bg-[rgba(0,191,254,0.64)] content-stretch flex items-center p-[20px] relative rounded-[100px] shrink-0" data-name="Icon">
      <ShoppingEcommerceQrCode />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_-2px_-2px_3px_0px_white,inset_2px_2px_3px_0px_white]" />
    </div>
  );
}

function Container1() {
  return (
    <div className="bg-[rgba(0,191,254,0.32)] content-stretch flex gap-[10px] items-center p-[20px] relative rounded-[100px] shrink-0" data-name="Container">
      <div className="absolute left-[calc(50%+0.5px)] size-[120px] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="Blur">
        <div className="absolute inset-[-20%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 168 168">
            <g filter="url(#filter0_f_7_1088)" id="Blur">
              <circle cx="84" cy="84" fill="var(--fill-0, #00BFFE)" fillOpacity="0.4" r="60" />
            </g>
            <defs>
              <filter colorInterpolationFilters="sRGB" filterUnits="userSpaceOnUse" height="168" id="filter0_f_7_1088" width="168" x="0" y="0">
                <feFlood floodOpacity="0" result="BackgroundImageFix" />
                <feBlend in="SourceGraphic" in2="BackgroundImageFix" mode="normal" result="shape" />
                <feGaussianBlur result="effect1_foregroundBlur_7_1088" stdDeviation="12" />
              </filter>
            </defs>
          </svg>
        </div>
      </div>
      <Icon1 />
    </div>
  );
}

function Content1() {
  return (
    <div className="content-stretch flex flex-col gap-[12px] h-[81px] items-start relative shrink-0 text-[#00bffe] text-center w-full" data-name="Content">
      <p className="css-4hzbpn font-['Mulish:Bold',sans-serif] font-bold leading-[1.2] relative shrink-0 text-[20px] w-full">Tez va oson boshqaruv</p>
      <div className="flex flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] relative shrink-0 text-[14px] w-full">
        <p className="css-4hzbpn leading-[1.2]">QR-kodni skaner qilib, avtomobil yuvish jarayonini tez va oson boshqaring</p>
      </div>
    </div>
  );
}

function Card1() {
  return (
    <div className="bg-[#e5f9ff] content-stretch flex flex-col h-[360px] items-center justify-between pb-[24px] pt-[64px] px-[16px] relative rounded-[24px] w-[303px]" data-name="Card">
      <Container1 />
      <Content1 />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_0px_-1px_2px_0px_rgba(255,255,255,0.3)]" />
    </div>
  );
}

function Group1() {
  return (
    <div className="absolute inset-[-0.02%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 40.0167 40.0167">
        <g id="Group">
          <path d="M20.0101 15.0063V13.3389" id="Path" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d="M20.0101 25.0104V26.6778" id="Path_2" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p1a52b680} id="Path_3" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p942a400} id="a" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p942a400} id="a-2" stroke="var(--stroke-0, #FFEEEA)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <g id="Rectangle" />
        </g>
      </svg>
    </div>
  );
}

function Money() {
  return (
    <div className="relative shrink-0 size-[40px]" data-name="money">
      <Group1 />
    </div>
  );
}

function Icon2() {
  return (
    <div className="bg-[rgba(0,191,254,0.64)] content-stretch flex items-center p-[20px] relative rounded-[100px] shrink-0" data-name="Icon">
      <Money />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_-2px_-2px_3px_0px_white,inset_2px_2px_3px_0px_white]" />
    </div>
  );
}

function Container2() {
  return (
    <div className="bg-[rgba(0,191,254,0.32)] content-stretch flex gap-[10px] items-center p-[20px] relative rounded-[100px] shrink-0" data-name="Container">
      <div className="absolute left-[calc(50%+0.5px)] size-[120px] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="Blur">
        <div className="absolute inset-[-20%]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 168 168">
            <g filter="url(#filter0_f_7_1088)" id="Blur">
              <circle cx="84" cy="84" fill="var(--fill-0, #00BFFE)" fillOpacity="0.4" r="60" />
            </g>
            <defs>
              <filter colorInterpolationFilters="sRGB" filterUnits="userSpaceOnUse" height="168" id="filter0_f_7_1088" width="168" x="0" y="0">
                <feFlood floodOpacity="0" result="BackgroundImageFix" />
                <feBlend in="SourceGraphic" in2="BackgroundImageFix" mode="normal" result="shape" />
                <feGaussianBlur result="effect1_foregroundBlur_7_1088" stdDeviation="12" />
              </filter>
            </defs>
          </svg>
        </div>
      </div>
      <Icon2 />
    </div>
  );
}

function Content2() {
  return (
    <div className="content-stretch flex flex-col gap-[12px] h-[81px] items-start relative shrink-0 text-[#00bffe] text-center w-full" data-name="Content">
      <p className="css-4hzbpn font-['Mulish:Bold',sans-serif] font-bold leading-[1.2] relative shrink-0 text-[20px] w-full">Biz bilan pulingizni tejang</p>
      <div className="flex flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] relative shrink-0 text-[14px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Obuna xizmatidan foydalanib, avtomobil yuvishda kamroq xarajat qiling va muntazam pul tejang</p>
      </div>
    </div>
  );
}

function Card2() {
  return (
    <div className="bg-[#e5f9ff] content-stretch flex flex-col h-[360px] items-center justify-between pb-[24px] pt-[64px] px-[16px] relative rounded-[24px] w-[303px]" data-name="Card">
      <Container2 />
      <Content2 />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_0px_-1px_2px_0px_rgba(255,255,255,0.3)]" />
    </div>
  );
}

function Dots() {
  return (
    <div className="absolute bottom-0 h-[6px] left-[calc(50%+0.5px)] translate-x-[-50%] w-[26px]" data-name="dots">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 26 6">
        <g id="dots">
          <circle cx="3" cy="3" fill="var(--fill-0, #0A0C13)" id="2" r="3" />
          <circle cx="13" cy="3" fill="var(--fill-0, #0A0C13)" id="1" opacity="0.1" r="3" />
          <circle cx="23" cy="3" fill="var(--fill-0, #0A0C13)" id="3" opacity="0.1" r="3" />
        </g>
      </svg>
    </div>
  );
}

function Cards() {
  return (
    <div className="absolute content-stretch flex gap-[12px] h-[380px] items-start left-1/2 px-[20px] top-[156px] translate-x-[-50%] w-[343px]" data-name="Cards">
      <Card />
      <div className="flex h-[375.364px] items-center justify-center relative shrink-0 w-[321.426px]" style={{ "--transform-inner-width": "341.703125", "--transform-inner-height": "57" } as React.CSSProperties}>
        <div className="flex-none rotate-[3deg]">
          <Card1 />
        </div>
      </div>
      <div className="flex h-[375.364px] items-center justify-center relative shrink-0 w-[321.426px]" style={{ "--transform-inner-width": "426.46875", "--transform-inner-height": "57" } as React.CSSProperties}>
        <div className="flex-none rotate-[3deg]">
          <Card2 />
        </div>
      </div>
      <Dots />
    </div>
  );
}

function Text() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[13px] items-center leading-[0] left-[36px] text-center top-[592px] w-[303px]" data-name="text">
      <div className="flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center relative shrink-0 text-[#0a0c13] text-[26px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Добро пожаловать</p>
      </div>
      <div className="flex flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center relative shrink-0 text-[#646d79] text-[14px] w-full">
        <p className="css-4hzbpn leading-[1.2]">YuvGO позволяет быстро и удобно управлять услугами автомойки.</p>
      </div>
    </div>
  );
}

function LightBgDefault() {
  return (
    <div className="absolute h-[24px] left-[16px] top-1/2 translate-y-[-50%] w-[111px]" data-name="Light BG Default">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 111 24">
        <g id="Light BG Default">
          <g id="YUV">
            <path d={svgPaths.p1489e200} fill="var(--fill-0, #00BFFE)" />
            <path d={svgPaths.p11b80d00} fill="var(--fill-0, #00BFFE)" />
            <path d={svgPaths.p9963d00} fill="var(--fill-0, #00BFFE)" />
          </g>
          <g id="GO">
            <path d={svgPaths.p11d0cf00} fill="var(--fill-0, #03142A)" />
            <path d={svgPaths.p5ad6700} fill="var(--fill-0, #03142A)" />
          </g>
        </g>
      </svg>
    </div>
  );
}

function Flags() {
  return (
    <div className="h-[16px] relative shrink-0 w-[24px]" data-name="Flags">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 16">
        <g id="Flags">
          <g clipPath="url(#clip0_7_1084)">
            <rect fill="var(--fill-0, #1A47B8)" height="16" rx="3" width="24" />
            <path clipRule="evenodd" d="M0 10.6667H24V16H0V10.6667Z" fill="var(--fill-0, #F93939)" fillRule="evenodd" id="Vector" />
            <path clipRule="evenodd" d="M0 0H24V5.33333H0V0Z" fill="var(--fill-0, white)" fillRule="evenodd" id="Vector_2" />
          </g>
        </g>
        <defs>
          <clipPath id="clip0_7_1084">
            <rect fill="white" height="16" rx="3" width="24" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Chevron() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M8 10L12 14L16 10" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
        </g>
      </svg>
    </div>
  );
}

function Lang() {
  return (
    <div className="absolute content-stretch flex gap-[4px] items-center right-[16px] top-1/2 translate-y-[-50%]" data-name="Lang">
      <Flags />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[15px]">
        <p className="css-ew64yg leading-[1.2]">Русский</p>
      </div>
      <Chevron />
    </div>
  );
}

function Topbar() {
  return (
    <div className="absolute backdrop-blur-[10px] bg-[rgba(255,255,255,0.85)] h-[56px] left-0 top-[44px] w-[375px]" data-name="topbar">
      <LightBgDefault />
      <Lang />
    </div>
  );
}

export default function OnboardingDefault() {
  return (
    <div className="bg-white relative size-full" data-name="Onboarding_Default">
      <Statusbar />
      <Navbar />
      <ButtonMin />
      <Cards />
      <Text />
      <Topbar />
    </div>
  );
}