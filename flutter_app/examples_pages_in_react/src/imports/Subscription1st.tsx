import svgPaths from "./svg-n3vev5lq3f";
import imgImage12 from "figma:asset/cf60d18fa5d4a3f355d9680de472249a061f2d56.png";
import imgImage19 from "figma:asset/dc39eda64d246726ea5621050f1a81b4f23f7d79.png";

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
    <div className="absolute contents left-[calc(50%+0.5px)] top-[calc(50%+0.5px)] translate-x-[-50%] translate-y-[-50%]" data-name="BG">
      <div className="absolute h-[239px] left-[calc(50%+0.5px)] top-[calc(50%+0.5px)] translate-x-[-50%] translate-y-[-50%] w-[358px]" data-name="image 12">
        <img alt="" className="absolute inset-0 max-w-none object-cover opacity-90 pointer-events-none size-full" src={imgImage12} />
      </div>
      <div className="absolute backdrop-blur-[20px] bg-[rgba(255,255,255,0.01)] h-[222px] left-[calc(50%+1px)] top-[calc(50%+1px)] translate-x-[-50%] translate-y-[-50%] w-[343px]" />
    </div>
  );
}

function Chevron() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="chevron">
          <path d={svgPaths.p1385a000} id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Frame1() {
  return (
    <div className="content-stretch flex gap-[2px] items-center relative shrink-0">
      <p className="css-ew64yg font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] relative shrink-0 text-[12px] text-white">Pullik obunalar haqida batafsil ma’lumot</p>
      <Chevron />
    </div>
  );
}

function Frame() {
  return (
    <div className="content-stretch flex flex-col h-[140px] items-start justify-between relative shrink-0 w-[303px]">
      <p className="css-4hzbpn font-['Mulish:Black',sans-serif] font-black leading-[1.2] relative shrink-0 text-[20px] text-white w-[269px]">Mehmon obunachi</p>
      <Frame1 />
    </div>
  );
}

function Container() {
  return (
    <div className="absolute bg-[#00bffe] content-stretch flex flex-col gap-[20px] h-[180px] items-center left-[16px] overflow-clip px-[4px] py-[20px] rounded-[24px] top-[104px] w-[343px]" data-name="Container">
      <Bg />
      <Frame />
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

function Group() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="group">
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px]">
        <p className="css-ew64yg leading-[1.2]">Savollar va javoblar</p>
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

function Suffix() {
  return (
    <div className="content-stretch flex gap-[4px] items-center relative shrink-0" data-name="suffix">
      <Chevron1 />
    </div>
  );
}

function MenuItem() {
  return (
    <div className="content-stretch flex gap-[12px] h-[46px] items-center relative shrink-0 w-full" data-name="menu-item">
      <Sign />
      <Label />
      <Suffix />
    </div>
  );
}

function List() {
  return (
    <div className="absolute bg-white content-stretch flex flex-col gap-[12px] items-start left-1/2 px-[16px] top-[308px] translate-x-[-50%] w-[375px]" data-name="list">
      <MenuItem />
    </div>
  );
}

function Chevron2() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M10 16L14 12L10 8" id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Frame2() {
  return (
    <div className="content-stretch flex gap-[2px] items-start relative shrink-0 w-full">
      <p className="css-ew64yg font-['Mulish:Black',sans-serif] font-black leading-[1.2] relative shrink-0 text-[16px] text-white">Obuna sotib oling</p>
      <Chevron2 />
    </div>
  );
}

function Text() {
  return (
    <div className="absolute content-stretch flex flex-col items-start left-[116px] top-[20px] w-[207px]" data-name="Text">
      <Frame2 />
      <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] relative shrink-0 text-[12px] text-white w-full">Bizning obuna orqali 50% gacha pul tejaysiz!</p>
    </div>
  );
}

function Group1() {
  return (
    <div className="absolute contents left-[-9px] top-[-20px]">
      <div className="absolute h-[161.25px] left-[-9px] top-[-20px] w-[129px]" data-name="image 19">
        <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgImage19} />
      </div>
    </div>
  );
}

function Component3DImage() {
  return (
    <div className="absolute h-[91px] left-0 top-0 w-[104px]" data-name="3D image">
      <Group1 />
    </div>
  );
}

function Container1() {
  return (
    <div className="absolute bg-[#03142a] h-[92px] left-[16px] overflow-clip rounded-[20px] top-[614px] w-[343px]" data-name="Container">
      <div className="absolute flex h-[103.9px] items-center justify-center left-[242.34px] top-[-60.45px] w-[186.314px]" style={{ "--transform-inner-width": "0", "--transform-inner-height": "0" } as React.CSSProperties}>
        <div className="flex-none rotate-[15.41deg]">
          <div className="bg-[#00bffe] blur-[30px] h-[59px] rounded-[1000px] w-[177px]" />
        </div>
      </div>
      <div className="absolute bg-[#00bffe] blur-[34.35px] bottom-[-39px] h-[66px] left-[-49px] rounded-[1000px] w-[63px]" />
      <Text />
      <Component3DImage />
    </div>
  );
}

function PinRight() {
  return (
    <div className="absolute h-[12px] right-[13px] top-[calc(50%+1px)] translate-y-[-50%] w-[67.272px]" data-name="Pin Right">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 67.2724 12">
        <g clipPath="url(#clip0_6_10690)" id="Pin Right">
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
          <clipPath id="clip0_6_10690">
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
      <Container1 />
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

function Group2() {
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
      <Group2 />
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

function Group4() {
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

function Group3() {
  return (
    <div className="absolute contents inset-[16.67%_8.33%]" data-name="Group">
      <Group4 />
    </div>
  );
}

function Subs() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="subs">
      <Group3 />
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

export default function Subscription1st() {
  return (
    <div className="overflow-clip relative rounded-[40px] size-full" data-name="Subscription 1st">
      <MProfileSigned />
      <Navigation />
    </div>
  );
}