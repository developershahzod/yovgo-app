import { useState } from "react";
import OnboardingDefault from "@/imports/OnboardingDefault";
import OnboardingLangSwitch from "@/imports/OnboardingLangSwitch";

type OnboardingScreen = "default" | "langswitch";

export default function Onboarding() {
  const [onboardingScreen, setOnboardingScreen] = useState<OnboardingScreen>("default");

  const renderOnboardingScreen = () => {
    switch (onboardingScreen) {
      case "default":
        return <OnboardingDefault />;
      case "langswitch":
        return <OnboardingLangSwitch />;
      default:
        return <OnboardingDefault />;
    }
  };

  return (
    <div className="relative size-full">
      {/* Onboarding Screen Selector - Floating at top */}
      <div className="absolute top-2 left-1/2 -translate-x-1/2 z-50 flex gap-1 bg-white/95 backdrop-blur-sm rounded-full p-1 shadow-xl">
        <button
          onClick={() => setOnboardingScreen("default")}
          className={`px-3 py-1.5 rounded-full font-semibold transition-all text-xs whitespace-nowrap ${
            onboardingScreen === "default"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          Default
        </button>
        <button
          onClick={() => setOnboardingScreen("langswitch")}
          className={`px-3 py-1.5 rounded-full font-semibold transition-all text-xs whitespace-nowrap ${
            onboardingScreen === "langswitch"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          Lang Switcher
        </button>
      </div>

      {/* Onboarding Screen Content */}
      <div className="size-full">
        {renderOnboardingScreen()}
      </div>
    </div>
  );
}
