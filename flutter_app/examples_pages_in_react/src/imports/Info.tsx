import svgPaths from "./svg-oixhtl1tah";
import imgInfo from "figma:asset/e84decbff63abebf3913926a9d0edbf52a56e848.png";
import imgInfo1 from "figma:asset/bbee97e951036325dfe85abc45041b92fe3aadfa.png";

function Scanner() {
  return (
    <div className="absolute h-[218px] left-[78px] top-[262px] w-[219px]" data-name="Scanner">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 219 218">
        <g id="Scanner">
          <path d="M56 0V4H4V56H0V0H56Z" fill="var(--fill-0, #00BFFE)" id="Union" />
          <path d="M56 218V214H4V162H0V218H56Z" fill="var(--fill-0, #00BFFE)" id="Union_2" />
          <path d={svgPaths.p1a9fbb80} fill="var(--fill-0, #00BFFE)" id="Union_3" />
          <path d="M163 0V4H215V56H219V0H163Z" fill="var(--fill-0, #00BFFE)" id="Union_4" />
        </g>
      </svg>
    </div>
  );
}

function Group() {
  return (
    <div className="absolute inset-[-0.02%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24.01 24.01">
        <g id="Group">
          <g id="Path"></g>
          <path d="M8.25344 11.5048H6.2526" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3e1b3c80} id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.pdeb9200} id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p13b28c0} id="Path_5" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p28204440} id="Path_6" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M14.7561 11.5048H16.757" id="Path_7" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p33d79500} fillRule="evenodd" id="Path_8" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Detailing() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="detailing">
      <Group />
    </div>
  );
}

function Icon() {
  return (
    <div className="bg-white content-stretch flex items-center p-[12px] relative rounded-[12px] shrink-0" data-name="Icon">
      <Detailing />
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

function Tags() {
  return (
    <div className="content-stretch flex items-start relative shrink-0" data-name="Tags">
      <CarPlateNumber />
    </div>
  );
}

function Container() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[8px] items-start justify-center min-h-px min-w-px relative" data-name="Container">
      <div className="flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] min-w-full relative shrink-0 text-[#0a0c13] text-[16px] w-[min-content]">
        <p className="css-4hzbpn leading-[1.2]">BMW i7</p>
      </div>
      <Tags />
    </div>
  );
}

function Chevron() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M8 10L12 14L16 10" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function CarSelection() {
  return (
    <div className="bg-[rgba(255,255,255,0.85)] relative rounded-[24px] shrink-0 w-full" data-name="Car selection">
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[8px] items-center p-[12px] relative w-full">
          <Icon />
          <Container />
          <Chevron />
        </div>
      </div>
    </div>
  );
}

function Container1() {
  return (
    <div className="absolute bottom-[114px] content-stretch flex flex-col gap-[8px] items-start left-[16px] w-[343px]" data-name="Container">
      <div className="flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[14px] text-white w-full">
        <p className="css-4hzbpn leading-[1.2]">Scan a YUVGO QR code to access as:</p>
      </div>
      <CarSelection />
    </div>
  );
}

function Sign() {
  return (
    <div className="absolute right-[16px] size-[24px] top-1/2 translate-y-[-50%]" data-name="sign">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="sign">
          <path d={svgPaths.p3eda8800} id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M10.9996 15.5001H13.3099" id="Path_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p1d1c9280} id="Path_3" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p2272d740} id="Path_4" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <rect height="18.0075" id="Path_5" rx="5" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" width="18.0075" x="2.99625" y="2.99487" />
        </g>
      </svg>
    </div>
  );
}

function Topbar() {
  return (
    <div className="absolute backdrop-blur-[10px] h-[56px] left-1/2 top-[44px] translate-x-[-50%] w-[375px]" data-name="topbar">
      <Sign />
    </div>
  );
}

function Home() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="home">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="home">
          <g id="Path"></g>
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
          <g id="Path_4"></g>
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

function Group1() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Path"></g>
          <path clipRule="evenodd" d="M6 6H10V10H6V6Z" fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d="M6 14H10V18H6V14Z" fillRule="evenodd" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d="M18 10H14V6L18 6V10Z" fillRule="evenodd" id="Path_4" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p348e1a2a} id="Path_5" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3ee14d20} id="Path_6" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p2eee6b00} id="Path_7" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.pa10d3c0} id="Path_8" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p944df00} id="Path_9" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3c0ddb00} id="Path_10" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p36c54400} id="Path_11" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p22406700} id="Path_12" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p2b71cf98} id="Path_13" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function QrCode() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="qr code">
      <Group1 />
    </div>
  );
}

function NavItem2() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[64px]" data-name="nav-item">
      <div className="absolute bg-[#00bffe] left-1/2 opacity-10 rounded-[8px] size-[30px] top-[calc(50%-8.5px)] translate-x-[-50%] translate-y-[-50%]" />
      <QrCode />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#00bffe] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">QR kod</p>
      </div>
    </div>
  );
}

function Group2() {
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
      <Group2 />
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
    <div className="bg-[rgba(255,255,255,0.85)] content-stretch flex flex-col items-center justify-center relative rounded-tl-[22px] rounded-tr-[22px] shrink-0 w-full" data-name="navbar">
      <Menu />
      <Navbar />
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

function PinRight() {
  return (
    <div className="absolute h-[12px] right-[13px] top-[calc(50%+1px)] translate-y-[-50%] w-[67.272px]" data-name="Pin Right">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 67.2725 12">
        <g clipPath="url(#clip0_1_10089)" id="Pin Right">
          <path d={svgPaths.p17d48900} fill="var(--fill-0, white)" id="Mobile Signal" />
          <path d={svgPaths.p24d75c00} fill="var(--fill-0, white)" id="Wifi" />
          <g id="Battery">
            <g id="Border" opacity="0.4">
              <path clipRule="evenodd" d={svgPaths.p2a8e080} fill="var(--fill-0, white)" fillRule="evenodd" />
              <path d={svgPaths.p2c54ff00} fill="var(--fill-0, white)" />
            </g>
            <path clipRule="evenodd" d={svgPaths.p17951900} fill="var(--fill-0, white)" fillRule="evenodd" id="Charge" />
          </g>
        </g>
        <defs>
          <clipPath id="clip0_1_10089">
            <rect fill="white" height="12" width="67.2725" />
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
      <div className="absolute css-g0mm18 flex flex-col font-['SF_Pro_Text:Semibold',sans-serif] justify-center leading-[0] left-[28px] not-italic text-[15px] text-white top-[calc(50%+1px)] tracking-[-0.2px] translate-y-[-50%]">
        <p className="css-ew64yg leading-[normal]">9:41</p>
      </div>
    </div>
  );
}

function Drag() {
  return (
    <div className="content-stretch flex flex-col items-center justify-center py-[6px] relative shrink-0 w-full" data-name="Drag">
      <div className="bg-[#d9dde3] h-[4px] rounded-[23px] shrink-0 w-[32px]" data-name="drag" />
    </div>
  );
}

function Pin() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="pin">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="pin">
          <path clipRule="evenodd" d={svgPaths.p33ac780} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d={svgPaths.p33ac780} fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <circle cx="12" cy="11.2989" id="Oval" r="2.56043" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Icon1() {
  return (
    <div className="bg-[#e5f9ff] content-stretch flex items-center p-[12px] relative rounded-[12px] shrink-0" data-name="Icon">
      <Pin />
    </div>
  );
}

function Container2() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[4px] items-start justify-center leading-[0] min-h-px min-w-px relative" data-name="Container">
      <div className="flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center relative shrink-0 text-[#0a0c13] text-[15px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Avtomoykaga boring</p>
      </div>
      <div className="flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center relative shrink-0 text-[#8f96a0] text-[12px] w-full">
        <p className="css-4hzbpn leading-[1.2]">{`Yaqin-atrofdagi joylashuvni ko'rib chiqing yoki tezkor ro'yxatdan o'ting`}</p>
      </div>
    </div>
  );
}

function CarSelection1() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="Car selection">
      <Icon1 />
      <Container2 />
    </div>
  );
}

function Group3() {
  return (
    <div className="absolute contents inset-0" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Path"></g>
          <path clipRule="evenodd" d="M6 6H10V10H6V6Z" fillRule="evenodd" id="Path_2" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d="M6 14H10V18H6V14Z" fillRule="evenodd" id="Path_3" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path clipRule="evenodd" d="M18 10H14V6L18 6V10Z" fillRule="evenodd" id="Path_4" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p348e1a2a} id="Path_5" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3ee14d20} id="Path_6" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p2eee6b00} id="Path_7" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.pa10d3c0} id="Path_8" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p944df00} id="Path_9" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p3c0ddb00} id="Path_10" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p36c54400} id="Path_11" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p22406700} id="Path_12" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d={svgPaths.p2b71cf98} id="Path_13" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function QrCode1() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="qr code">
      <Group3 />
    </div>
  );
}

function Icon2() {
  return (
    <div className="bg-[#e5f9ff] content-stretch flex items-center p-[12px] relative rounded-[12px] shrink-0" data-name="Icon">
      <QrCode1 />
    </div>
  );
}

function Container3() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[4px] items-start justify-center leading-[0] min-h-px min-w-px relative" data-name="Container">
      <div className="flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center relative shrink-0 text-[#0a0c13] text-[15px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Xodimlardan QR kod so’rang</p>
      </div>
      <div className="flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center relative shrink-0 text-[#8f96a0] text-[12px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Avtomoyka xodimlaridan YuvGO uchun QR kod ko’rsatishlarini so’rang</p>
      </div>
    </div>
  );
}

function CarSelection2() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="Car selection">
      <Icon2 />
      <Container3 />
    </div>
  );
}

function Check() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="check">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="check">
          <path d="M17 9.00002L11 15L8 12" id="Vector" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeWidth="2" />
        </g>
      </svg>
    </div>
  );
}

function Icon3() {
  return (
    <div className="bg-[#e5f9ff] content-stretch flex items-center p-[12px] relative rounded-[12px] shrink-0" data-name="Icon">
      <Check />
    </div>
  );
}

function Container4() {
  return (
    <div className="content-stretch flex flex-[1_0_0] flex-col gap-[4px] items-start justify-center leading-[0] min-h-px min-w-px relative" data-name="Container">
      <div className="flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center relative shrink-0 text-[#0a0c13] text-[15px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Kamerani QR kodga yo’naltiring</p>
      </div>
      <div className="flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center relative shrink-0 text-[#8f96a0] text-[12px] w-full">
        <p className="css-4hzbpn leading-[1.2]">QR kodni skanerlang va mashinangizni yuvdiring</p>
      </div>
    </div>
  );
}

function CarSelection3() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="Car selection">
      <Icon3 />
      <Container4 />
    </div>
  );
}

function Content() {
  return (
    <div className="content-stretch flex flex-col gap-[16px] items-start relative shrink-0 w-full" data-name="Content">
      <CarSelection1 />
      <CarSelection2 />
      <CarSelection3 />
    </div>
  );
}

function List() {
  return (
    <div className="content-stretch flex flex-col gap-[16px] items-start px-[16px] py-[12px] relative shrink-0 w-[375px]" data-name="list">
      <div className="flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[15px] w-full">
        <p className="css-4hzbpn leading-[1.2]">Bu qanday ishlaydi</p>
      </div>
      <Content />
    </div>
  );
}

function SearchBar() {
  return (
    <div className="absolute backdrop-blur-[10px] bg-white bottom-0 content-stretch flex flex-col items-center left-1/2 pb-[16px] px-[16px] rounded-tl-[22px] rounded-tr-[22px] shadow-[0px_-4px_25px_0px_rgba(0,0,0,0.2)] translate-x-[-50%] w-[375px]" data-name="Search bar">
      <Drag />
      <List />
    </div>
  );
}

export default function Info() {
  return (
    <div className="overflow-clip relative rounded-[40px] size-full" data-name="Info">
      <div aria-hidden="true" className="absolute inset-0 pointer-events-none rounded-[40px]">
        <div className="absolute inset-0 overflow-hidden rounded-[40px]">
          <img alt="" className="absolute h-full left-[-31.2%] max-w-none top-0 w-[162.4%]" src={imgInfo} />
        </div>
        <div className="absolute inset-0 overflow-hidden rounded-[40px]">
          <img alt="" className="absolute h-full left-[-147.68%] max-w-none top-[-0.04%] w-[324.8%]" src={imgInfo1} />
        </div>
      </div>
      <IOsStatusBar />
      <div className="absolute h-0 left-0 top-[881px] w-[375px]">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(22, 22, 22, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 32 32">
            <g id="Line 4" opacity="0.4"></g>
          </svg>
        </div>
      </div>
      <div className="absolute bg-[rgba(0,0,0,0.6)] inset-0" data-name="backdrop" />
      <SearchBar />
      <div className="absolute h-[812px] left-0 top-0 w-[375px]" data-name="Subtract">
        <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 375 812">
          <path d={svgPaths.p2e262c80} fill="var(--fill-0, black)" fillOpacity="0.8" id="Subtract" />
        </svg>
      </div>
      <Scanner />
      <Container1 />
      <Topbar />
      <div className="absolute flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] left-[calc(50%+4.5px)] text-[16px] text-center text-white top-[209px] translate-x-[-50%] translate-y-[-50%] w-[270px]">
        <p className="css-4hzbpn leading-[1.2]">Kamerani QR kodga yo’naltiring va skanerlang</p>
      </div>
      <Navigation />
    </div>
  );
}