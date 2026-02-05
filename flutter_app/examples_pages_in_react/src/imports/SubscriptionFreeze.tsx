import svgPaths from "./svg-xwirv2l3hw";

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

function Label() {
  return (
    <div className="content-stretch flex gap-[2px] items-center relative shrink-0 w-full" data-name="label">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[11px]">
        <p className="css-4hzbpn leading-[1.2]">Nima sababdan muzlatmoqchisiz?</p>
      </div>
    </div>
  );
}

function Values() {
  return (
    <div className="relative shrink-0 w-full" data-name="values">
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[4px] items-center pr-[16px] relative w-full">
          <div className="flex flex-[1_0_0] flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] min-h-px min-w-px relative text-[#bbbfc5] text-[15px]">
            <p className="css-4hzbpn leading-[1.2]">7 kun safarda bo’laman</p>
          </div>
        </div>
      </div>
    </div>
  );
}

function FieldContent() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[4px] h-[52px] items-start justify-center px-[8px] relative rounded-[12px] shrink-0 w-[343px]" data-name="field-content">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[12px] shadow-[0px_1px_3px_0px_rgba(0,0,0,0.15)]" />
      <Label />
      <Values />
    </div>
  );
}

function Label1() {
  return (
    <div className="content-stretch flex gap-[2px] items-center relative shrink-0 w-full" data-name="label">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[11px]">
        <p className="css-4hzbpn leading-[1.2]">Obunani muzlatish sanasi</p>
      </div>
    </div>
  );
}

function Calendar() {
  return (
    <div className="absolute right-0 size-[24px] top-[calc(50%+0.5px)] translate-y-[-50%]" data-name="calendar">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="calendar">
          <path d="M7.49813 2.99625V5.9975" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M16.5019 2.99625V5.9975" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <rect height="16.5069" id="Rectangle" rx="3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" width="18.0075" x="2.99625" y="4.49687" />
          <path d="M6.99792 10.9996H17.0021" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Values1() {
  return (
    <div className="relative shrink-0 w-full" data-name="values">
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[4px] items-center pr-[16px] relative w-full">
          <div className="flex flex-[1_0_0] flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
            <p className="css-4hzbpn leading-[1.2]">3-yanvar, 2026</p>
          </div>
          <Calendar />
        </div>
      </div>
    </div>
  );
}

function FieldContent1() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[4px] h-[52px] items-start justify-center px-[8px] relative rounded-[12px] shrink-0 w-[343px]" data-name="field-content">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[12px] shadow-[0px_1px_3px_0px_rgba(0,0,0,0.15)]" />
      <Label1 />
      <Values1 />
    </div>
  );
}

function Label2() {
  return (
    <div className="content-stretch flex gap-[2px] items-center relative shrink-0 w-full" data-name="label">
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[11px]">
        <p className="css-4hzbpn leading-[1.2]">Obunani faollashtirish sanasi</p>
      </div>
    </div>
  );
}

function Calendar1() {
  return (
    <div className="absolute right-0 size-[24px] top-[calc(50%+0.5px)] translate-y-[-50%]" data-name="calendar">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="calendar">
          <path d="M7.49813 2.99625V5.9975" id="Path" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <path d="M16.5019 2.99625V5.9975" id="Path_2" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          <rect height="16.5069" id="Rectangle" rx="3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" width="18.0075" x="2.99625" y="4.49687" />
          <path d="M6.99792 10.9996H17.0021" id="Path_3" stroke="var(--stroke-0, #0A0C13)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
        </g>
      </svg>
    </div>
  );
}

function Values2() {
  return (
    <div className="relative shrink-0 w-full" data-name="values">
      <div className="flex flex-row items-center size-full">
        <div className="content-stretch flex gap-[4px] items-center pr-[16px] relative w-full">
          <div className="flex flex-[1_0_0] flex-col font-['Mulish:Regular',sans-serif] font-normal justify-center leading-[0] min-h-px min-w-px relative text-[#0a0c13] text-[15px]">
            <p className="css-4hzbpn leading-[1.2]">10-yanvar, 2026</p>
          </div>
          <Calendar1 />
        </div>
      </div>
    </div>
  );
}

function FieldContent2() {
  return (
    <div className="bg-white content-stretch flex flex-col gap-[4px] h-[52px] items-start justify-center px-[8px] relative rounded-[12px] shrink-0 w-[343px]" data-name="field-content">
      <div aria-hidden="true" className="absolute border border-[#d9dde3] border-solid inset-0 pointer-events-none rounded-[12px] shadow-[0px_1px_3px_0px_rgba(0,0,0,0.15)]" />
      <Label2 />
      <Values2 />
    </div>
  );
}

function Frame() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[16px] items-start left-0 p-[16px] top-[100px] w-[375px]">
      <FieldContent />
      <FieldContent1 />
      <FieldContent2 />
    </div>
  );
}

function Info() {
  return (
    <div className="relative shrink-0 size-[16px]" data-name="info">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g clipPath="url(#clip0_6_11032)" id="info">
          <path d={svgPaths.p1e90dd80} fill="var(--fill-0, #8F96A0)" id="Subtract" />
        </g>
        <defs>
          <clipPath id="clip0_6_11032">
            <rect fill="white" height="16" width="16" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function FieldHint() {
  return (
    <div className="absolute content-stretch flex gap-[6px] items-center left-[16px] top-[676px] w-[343px]" data-name="field-hint">
      <Info />
      <div className="flex flex-[1_0_0] flex-col font-['Mulish:SemiBold',sans-serif] font-semibold justify-center leading-[0] min-h-px min-w-px relative text-[#8f96a0] text-[12px]">
        <p className="css-4hzbpn leading-[1.2]">Obuna muzlatilgandan so’ng, belgilangan muddatgacha avtomoykalarga QR kod orqali kira olmaysiz</p>
      </div>
    </div>
  );
}

function Snow() {
  return (
    <div className="relative shrink-0 size-[20px]" data-name="snow">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 20 20">
        <g id="Group">
          <g id="Group_2">
            <path d="M10 2.5V17.5" id="Path" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p5712600} id="Path_2" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M16.6667 6.15L3.33333 13.85" id="Path_3" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p3e0f600} id="Path_4" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.pc228300} id="Path_5" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d="M3.33333 6.15L16.6667 13.85" id="Path_6" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p17b0100} id="Path_7" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p2583a8c0} id="Path_8" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
            <path d={svgPaths.p3813cdc0} id="Path_9" stroke="var(--stroke-0, white)" strokeLinecap="round" strokeLinejoin="round" strokeWidth="1.5" />
          </g>
          <g id="Path_10" />
        </g>
      </svg>
    </div>
  );
}

function ButtonMin() {
  return (
    <div className="absolute backdrop-blur-[10px] bg-[#03142a] content-stretch flex gap-[6px] h-[50px] items-center justify-center left-1/2 p-[16px] rounded-[16px] shadow-[0px_2px_20px_0px_rgba(0,0,0,0.25)] top-[720px] translate-x-[-50%] w-[343px]" data-name="button-min">
      <Snow />
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[15px] text-white">
        <p className="css-ew64yg leading-[1.2]">Muzlatish</p>
      </div>
    </div>
  );
}

function Label3() {
  return (
    <div className="absolute content-stretch flex flex-col gap-[2px] items-center justify-center left-[calc(50%+0.5px)] top-1/2 translate-x-[-50%] translate-y-[-50%]" data-name="label">
      <div className="css-g0mm18 flex flex-col font-['Mulish:Bold',sans-serif] font-bold justify-center leading-[0] relative shrink-0 text-[#0a0c13] text-[16px] text-center">
        <p className="css-ew64yg leading-[1.2]">Obunani muzlatish</p>
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
      <Label3 />
      <Arrow />
    </div>
  );
}

export default function SubscriptionFreeze() {
  return (
    <div className="bg-white overflow-clip relative rounded-[40px] size-full" data-name="Subscription_Freeze">
      <IOsStatusBar />
      <Navbar />
      <Frame />
      <FieldHint />
      <ButtonMin />
      <Topbar />
    </div>
  );
}