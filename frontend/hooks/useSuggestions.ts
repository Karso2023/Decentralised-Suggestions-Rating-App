"use client";

import { useEffect, useState } from "react";
import { getPublicClient } from "@/lib/client";
import { getContract } from "viem";
import emlSuggestionsABI from "@/lib/EmlSuggestions.json";

const publicClient = getPublicClient();
const suggestionsContract = getContract({
  address: "0x5a4379923038ece3b64a34b475304688514ca30d", 
  abi: emlSuggestionsABI,
  client: { public: publicClient}
});

export const useSuggestions = () => {
    const [suggestions, setSuggestions] = useState<any[]>([]);
    useEffect(() => {
        const fetchSuggestions = async () => {
            try {
                const fetched = await suggestionsContract.read.getSuggestions();
                setSuggestions(fetched as any[]);
            } catch (error) {
                console.error("Error fetching suggestions:", error);
            }
        };
        fetchSuggestions();
    }, []);

    return suggestions;
};