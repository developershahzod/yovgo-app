import { useState } from "react";
import Subscription1st from "@/imports/Subscription1st";
import Subscription30 from "@/imports/Subscription30";
import Subscription90 from "@/imports/Subscription90";
import Subscription365 from "@/imports/Subscription365";
import SubscriptionQuestions from "@/imports/SubscriptionQuestions";
import SubscriptionFreeze from "@/imports/SubscriptionFreeze";

type SubscriptionScreen = "1st" | "30" | "90" | "365" | "questions" | "freeze";

export default function Subscription() {
  const [subscriptionScreen, setSubscriptionScreen] = useState<SubscriptionScreen>("1st");

  const renderSubscriptionScreen = () => {
    switch (subscriptionScreen) {
      case "1st":
        return <Subscription1st />;
      case "30":
        return <Subscription30 />;
      case "90":
        return <Subscription90 />;
      case "365":
        return <Subscription365 />;
      case "questions":
        return <SubscriptionQuestions />;
      case "freeze":
        return <SubscriptionFreeze />;
      default:
        return <Subscription1st />;
    }
  };

  return (
    <div className="relative size-full">
      {/* Subscription Screen Selector - Floating at top */}
      <div className="absolute top-2 left-1/2 -translate-x-1/2 z-50 flex gap-1 bg-white/95 backdrop-blur-sm rounded-full p-1 shadow-xl max-w-[370px] overflow-x-auto">
        <button
          onClick={() => setSubscriptionScreen("1st")}
          className={`px-2.5 py-1.5 rounded-full font-semibold transition-all text-[10px] whitespace-nowrap ${
            subscriptionScreen === "1st"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          Guest
        </button>
        <button
          onClick={() => setSubscriptionScreen("30")}
          className={`px-2.5 py-1.5 rounded-full font-semibold transition-all text-[10px] whitespace-nowrap ${
            subscriptionScreen === "30"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          30 kun
        </button>
        <button
          onClick={() => setSubscriptionScreen("90")}
          className={`px-2.5 py-1.5 rounded-full font-semibold transition-all text-[10px] whitespace-nowrap ${
            subscriptionScreen === "90"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          90 kun
        </button>
        <button
          onClick={() => setSubscriptionScreen("365")}
          className={`px-2.5 py-1.5 rounded-full font-semibold transition-all text-[10px] whitespace-nowrap ${
            subscriptionScreen === "365"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          365 kun
        </button>
        <button
          onClick={() => setSubscriptionScreen("questions")}
          className={`px-2.5 py-1.5 rounded-full font-semibold transition-all text-[10px] whitespace-nowrap ${
            subscriptionScreen === "questions"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          FAQ
        </button>
        <button
          onClick={() => setSubscriptionScreen("freeze")}
          className={`px-2.5 py-1.5 rounded-full font-semibold transition-all text-[10px] whitespace-nowrap ${
            subscriptionScreen === "freeze"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          Muzlatish
        </button>
      </div>

      {/* Subscription Screen Content */}
      <div className="size-full">
        {renderSubscriptionScreen()}
      </div>
    </div>
  );
}
