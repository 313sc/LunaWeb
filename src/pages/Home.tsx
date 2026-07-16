import { useState, useEffect } from 'react';

const translations = {
  chinese: {
    owned: '此域名由 Zijie 拥有',
    buy: '如果你想要购买域名或联系 Zijie',
    email: '请发邮件到',
  },
  english: {
    owned: 'This domain is owned by Zijie',
    buy: 'If you want to purchase this domain or contact Zijie',
    email: 'Please send an email to',
  },
  french: {
    owned: 'Ce domaine appartient à Zijie',
    buy: 'Si vous souhaitez acheter ce domaine ou contacter Zijie',
    email: 'Veuillez envoyer un email à',
  },
  german: {
    owned: 'Diese Domain gehört Zijie',
    buy: 'Wenn Sie diese Domain kaufen oder Zijie kontaktieren möchten',
    email: 'Bitte senden Sie eine E-Mail an',
  },
  korean: {
    owned: '이 도메인은 Zijie가 소유하고 있습니다',
    buy: '이 도메인을 구매하거나 Zijie에게 연락하시려면',
    email: '다음 이메일로 연락하세요',
  },
};

const languages = [
  { code: 'chinese', name: '中文', flag: 'CN' },
  { code: 'english', name: 'English', flag: 'EN' },
  { code: 'french', name: 'Français', flag: 'FR' },
  { code: 'german', name: 'Deutsch', flag: 'DE' },
  { code: 'korean', name: '한국어', flag: 'KR' },
];

const getDefaultLanguage = () => {
  const browserLang = navigator.language.toLowerCase();
  if (browserLang.startsWith('zh')) return 'chinese';
  if (browserLang.startsWith('fr')) return 'french';
  if (browserLang.startsWith('de')) return 'german';
  if (browserLang.startsWith('ko')) return 'korean';
  return 'chinese';
};

export default function Home() {
  const [activeLang, setActiveLang] = useState(getDefaultLanguage);
  const [copied, setCopied] = useState(false);
  const [hostname, setHostname] = useState('');

  useEffect(() => {
    setHostname(window.location.hostname || 'LUNAWEB');
  }, []);

  const handleCopyEmail = () => {
    navigator.clipboard.writeText('zhangzj-eric@outlook.com');
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const currentTranslation = translations[activeLang as keyof typeof translations];

  return (
    <div className="min-h-screen bg-black relative overflow-hidden">
      <div className="scan-line" />
      <div className="bg-grid absolute inset-0 opacity-30" />
      
      <div className="relative z-10 flex flex-col items-center justify-center min-h-screen px-4 py-8">
        <div className="text-center mb-12 animate-float">
          <h1 className="font-orbitron text-4xl md:text-6xl lg:text-7xl font-bold text-glow mb-4 tracking-wider animate-pulse-glow">
            {hostname.toUpperCase()}
          </h1>
          <div className="flex items-center justify-center gap-2 text-cyan-400 font-rajdhani text-lg md:text-xl">
            <span className="w-2 h-2 bg-cyan-400 rounded-full animate-pulse" />
            <span className="tracking-widest">DOMAIN FOR SALE</span>
          </div>
        </div>

        <div className="w-full max-w-4xl mb-12">
          <div className="grid grid-cols-2 md:grid-cols-5 gap-3">
            {languages.map((lang) => (
              <button
                key={lang.code}
                onClick={() => setActiveLang(lang.code)}
                className={`relative px-4 py-3 border transition-all duration-300 font-rajdhani text-sm md:text-base ${
                  activeLang === lang.code
                    ? 'border-cyan-400 bg-cyan-400/10 text-cyan-300 border-glow'
                    : 'border-white/20 text-white/60 hover:border-white/40 hover:text-white/80'
                }`}
              >
                {activeLang === lang.code && (
                  <span className="absolute top-0 right-0 w-2 h-2 bg-cyan-400 rounded-full" />
                )}
                <div className="font-orbitron text-xs mb-1 opacity-50">
                  [{lang.flag}]
                </div>
                <div>{lang.name}</div>
              </button>
            ))}
          </div>
        </div>

        <div className="w-full max-w-2xl space-y-6">
          <div className="border border-white/20 bg-white/5 p-6 md:p-8 rounded-sm border-glow">
            <p className="font-rajdhani text-xl md:text-2xl lg:text-3xl text-white/90 leading-relaxed">
              {currentTranslation.owned}
            </p>
          </div>

          <div className="border border-white/20 bg-white/5 p-6 md:p-8 rounded-sm border-glow">
            <p className="font-rajdhani text-lg md:text-xl lg:text-2xl text-white/80 leading-relaxed">
              {currentTranslation.buy}
            </p>
          </div>

          <div className="border border-cyan-400/30 bg-cyan-400/5 p-6 md:p-8 rounded-sm">
            <p className="font-rajdhani text-lg md:text-xl text-cyan-300/80 mb-3">
              {currentTranslation.email}
            </p>
            <button
              onClick={handleCopyEmail}
              className="group flex items-center justify-center gap-3 w-full px-6 py-4 bg-cyan-400/10 border border-cyan-400/40 hover:bg-cyan-400/20 hover:border-cyan-400/60 transition-all duration-300"
            >
              <span className="font-orbitron text-xl md:text-2xl text-cyan-300 tracking-wider">
                zhangzj-eric@outlook.com
              </span>
              <span className={`font-rajdhani text-sm transition-all ${
                copied ? 'text-green-400' : 'text-cyan-400/60 group-hover:text-cyan-300'
              }`}>
                {copied ? '✓ COPIED' : '[COPY]'}
              </span>
            </button>
          </div>
        </div>

        <div className="mt-16 text-center">
          <div className="flex items-center justify-center gap-4 text-white/20 font-orbitron text-xs tracking-widest">
            <span className="w-8 h-px bg-white/20" />
            <span>EST. 2026</span>
            <span className="w-8 h-px bg-white/20" />
          </div>
        </div>
      </div>
    </div>
  );
}