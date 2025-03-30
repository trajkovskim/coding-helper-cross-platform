import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import { BrowserRouter, Route, Routes } from 'react-router-dom'
import routes, { RouteOptions } from 'routes';

const renderRoutes = (routess?: RouteOptions) => {
  return (
    <>
      {Object.entries(routess ?? {}).map(([route, options]) => (
        <Route key={route} path={route} element={options.element}>
          {options.children && renderRoutes(options.children)}
        </Route>
      ))}
    </>
  );
};

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <Routes>{renderRoutes(routes)}</Routes>
    </BrowserRouter>
  </StrictMode>
);
