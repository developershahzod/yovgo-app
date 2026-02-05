import svgPaths from "./svg-zg14zepwgw";
import imgRectangle3 from "figma:asset/af4f3f12083748892aa8cce089849a9c6258d073.png";
import imgRectangle4 from "figma:asset/72736a3105b93be09268e4ff3f9cf58a4e3a202e.png";
import imgImage from "figma:asset/194b66145883c040db1229c8b27859f09f39f78f.png";
import imgImage1 from "figma:asset/4b1424abcdb0e2bc7c588b386fefdd18f7346127.png";
import imgImage2 from "figma:asset/c5a726432db7596ee5d4f6a73b2e16ddb181dc11.png";
import imgImage3 from "figma:asset/f1b5f4ba675e1a1231397f69c960d551e8586a15.png";

function PinRight() {
  return (
    <div className="absolute h-[12px] right-[13px] top-[calc(50%+1px)] translate-y-[-50%] w-[67.272px]" data-name="Pin Right">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 67.2725 12">
        <g clipPath="url(#clip0_1_2914)" id="Pin Right">
          <path d={svgPaths.p17d48900} fill="var(--fill-0, #161616)" id="Mobile Signal" />
          <path d={svgPaths.p24d75c00} fill="var(--fill-0, #161616)" id="Wifi" />
          <g id="Battery">
            <g id="Border" opacity="0.4">
              <path clipRule="evenodd" d={svgPaths.p2a8e080} fill="var(--fill-0, #161616)" fillRule="evenodd" />
              <path d={svgPaths.p2c54ff00} fill="var(--fill-0, #161616)" />
            </g>
            <path clipRule="evenodd" d={svgPaths.p17951900} fill="var(--fill-0, #161616)" fillRule="evenodd" id="Charge" />
          </g>
        </g>
        <defs>
          <clipPath id="clip0_1_2914">
            <rect fill="white" height="12" width="67.2725" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function IOsStatusBar() {
  return (
    <div className="h-[44px] relative shrink-0 w-full" data-name="iOS Status Bar">
      <PinRight />
      <div className="absolute css-g0mm18 flex flex-col font-['SF_Pro_Text:Semibold',sans-serif] justify-center leading-[0] left-[28px] not-italic text-[#161616] text-[15px] top-[calc(50%+1px)] tracking-[-0.2px] translate-y-[-50%]">
        <p className="css-ew64yg leading-[normal]">9:41</p>
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

function Group() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Path"></g>
          <path clipRule="evenodd" d={svgPaths.p39ce2c00} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M10.5 21H13.5" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Bell() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Bell">
      <Group />
    </div>
  );
}

function Badge() {
  return (
    <div className="absolute content-stretch flex flex-col items-center justify-center right-[4px] top-[4px]" data-name="badge">
      <div className="absolute left-0 size-[20px] top-0" data-name="bound">
        <div className="absolute inset-[-5%]" style={{ "--fill-0": "rgba(252, 62, 62, 1)", "--stroke-0": "rgba(255, 255, 255, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 22 22">
            <g id="bound">
              <circle cx="11" cy="11" fill="var(--fill-0, #FC3E3E)" r="10" />
              <circle cx="11" cy="11" r="10.5" stroke="var(--stroke-0, white)" strokeOpacity="0.85" />
            </g>
          </svg>
        </div>
      </div>
      <div className="flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 size-[20px] text-[10px] text-center text-white">
        <p className="css-4hzbpn leading-[1.2]">10</p>
      </div>
    </div>
  );
}

function NavItem() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[2px] items-center justify-center overflow-clip p-[4px] right-[4px] size-[48px] top-1/2 translate-y-[-50%]" data-name="nav-item">
      <Bell />
      <Badge />
    </div>
  );
}

function Group1() {
  return (
    <div className="absolute inset-[-0.02%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24.01 24.01">
        <g id="Group">
          <path clipRule="evenodd" d={svgPaths.p35bf3880} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <g id="Rectangle"></g>
        </g>
      </svg>
    </div>
  );
}

function Bookmark() {
  return (
    <div className="absolute left-[295px] size-[24px] top-[16px]" data-name="bookmark">
      <Group1 />
    </div>
  );
}

function Topbar() {
  return (
    <div className="backdrop-blur-[10px] bg-[rgba(255,255,255,0.85)] h-[56px] relative shrink-0 w-full" data-name="topbar">
      <LightBgDefault />
      <NavItem />
      <Bookmark />
    </div>
  );
}

function Crown() {
  return (
    <div className="relative shrink-0 size-[14px]" data-name="crown">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 14 14">
        <g id="crown">
          <path clipRule="evenodd" d={svgPaths.p3b2aa000} fill="var(--fill-0, white)" fillRule="evenodd" id="Vector" />
        </g>
      </svg>
    </div>
  );
}

function Container() {
  return (
    <div className="bg-[rgba(255,255,255,0.1)] content-stretch flex gap-[4px] items-center px-[12px] py-[4px] relative rounded-[16777200px] shrink-0" data-name="Container">
      <Crown />
      <p className="css-ew64yg font-['Mulish:Bold',sans-serif] font-bold leading-[1.2] relative shrink-0 text-[#ffeeea] text-[12px] uppercase">Premium</p>
    </div>
  );
}

function Frame5() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start leading-[1.2] relative shrink-0 text-[#ffeeea]">
      <p className="css-ew64yg font-['Mulish:Black',sans-serif] font-black relative shrink-0 text-[20px]">90 kunlik</p>
      <p className="css-ew64yg font-['Mulish:Regular',sans-serif] font-normal relative shrink-0 text-[12px]">Tugaydi: Yanvar 15</p>
    </div>
  );
}

function Container1() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start relative shrink-0 w-[174px]" data-name="Container">
      <Container />
      <Frame5 />
    </div>
  );
}

function Security() {
  return (
    <div className="relative shrink-0 size-[28px]" data-name="Security">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 28 28">
        <g id="Group">
          <g id="Path"></g>
          <path d={svgPaths.pc74c700} fill="var(--fill-0, white)" id="Exclude" />
        </g>
      </svg>
    </div>
  );
}

function Container2() {
  return (
    <div className="content-stretch flex items-start justify-between relative shrink-0 w-[303px]" data-name="Container">
      <Container1 />
      <Security />
    </div>
  );
}

function Group2() {
  return (
    <div className="absolute inset-[-0.02%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24.01 24.01">
        <g id="Group">
          <path d="M12.006 9.00375V8.00333" id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d="M12.006 15.0063V16.0067" id="Path_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p18e6cae0} id="Path_3" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.pad7a680} id="a" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.pad7a680} id="a-2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <g id="Rectangle"></g>
        </g>
      </svg>
    </div>
  );
}

function Money() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="money">
      <Group2 />
    </div>
  );
}

function Price() {
  return (
    <div className="content-stretch flex font-['Mulish:Black',sans-serif] font-black gap-[2px] items-baseline leading-[0] relative shrink-0 text-center text-white w-full" data-name="price">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[16px]">
        <p className="css-ew64yg leading-[1.2]">120 000</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[14px]">
        <p className="css-ew64yg leading-[1.2]">so’m</p>
      </div>
    </div>
  );
}

function Container3() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start justify-center relative shrink-0" data-name="Container">
      <p className="css-ew64yg font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] relative shrink-0 text-[#ffeeea] text-[12px]">Tejalgan pul</p>
      <Price />
    </div>
  );
}

function Frame3() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full">
      <Money />
      <Container3 />
    </div>
  );
}

function Frame() {
  return (
    <div className="bg-[rgba(255,255,255,0.15)] flex-[1_0_0] min-h-px min-w-px relative rounded-[20px]">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start px-[12px] py-[10px] relative w-full">
          <Frame3 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(255,255,255,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function History() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="history">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="history">
          <path d={svgPaths.p17176c00} id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p59f7818} id="Path_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p20cfba00} id="Path_3" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
        </g>
      </svg>
    </div>
  );
}

function Container4() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start justify-center relative shrink-0 text-[#ffeeea]" data-name="Container">
      <p className="css-ew64yg font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] relative shrink-0 text-[12px]">Shu oy tashriflari</p>
      <p className="css-ew64yg font-['Mulish:Black',sans-serif] font-black leading-[0] relative shrink-0 text-[0px]">
        <span className="leading-[1.2] text-[16px]">8/</span>
        <span className="leading-[1.2] text-[12px]">12</span>
      </p>
    </div>
  );
}

function Frame4() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full">
      <History />
      <Container4 />
    </div>
  );
}

function Frame1() {
  return (
    <div className="bg-[rgba(255,255,255,0.15)] flex-[1_0_0] min-h-px min-w-px relative rounded-[20px]">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start px-[12px] py-[10px] relative w-full">
          <Frame4 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(255,255,255,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Frame2() {
  return (
    <div className="content-stretch flex gap-[4px] items-center justify-center relative shrink-0 w-full">
      <Frame />
      <Frame1 />
    </div>
  );
}

function Container5() {
  return (
    <div className="bg-[#00bffe] content-stretch flex flex-col gap-[20px] items-center overflow-clip pb-[4px] pt-[20px] px-[4px] relative rounded-[24px] shadow-[0px_4px_14px_-4px_rgba(0,191,254,0.3),0px_10px_15px_-3px_rgba(0,122,255,0.2)] shrink-0 w-[343px]" data-name="Container">
      <Container2 />
      <Frame2 />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_0px_10px_18px_0px_rgba(255,255,255,0.1),inset_0px_4px_40px_0px_rgba(255,255,255,0.1),inset_0px_-1px_2px_0px_rgba(255,255,255,0.3)]" />
    </div>
  );
}

function Chart() {
  return (
    <div className="h-[38px] relative shrink-0 w-[60px]" data-name="Chart">
      <div className="absolute left-0 size-[60px] top-[2px]">
        <div className="absolute inset-[0_0_44.19%_0]">
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 60 33.4881">
            <path d={svgPaths.p303c3280} fill="url(#paint0_linear_1_2842)" id="Ellipse 2037" />
            <defs>
              <linearGradient gradientUnits="userSpaceOnUse" id="paint0_linear_1_2842" x1="57.6923" x2="1.73078" y1="30" y2="30">
                <stop stopColor="#5CCC27" />
                <stop offset="0.5" stopColor="#FFD600" />
                <stop offset="1" stopColor="#D22929" />
              </linearGradient>
            </defs>
          </svg>
        </div>
      </div>
      <div className="absolute left-[1.07px] size-[57.857px] top-[3.07px]">
        <div className="absolute inset-[34.29%_1.49%_57.85%_90.46%]" style={{ "--fill-0": "rgba(255, 255, 255, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 4.65467 4.54685">
            <path d={svgPaths.pe6507c0} fill="var(--fill-0, white)" id="Ellipse 2036" />
          </svg>
        </div>
      </div>
      <div className="absolute css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] left-[17px] text-[#0a0c13] text-[12px] top-[29px] translate-y-[-50%]">
        <p className="css-ew64yg leading-[1.2]">92%</p>
      </div>
    </div>
  );
}

function Chevron() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, #8F96A0)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Container6() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="Container">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
        <p className="css-4hzbpn leading-[1.2]">Yuvish reytingi</p>
      </div>
      <Chevron />
    </div>
  );
}

function Content() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[4px] items-start justify-center min-h-px min-w-px relative" data-name="Content">
      <Container6 />
      <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] relative shrink-0 text-[#8f96a0] text-[12px] w-full">3 kun davomida yog‘ingarchilik kutilmaydi. Yuvish uchun mukammal havo!</p>
    </div>
  );
}

function WashRating() {
  return (
    <div className="content-stretch flex gap-[12px] items-center relative shrink-0 w-full" data-name="Wash rating">
      <Chart />
      <Content />
    </div>
  );
}

function WeatherClimate() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Weather, Climate">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <g id="Path">
              <path clipRule="evenodd" d={svgPaths.p8e6a080} fill="var(--fill-0, #FFD600)" fillRule="evenodd" />
              <path d={svgPaths.p8e6a080} stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            </g>
            <path d="M12 4V2" id="Path_2" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M12 22V20" id="Path_3" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18.36 5.64L19.07 4.93" id="Path_4" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M4.93 19.07L5.64 18.36" id="Path_5" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M20 12H22" id="Path_6" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M2 12H4" id="Path_7" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18.36 18.36L19.07 19.07" id="Path_8" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M4.93 4.93L5.64 5.64" id="Path_9" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_10"></g>
        </g>
      </svg>
    </div>
  );
}

function Frame12() {
  return (
    <div className="content-stretch flex flex-col font-['Mulish:Bold',sans-serif] font-bold gap-[4px] items-start leading-[0] relative shrink-0 text-[11px] text-center">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#8f96a0]">
        <p className="css-ew64yg leading-[1.2]">+24°</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#0a0c13]">
        <p className="css-ew64yg leading-[1.2]">92%</p>
      </div>
    </div>
  );
}

function Day() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[8px] items-center p-[12px] relative rounded-[24px] shrink-0 w-[47px]" data-name="Day">
      <div aria-hidden="true" className="absolute border border-[#1d99f2] border-solid inset-0 pointer-events-none rounded-[24px]" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">11</p>
      </div>
      <WeatherClimate />
      <Frame12 />
    </div>
  );
}

function WeatherClimate1() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Weather, Climate">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <g id="Path">
              <path clipRule="evenodd" d={svgPaths.p8e6a080} fill="var(--fill-0, #FFD600)" fillRule="evenodd" />
              <path d={svgPaths.p8e6a080} stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            </g>
            <path d="M12 4V2" id="Path_2" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M12 22V20" id="Path_3" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18.36 5.64L19.07 4.93" id="Path_4" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M4.93 19.07L5.64 18.36" id="Path_5" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M20 12H22" id="Path_6" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M2 12H4" id="Path_7" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18.36 18.36L19.07 19.07" id="Path_8" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M4.93 4.93L5.64 5.64" id="Path_9" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_10"></g>
        </g>
      </svg>
    </div>
  );
}

function Frame13() {
  return (
    <div className="content-stretch flex flex-col font-['Mulish:Bold',sans-serif] font-bold gap-[4px] items-start leading-[0] relative shrink-0 text-[11px] text-center">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#8f96a0]">
        <p className="css-ew64yg leading-[1.2]">+24°</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#0a0c13]">
        <p className="css-ew64yg leading-[1.2]">85%</p>
      </div>
    </div>
  );
}

function Day1() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[8px] items-center p-[12px] relative rounded-[24px] shrink-0 w-[47px]" data-name="Day">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[24px]" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">12</p>
      </div>
      <WeatherClimate1 />
      <Frame13 />
    </div>
  );
}

function WeatherClimate2() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Weather, Climate">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <g id="Path">
              <path clipRule="evenodd" d={svgPaths.p8e6a080} fill="var(--fill-0, #FFD600)" fillRule="evenodd" />
              <path d={svgPaths.p8e6a080} stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            </g>
            <path d="M12 4V2" id="Path_2" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M12 22V20" id="Path_3" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18.36 5.64L19.07 4.93" id="Path_4" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M4.93 19.07L5.64 18.36" id="Path_5" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M20 12H22" id="Path_6" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M2 12H4" id="Path_7" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18.36 18.36L19.07 19.07" id="Path_8" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M4.93 4.93L5.64 5.64" id="Path_9" stroke="var(--stroke-0, #FFD600)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_10"></g>
        </g>
      </svg>
    </div>
  );
}

function Frame14() {
  return (
    <div className="content-stretch flex flex-col font-['Mulish:Bold',sans-serif] font-bold gap-[4px] items-start leading-[0] relative shrink-0 text-[11px] text-center">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#8f96a0]">
        <p className="css-ew64yg leading-[1.2]">+24°</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#0a0c13]">
        <p className="css-ew64yg leading-[1.2]">98%</p>
      </div>
    </div>
  );
}

function Day2() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[8px] items-center p-[12px] relative rounded-[24px] shrink-0 w-[47px]" data-name="Day">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[24px]" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">13</p>
      </div>
      <WeatherClimate2 />
      <Frame14 />
    </div>
  );
}

function WeatherClimate3() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Weather, Climate">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <path d={svgPaths.p316adc00} id="Path" stroke="var(--stroke-0, #1D99F2)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p13b80e40} id="Path_2" stroke="var(--stroke-0, #1D99F2)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p99e6900} id="Path_3" stroke="var(--stroke-0, #1D99F2)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_4"></g>
        </g>
      </svg>
    </div>
  );
}

function Frame15() {
  return (
    <div className="content-stretch flex flex-col font-['Mulish:Bold',sans-serif] font-bold gap-[4px] items-start leading-[0] relative shrink-0 text-[11px] text-center">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#8f96a0]">
        <p className="css-ew64yg leading-[1.2]">+24°</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#0a0c13]">
        <p className="css-ew64yg leading-[1.2]">36%</p>
      </div>
    </div>
  );
}

function Day3() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[8px] items-center p-[12px] relative rounded-[24px] shrink-0 w-[47px]" data-name="Day">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[24px]" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">14</p>
      </div>
      <WeatherClimate3 />
      <Frame15 />
    </div>
  );
}

function WeatherClimate4() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Weather, Climate">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <path clipRule="evenodd" d={svgPaths.p7500700} fill="var(--fill-0, #C1D1E8)" fillRule="evenodd" id="Path" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M6.75 17L5.75 19" id="Path_2" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M14.75 17L13.75 19" id="Path_3" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M10.75 18L9.75 20" id="Path_4" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18.25 18L17.75 19" id="Path_5" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_6"></g>
        </g>
      </svg>
    </div>
  );
}

function Frame16() {
  return (
    <div className="content-stretch flex flex-col font-['Mulish:Bold',sans-serif] font-bold gap-[4px] items-start leading-[0] relative shrink-0 text-[11px] text-center">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#8f96a0]">
        <p className="css-ew64yg leading-[1.2]">+24°</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#0a0c13]">
        <p className="css-ew64yg leading-[1.2]">24%</p>
      </div>
    </div>
  );
}

function Day4() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[8px] items-center p-[12px] relative rounded-[24px] shrink-0 w-[47px]" data-name="Day">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[24px]" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">15</p>
      </div>
      <WeatherClimate4 />
      <Frame16 />
    </div>
  );
}

function WeatherClimate5() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="Weather, Climate">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <path clipRule="evenodd" d={svgPaths.p2b686300} fill="var(--fill-0, #C1D1E8)" fillRule="evenodd" id="Path" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p2c987400} id="Path_2" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M18 17L16.5 20" id="Path_3" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M7.5 17L6 20" id="Path_4" stroke="var(--stroke-0, #C1D1E8)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_5"></g>
        </g>
      </svg>
    </div>
  );
}

function Frame17() {
  return (
    <div className="content-stretch flex flex-col font-['Mulish:Bold',sans-serif] font-bold gap-[4px] items-start leading-[0] relative shrink-0 text-[11px] text-center">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#8f96a0]">
        <p className="css-ew64yg leading-[1.2]">+24°</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[#0a0c13]">
        <p className="css-ew64yg leading-[1.2]">12%</p>
      </div>
    </div>
  );
}

function Day5() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[8px] items-center p-[12px] relative rounded-[24px] shrink-0 w-[47px]" data-name="Day">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[24px]" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">16</p>
      </div>
      <WeatherClimate5 />
      <Frame17 />
    </div>
  );
}

function Days() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0 w-full" data-name="Days">
      <Day />
      <Day1 />
      <Day2 />
      <Day3 />
      <Day4 />
      <Day5 />
    </div>
  );
}

function Weather() {
  return (
    <div className="backdrop-blur-[10px] bg-white content-stretch flex flex-col gap-[12px] items-start overflow-clip p-[16px] relative rounded-[24px] shadow-[0px_2px_20px_0px_rgba(0,0,0,0.1)] shrink-0 w-[343px]" data-name="Weather">
      <WashRating />
      <div className="h-0 relative shrink-0 w-full" data-name="Divider">
        <div className="absolute inset-[-1px_0_0_0]" style={{ "--stroke-0": "rgba(0, 0, 0, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 311 1">
            <line id="Divider" stroke="var(--stroke-0, black)" strokeOpacity="0.05" x2="311" y1="0.5" y2="0.5" />
          </svg>
        </div>
      </div>
      <Days />
    </div>
  );
}

function Tariff() {
  return (
    <div className="relative shrink-0 w-full" data-name="Tariff">
      <div className="content-stretch flex flex-col gap-[16px] items-start pb-[16px] pt-[12px] px-[16px] relative w-full">
        <Container5 />
        <Weather />
      </div>
    </div>
  );
}

function Frame7() {
  return (
    <div className="bg-white h-[80px] overflow-clip relative rounded-[24px] shrink-0 w-[162px]">
      <p className="absolute css-4hzbpn font-['Mulish:Black',sans-serif] font-black leading-[1.2] left-[12px] text-[#0a0c13] text-[13px] top-[12px] w-[138px]">Premium avto moykalar</p>
      <div className="absolute left-[81px] rounded-[12px] size-[109px] top-[-5px]">
        <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[12px] size-full" src={imgRectangle3} />
      </div>
    </div>
  );
}

function Frame6() {
  return (
    <div className="bg-white h-[80px] overflow-clip relative rounded-[24px] shrink-0 w-[162px]">
      <p className="absolute css-4hzbpn font-['Mulish:Black',sans-serif] font-black leading-[1.2] left-[12px] text-[#0a0c13] text-[13px] top-[12px] w-[138px]">
        Yangi avto
        <br aria-hidden="true" />
        moykalar
      </p>
      <div className="absolute left-[81px] rounded-[12px] size-[109px] top-[-5px]">
        <div aria-hidden="true" className="absolute inset-0 pointer-events-none rounded-[12px]">
          <img alt="" className="absolute max-w-none object-cover rounded-[12px] size-full" src={imgRectangle3} />
          <img alt="" className="absolute max-w-none object-cover rounded-[12px] size-full" src={imgRectangle4} />
        </div>
      </div>
    </div>
  );
}

function Primushestva() {
  return (
    <div className="content-stretch flex gap-[8px] items-center overflow-x-auto overflow-y-clip relative shrink-0 w-full" data-name="Primushestva">
      <Frame7 />
      <Frame6 />
      <Frame7 />
      <Frame7 />
    </div>
  );
}

function BlockTitle() {
  return (
    <div className="content-stretch flex gap-[8px] items-center justify-center leading-[0] relative shrink-0 w-full" data-name="block-title">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Black',sans-serif] font-black justify-center min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
        <p className="css-4hzbpn leading-[1.2]">Eng yaqin avto moykalar</p>
      </div>
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center relative shrink-0 text-[#00bffe] text-[14px] text-right">
        <p className="css-ew64yg leading-[1.2]">Hammasi</p>
      </div>
    </div>
  );
}

function Star() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="star">
          <path d={svgPaths.p31704780} fill="var(--fill-0, #FFD600)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Badges() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">4.6</p>
      </div>
    </div>
  );
}

function GalleryDots() {
  return (
    <div className="absolute h-[12px] left-[calc(50%-0.5px)] top-[144px] translate-x-[-50%] w-[54px]" data-name="gallery-dots">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 54 12">
        <g id="gallery-dots">
          <rect fill="var(--fill-0, black)" fillOpacity="0.25" height="12" rx="6" width="54" />
          <circle cx="7" cy="6" fill="var(--fill-0, white)" id="1" r="2" />
          <circle cx="15" cy="6" fill="var(--fill-0, white)" id="2" opacity="0.35" r="2" />
          <circle cx="23" cy="6" fill="var(--fill-0, white)" id="3" opacity="0.35" r="2" />
          <circle cx="31" cy="6" fill="var(--fill-0, white)" id="4" opacity="0.35" r="2" />
          <circle cx="39" cy="6" fill="var(--fill-0, white)" id="5" opacity="0.35" r="2" />
          <circle cx="47" cy="6" fill="var(--fill-0, white)" id="6" opacity="0.35" r="2" />
        </g>
      </svg>
    </div>
  );
}

function Image() {
  return (
    <div className="h-[160px] relative rounded-[16px] shrink-0 w-full" data-name="image">
      <div className="absolute inset-0 overflow-hidden pointer-events-none rounded-[16px]">
        <img alt="" className="absolute h-[128.07%] left-[-2.89%] max-w-none top-[-4.21%] w-[179.17%]" src={imgImage} />
      </div>
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col gap-[8px] items-start justify-end p-[8px] relative size-full">
          <Badges />
          <GalleryDots />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[16px]" />
    </div>
  );
}

function Group3() {
  return (
    <div className="absolute inset-[-7.14%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="Group">
          <g id="Path"></g>
          <path d={svgPaths.p353c1a00} fill="var(--fill-0, #00BFFE)" id="Exclude" />
        </g>
      </svg>
    </div>
  );
}

function ClockTime() {
  return (
    <div className="absolute left-1/2 size-[14px] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="clock, time">
      <Group3 />
    </div>
  );
}

function Clock() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime />
    </div>
  );
}

function Badges1() {
  return (
    <div className="backdrop-blur-[10px] bg-[#e5f9ff] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[16px] shrink-0" data-name="Badges">
      <Clock />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#00bffe] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">22:00 gacha ochiq</p>
      </div>
    </div>
  );
}

function TitleDatetime() {
  return (
    <div className="content-stretch flex items-center relative shrink-0 w-full" data-name="title&datetime">
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[13px] text-ellipsis">Black Star Car Wash</p>
    </div>
  );
}

function Pin() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="pin">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="pin">
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <circle cx="10" cy="9.41576" id="Oval" r="2.13369" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Location() {
  return (
    <div className="content-stretch flex gap-[4px] items-center pt-[4px] relative shrink-0 w-full" data-name="Location">
      <Pin />
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[12px]">500 m</p>
    </div>
  );
}

function Details() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime />
      <p className="css-g0mm18 font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] overflow-hidden relative shrink-0 text-[#0a0c13] text-[12px] text-ellipsis w-[221px]">Matbuotchilar Street 32, Tashkent</p>
      <Location />
    </div>
  );
}

function Content1() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges1 />
      <Details />
    </div>
  );
}

function NearestCarWash() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-[245px]" data-name="nearest car wash">
      <Image />
      <Content1 />
    </div>
  );
}

function Star1() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="star">
          <path d={svgPaths.p31704780} fill="var(--fill-0, #FFD600)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Badges2() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star1 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">4.6</p>
      </div>
    </div>
  );
}

function GalleryDots1() {
  return (
    <div className="absolute h-[12px] left-[calc(50%-0.5px)] top-[144px] translate-x-[-50%] w-[54px]" data-name="gallery-dots">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 54 12">
        <g id="gallery-dots">
          <rect fill="var(--fill-0, black)" fillOpacity="0.25" height="12" rx="6" width="54" />
          <circle cx="7" cy="6" fill="var(--fill-0, white)" id="1" r="2" />
          <circle cx="15" cy="6" fill="var(--fill-0, white)" id="2" opacity="0.35" r="2" />
          <circle cx="23" cy="6" fill="var(--fill-0, white)" id="3" opacity="0.35" r="2" />
          <circle cx="31" cy="6" fill="var(--fill-0, white)" id="4" opacity="0.35" r="2" />
          <circle cx="39" cy="6" fill="var(--fill-0, white)" id="5" opacity="0.35" r="2" />
          <circle cx="47" cy="6" fill="var(--fill-0, white)" id="6" opacity="0.35" r="2" />
        </g>
      </svg>
    </div>
  );
}

function Image1() {
  return (
    <div className="h-[160px] relative rounded-[16px] shrink-0 w-full" data-name="image">
      <div className="absolute inset-0 overflow-hidden pointer-events-none rounded-[16px]">
        <img alt="" className="absolute h-[189.68%] left-[-42.95%] max-w-none top-[-52.42%] w-[165.16%]" src={imgImage1} />
      </div>
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col gap-[8px] items-start justify-end p-[8px] relative size-full">
          <Badges2 />
          <GalleryDots1 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[16px]" />
    </div>
  );
}

function Group4() {
  return (
    <div className="absolute inset-[-7.14%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="Group">
          <g id="Path"></g>
          <path d={svgPaths.p353c1a00} fill="var(--fill-0, #FC3E3E)" id="Exclude" />
        </g>
      </svg>
    </div>
  );
}

function ClockTime1() {
  return (
    <div className="absolute left-1/2 size-[14px] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="clock, time">
      <Group4 />
    </div>
  );
}

function Clock1() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime1 />
    </div>
  );
}

function Badges3() {
  return (
    <div className="bg-[#ffebeb] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[7px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Clock1 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#fc3e3e] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">Yopiq 8:00 gacha</p>
      </div>
    </div>
  );
}

function TitleDatetime1() {
  return (
    <div className="content-stretch flex items-center relative shrink-0 w-full" data-name="title&datetime">
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[13px] text-ellipsis">Wash N Go Car Wash</p>
    </div>
  );
}

function Pin1() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="pin">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="pin">
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <circle cx="10" cy="9.41576" id="Oval" r="2.13369" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Location1() {
  return (
    <div className="content-stretch flex gap-[4px] items-center pt-[4px] relative shrink-0 w-full" data-name="Location">
      <Pin1 />
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[12px]">900 m</p>
    </div>
  );
}

function Details1() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime1 />
      <p className="css-g0mm18 font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] overflow-hidden relative shrink-0 text-[#0a0c13] text-[12px] text-ellipsis w-[221px]">Tutzor mahallasi, 35 uy, Choshtepa, 100114, Tashkent</p>
      <Location1 />
    </div>
  );
}

function Content2() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges3 />
      <Details1 />
    </div>
  );
}

function NearestCarWash1() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-[245px]" data-name="nearest car wash">
      <Image1 />
      <Content2 />
    </div>
  );
}

function Star2() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="star">
          <path d={svgPaths.p31704780} fill="var(--fill-0, #FFD600)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Badges4() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star2 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">4.6</p>
      </div>
    </div>
  );
}

function GalleryDots2() {
  return (
    <div className="absolute h-[12px] left-[calc(50%-0.5px)] top-[144px] translate-x-[-50%] w-[54px]" data-name="gallery-dots">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 54 12">
        <g id="gallery-dots">
          <rect fill="var(--fill-0, black)" fillOpacity="0.25" height="12" rx="6" width="54" />
          <circle cx="7" cy="6" fill="var(--fill-0, white)" id="1" r="2" />
          <circle cx="15" cy="6" fill="var(--fill-0, white)" id="2" opacity="0.35" r="2" />
          <circle cx="23" cy="6" fill="var(--fill-0, white)" id="3" opacity="0.35" r="2" />
          <circle cx="31" cy="6" fill="var(--fill-0, white)" id="4" opacity="0.35" r="2" />
          <circle cx="39" cy="6" fill="var(--fill-0, white)" id="5" opacity="0.35" r="2" />
          <circle cx="47" cy="6" fill="var(--fill-0, white)" id="6" opacity="0.35" r="2" />
        </g>
      </svg>
    </div>
  );
}

function Image2() {
  return (
    <div className="h-[160px] relative rounded-[16px] shrink-0 w-full" data-name="image">
      <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[16px] size-full" src={imgImage2} />
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col gap-[8px] items-start justify-end p-[8px] relative size-full">
          <Badges4 />
          <GalleryDots2 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[16px]" />
    </div>
  );
}

function Group5() {
  return (
    <div className="absolute inset-[-7.14%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="Group">
          <g id="Path"></g>
          <path d={svgPaths.p353c1a00} fill="var(--fill-0, #5CCC27)" id="Exclude" />
        </g>
      </svg>
    </div>
  );
}

function ClockTime2() {
  return (
    <div className="absolute left-1/2 size-[14px] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="clock, time">
      <Group5 />
    </div>
  );
}

function Clock2() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime2 />
    </div>
  );
}

function Badges5() {
  return (
    <div className="backdrop-blur-[10px] bg-[#eeffe7] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[16px] shrink-0" data-name="Badges">
      <Clock2 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#5ccc27] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">24/7 ochiq</p>
      </div>
    </div>
  );
}

function TitleDatetime2() {
  return (
    <div className="content-stretch flex items-center relative shrink-0 w-full" data-name="title&datetime">
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[13px] text-ellipsis">DJ Car Wash</p>
    </div>
  );
}

function Pin2() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="pin">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="pin">
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <circle cx="10" cy="9.41576" id="Oval" r="2.13369" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Location2() {
  return (
    <div className="content-stretch flex gap-[4px] items-center pt-[4px] relative shrink-0 w-full" data-name="Location">
      <Pin2 />
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[12px]">1.2 km</p>
    </div>
  );
}

function Details2() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime2 />
      <p className="css-g0mm18 font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] overflow-hidden relative shrink-0 text-[#0a0c13] text-[12px] text-ellipsis w-[221px]">Chimrobod ko’chasi 28, Тоshkent, Toshkent</p>
      <Location2 />
    </div>
  );
}

function Content3() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges5 />
      <Details2 />
    </div>
  );
}

function NearestCarWash2() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-[245px]" data-name="nearest car wash">
      <Image2 />
      <Content3 />
    </div>
  );
}

function Star3() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="star">
          <path d={svgPaths.p31704780} fill="var(--fill-0, #FFD600)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Badges6() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star3 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">4.6</p>
      </div>
    </div>
  );
}

function GalleryDots3() {
  return (
    <div className="absolute h-[12px] left-[calc(50%-0.5px)] top-[144px] translate-x-[-50%] w-[54px]" data-name="gallery-dots">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 54 12">
        <g id="gallery-dots">
          <rect fill="var(--fill-0, black)" fillOpacity="0.25" height="12" rx="6" width="54" />
          <circle cx="7" cy="6" fill="var(--fill-0, white)" id="1" r="2" />
          <circle cx="15" cy="6" fill="var(--fill-0, white)" id="2" opacity="0.35" r="2" />
          <circle cx="23" cy="6" fill="var(--fill-0, white)" id="3" opacity="0.35" r="2" />
          <circle cx="31" cy="6" fill="var(--fill-0, white)" id="4" opacity="0.35" r="2" />
          <circle cx="39" cy="6" fill="var(--fill-0, white)" id="5" opacity="0.35" r="2" />
          <circle cx="47" cy="6" fill="var(--fill-0, white)" id="6" opacity="0.35" r="2" />
        </g>
      </svg>
    </div>
  );
}

function Image3() {
  return (
    <div className="h-[160px] relative rounded-[16px] shrink-0 w-full" data-name="image">
      <div className="absolute inset-0 overflow-hidden pointer-events-none rounded-[16px]">
        <img alt="" className="absolute h-full left-[-9.72%] max-w-none top-0 w-[138.13%]" src={imgImage3} />
      </div>
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col gap-[8px] items-start justify-end p-[8px] relative size-full">
          <Badges6 />
          <GalleryDots3 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[16px]" />
    </div>
  );
}

function Group6() {
  return (
    <div className="absolute inset-[-7.14%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="Group">
          <g id="Path"></g>
          <path d={svgPaths.p353c1a00} fill="var(--fill-0, #FC941A)" id="Exclude" />
        </g>
      </svg>
    </div>
  );
}

function ClockTime3() {
  return (
    <div className="absolute left-1/2 size-[14px] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="clock, time">
      <Group6 />
    </div>
  );
}

function Clock3() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime3 />
    </div>
  );
}

function Badges7() {
  return (
    <div className="backdrop-blur-[10px] bg-[#ffedbf] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[16px] shrink-0" data-name="Badges">
      <Clock3 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#fc941a] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">2 soatda yopiladi</p>
      </div>
    </div>
  );
}

function TitleDatetime3() {
  return (
    <div className="content-stretch flex items-center relative shrink-0 w-full" data-name="title&datetime">
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[13px] text-ellipsis">Car wash 777</p>
    </div>
  );
}

function Pin3() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="pin">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="pin">
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p27406380} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <circle cx="10" cy="9.41576" id="Oval" r="2.13369" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Location3() {
  return (
    <div className="content-stretch flex gap-[4px] items-center pt-[4px] relative shrink-0 w-full" data-name="Location">
      <Pin3 />
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[12px]">1.5 km</p>
    </div>
  );
}

function Details3() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime3 />
      <p className="css-g0mm18 font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] overflow-hidden relative shrink-0 text-[#0a0c13] text-[12px] text-ellipsis w-[221px]">Qumariq ko’chasi 59 Tashkent</p>
      <Location3 />
    </div>
  );
}

function Content4() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges7 />
      <Details3 />
    </div>
  );
}

function NearestCarWash3() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-[245px]" data-name="nearest car wash">
      <Image3 />
      <Content4 />
    </div>
  );
}

function Container7() {
  return (
    <div className="content-stretch flex gap-[12px] items-center relative shrink-0 w-full" data-name="Container">
      <NearestCarWash />
      <NearestCarWash1 />
      <NearestCarWash2 />
      <NearestCarWash3 />
    </div>
  );
}

function Container8() {
  return (
    <div className="bg-white relative rounded-[24px] shrink-0 w-full" data-name="Container">
      <div className="flex flex-col items-center overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col gap-[12px] items-center p-[12px] relative w-full">
          <BlockTitle />
          <Container7 />
        </div>
      </div>
    </div>
  );
}

function BlockTitle1() {
  return (
    <div className="content-stretch flex gap-[8px] items-center justify-center leading-[0] relative shrink-0 w-full" data-name="block-title">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Black',sans-serif] font-black justify-center min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
        <p className="css-4hzbpn leading-[1.2]">So’nggi tashriflar</p>
      </div>
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center relative shrink-0 text-[#00bffe] text-[14px] text-right">
        <p className="css-ew64yg leading-[1.2]">Hammasi</p>
      </div>
    </div>
  );
}

function Tag() {
  return (
    <div className="bg-[#dbf0ff] content-stretch flex items-center justify-center px-[8px] py-[2px] relative rounded-[8px] shrink-0" data-name="Tag">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#1d99f2] text-[10px]">
        <p className="css-ew64yg leading-[1.2]">BMW</p>
      </div>
    </div>
  );
}

function Region() {
  return (
    <div className="content-stretch flex items-center justify-center px-[4px] py-[2px] relative shrink-0" data-name="Region">
      <div aria-hidden="true" className="absolute border-[#d9dde3] border-r border-solid inset-0 pointer-events-none" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px]">
        <p className="css-ew64yg leading-[1.2]">85</p>
      </div>
    </div>
  );
}

function Number() {
  return (
    <div className="content-stretch flex items-center justify-center px-[4px] py-[2px] relative shrink-0" data-name="Number">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px]">
        <p className="css-ew64yg leading-[1.2]">O 777 OO</p>
      </div>
    </div>
  );
}

function CarPlateNumber() {
  return (
    <div className="bg-white content-stretch flex items-center relative rounded-[4px] shrink-0" data-name="Car plate number">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[4px]" />
      <Region />
      <Number />
    </div>
  );
}

function Frame8() {
  return (
    <div className="content-stretch flex gap-[8px] items-start relative shrink-0">
      <Tag />
      <CarPlateNumber />
    </div>
  );
}

function Frame9() {
  return (
    <div className="content-stretch flex items-center justify-between pt-[6px] relative shrink-0 w-full">
      <Frame8 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] relative shrink-0 text-[#8f96a0] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">14:00</p>
      </div>
    </div>
  );
}

function Container9() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="Container">
      <div className="flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Wash N Go Car Wash</p>
      </div>
      <p className="css-g0mm18 font-['Mulish:Regular',sans-serif] font-normal h-[15px] leading-[1.2] overflow-hidden relative shrink-0 text-[#646d79] text-[12px] text-ellipsis w-full">Tutzor mahallasi, 35 uy, Choshtepa, 100114, Tashkent</p>
      <Frame9 />
    </div>
  );
}

function HistoryContainer() {
  return (
    <div className="bg-white relative rounded-[20px] shrink-0 w-full" data-name="History container">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center p-[12px] relative w-full">
          <div className="relative rounded-[12px] shrink-0 size-[60px]">
            <div aria-hidden="true" className="absolute inset-0 pointer-events-none rounded-[12px]">
              <div className="absolute inset-0 overflow-hidden rounded-[12px]">
                <img alt="" className="absolute h-[128.07%] left-[-2.89%] max-w-none top-[-4.21%] w-[179.17%]" src={imgImage} />
              </div>
              <img alt="" className="absolute max-w-none object-cover rounded-[12px] size-full" src={imgImage1} />
            </div>
          </div>
          <Container9 />
        </div>
      </div>
    </div>
  );
}

function Tag1() {
  return (
    <div className="bg-[#dbf0ff] content-stretch flex items-center justify-center px-[8px] py-[2px] relative rounded-[8px] shrink-0" data-name="Tag">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#1d99f2] text-[10px]">
        <p className="css-ew64yg leading-[1.2]">Tracker</p>
      </div>
    </div>
  );
}

function Region1() {
  return (
    <div className="content-stretch flex items-center justify-center px-[4px] py-[2px] relative shrink-0" data-name="Region">
      <div aria-hidden="true" className="absolute border-[#d9dde3] border-r border-solid inset-0 pointer-events-none" />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px]">
        <p className="css-ew64yg leading-[1.2]">85</p>
      </div>
    </div>
  );
}

function Number1() {
  return (
    <div className="content-stretch flex items-center justify-center px-[4px] py-[2px] relative shrink-0" data-name="Number">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px]">
        <p className="css-ew64yg leading-[1.2]">O 555 OO</p>
      </div>
    </div>
  );
}

function CarPlateNumber1() {
  return (
    <div className="bg-white content-stretch flex items-center relative rounded-[4px] shrink-0" data-name="Car plate number">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[4px]" />
      <Region1 />
      <Number1 />
    </div>
  );
}

function Frame10() {
  return (
    <div className="content-stretch flex gap-[8px] items-start relative shrink-0">
      <Tag1 />
      <CarPlateNumber1 />
    </div>
  );
}

function Frame11() {
  return (
    <div className="content-stretch flex items-center justify-between pt-[6px] relative shrink-0 w-full">
      <Frame10 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] relative shrink-0 text-[#8f96a0] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">12:00</p>
      </div>
    </div>
  );
}

function Container10() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="Container">
      <div className="flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px] w-full">
        <p className="css-4hzbpn leading-[1.2]">DJ Car Wash</p>
      </div>
      <p className="css-g0mm18 font-['Mulish:Regular',sans-serif] font-normal h-[15px] leading-[1.2] overflow-hidden relative shrink-0 text-[#646d79] text-[12px] text-ellipsis w-full">Chimrobod ko’chasi 28, Тоshkent, Toshkent</p>
      <Frame11 />
    </div>
  );
}

function HistoryContainer1() {
  return (
    <div className="bg-white relative rounded-[20px] shrink-0 w-full" data-name="History container">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[12px] items-center p-[12px] relative w-full">
          <div className="relative rounded-[12px] shrink-0 size-[60px]">
            <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[12px] size-full" src={imgImage2} />
          </div>
          <Container10 />
        </div>
      </div>
    </div>
  );
}

function Container11() {
  return (
    <div className="content-stretch flex flex-col gap-[12px] items-start justify-center relative shrink-0 w-full" data-name="Container">
      <HistoryContainer />
      <HistoryContainer1 />
      <HistoryContainer />
    </div>
  );
}

function History1() {
  return (
    <div className="bg-white relative rounded-[24px] shrink-0 w-full" data-name="History">
      <div className="flex flex-col items-center overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col gap-[12px] items-center p-[12px] relative w-full">
          <BlockTitle1 />
          <Container11 />
        </div>
      </div>
    </div>
  );
}

function Container12() {
  return (
    <div className="bg-[#f2f2f2] h-[918px] relative rounded-[32px] shrink-0 w-full" data-name="Container">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col gap-[12px] items-start p-[12px] relative size-full">
          <Primushestva />
          <Container8 />
          <History1 />
        </div>
      </div>
    </div>
  );
}

function Home() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="home">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="home">
          <g id="Path"></g>
          <path d="M4 8.6V21H20V8.6" id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M2 10L12 3L22 10" id="Path_3" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3d1f8300} id="Path_4" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function NavItem1() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <div className="absolute bg-[#00bffe] left-1/2 opacity-10 rounded-[8px] size-[30px] top-[calc(50%-8.5px)] translate-x-[-50%] translate-y-[-50%]" />
      <Home />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#00bffe] text-[11px]">
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
          <g id="Path_4"></g>
        </g>
      </svg>
    </div>
  );
}

function NavItem2() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <Map />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">Xarita</p>
      </div>
    </div>
  );
}

function Group7() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Path"></g>
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
      <Group7 />
    </div>
  );
}

function NavItem3() {
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

function Group8() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Path"></g>
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
      <Group8 />
    </div>
  );
}

function NavItem4() {
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
          <path d={svgPaths.p17ecbe80} id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <circle cx="12" cy="7" id="Oval" r="4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function NavItem5() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <Profile />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
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
          <NavItem1 />
          <NavItem2 />
          <NavItem3 />
          <NavItem4 />
          <NavItem5 />
        </div>
      </div>
    </div>
  );
}

function Navbar() {
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
      <Navbar />
    </div>
  );
}

function Navigation() {
  return (
    <div className="absolute bottom-0 content-stretch flex flex-col gap-[16px] h-[90px] items-center justify-center left-0 w-[375px]" data-name="navigation">
      <Navbar1 />
    </div>
  );
}

export default function Main() {
  return (
    <div className="bg-white content-stretch flex flex-col items-start overflow-clip relative rounded-[40px] size-full" data-name="Main">
      <IOsStatusBar />
      <Topbar />
      <Tariff />
      <Container12 />
      <Navigation />
      <div className="absolute h-0 left-0 top-[881px] w-[375px]">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(22, 22, 22, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 32 32">
            <g id="Line 4" opacity="0.4"></g>
          </svg>
        </div>
      </div>
    </div>
  );
}