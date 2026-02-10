import { createBrowserRouter } from "react-router";
import LandingPage from "./components/LandingPage";
import PartnersWrapper from "./components/PartnersWrapper";
import Root from "./components/Root";
import NotFoundPage from "./components/NotFoundPage";

export const router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    ErrorBoundary: NotFoundPage,
    children: [
      { index: true, Component: LandingPage },
      { path: "partners", Component: PartnersWrapper },
      { path: "*", Component: NotFoundPage },
    ],
  },
  {
    path: "*",
    Component: NotFoundPage,
  },
]);