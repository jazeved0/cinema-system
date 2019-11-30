import React, { Suspense, lazy } from "react";

import { Spinner } from "react-bootstrap";
import { ErrorBoundary } from "Components";

// Re-export filters
export { default as NumericFilter } from "./NumericFilter";
export { default as ComboFilter } from "./ComboFilter";
export { default as DateFilter } from "./DateFilter";

// Lazy-loading tree contains:
// - DataGrid
// - AddRowModal
// - react-data-grid
// - react-data-grid-addons

function DataGridLoader(props) {
  return (
    <div className="data-grid">
      <ErrorBoundary>
        <Suspense fallback={<LoadingFallback />}>
          <LazyLoadingWrapper {...props} />
        </Suspense>
      </ErrorBoundary>
    </div>
  );
}

export default DataGridLoader;

DataGridLoader.displayName = "DataGridLoader";

// ? =================
// ? Helper components
// ? =================

// Split bundle
const LazyLoadingWrapper = lazy(() => import("Components/DataGrid/DataGrid"));
LazyLoadingWrapper.displayName = "LazyLoadingWrapper";

function LoadingFallback() {
  return (
    <div
      className="loading"
      children={
        <Spinner animation="border" variant="primary" role="status">
          <span className="sr-only">Loading...</span>
        </Spinner>
      }
    />
  );
}

LoadingFallback.displayName = "LoadingFallback";
