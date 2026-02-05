import { createBrowserRouter } from "react-router";
import LandingWrapper from "./components/LandingWrapper";
import PartnersWrapper from "./components/PartnersWrapper";
import Root from "./components/Root";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      { index: true, Component: LandingWrapper },
      { path: "partners", Component: PartnersWrapper },
    ],
  },
]);