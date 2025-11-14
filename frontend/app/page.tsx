"use client";

import { Button } from "@/components/ui/button"
import {useState} from "react";
import {useSuggestions} from "@/hooks/useSuggestions";
import {
  Card,
  CardAction,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card"
import SuggestionCard from "@/components/SuggestionCard";

const page = () => {
  const [currentSuggestionIndex, setCurrentSuggestionIndex] = useState(0);
  const suggestions = useSuggestions();

  const handlePreviousPage = () => {
    setCurrentSuggestionIndex((prevIndex) =>
      prevIndex === 0 ? suggestions.length - 1 : prevIndex - 1
    );
  };

  const handleNextPage = () => {
    setCurrentSuggestionIndex((prevIndex) =>
      prevIndex === suggestions.length - 1 ? 0 : prevIndex + 1
    );
  };
  return (
    <div className="flex flex-col items-center">
      <SuggestionCard suggestion={suggestions[currentSuggestionIndex]} />

      <div className="flex justify-between w-64 mt-4">
        <Button onClick={handlePreviousPage}>Previous</Button>
        <Button onClick={handleNextPage}>Next</Button>
      </div>
    </div>
  );

};

export default page;