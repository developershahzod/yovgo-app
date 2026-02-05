import svgPaths from "./svg-iwbeefwczv";
import imgImage from "figma:asset/194b66145883c040db1229c8b27859f09f39f78f.png";
import imgImage1 from "figma:asset/4b1424abcdb0e2bc7c588b386fefdd18f7346127.png";

function Label() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[2px] items-center justify-center left-[calc(50%+0.5px)] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="label">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px] text-center">
        <p className="css-ew64yg leading-[1.2]">Saqlanganlar</p>
      </div>
    </div>
  );
}

function Arrow() {
  return (
    <div className="absolute left-[16px] size-[24px] top-1/2 translate-y-[-50%]" data-name="arrow">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="arrow">
          <g id="Path">
            <path clipRule="evenodd" d="M4.01 11.98H19Z" fill="var(--fill-0, #0A0C13)" fillRule="evenodd" />
            <path d="M4.01 11.98H19" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <path d={svgPaths.p3b3a2b00} id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Topbar() {
  return (
    <div className="absolute backdrop-blur-[10px] bg-[rgba(255,255,255,0.85)] h-[56px] left-1/2 top-[44px] translate-x-[-50%] w-[375px]" data-name="topbar">
      <Label />
      <Arrow />
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

function Image() {
  return (
    <div className="h-[160px] relative rounded-[20px] shrink-0 w-full" data-name="image">
      <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[20px] size-full" src={imgImage} />
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start justify-end p-[12px] relative size-full">
          <Badges />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Group() {
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
      <Group />
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
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[15px] text-ellipsis">Black Star Car Wash</p>
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
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[14px]">500 m</p>
    </div>
  );
}

function Details() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime />
      <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] max-h-[36px] min-w-full overflow-hidden relative shrink-0 text-[#0a0c13] text-[14px] text-ellipsis w-[min-content]">Matbuotchilar Street 32, Tashkent</p>
      <Location />
    </div>
  );
}

function Content() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges1 />
      <Details />
    </div>
  );
}

function NearestCarWash() {
  return (
    <div className="absolute content-stretch flex flex-col items-start left-[16px] rounded-[16px] top-[116px] w-[343px]" data-name="nearest car wash">
      <Image />
      <Content />
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

function Image1() {
  return (
    <div className="h-[160px] relative rounded-[20px] shrink-0 w-full" data-name="image">
      <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[20px] size-full" src={imgImage1} />
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start justify-end p-[12px] relative size-full">
          <Badges2 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Group1() {
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
      <Group1 />
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
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[15px] text-ellipsis">Wash N Go Car Wash</p>
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
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[14px]">900 m</p>
    </div>
  );
}

function Details1() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime1 />
      <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] max-h-[36px] min-w-full overflow-hidden relative shrink-0 text-[#0a0c13] text-[14px] text-ellipsis w-[min-content]">Tutzor mahallasi, 35 uy, Choshtepa, 100114, Tashkent</p>
      <Location1 />
    </div>
  );
}

function Content1() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges3 />
      <Details1 />
    </div>
  );
}

function NearestCarWash1() {
  return (
    <div className="absolute content-stretch flex flex-col items-start left-1/2 rounded-[16px] top-[395px] translate-x-[-50%] w-[343px]" data-name="nearest car wash">
      <Image1 />
      <Content1 />
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

function NavItem() {
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

function Group3() {
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
      <Group3 />
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
    <div className="backdrop-blur-[10px] bg-[rgba(255,255,255,0.85)] content-stretch flex flex-col items-center justify-center relative rounded-tl-[22px] rounded-tr-[22px] shadow-[0px_-4px_25px_0px_rgba(0,0,0,0.2)] shrink-0 w-full" data-name="navbar">
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
        <g clipPath="url(#clip0_1_3111)" id="Pin Right">
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
          <clipPath id="clip0_1_3111">
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
      <div className="absolute css-g0mm18 flex flex-col font-['SF_Pro_Text:Semibold',sans-serif] justify-center leading-[0] left-[28px] not-italic text-[#161616] text-[15px] top-[calc(50%+1px)] tracking-[-0.2px] translate-y-[-50%]">
        <p className="css-ew64yg leading-[normal]">9:41</p>
      </div>
    </div>
  );
}

export default function Saved() {
  return (
    <div className="bg-white overflow-clip relative rounded-[40px] size-full" data-name="Saved">
      <IOsStatusBar />
      <div className="absolute h-0 left-0 top-[881px] w-[375px]">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(22, 22, 22, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 32 32">
            <g id="Line 4" opacity="0.4"></g>
          </svg>
        </div>
      </div>
      <Topbar />
      <NearestCarWash />
      <NearestCarWash1 />
      <Navigation />
    </div>
  );
}