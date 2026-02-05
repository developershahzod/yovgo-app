import svgPaths from "./svg-fxdkkicce2";

function PinRight() {
  return (
    <div className="absolute h-[12px] right-[13px] top-[calc(50%+1px)] translate-y-[-50%] w-[67.272px]" data-name="Pin Right">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 67.2724 12">
        <g clipPath="url(#clip0_6_6948)" id="Pin Right">
          <path d={svgPaths.p17d48900} fill="var(--fill-0, #161616)" id="Mobile Signal" />
          <path d={svgPaths.p40b6ac0} fill="var(--fill-0, #161616)" id="Wifi" />
          <g id="Battery">
            <g id="Border" opacity="0.4">
              <path clipRule="evenodd" d={svgPaths.p2a8e080} fill="var(--fill-0, #161616)" fillRule="evenodd" />
              <path d={svgPaths.p2c54ff00} fill="var(--fill-0, #161616)" />
            </g>
            <path clipRule="evenodd" d={svgPaths.p17951900} fill="var(--fill-0, #161616)" fillRule="evenodd" id="Charge" />
          </g>
        </g>
        <defs>
          <clipPath id="clip0_6_6948">
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
      <div className="absolute css-g0mm18 flex flex-col font-['SF_Pro_Text:Semibold',sans-serif] justify-center leading-[0] left-[28px] not-italic text-[#161616] text-[15px] top-[calc(50%+1px)] tracking-[-0.2px] translate-y-[-50%]">
        <p className="css-ew64yg leading-[normal]">9:41</p>
      </div>
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

function Chevron() {
  return (
    <div className="relative shrink-0 size-[24px]" data-name="chevron">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="chevron">
          <path d="M16 14L12 10L8 14" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Container() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="Container">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
        <p className="css-4hzbpn leading-[1.2]">Qanday qilib obuna sotib olish mumkin?</p>
      </div>
      <Chevron />
    </div>
  );
}

function Faq() {
  return (
    <div className="bg-white relative rounded-[20px] shrink-0 w-full" data-name="FAQ">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[20px]" />
      <div className="flex flex-col items-center size-full">
        <div className="content-stretch flex flex-col gap-[12px] items-center px-[16px] py-[12px] relative w-full">
          <Container />
          <div className="h-0 relative shrink-0 w-full">
            <div className="absolute inset-[-1px_0_0_0]" style={{ "--stroke-0": "rgba(217, 221, 227, 1)" } as React.CSSProperties}>
              <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 311 1">
                <line id="Line 11" stroke="var(--stroke-0, #D9DDE3)" x2="311" y1="0.5" y2="0.5" />
              </svg>
            </div>
          </div>
          <p className="css-4hzbpn font-['Mulish:Regular',sans-serif] font-normal leading-[1.2] relative shrink-0 text-[#040d19] text-[14px] w-full">Go to personalization section and click the “Retake quiz” button.</p>
        </div>
      </div>
    </div>
  );
}

function Chevron1() {
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

function Container1() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="Container">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
        <p className="css-4hzbpn leading-[1.2]">Obuna muddati necha kun?</p>
      </div>
      <Chevron1 />
    </div>
  );
}

function Faq1() {
  return (
    <div className="bg-white relative rounded-[20px] shrink-0 w-full" data-name="FAQ">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[20px]" />
      <div className="flex flex-col items-center size-full">
        <div className="content-stretch flex flex-col items-center px-[16px] py-[12px] relative w-full">
          <Container1 />
        </div>
      </div>
    </div>
  );
}

function Chevron2() {
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

function Container2() {
  return (
    <div className="content-stretch flex gap-[8px] items-center relative shrink-0 w-full" data-name="Container">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
        <p className="css-4hzbpn leading-[1.2]">1 oylik qatnovlar soni nechta?</p>
      </div>
      <Chevron2 />
    </div>
  );
}

function Faq2() {
  return (
    <div className="bg-white relative rounded-[20px] shrink-0 w-full" data-name="FAQ">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[20px]" />
      <div className="flex flex-col items-center size-full">
        <div className="content-stretch flex flex-col items-center px-[16px] py-[12px] relative w-full">
          <Container2 />
        </div>
      </div>
    </div>
  );
}

function Frame() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[12px] items-start left-[16px] top-[116px] w-[343px]">
      <Faq />
      <Faq1 />
      <Faq2 />
    </div>
  );
}

function Label() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[2px] items-center justify-center left-[calc(50%+0.5px)] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="label">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px] text-center">
        <p className="css-ew64yg leading-[1.2]">Savollar va javoblar</p>
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

export default function SubscriptionQuestions() {
  return (
    <div className="bg-white overflow-clip relative rounded-[40px] size-full" data-name="Subscription_Questions">
      <IOsStatusBar />
      <Navbar />
      <Frame />
      <Topbar />
    </div>
  );
}