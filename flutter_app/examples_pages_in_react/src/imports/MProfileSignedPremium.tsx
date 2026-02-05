import svgPaths from "./svg-7lvxklbbkg";

function Battery() {
  return (
    <div className="absolute contents right-[14.67px] top-[calc(50%+1px)] translate-y-[-50%]" data-name="Battery">
      <div className="absolute h-[11.333px] right-[17px] top-[calc(50%+1px)] translate-y-[-50%] w-[22px]" data-name="Rectangle">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 22 11.3333">
          <path d={svgPaths.p7e6b880} id="Rectangle" opacity="0.35" stroke="var(--stroke-0, black)" />
        </svg>
      </div>
      <div className="absolute h-[4px] right-[14.67px] top-[calc(50%+1px)] translate-y-[-50%] w-[1.328px]" data-name="Combined Shape">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 1.32804 4">
          <path d={svgPaths.p32d253c0} fill="var(--fill-0, black)" id="Combined Shape" opacity="0.4" />
        </svg>
      </div>
      <div className="absolute h-[7.333px] right-[19px] top-[calc(50%+1px)] translate-y-[-50%] w-[18px]" data-name="Rectangle">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 18 7.33333">
          <path d={svgPaths.p3544af00} fill="var(--fill-0, black)" id="Rectangle" />
        </svg>
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
            <path d={svgPaths.p631ad00} fill="var(--fill-0, black)" />
            <path d={svgPaths.p15c89100} fill="var(--fill-0, black)" />
            <path d={svgPaths.p2e6b3780} fill="var(--fill-0, black)" />
            <path d={svgPaths.p21e5500} fill="var(--fill-0, black)" />
          </g>
        </g>
      </svg>
    </div>
  );
}

function Statusbar() {
  return (
    <div className="h-[44px] overflow-clip relative shrink-0 w-full" data-name="statusbar">
      <Battery />
      <div className="absolute h-[10.965px] right-[44.03px] top-[calc(50%+0.81px)] translate-y-[-50%] w-[15.272px]" data-name="Wifi">
        <div className="absolute inset-[0_0_-0.01%_0]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 15.2725 10.9661">
            <path d={svgPaths.p3e2fd100} fill="var(--fill-0, black)" id="Wifi" />
          </svg>
        </div>
      </div>
      <div className="absolute h-[10.667px] right-[64.33px] top-[calc(50%+1px)] translate-y-[-50%] w-[17px]" data-name="Mobile Signal">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 17 10.667">
          <path d={svgPaths.pb081600} fill="var(--fill-0, black)" id="Mobile Signal" />
        </svg>
      </div>
      <TimeStyle />
    </div>
  );
}

function Avatar() {
  return (
    <div className="relative shrink-0 size-[80px]" data-name="avatar">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 80 80">
        <g id="avatar">
          <path clipRule="evenodd" d={svgPaths.p379c0900} fill="url(#paint0_linear_6_7177)" fillRule="evenodd" id="stroke" />
          <g id="avatar-types">
            <circle cx="40.2174" cy="40.2174" fill="url(#paint1_linear_6_7177)" id="bound" r="35" />
            <g id="placeholder">
              <path d={svgPaths.p13e60400} fill="url(#paint2_linear_6_7177)" id="Intersect" />
              <g id="Intersect_2">
                <path d={svgPaths.p283834f2} fill="url(#paint3_radial_6_7177)" fillOpacity="0.7" style={{ mixBlendMode: "overlay" }} />
              </g>
            </g>
          </g>
        </g>
        <defs>
          <linearGradient gradientUnits="userSpaceOnUse" id="paint0_linear_6_7177" x1="14.0426" x2="87.5279" y1="-1.75448e-07" y2="43.8586">
            <stop stopColor="#00BFFE" />
            <stop offset="1" stopColor="#1098FF" />
          </linearGradient>
          <linearGradient gradientUnits="userSpaceOnUse" id="paint1_linear_6_7177" x1="40.2174" x2="40.2174" y1="5.21739" y2="75.2174">
            <stop stopColor="#F1F6FD" />
            <stop offset="1" stopColor="#E0E3E8" />
          </linearGradient>
          <linearGradient gradientUnits="userSpaceOnUse" id="paint2_linear_6_7177" x1="39.9993" x2="39.9993" y1="19.1309" y2="74.7828">
            <stop stopColor="#CFD6E6" />
            <stop offset="1" stopColor="#AEB7C8" />
          </linearGradient>
          <radialGradient cx="0" cy="0" gradientTransform="translate(39.8742 47.0511) rotate(90) scale(21.3482 35.2509)" gradientUnits="userSpaceOnUse" id="paint3_radial_6_7177" r="1">
            <stop />
            <stop offset="1" stopOpacity="0" />
          </radialGradient>
        </defs>
      </svg>
    </div>
  );
}

function Badges() {
  return (
    <div className="backdrop-blur-[10px] bg-[#e5f9ff] content-stretch flex gap-[4px] items-center justify-center px-[6px] py-[2px] relative rounded-[16px] shrink-0" data-name="Badges">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#00bffe] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">Obunachi</p>
      </div>
    </div>
  );
}

function Name() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[4px] items-start justify-center min-h-px min-w-px relative" data-name="name">
      <Badges />
      <div className="flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] min-w-full relative shrink-0 text-[#0a0c13] text-[18px] w-[min-content]">
        <p className="css-4hzbpn leading-[1.2]">Shakhzod Ismoilov</p>
      </div>
      <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] min-w-full relative shrink-0 text-[#646d79] text-[14px] w-[min-content]">+998 93 956 6961</p>
    </div>
  );
}

function Info() {
  return (
    <div className="content-stretch flex gap-[12px] items-center relative shrink-0 w-full" data-name="info">
      <Avatar />
      <Name />
    </div>
  );
}

function CarWash() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="car wash">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g clipPath="url(#clip0_6_7140)" id="car wash">
          <path d={svgPaths.p13ea9300} fill="var(--fill-0, #0A0C13)" id="Exclude" />
        </g>
        <defs>
          <clipPath id="clip0_6_7140">
            <rect fill="white" height="20" width="20" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Text() {
  return (
    <div className="content-stretch flex flex-col gap-[2px] items-start justify-center leading-[0] relative shrink-0" data-name="text">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center relative shrink-0 text-[#0a0c13] text-[15px]">
        <p className="css-ew64yg leading-[1.2]">12</p>
      </div>
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center relative shrink-0 text-[#8f96a0] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">Avto moykalar</p>
      </div>
    </div>
  );
}

function FactsCard() {
  return (
    <div className="bg-[#f2f2f2] flex-[1_0_0] min-h-px min-w-px relative rounded-[12px]" data-name="facts-card">
      <div className="flex flex-col justify-center size-full">
        <div className="content-stretch flex flex-col gap-[8px] items-start justify-center p-[12px] relative w-full">
          <CarWash />
          <Text />
        </div>
      </div>
    </div>
  );
}

function Trand() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="trand">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g clipPath="url(#clip0_6_7198)" id="trand">
          <path d={svgPaths.p1fb9df80} fill="var(--fill-0, #0A0C13)" id="Exclude" />
        </g>
        <defs>
          <clipPath id="clip0_6_7198">
            <rect fill="white" height="20" width="20" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Text1() {
  return (
    <div className="content-stretch flex flex-col gap-[2px] items-start justify-center leading-[0] relative shrink-0" data-name="text">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center relative shrink-0 text-[#0a0c13] text-[15px]">
        <p className="css-ew64yg leading-[1.2]">213</p>
      </div>
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center relative shrink-0 text-[#8f96a0] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">Tashriflar</p>
      </div>
    </div>
  );
}

function FactsCard1() {
  return (
    <div className="bg-[#f2f2f2] flex-[1_0_0] min-h-px min-w-px relative rounded-[12px]" data-name="facts-card">
      <div className="flex flex-col justify-center size-full">
        <div className="content-stretch flex flex-col gap-[8px] items-start justify-center p-[12px] relative w-full">
          <Trand />
          <Text1 />
        </div>
      </div>
    </div>
  );
}

function DollarSign() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="dollar sign">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g clipPath="url(#clip0_6_7211)" id="dollar sign">
          <path d={svgPaths.p2a51f5c0} fill="var(--fill-0, #0A0C13)" id="Exclude" />
        </g>
        <defs>
          <clipPath id="clip0_6_7211">
            <rect fill="white" height="20" width="20" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Text2() {
  return (
    <div className="content-stretch flex flex-col gap-[2px] items-start justify-center leading-[0] relative shrink-0" data-name="text">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center relative shrink-0 text-[#0a0c13] text-[15px]">
        <p className="css-ew64yg leading-[1.2]">240 000</p>
      </div>
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center relative shrink-0 text-[#8f96a0] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">Tejaldi (so’m)</p>
      </div>
    </div>
  );
}

function FactsCard2() {
  return (
    <div className="bg-[#f2f2f2] flex-[1_0_0] min-h-px min-w-px relative rounded-[12px]" data-name="facts-card">
      <div className="flex flex-col justify-center size-full">
        <div className="content-stretch flex flex-col gap-[8px] items-start justify-center p-[12px] relative w-full">
          <DollarSign />
          <Text2 />
        </div>
      </div>
    </div>
  );
}

function Info1() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="info">
      <FactsCard />
      <FactsCard1 />
      <FactsCard2 />
    </div>
  );
}

function TopBlock() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[16px] items-start pb-[16px] px-[16px] relative rounded-bl-[20px] rounded-br-[20px] shrink-0 w-[375px]" data-name="Top block">
      <Statusbar />
      <Info />
      <Info1 />
    </div>
  );
}

function Group() {
  return (
    <div className="absolute inset-[33.33%_8.31%_24.98%_8.31%]" data-name="Group">
      <div className="absolute inset-[-7.5%_-3.75%]">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 21.5101 11.5054">
          <g id="Group">
            <path d="M14.5287 9.75411H7.13672" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <circle cx="16.1062" cy="9.00464" id="Oval" r="1.75073" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <circle cx="5.38354" cy="9.00464" id="Oval_2" r="1.75073" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p3d57a280} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
        </svg>
      </div>
    </div>
  );
}

function Car() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="car">
      <Group />
    </div>
  );
}

function Group1() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Mening mashinalarim</p>
      </div>
    </div>
  );
}

function Label() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group1 />
    </div>
  );
}

function Chevron() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#646d79] text-[13px] text-right">
        <p className="css-ew64yg leading-[1.2]">3 ta</p>
      </div>
      <Chevron />
    </div>
  );
}

function MenuItem() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Car />
      <Label />
      <Suffix />
    </div>
  );
}

function History() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="history">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="history">
          <path d={svgPaths.p17176c00} id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p59f7818} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p20cfba00} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Group2() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Tashriflar tarixi</p>
      </div>
    </div>
  );
}

function Label1() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group2 />
    </div>
  );
}

function Chevron1() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix1() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <Chevron1 />
    </div>
  );
}

function MenuItem1() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <History />
      <Label1 />
      <Suffix1 />
    </div>
  );
}

function Cards() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="cards">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="cards">
          <path clipRule="evenodd" d={svgPaths.pb945c00} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M6 12H21" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p28279380} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M12 16H9" id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Group3() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Mening kartalarim</p>
      </div>
    </div>
  );
}

function Label2() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group3 />
    </div>
  );
}

function Chevron2() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix2() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#646d79] text-[13px] text-right">
        <p className="css-ew64yg leading-[1.2]">2</p>
      </div>
      <Chevron2 />
    </div>
  );
}

function MenuItem2() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Cards />
      <Label2 />
      <Suffix2 />
    </div>
  );
}

function List() {
  return (
    <div className="bg-white relative rounded-[20px] shrink-0 w-full" data-name="list">
      <div className="content-stretch flex flex-col gap-[12px] items-start px-[16px] py-[12px] relative w-full">
        <MenuItem />
        <MenuItem1 />
        <MenuItem2 />
      </div>
    </div>
  );
}

function Settings() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="settings">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="settings">
          <path d={svgPaths.p5f92850} id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p16dc5c00} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Group4() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Sozlamalar</p>
      </div>
    </div>
  );
}

function Label3() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group4 />
    </div>
  );
}

function Chevron3() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix3() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <Chevron3 />
    </div>
  );
}

function MenuItem3() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Settings />
      <Label3 />
      <Suffix3 />
    </div>
  );
}

function Rules() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="rules">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="rules">
          <path clipRule="evenodd" d={svgPaths.p3b5cbb00} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p1135ac98} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M7.99833 9.99917H16.0017" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M13.0004 16.0017H7.99833" id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M7.99833 13.0004H16.0017" id="Path_5" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Group5() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Maxfiylik siyosati</p>
      </div>
    </div>
  );
}

function Label4() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group5 />
    </div>
  );
}

function Chevron4() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix4() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <Chevron4 />
    </div>
  );
}

function MenuItem4() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Rules />
      <Label4 />
      <Suffix4 />
    </div>
  );
}

function Social() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="social">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="social">
          <path d={svgPaths.p35036400} id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p1974bc00} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Group6() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Telegram</p>
      </div>
    </div>
  );
}

function Label5() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group6 />
    </div>
  );
}

function Chevron5() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix5() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <Chevron5 />
    </div>
  );
}

function MenuItem5() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Social />
      <Label5 />
      <Suffix5 />
    </div>
  );
}

function Support() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="support">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="support">
          <path d={svgPaths.p39afc280} id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p8c358a0} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p34ae9140} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p30c7a620} id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p28a7d5c0} id="Path_5" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p4397360} id="Path_6" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p1ba2f860} id="Path_7" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Group7() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Yordam markazi</p>
      </div>
    </div>
  );
}

function Label6() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group7 />
    </div>
  );
}

function Chevron6() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix6() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <Chevron6 />
    </div>
  );
}

function MenuItem6() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Support />
      <Label6 />
      <Suffix6 />
    </div>
  );
}

function List1() {
  return (
    <div className="bg-white relative rounded-[20px] shrink-0 w-full" data-name="list">
      <div className="content-stretch flex flex-col gap-[12px] items-start px-[16px] py-[12px] relative w-full">
        <MenuItem3 />
        <MenuItem4 />
        <MenuItem5 />
        <MenuItem6 />
      </div>
    </div>
  );
}

function Blocks() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[8px] items-start left-0 right-0 top-0" data-name="blocks">
      <TopBlock />
      <List />
      <List1 />
    </div>
  );
}

function Navbar() {
  return (
    <div className="absolute bottom-0 h-[34px] left-0 right-0" data-name="navbar">
      <div className="absolute h-[5px] left-[calc(50%+0.5px)] top-[calc(50%+6.5px)] translate-x-[-50%] translate-y-[-50%] w-[134px]" data-name="Rectangle">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 134 5">
          <path clipRule="evenodd" d={svgPaths.p1b107900} fill="var(--fill-0, black)" fillRule="evenodd" id="Rectangle" />
        </svg>
      </div>
    </div>
  );
}

function MProfileSigned() {
  return (
    <div className="absolute bg-[#f2f2f2] inset-0" data-name="m_profile-signed">
      <Blocks />
      <Navbar />
    </div>
  );
}

function Home() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="home">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="home">
          <g id="Path" />
          <path d="M4 8.6V21H20V8.6" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M2 10L12 3L22 10" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3d1f8300} id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function NavItem() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <Home />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">Asosiy</p>
      </div>
    </div>
  );
}

function Map() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="map">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <path clipRule="evenodd" d={svgPaths.p3a6e9400} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M15 9.53V15.47" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M9 7.53V13.47" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_4" />
        </g>
      </svg>
    </div>
  );
}

function NavItem1() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <Map />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">Xarita</p>
      </div>
    </div>
  );
}

function Group8() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Path" />
          <path clipRule="evenodd" d="M6 6H10V10H6V6Z" fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d="M6 14H10V18H6V14Z" fillRule="evenodd" id="Path_3" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d="M18 10H14V6L18 6V10Z" fillRule="evenodd" id="Path_4" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p348e1a2a} id="Path_5" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3ee14d20} id="Path_6" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p2eee6b00} id="Path_7" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.pa10d3c0} id="Path_8" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p944df00} id="Path_9" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3c0ddb00} id="Path_10" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p36c54400} id="Path_11" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p22406700} id="Path_12" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p2b71cf98} id="Path_13" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Qr() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="qr">
      <Group8 />
    </div>
  );
}

function NavItem2() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center p-[4px] relative shrink-0 size-[64px]" data-name="nav-item">
      <div className="absolute bg-[#00bffe] inset-[-12.5%] opacity-1 rounded-[100px]" data-name="4" />
      <div className="absolute aspect-[64/64] bg-[#00bffe] left-0 opacity-20 right-0 rounded-[100px] top-1/2 translate-y-[-50%]" data-name="3" />
      <div className="absolute aspect-[76/76] bg-[#00bffe] left-[9.38%] opacity-1 right-[9.38%] rounded-[100px] top-1/2 translate-y-[-50%]" data-name="2" />
      <div className="absolute bg-[#00bffe] inset-[9.38%] opacity-99 rounded-[100px]" data-name="1" />
      <div className="absolute bg-[#00bffe] inset-[9.38%] rounded-[100px]" data-name="Main" />
      <Qr />
    </div>
  );
}

function Group9() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Path" />
          <path clipRule="evenodd" d={svgPaths.p1b608380} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p1392ba00} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p464900} id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p1ca71f80} fillRule="evenodd" id="Path_5" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Subscription() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="subscription">
      <Group9 />
    </div>
  );
}

function NavItem3() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <Subscription />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">Obuna</p>
      </div>
    </div>
  );
}

function Profile() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="profile">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="profile">
          <path d={svgPaths.p17ecbe80} id="Path" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <circle cx="12" cy="7" id="Oval" r="4" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function NavItem4() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <div className="absolute bg-[#00bffe] left-1/2 opacity-10 rounded-[8px] size-[30px] top-[calc(50%-8.5px)] translate-x-[-50%] translate-y-[-50%]" />
      <Profile />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#00bffe] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">Profil</p>
      </div>
    </div>
  );
}

function Menu() {
  return (
    <div className="h-[56px] relative shrink-0 w-full" data-name="menu">
      <div className="flex flex-row items-end size-full">
        <div className="content-stretch flex items-end justify-between pt-[8px] px-[16px] relative size-full">
          <NavItem />
          <NavItem1 />
          <NavItem2 />
          <NavItem3 />
          <NavItem4 />
        </div>
      </div>
    </div>
  );
}

function Navbar2() {
  return (
    <div className="h-[34px] relative shrink-0 w-full" data-name="navbar">
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

function Navbar1() {
  return (
    <div className="backdrop-blur-[10px] bg-[rgba(255,255,255,0.85)] content-stretch flex flex-col items-center justify-center relative rounded-tl-[22px] rounded-tr-[22px] shadow-[0px_-4px_25px_0px_rgba(0,0,0,0.2)] shrink-0 w-full" data-name="navbar">
      <Menu />
      <Navbar2 />
    </div>
  );
}

function Navigation() {
  return (
    <div className="absolute bottom-0 content-stretch flex flex-col gap-[16px] items-center justify-center left-0 w-[375px]" data-name="navigation">
      <Navbar1 />
    </div>
  );
}

export default function MProfileSignedPremium() {
  return (
    <div className="overflow-clip relative rounded-[40px] size-full" data-name="m_profile-signed-premium">
      <MProfileSigned />
      <Navigation />
    </div>
  );
}