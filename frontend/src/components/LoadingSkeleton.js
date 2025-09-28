const LoadingSkeleton = () => (
  <div className="mt-4 animate-pulse p-6 bg-white rounded-lg shadow-lg max-w-3xl mx-auto">
    <div className="h-6 bg-gray-300 rounded mb-2 w-3/4"></div>
    <div className="h-6 bg-gray-300 rounded mb-2 w-1/2"></div>
    <div className="h-6 bg-gray-300 rounded w-5/6"></div>
  </div>
);

export default LoadingSkeleton;
