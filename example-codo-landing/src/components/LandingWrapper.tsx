import LandingOriginal from "../imports/Landing1920";

export default function LandingWrapper() {
  return (
    <div className="w-full bg-white">
      <div className="w-[1920px] h-[6003px] mx-auto relative">
        <LandingOriginal />
      </div>
    </div>
  );
}