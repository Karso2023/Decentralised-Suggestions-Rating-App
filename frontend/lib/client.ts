import { create } from 'domain';
import {createWalletClient, createPublicClient, custom, http} from 'viem';
import {sepolia} from 'viem/chains';
import 'viem/window';


export async function getWalletClient() {

    let transport;

    if (typeof window === 'undefined' || !window.ethereum) {
        throw new Error('No Ethereum provider found');
    }

    transport = custom(window.ethereum);

    const createClient = createWalletClient({
        chain: sepolia,
        transport: transport
    })

    return createClient;
}

export function getPublicClient() {
    const publicClient = createPublicClient({
        chain: sepolia,
        transport: http('https://rpc.sepolia.dev')
    });

    return publicClient;
}