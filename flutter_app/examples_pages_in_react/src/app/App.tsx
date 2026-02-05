import { useState } from "react";
import Main from "@/imports/Main";
import Notifications from "@/imports/Notifications";
import Saved from "@/imports/Saved";
import PremiumCarWashes from "@/imports/PremiumCarWashes";
import Info from "@/imports/Info";
import QrCode from "@/imports/QrCode";
import ChangeCar from "@/imports/ChangeCar";
import Profile from "@/app/components/Profile";
import Subscription from "@/app/components/Subscription";
import Onboarding from "@/app/components/Onboarding";

type Screen = "main" | "notifications" | "saved" | "premium" | "info" | "qrcode" | "changecar" | "profile" | "subscription" | "onboarding";

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>("main");

  const renderScreen = () => {
    switch (currentScreen) {
      case "main":
        return <Main />;
      case "notifications":
        return <Notifications />;
      case "saved":
        return <Saved />;
      case "premium":
        return <PremiumCarWashes />;
      case "info":
        return <Info />;
      case "qrcode":
        return <QrCode />;
      case "changecar":
        return <ChangeCar />;
      case "profile":
        return <Profile />;
      case "subscription":
        return <Subscription />;
      case "onboarding":
        return <Onboarding />;
      default:
        return <Main />;
    }
  };

  return (
    <div className="min-h-screen w-full bg-gradient-to-br from-[#e8f4f8] to-[#f5f5f5] flex flex-col items-center justify-center p-4 md:p-8">
      {/* Screen Selector */}
      <div className="mb-4 flex gap-2 flex-wrap justify-center max-w-5xl">
        <button
          onClick={() => setCurrentScreen("main")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "main"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          🏠 Main
        </button>
        <button
          onClick={() => setCurrentScreen("notifications")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "notifications"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          🔔 Notifications
        </button>
        <button
          onClick={() => setCurrentScreen("saved")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "saved"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          💾 Saved
        </button>
        <button
          onClick={() => setCurrentScreen("premium")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "premium"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          ⭐ Premium
        </button>
        <button
          onClick={() => setCurrentScreen("info")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "info"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          ℹ️ QR Info
        </button>
        <button
          onClick={() => setCurrentScreen("qrcode")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "qrcode"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          📷 QR Scanner
        </button>
        <button
          onClick={() => setCurrentScreen("changecar")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "changecar"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          🚗 Change Car
        </button>
        <button
          onClick={() => setCurrentScreen("profile")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "profile"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          👤 Profile
        </button>
        <button
          onClick={() => setCurrentScreen("subscription")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "subscription"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          💰 Subscription
        </button>
        <button
          onClick={() => setCurrentScreen("onboarding")}
          className={`px-3 py-2 rounded-lg font-semibold transition-all text-sm ${
            currentScreen === "onboarding"
              ? "bg-[#00bffe] text-white shadow-lg scale-105"
              : "bg-white text-[#0a0c13] hover:bg-gray-100"
          }`}
        >
          📚 Onboarding
        </button>
      </div>

      {/* Phone Frame */}
      <div className="w-full max-w-[375px] h-[812px] overflow-hidden shadow-2xl rounded-[40px] bg-white">
        {renderScreen()}
      </div>

      {/* Screen Info */}
      <div className="mt-4 text-center text-sm text-gray-600 max-w-md">
        {currentScreen === "main" && "🏠 Home screen with premium subscription & weather"}
        {currentScreen === "notifications" && "🔔 View all your notifications and updates"}
        {currentScreen === "saved" && "💾 Your bookmarked car washes"}
        {currentScreen === "premium" && "⭐ Premium car washes map view"}
        {currentScreen === "info" && "ℹ️ How QR code scanning works - Tutorial"}
        {currentScreen === "qrcode" && "📷 Active QR code scanner - Scan to wash"}
        {currentScreen === "changecar" && "🚗 Select which car you want to wash"}
        {currentScreen === "profile" && "👤 Your profile and settings"}
        {currentScreen === "subscription" && "💰 Manage your subscription"}
        {currentScreen === "onboarding" && "📚 Welcome to the app - Get started"}
      </div>
    </div>
  );
}