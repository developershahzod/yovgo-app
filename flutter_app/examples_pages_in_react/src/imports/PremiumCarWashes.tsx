import svgPaths from "./svg-hnahr4kgzq";
import imgImage14 from "figma:asset/262716fecd02c7d38856707e19bc30863e5c869c.png";
import imgImage from "figma:asset/194b66145883c040db1229c8b27859f09f39f78f.png";
import imgImage1 from "figma:asset/4b1424abcdb0e2bc7c588b386fefdd18f7346127.png";
import imgImage2 from "figma:asset/c5a726432db7596ee5d4f6a73b2e16ddb181dc11.png";
import imgImage3 from "figma:asset/f1b5f4ba675e1a1231397f69c960d551e8586a15.png";

function Address() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="address">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g clipPath="url(#clip0_1_5745)" id="address">
          <path d={svgPaths.pabd6480} fill="var(--fill-0, white)" id="Subtract" />
        </g>
        <defs>
          <clipPath id="clip0_1_5745">
            <rect fill="white" height="16" width="16" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Badges() {
  return (
    <div className="bg-[#03142a] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[7px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Address />
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[11px] text-white">
        <p className="css-ew64yg leading-[1.2]">777 car wash</p>
      </div>
    </div>
  );
}

function Star() {
  return (
    <div className="relative shrink-0 size-[12px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 12 12">
        <g id="star">
          <path d={svgPaths.p36d60f70} fill="var(--fill-0, #0A0C13)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Rating() {
  return (
    <div className="content-stretch flex gap-[2px] h-[20px] items-center justify-center relative rounded-[25px] shrink-0" data-name="Rating">
      <Star />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">5.0</p>
      </div>
    </div>
  );
}

function Frame1() {
  return (
    <div className="backdrop-blur-[5px] bg-[rgba(255,255,255,0.5)] content-stretch flex gap-[2px] h-[20px] items-center pr-[4px] relative rounded-[25px] shrink-0">
      <Badges />
      <Rating />
    </div>
  );
}

function CarWashPin() {
  return (
    <div className="absolute content-stretch flex gap-[2px] items-center left-[48px] shadow-[0px_2px_10px_0px_rgba(0,0,0,0.15)] top-[184px]" data-name="Car wash pin">
      <div className="relative shrink-0 size-[4px]" data-name="dot">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(3, 20, 42, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 4 4">
            <circle cx="2" cy="2" fill="var(--fill-0, #03142A)" id="dot" r="2" />
          </svg>
        </div>
      </div>
      <Frame1 />
    </div>
  );
}

function Address1() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="address">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g clipPath="url(#clip0_1_5745)" id="address">
          <path d={svgPaths.pabd6480} fill="var(--fill-0, white)" id="Subtract" />
        </g>
        <defs>
          <clipPath id="clip0_1_5745">
            <rect fill="white" height="16" width="16" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Badges1() {
  return (
    <div className="bg-[#03142a] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[7px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Address1 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] relative shrink-0 text-[11px] text-white">
        <p className="css-ew64yg leading-[1.2]">Black Star</p>
      </div>
    </div>
  );
}

function Star1() {
  return (
    <div className="relative shrink-0 size-[12px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 12 12">
        <g id="star">
          <path d={svgPaths.p36d60f70} fill="var(--fill-0, #0A0C13)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Rating1() {
  return (
    <div className="content-stretch flex gap-[2px] h-[20px] items-center justify-center relative rounded-[25px] shrink-0" data-name="Rating">
      <Star1 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">5.0</p>
      </div>
    </div>
  );
}

function Frame2() {
  return (
    <div className="backdrop-blur-[5px] bg-[rgba(255,255,255,0.5)] content-stretch flex gap-[2px] h-[20px] items-center pr-[4px] relative rounded-[25px] shrink-0">
      <Badges1 />
      <Rating1 />
    </div>
  );
}

function CarWashPin1() {
  return (
    <div className="absolute content-stretch flex gap-[2px] items-center left-[122px] shadow-[0px_2px_10px_0px_rgba(0,0,0,0.15)] top-[88px]" data-name="Car wash pin">
      <div className="relative shrink-0 size-[4px]" data-name="dot">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(3, 20, 42, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 4 4">
            <circle cx="2" cy="2" fill="var(--fill-0, #03142A)" id="dot" r="2" />
          </svg>
        </div>
      </div>
      <Frame2 />
    </div>
  );
}

function Map() {
  return (
    <div className="h-[812px] pointer-events-auto sticky top-0 w-[375px]" data-name="Map">
      <div className="absolute h-[892px] left-[-208px] top-[-131px] w-[876px]" data-name="image 14">
        <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgImage14} />
      </div>
      <CarWashPin />
      <CarWashPin1 />
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

function Search() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="search">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="search">
          <path d={svgPaths.p3a3e5070} id="Vector" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M18.75 18.75L15.4875 15.4875" id="Vector_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Searchbar() {
  return (
    <div className="backdrop-blur-[10px] bg-white relative rounded-[43px] shrink-0 w-full" data-name="searchbar">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[43px] shadow-[0px_2px_20px_0px_rgba(0,0,0,0.1)]" />
      <div className="flex flex-row items-center justify-center size-full">
        <div className="content-stretch flex gap-[8px] items-center justify-center px-[16px] py-[12px] relative w-full">
          <Search />
          <div className="flex flex-[1_0_0] flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] min-h-px min-w-px relative text-[#bbbfc5] text-[15px]">
            <p className="css-4hzbpn leading-[1.2]">Avto moykalarni qidirish</p>
          </div>
        </div>
      </div>
    </div>
  );
}

function Clock() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="Clock">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g clipPath="url(#clip0_1_5740)" id="Clock">
          <path d={svgPaths.p100f1000} fill="var(--fill-0, white)" id="Exclude" />
        </g>
        <defs>
          <clipPath id="clip0_1_5740">
            <rect fill="white" height="16" width="16" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Badges2() {
  return (
    <div className="backdrop-blur-[10px] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges" style={{ backgroundImage: "linear-gradient(120.83deg, rgb(0, 191, 254) 10.992%, rgb(16, 152, 255) 89.008%)" }}>
      <Clock />
    </div>
  );
}

function Badge() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges2 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">24/7</p>
      </div>
    </div>
  );
}

function Clock1() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="Clock">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g clipPath="url(#clip0_1_5740)" id="Clock">
          <path d={svgPaths.p100f1000} fill="var(--fill-0, white)" id="Exclude" />
        </g>
        <defs>
          <clipPath id="clip0_1_5740">
            <rect fill="white" height="16" width="16" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Badges3() {
  return (
    <div className="backdrop-blur-[10px] bg-[#5ccc27] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Clock1 />
    </div>
  );
}

function Badge1() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges3 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Hozir ochiq</p>
      </div>
    </div>
  );
}

function Navigator() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="navigator">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="navigator">
          <path clipRule="evenodd" d={svgPaths.p2c49f200} fill="var(--fill-0, white)" fillRule="evenodd" id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Badges4() {
  return (
    <div className="backdrop-blur-[10px] bg-[#8f96a0] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Navigator />
    </div>
  );
}

function Badge2() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges4 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Eng yaqin</p>
      </div>
    </div>
  );
}

function Star2() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="star">
          <path d={svgPaths.p31704780} fill="var(--fill-0, white)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Badges5() {
  return (
    <div className="backdrop-blur-[10px] bg-[#8f96a0] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Star2 />
    </div>
  );
}

function Badge3() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges5 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Reytingi baland</p>
      </div>
    </div>
  );
}

function Crown() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="crown">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="crown">
          <path clipRule="evenodd" d={svgPaths.p3bc65c00} fill="var(--fill-0, white)" fillRule="evenodd" id="Vector" />
        </g>
      </svg>
    </div>
  );
}

function Badges6() {
  return (
    <div className="backdrop-blur-[10px] bg-[#8f96a0] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Crown />
    </div>
  );
}

function Badge4() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges6 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Premium</p>
      </div>
    </div>
  );
}

function HotSearch() {
  return (
    <div className="content-stretch flex gap-[16px] items-start py-[16px] relative shrink-0 w-[343px]" data-name="Hot search">
      <Badge />
      <Badge1 />
      <Badge2 />
      <Badge3 />
      <Badge4 />
    </div>
  );
}

function SearchBar() {
  return (
    <div className="bg-[rgba(255,255,255,0.85)] content-stretch flex flex-col items-center justify-center pb-[16px] px-[16px] relative shrink-0 w-[375px]" data-name="Search bar">
      <Drag />
      <Searchbar />
      <HotSearch />
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

function Map1() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="map">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="Group">
          <g id="Group_2">
            <path clipRule="evenodd" d={svgPaths.p3a6e9400} fillRule="evenodd" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M15 9.53V15.47" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M9 7.53V13.47" id="Path_3" stroke="var(--stroke-0, #00BFFE)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
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
      <Map1 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">Xarita</p>
      </div>
    </div>
  );
}

function Group() {
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

function Qr() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="qr">
      <Group />
    </div>
  );
}

function NavItem2() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-center justify-center overflow-clip p-[4px] relative shrink-0 size-[48px]" data-name="nav-item">
      <Qr />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[11px]">
        <p className="css-ew64yg leading-[1.2]">QR kod</p>
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

function NavItem3() {
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
        <div className="content-stretch flex items-end justify-between pt-[8px] px-[24px] relative size-full">
          <NavItem />
          <NavItem1 />
          <NavItem2 />
          <NavItem3 />
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
    <div className="backdrop-blur-[10px] bg-[rgba(255,255,255,0.85)] content-stretch flex flex-col items-center justify-center overflow-clip relative rounded-tl-[22px] rounded-tr-[22px] shadow-[0px_-4px_25px_0px_rgba(0,0,0,0.2)] shrink-0 w-full" data-name="navbar">
      <SearchBar />
      <div className="h-0 relative shrink-0 w-full" data-name="divider">
        <div className="absolute inset-[-1px_0_0_0]" style={{ "--stroke-0": "rgba(0, 0, 0, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 375 1">
            <line id="divider" stroke="var(--stroke-0, black)" strokeOpacity="0.05" x2="375" y1="0.5" y2="0.5" />
          </svg>
        </div>
      </div>
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

function Drag1() {
  return (
    <div className="content-stretch flex flex-col items-center justify-center py-[6px] relative shrink-0 w-full" data-name="Drag">
      <div className="bg-[#d9dde3] h-[4px] rounded-[23px] shrink-0 w-[32px]" data-name="drag" />
    </div>
  );
}

function Search1() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="search">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="search">
          <path d={svgPaths.p3a3e5070} id="Vector" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M18.75 18.75L15.4875 15.4875" id="Vector_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Searchbar1() {
  return (
    <div className="backdrop-blur-[10px] bg-white flex-[1_0_0] min-h-px min-w-px relative rounded-[43px]" data-name="searchbar">
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[43px] shadow-[0px_2px_20px_0px_rgba(0,0,0,0.1)]" />
      <div className="flex flex-row items-center justify-center size-full">
        <div className="content-stretch flex gap-[8px] items-center justify-center px-[16px] py-[12px] relative w-full">
          <Search1 />
          <div className="flex flex-[1_0_0] flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] min-h-px min-w-px relative text-[#bbbfc5] text-[15px]">
            <p className="css-4hzbpn leading-[1.2]">Avto moykalarni qidirish</p>
          </div>
        </div>
      </div>
    </div>
  );
}

function Cross() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="cross">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="cross">
          <path d="M6 6L18 18" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M18 6L6 18" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Suffix() {
  return (
    <div className="backdrop-blur-[10px] bg-white h-[48px] relative rounded-[43px] shrink-0" data-name="suffix">
      <div className="content-stretch flex h-full items-center justify-center overflow-clip p-[12px] relative rounded-[inherit]">
        <Cross />
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[43px] shadow-[0px_2px_20px_0px_rgba(0,0,0,0.1)]" />
    </div>
  );
}

function Frame() {
  return (
    <div className="content-stretch flex gap-[8px] items-start relative shrink-0 w-full">
      <Searchbar1 />
      <Suffix />
    </div>
  );
}

function Crown1() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="crown">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="crown">
          <path clipRule="evenodd" d={svgPaths.p3bc65c00} fill="var(--fill-0, white)" fillRule="evenodd" id="Vector" />
        </g>
      </svg>
    </div>
  );
}

function Badges7() {
  return (
    <div className="backdrop-blur-[10px] bg-[#8f96a0] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Crown1 />
    </div>
  );
}

function Badge5() {
  return (
    <div className="bg-[#0a0c13] content-stretch flex gap-[6px] items-center pl-[4px] pr-[8px] py-[4px] relative rounded-[10px] shrink-0" data-name="Badge">
      <Badges7 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[13px] text-white">
        <p className="css-ew64yg leading-[1.2]">Premium</p>
      </div>
    </div>
  );
}

function Clock2() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="Clock">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g clipPath="url(#clip0_1_5740)" id="Clock">
          <path d={svgPaths.p100f1000} fill="var(--fill-0, white)" id="Exclude" />
        </g>
        <defs>
          <clipPath id="clip0_1_5740">
            <rect fill="white" height="16" width="16" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Badges8() {
  return (
    <div className="backdrop-blur-[10px] bg-[#5ccc27] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Clock2 />
    </div>
  );
}

function Badge6() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges8 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">24/7</p>
      </div>
    </div>
  );
}

function Clock3() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="Clock">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g clipPath="url(#clip0_1_5740)" id="Clock">
          <path d={svgPaths.p100f1000} fill="var(--fill-0, white)" id="Exclude" />
        </g>
        <defs>
          <clipPath id="clip0_1_5740">
            <rect fill="white" height="16" width="16" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Badges9() {
  return (
    <div className="backdrop-blur-[10px] bg-[#00bffe] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Clock3 />
    </div>
  );
}

function Badge7() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges9 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Hozir ochiq</p>
      </div>
    </div>
  );
}

function Navigator1() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="navigator">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="navigator">
          <path clipRule="evenodd" d={svgPaths.p2c49f200} fill="var(--fill-0, white)" fillRule="evenodd" id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Badges10() {
  return (
    <div className="backdrop-blur-[10px] bg-[#8f96a0] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Navigator1 />
    </div>
  );
}

function Badge8() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges10 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Eng yaqin</p>
      </div>
    </div>
  );
}

function Star3() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="star">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="star">
          <path d={svgPaths.p31704780} fill="var(--fill-0, white)" id="Intersect" />
        </g>
      </svg>
    </div>
  );
}

function Badges11() {
  return (
    <div className="backdrop-blur-[10px] bg-[#8f96a0] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Star3 />
    </div>
  );
}

function Badge9() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges11 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Reytingi baland</p>
      </div>
    </div>
  );
}

function Group1() {
  return (
    <div className="absolute inset-[-0.02%]" data-name="Group">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16.0067 16.0067">
        <g id="Group">
          <path d={svgPaths.p8cc1f00} fill="var(--fill-0, white)" id="Union" />
          <g id="Rectangle"></g>
        </g>
      </svg>
    </div>
  );
}

function Bookmark() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="bookmark">
      <Group1 />
    </div>
  );
}

function Badges12() {
  return (
    <div className="backdrop-blur-[10px] bg-[#8f96a0] content-stretch flex items-center justify-center p-[4px] relative rounded-[8px] shrink-0" data-name="Badges">
      <Bookmark />
    </div>
  );
}

function Badge10() {
  return (
    <div className="content-stretch flex gap-[6px] items-center relative shrink-0" data-name="Badge">
      <Badges12 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[13px]">
        <p className="css-ew64yg leading-[1.2]">Saqlanganlar</p>
      </div>
    </div>
  );
}

function HotSearch1() {
  return (
    <div className="content-stretch flex gap-[16px] h-[56px] items-center relative shrink-0 w-[343px]" data-name="Hot search">
      <Badge5 />
      <Badge6 />
      <Badge7 />
      <Badge8 />
      <Badge9 />
      <Badge10 />
    </div>
  );
}

function Star4() {
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

function Badges13() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star4 />
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
          <Badges13 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Group2() {
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
      <Group2 />
    </div>
  );
}

function Clock4() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime />
    </div>
  );
}

function Badges14() {
  return (
    <div className="backdrop-blur-[10px] bg-[#e5f9ff] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[16px] shrink-0" data-name="Badges">
      <Clock4 />
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
      <Badges14 />
      <Details />
    </div>
  );
}

function NearestCarWash() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-full" data-name="nearest car wash">
      <Image />
      <Content />
    </div>
  );
}

function Star5() {
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

function Badges15() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star5 />
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
          <Badges15 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Group3() {
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
      <Group3 />
    </div>
  );
}

function Clock5() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime1 />
    </div>
  );
}

function Badges16() {
  return (
    <div className="bg-[#ffebeb] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[7px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Clock5 />
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
      <Badges16 />
      <Details1 />
    </div>
  );
}

function NearestCarWash1() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-full" data-name="nearest car wash">
      <Image1 />
      <Content1 />
    </div>
  );
}

function Star6() {
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

function Badges17() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star6 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">4.6</p>
      </div>
    </div>
  );
}

function Image2() {
  return (
    <div className="h-[160px] relative rounded-[20px] shrink-0 w-full" data-name="image">
      <div aria-hidden="true" className="absolute inset-0 pointer-events-none rounded-[20px]">
        <img alt="" className="absolute max-w-none object-cover rounded-[20px] size-full" src={imgImage} />
        <img alt="" className="absolute max-w-none object-cover rounded-[20px] size-full" src={imgImage2} />
      </div>
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start justify-end p-[12px] relative size-full">
          <Badges17 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Group4() {
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
      <Group4 />
    </div>
  );
}

function Clock6() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime2 />
    </div>
  );
}

function Badges18() {
  return (
    <div className="backdrop-blur-[10px] bg-[#eeffe7] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[16px] shrink-0" data-name="Badges">
      <Clock6 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#5ccc27] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">24/7 ochiq</p>
      </div>
    </div>
  );
}

function TitleDatetime2() {
  return (
    <div className="content-stretch flex items-center relative shrink-0 w-full" data-name="title&datetime">
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[15px] text-ellipsis">DJ Car Wash</p>
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
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[14px]">1.2 km</p>
    </div>
  );
}

function Details2() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime2 />
      <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] max-h-[36px] min-w-full overflow-hidden relative shrink-0 text-[#0a0c13] text-[14px] text-ellipsis w-[min-content]">Chimrobod ko’chasi 28, Тоshkent, Toshkent</p>
      <Location2 />
    </div>
  );
}

function Content2() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges18 />
      <Details2 />
    </div>
  );
}

function NearestCarWash2() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-full" data-name="nearest car wash">
      <Image2 />
      <Content2 />
    </div>
  );
}

function Star7() {
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

function Badges19() {
  return (
    <div className="bg-white content-stretch flex gap-[4px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[25px] shrink-0" data-name="Badges">
      <Star7 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">4.6</p>
      </div>
    </div>
  );
}

function Image3() {
  return (
    <div className="h-[160px] relative rounded-[20px] shrink-0 w-full" data-name="image">
      <div aria-hidden="true" className="absolute inset-0 pointer-events-none rounded-[20px]">
        <img alt="" className="absolute max-w-none object-cover rounded-[20px] size-full" src={imgImage} />
        <img alt="" className="absolute max-w-none object-cover rounded-[20px] size-full" src={imgImage3} />
      </div>
      <div className="flex flex-col justify-end overflow-clip rounded-[inherit] size-full">
        <div className="content-stretch flex flex-col items-start justify-end p-[12px] relative size-full">
          <Badges19 />
        </div>
      </div>
      <div aria-hidden="true" className="absolute border border-[rgba(0,0,0,0.05)] border-solid inset-0 pointer-events-none rounded-[20px]" />
    </div>
  );
}

function Group5() {
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
      <Group5 />
    </div>
  );
}

function Clock7() {
  return (
    <div className="overflow-clip relative shrink-0 size-[16px]" data-name="clock">
      <ClockTime3 />
    </div>
  );
}

function Badges20() {
  return (
    <div className="backdrop-blur-[10px] bg-[#ffedbf] content-stretch flex gap-[4px] h-[20px] items-center justify-center pl-[2px] pr-[6px] py-[2px] relative rounded-[16px] shrink-0" data-name="Badges">
      <Clock7 />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Black',sans-serif] font-black justify-center leading-[0] relative shrink-0 text-[#fc941a] text-[10px] uppercase">
        <p className="css-ew64yg leading-[1.2]">2 soatda yopiladi</p>
      </div>
    </div>
  );
}

function TitleDatetime3() {
  return (
    <div className="content-stretch flex items-center relative shrink-0 w-full" data-name="title&datetime">
      <p className="css-g0mm18 flex-[1_0_0] font-['Mulish:Black',sans-serif] font-black leading-[1.2] min-h-px min-w-px overflow-hidden relative text-[#0a0c13] text-[15px] text-ellipsis">Car wash 777</p>
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
      <p className="css-4hzbpn flex-[1_0_0] font-['Mulish:SemiBold',sans-serif] font-semibold leading-[1.2] min-h-px min-w-px relative text-[#00bffe] text-[14px]">1.5 km</p>
    </div>
  );
}

function Details3() {
  return (
    <div className="content-stretch flex flex-col gap-[4px] items-start relative shrink-0 w-full" data-name="details">
      <TitleDatetime3 />
      <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] max-h-[36px] min-w-full overflow-hidden relative shrink-0 text-[#0a0c13] text-[14px] text-ellipsis w-[min-content]">Qumariq ko’chasi 59 Tashkent</p>
      <Location3 />
    </div>
  );
}

function Content3() {
  return (
    <div className="content-stretch flex flex-col gap-[8px] items-start pt-[8px] relative shrink-0 w-full" data-name="content">
      <Badges20 />
      <Details3 />
    </div>
  );
}

function NearestCarWash3() {
  return (
    <div className="content-stretch flex flex-col items-start relative rounded-[16px] shrink-0 w-full" data-name="nearest car wash">
      <Image3 />
      <Content3 />
    </div>
  );
}

function Container() {
  return (
    <div className="content-stretch flex flex-col gap-[24px] items-start justify-center pb-[32px] relative shrink-0 w-full" data-name="Container">
      <NearestCarWash />
      <NearestCarWash1 />
      <NearestCarWash2 />
      <NearestCarWash3 />
    </div>
  );
}

function SearchBar1() {
  return (
    <div className="absolute backdrop-blur-[10px] bg-[rgba(255,255,255,0.85)] content-stretch flex flex-col items-center left-0 pb-[16px] px-[16px] rounded-tl-[22px] rounded-tr-[22px] shadow-[0px_-4px_25px_0px_rgba(0,0,0,0.2)] top-[260px] w-[375px]" data-name="Search bar">
      <Drag1 />
      <Frame />
      <HotSearch1 />
      <Container />
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

export default function PremiumCarWashes() {
  return (
    <div className="bg-white overflow-clip relative rounded-[40px] size-full" data-name="Premium car washes">
      <div className="absolute h-0 left-0 top-[881px] w-[375px]">
        <div className="absolute inset-0" style={{ "--fill-0": "rgba(22, 22, 22, 1)" } as React.CSSProperties}>
          <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 32 32">
            <g id="Line 4" opacity="0.4"></g>
          </svg>
        </div>
      </div>
      <div className="absolute bottom-0 h-[812px] left-0 pointer-events-none top-0">
        <Map />
      </div>
      <Navigation />
      <SearchBar1 />
      <IOsStatusBar />
    </div>
  );
}