"use client";


const SuggestionCard = ({ suggestion }: { suggestion: any }) => {
  if (!suggestion) {
    return <div>Loading suggestion...</div>;
  }

  return (
    <div className="bg-white rounded-lg shadow-lg p-6 max-w-md mx-auto my-4 transition-transform hover:scale-105">
      <h2 className="text-2xl font-bold mb-2 text-gray-800">{suggestion.text}</h2>
      <p className="text-sm text-gray-500">Creator: {suggestion.creator}</p>
      <p className="text-sm text-gray-400">
        {suggestion.isDeleted ? "Deleted" : "Active"}
      </p>
    </div>
  );
};

export default SuggestionCard;