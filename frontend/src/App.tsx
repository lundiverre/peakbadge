import { useState } from 'react';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount, useWriteContract } from 'wagmi';
import { parseEther } from 'viem';

const CONTRACT = import.meta.env.VITE_CONTRACT_ADDRESS as `0x${string}`;

export default function App() {
  const { isConnected } = useAccount();
  const { writeContract, isPending } = useWriteContract();
  const [val, setVal] = useState('');

  return (
    <div style={{ minHeight: '100vh', background: '#0f172a', color: '#f1f5f9', fontFamily: 'system-ui', padding: '2rem' }}>
      <div style={{ maxWidth: 480, margin: '0 auto' }}>
        <div style={{ background: '#a855f7', borderRadius: 16, padding: '1.5rem', marginBottom: '1.5rem', textAlign: 'center' }}>
          <h1 style={{ margin: 0, fontSize: '1.8rem', fontWeight: 700 }}>PeakBadge</h1>
          <p style={{ margin: '0.5rem 0 0', opacity: 0.9 }}>Achievement Badges — Earn on-chain</p>
        </div>
        <div style={{ marginBottom: '1rem', display: 'flex', justifyContent: 'center' }}><ConnectButton /></div>
        {isConnected && (
          <div style={{ background: '#1e293b', borderRadius: 12, padding: '1.5rem' }}>
            <input value={val} onChange={e => setVal(e.target.value)} placeholder="Amount (USDC)"
              style={{ width: '100%', padding: '0.6rem', borderRadius: 8, border: 'none', background: '#334155', color: '#f1f5f9', marginBottom: '1rem', boxSizing: 'border-box' }} />
            <button disabled={isPending || !val} onClick={() => writeContract({ address: CONTRACT, abi: [{name:'createBadgeType',type:'function',stateMutability:'nonpayable',inputs:[{name:'name',type:'string'},{name:'desc',type:'string'}],outputs:[{type:'uint256'}]}] as const, functionName: 'createBadgeType', args: [val,'Badge description'] })} style={{ width:'100%',padding:'0.7rem',borderRadius:8,border:'none',background:'#a855f7',color:'#fff',fontWeight:600,cursor:'pointer' }}>{isPending ? 'Creating…' : 'Create Badge Type'}</button>
          </div>
        )}
        <p style={{ textAlign: 'center', fontSize: '0.75rem', color: '#475569', marginTop: '1.5rem' }}>Robinhood Testnet · USDC Native · <a href={`https://explorer.testnet.chain.robinhood.com/address/${CONTRACT}`} style={{ color: '#a855f7' }} target="_blank">Contract ↗</a></p>
      </div>
    </div>
  );
}