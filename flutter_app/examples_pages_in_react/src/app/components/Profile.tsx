import { useState } from "react";
import MProfileNewUser from "@/imports/MProfileNewUser";
import MProfileSigned from "@/imports/MProfileSigned";
import MProfileSignedPremium from "@/imports/MProfileSignedPremium";

type ProfileScreen = "new" | "signed" | "premium";

export default function Profile() {
  const [profileScreen, setProfileScreen] = useState<ProfileScreen>("new");

  const renderProfileScreen = () => {
    switch (profileScreen) {
      case "new":
        return <MProfileNewUser />;
      case "signed":
        return <MProfileSigned />;
      case "premium":
        return <MProfileSignedPremium />;
      default:
        return <MProfileNewUser />;
    }
  };

  return (
    <div className="relative size-full">
      {/* Profile Screen Selector - Floating at top */}
      <div className="absolute top-2 left-1/2 -translate-x-1/2 z-50 flex gap-1 bg-white/90 backdrop-blur-sm rounded-full p-1 shadow-lg">
        <button
          onClick={() => setProfileScreen("new")}
          className={`px-3 py-1.5 rounded-full font-semibold transition-all text-xs ${
            profileScreen === "new"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          New User
        </button>
        <button
          onClick={() => setProfileScreen("signed")}
          className={`px-3 py-1.5 rounded-full font-semibold transition-all text-xs ${
            profileScreen === "signed"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          Edit Profile
        </button>
        <button
          onClick={() => setProfileScreen("premium")}
          className={`px-3 py-1.5 rounded-full font-semibold transition-all text-xs ${
            profileScreen === "premium"
              ? "bg-[#00bffe] text-white shadow-md"
              : "bg-transparent text-[#646d79] hover:bg-gray-100"
          }`}
        >
          Premium
        </button>
      </div>

      {/* Profile Screen Content */}
      <div className="size-full">
        {renderProfileScreen()}
      </div>
    </div>
  );
}
