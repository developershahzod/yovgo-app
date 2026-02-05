import { createBrowserRouter } from "react-router";
import LandingPage from "./components/LandingPage";
import PartnersWrapper from "./components/PartnersWrapper";
import Root from "./components/Root";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    children: [
      { index: true, Component: LandingPage },
      { path: "partners", Component: PartnersWrapper },
    ],
  },
]);