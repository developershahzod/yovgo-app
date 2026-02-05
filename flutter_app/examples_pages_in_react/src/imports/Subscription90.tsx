import svgPaths from "./svg-mcx0mt7ipr";
import imgImage12 from "figma:asset/24e0bcc2480344e32bd5760bcba86bf3ae8711ec.png";

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

function Bg() {
  return (
    <div className="absolute contents left-1/2 top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="BG">
      <div className="absolute h-[180px] left-0 top-1/2 translate-y-[-50%] w-[343px]" data-name="image 12">
        <div className="absolute inset-0 overflow-hidden pointer-events-none">
          <img alt="" className="absolute h-[129.97%] left-[-0.75%] max-w-none top-[-22.22%] w-[119.36%]" src={imgImage12} />
        </div>
      </div>
      <div className="absolute backdrop-blur-[8px] bg-gradient-to-t from-[rgba(10,12,19,0.5)] h-[78px] left-1/2 to-[rgba(10,12,19,0)] top-[calc(50%+51px)] translate-x-[-50%] translate-y-[-50%] w-[343px]" />
    </div>
  );
}

function Text() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start justify-end leading-[1.2] relative shrink-0 text-white w-[303px]" data-name="Text">
      <p className="css-4hzbpn font-['Mulish:Black',sans-serif] font-black relative shrink-0 text-[16px] w-[269px]">90 kunlik obuna</p>
      <p className="css-ew64yg font-['Mulish:Regular',sans-serif] font-normal relative shrink-0 text-[12px]">Tugaydi: Mart 15</p>
    </div>
  );
}

function Badges() {
  return (
    <div className="absolute bg-white content-stretch flex flex-col items-start leading-[0] px-[8px] py-[4px] right-[20px] rounded-[12px] text-[#0a0c13] top-[127px] w-[54px]" data-name="Badges">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center relative shrink-0 text-[10px]">
        <p className="css-ew64yg leading-[1.2]">Qoldi:</p>
      </div>
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center relative shrink-0 text-[11px]">
        <p className="css-ew64yg leading-[1.2]">4 kun</p>
      </div>
    </div>
  );
}

function Container() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[20px] h-[180px] items-start justify-end left-[16px] overflow-clip p-[20px] rounded-[24px] shadow-[0px_4px_14px_-4px_rgba(9,37,75,0.3),0px_10px_15px_-3px_rgba(41,76,185,0.2)] top-[104px] w-[343px]" data-name="Container">
      <Bg />
      <Text />
      <Badges />
      <div className="absolute inset-0 pointer-events-none rounded-[inherit] shadow-[inset_0px_-1px_2px_0px_rgba(255,255,255,0.3)]" />
    </div>
  );
}

function Snow() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="snow">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <path d="M12 3V21" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p1a65e080} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M20 7.38L4 16.62" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p25b9880} id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p71db900} id="Path_5" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M4 7.38L20 16.62" id="Path_6" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p14b23d80} id="Path_7" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p39f86700} id="Path_8" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p160b7c80} id="Path_9" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_10" />
        </g>
      </svg>
    </div>
  );
}

function Group() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Obunani muzlatish</p>
      </div>
    </div>
  );
}

function Label() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group />
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
      <Chevron />
    </div>
  );
}

function MenuItem() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Snow />
      <Label />
      <Suffix />
    </div>
  );
}

function Sign() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="sign">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="sign">
          <path clipRule="evenodd" d={svgPaths.p20dc6e00} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p10e60100} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p14f4d80} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Group1() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Savollar va javoblar</p>
      </div>
    </div>
  );
}

function Label1() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-h-px min-w-px relative" data-name="label">
      <Group1 />
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
      <Sign />
      <Label1 />
      <Suffix1 />
    </div>
  );
}

function List() {
  return (
    <div className="absolute bg-white content-stretch flex flex-col gap-[8px] items-start left-1/2 px-[16px] top-[385px] translate-x-[-50%] w-[375px]" data-name="list">
      <MenuItem />
      <MenuItem1 />
    </div>
  );
}

function Group2() {
  return (
    <div className="absolute inset-[-0.02%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24.01 24.01">
        <g id="Group">
          <path d="M12.006 9.00375V8.00333" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d="M12.006 15.0063V16.0067" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p18e6cae0} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.pad7a680} id="a" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.pad7a680} id="a-2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <g id="Rectangle" />
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
    <div className="content-stretch flex font-['Mulish:Black',sans-serif] font-black gap-[2px] items-baseline leading-[0] relative shrink-0 text-center w-full" data-name="price">
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[16px]">
        <p className="css-ew64yg leading-[1.2]">120 000</p>
      </div>
      <div className="css-g0mm18 flex flex-col justify-center relative shrink-0 text-[14px]">
        <p className="css-ew64yg leading-[1.2]">so’m</p>
      </div>
    </div>
  );
}

function Container1() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start justify-center relative shrink-0 text-[#0a0c13]" data-name="Container">
      <p className="css-ew64yg font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] relative shrink-0 text-[12px]">Tejalgan pul</p>
      <Price />
    </div>
  );
}

function Frame3() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full">
      <Money />
      <Container1 />
    </div>
  );
}

function Frame() {
  return (
    <div className="bg-[#f2f2f2] flex-[1_0_0] min-h-px min-w-px relative rounded-[20px]">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start px-[12px] py-[16px] relative w-full">
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
          <path d={svgPaths.p17176c00} id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p59f7818} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
          <path d={svgPaths.p20cfba00} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" />
        </g>
      </svg>
    </div>
  );
}

function Container2() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start justify-center relative shrink-0 text-[#0a0c13]" data-name="Container">
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
      <Container2 />
    </div>
  );
}

function Frame1() {
  return (
    <div className="bg-[#f2f2f2] flex-[1_0_0] min-h-px min-w-px relative rounded-[20px]">
      <div className="overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start px-[12px] py-[16px] relative w-full">
          <Frame4 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(255,255,255,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Frame2() {
  return (
    <div className="absolute content-stretch flex gap-[4px] items-center justify-center left-1/2 top-[300px] translate-x-[-50%] w-[343px]">
      <Frame />
      <Frame1 />
    </div>
  );
}

function PinRight() {
  return (
    <div className="absolute h-[12px] right-[13px] top-[calc(50%+1px)] translate-y-[-50%] w-[67.272px]" data-name="Pin Right">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 67.2724 12">
        <g clipPath="url(#clip0_6_10828)" id="Pin Right">
          <path d={svgPaths.p17d48900} fill="var(--fill-0, black)" id="Mobile Signal" />
          <path d={svgPaths.p40b6ac0} fill="var(--fill-0, black)" id="Wifi" />
          <g id="Battery">
            <g id="Border" opacity="0.4">
              <path clipRule="evenodd" d={svgPaths.p2a8e080} fill="var(--fill-0, black)" fillRule="evenodd" />
              <path d={svgPaths.p2c54ff00} fill="var(--fill-0, black)" />
            </g>
            <path clipRule="evenodd" d={svgPaths.p17951900} fill="var(--fill-0, black)" fillRule="evenodd" id="Charge" />
          </g>
        </g>
        <defs>
          <clipPath id="clip0_6_10828">
            <rect fill="white" height="12" width="67.2724" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function IOsStatusBar() {
  return (
    <div className="absolute h-[44px] left-1/2 top-0 translate-x-[-50%] w-[375px]" data-name="iOS Status Bar">
      <PinRight />
      <div className="absolute css-g0mm18 flex flex-col font-['SF_Pro_Text:Semibold',sans-serif] justify-center leading-[0] left-[28px] not-italic text-[15px] text-black top-[calc(50%+1px)] tracking-[-0.2px] translate-y-[-50%]">
        <p className="css-ew64yg leading-[normal]">9:41</p>
      </div>
    </div>
  );
}

function MProfileSigned() {
  return (
    <div className="absolute bg-white inset-0" data-name="m_profile-signed">
      <Navbar />
      <p className="absolute css-ew64yg font-['Mulish:Black',sans-serif] font-black leading-[1.2] left-[16px] text-[#0a0c13] text-[23px] top-[60px]">Mening obunam</p>
      <Container />
      <List />
      <Frame2 />
      <IOsStatusBar />
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

function Group3() {
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
      <Group3 />
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

function Group5() {
  return (
    <div className="absolute inset-[16.67%_8.33%]" data-name="Group">
      <div className="absolute inset-[-4.69%_-3.75%]">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 21.5 17.5">
          <g id="Group">
            <path clipRule="evenodd" d={svgPaths.p3ad4f600} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p23751e40} id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p11be400} id="Path_3" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path clipRule="evenodd" d={svgPaths.p2a86cb00} fillRule="evenodd" id="Path_4" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
        </svg>
      </div>
    </div>
  );
}

function Group4() {
  return (
    <div className="absolute contents inset-[16.67%_8.33%]" data-name="Group">
      <Group5 />
    </div>
  );
}

function Subs() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="subs">
      <Group4 />
    </div>
  );
}

function NavItem3() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <div className="absolute bg-[#00bffe] left-1/2 opacity-10 rounded-[8px] size-[30px] top-[calc(50%-8.5px)] translate-x-[-50%] translate-y-[-50%]" />
      <Subs />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#00bffe] text-[11px]">
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

function NavItem4() {
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

export default function Subscription() {
  return (
    <div className="overflow-clip relative rounded-[40px] size-full" data-name="Subscription 90">
      <MProfileSigned />
      <Navigation />
    </div>
  );
}