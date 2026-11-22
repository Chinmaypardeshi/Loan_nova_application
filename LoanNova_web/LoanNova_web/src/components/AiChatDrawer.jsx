import React, { useState, useRef, useEffect } from 'react';
import { 
  Sparkles, 
  Send, 
  X, 
  Bot, 
  User, 
  ArrowRight, 
  Mic, 
  MicOff, 
  RotateCcw, 
  Download, 
  Languages, 
  Building, 
  CheckCircle,
  ExternalLink
} from 'lucide-react';

export function AiChatDrawer({ isOpen, onClose, onSelectProductType, onApplyProduct }) {
  const [lang, setLang] = useState('en'); // 'en' | 'hi'
  const [isListening, setIsListening] = useState(false);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(false);
  const messagesEndRef = useRef(null);

  const initialMessages = {
    en: [
      {
        id: 1,
        sender: 'ai',
        text: 'Hello Rahul! I am Nova, your AI Financial Advisor. How can I help you today?',
        actions: ['Lowest Rate Personal Loans', 'Best Cashback Credit Card', 'Calculate EMI', 'Check Credit Score'],
        productCard: {
          name: 'HDFC Instant Personal Loan',
          bank: 'HDFC Bank',
          rate: '10.5% p.a.',
          emi: '₹9,750 / mo',
          minAmount: 50000,
          maxAmount: 1500000,
          minTenure: 12,
          maxTenure: 60,
          subType: 'Personal Loan'
        }
      }
    ],
    hi: [
      {
        id: 1,
        sender: 'ai',
        text: 'नमस्ते राहुल! मैं नोवा हूँ, आपका AI वित्तीय सलाहकार। आज मैं आपकी क्या सहायता कर सकता हूँ?',
        actions: ['कम ब्याज पर पर्सनल लोन', 'बेस्ट कैशबैक क्रेडिट कार्ड', 'ईएमआई कैलकुलेटर', 'क्रेडिट स्कोर चेक करें'],
        productCard: {
          name: 'HDFC Instant Personal Loan',
          bank: 'HDFC Bank',
          rate: '10.5% p.a.',
          emi: '₹9,750 / महीना',
          minAmount: 50000,
          maxAmount: 1500000,
          minTenure: 12,
          maxTenure: 60,
          subType: 'Personal Loan'
        }
      }
    ]
  };

  const [messages, setMessages] = useState(initialMessages['en']);

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' });
  };

  useEffect(() => {
    if (isOpen) {
      scrollToBottom();
    }
  }, [messages, isOpen, loading]);

  const handleToggleLanguage = () => {
    const newLang = lang === 'en' ? 'hi' : 'en';
    setLang(newLang);
    setMessages(initialMessages[newLang]);
  };

  const handleClearChat = () => {
    setMessages(initialMessages[lang]);
  };

  const handleDownloadTranscript = () => {
    const textTranscript = messages
      .map((m) => `[${m.sender.toUpperCase()}]: ${m.text}`)
      .join('\n\n');
    const blob = new Blob([textTranscript], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `Nova_AI_Chat_${Date.now()}.txt`;
    a.click();
    URL.revokeObjectURL(url);
  };

  const handleVoiceListen = () => {
    if (isListening) {
      setIsListening(false);
      return;
    }
    setIsListening(true);
    setTimeout(() => {
      setIsListening(false);
      const voiceQuery = lang === 'hi' 
        ? 'कम ब्याज वाला सबसे अच्छा लोन बताओ' 
        : 'Show me lowest interest rate loan';
      setInput(voiceQuery);
      handleSend(voiceQuery);
    }, 2000);
  };

  const handleSend = async (messageText) => {
    const textToSend = messageText || input;
    if (!textToSend.trim()) return;

    // Add user message
    const newMsgList = [...messages, { id: Date.now(), sender: 'user', text: textToSend }];
    setMessages(newMsgList);
    setInput('');
    setLoading(true);

    try {
      const res = await fetch('/api/chat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ message: textToSend }),
      });
      const data = await res.json();

      let replyText = data.reply;
      let card = null;

      const q = textToSend.toLowerCase();
      if (q.includes('loan') || q.includes('लोन') || q.includes('rate') || q.includes('ब्याज')) {
        card = {
          name: 'SBI Xpress Credit Loan',
          bank: 'State Bank of India',
          rate: '9.85% p.a.',
          emi: '₹9,520 / mo',
          minAmount: 100000,
          maxAmount: 2000000,
          minTenure: 12,
          maxTenure: 72,
          subType: 'Personal Loan'
        };
        if (lang === 'hi') {
          replyText = 'SBI Xpress Credit लोन 9.85% p.a. की सबसे कम ब्याज दर पर उपलब्ध है। कोई प्रोसेसिंग फीस नहीं है और यह 10 मिनट में डिजिटल रूप से स्वीकृत हो जाता है।';
        }
      } else if (q.includes('card') || q.includes('कार्ड') || q.includes('cashback')) {
        card = {
          name: 'HDFC Millennia Credit Card',
          bank: 'HDFC Bank',
          rate: 'Lifetime Free / ₹1000',
          emi: '5% Amazon/Flipkart Cashback',
          minAmount: 50000,
          maxAmount: 500000,
          minTenure: 0,
          maxTenure: 0,
          subType: 'Credit Card'
        };
        if (lang === 'hi') {
          replyText = 'HDFC Millennia कार्ड पर 5% का ऑनलाइन कैशबैक और 4 मुफ्त एयरपोर्ट लाउंज एक्सेस मिलते हैं।';
        }
      }

      setMessages([
        ...newMsgList,
        {
          id: Date.now() + 1,
          sender: 'ai',
          text: replyText || (lang === 'hi' ? 'यहाँ आपकी प्रोफ़ाइल के अनुसार सर्वोत्तम विकल्प हैं:' : 'Here are the best options matching your profile:'),
          actions: lang === 'hi' 
            ? ['पर्सनल लोन अप्लाई करें', 'क्रेडिट कार्ड देखें', 'ईएमआई जानें'] 
            : ['Apply Personal Loan', 'Explore Credit Cards', 'Calculate EMI'],
          productCard: card
        }
      ]);
    } catch (err) {
      setMessages([
        ...newMsgList,
        {
          id: Date.now() + 1,
          sender: 'ai',
          text: lang === 'hi'
            ? 'HDFC Instant Loan 10.5% पर उपलब्ध है। आप सीधे अप्लाई कर सकते हैं।'
            : 'HDFC Instant Loan is pre-approved for you at 10.5% p.a.',
          actions: lang === 'hi' ? ['लोन अप्लाई करें', 'ईएमआई देखें'] : ['Personal Loans', 'Credit Cards'],
          productCard: {
            name: 'HDFC Instant Personal Loan',
            bank: 'HDFC Bank',
            rate: '10.5% p.a.',
            emi: '₹9,750 / mo',
            minAmount: 50000,
            maxAmount: 1500000,
            minTenure: 12,
            maxTenure: 60,
            subType: 'Personal Loan'
          }
        }
      ]);
    } finally {
      setLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-y-0 right-0 z-50 w-full sm:w-96 bg-white shadow-2xl border-l border-slate-200 flex flex-col animate-slide-left">
      {/* Drawer Header */}
      <div className="bg-slate-900 text-white p-4 flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-lg bg-gradient-to-tr from-blue-500 to-indigo-600 flex items-center justify-center text-white shadow-md">
            <Sparkles className="w-4 h-4" />
          </div>
          <div>
            <div className="text-sm font-bold flex items-center gap-1.5">
              <span>Nova AI Advisor</span>
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
            </div>
            <p className="text-[11px] text-slate-400">Financial Intelligence Engine</p>
          </div>
        </div>

        {/* Action Controls in Header */}
        <div className="flex items-center gap-1">
          {/* Language Toggle */}
          <button
            onClick={handleToggleLanguage}
            className="px-2 py-1 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-200 text-[11px] font-bold transition flex items-center gap-1"
            title="Toggle English / Hindi"
          >
            <Languages className="w-3 h-3 text-blue-400" />
            <span>{lang === 'en' ? 'हिन्दी' : 'EN'}</span>
          </button>

          {/* Download Transcript */}
          <button
            onClick={handleDownloadTranscript}
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
            title="Export Chat Transcript"
          >
            <Download className="w-4 h-4" />
          </button>

          {/* Clear Chat */}
          <button
            onClick={handleClearChat}
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition"
            title="Reset Chat"
          >
            <RotateCcw className="w-4 h-4" />
          </button>

          {/* Close */}
          <button
            onClick={onClose}
            className="p-1.5 rounded-lg text-slate-400 hover:text-white hover:bg-slate-800 transition ml-1"
          >
            <X className="w-5 h-5" />
          </button>
        </div>
      </div>

      {/* Voice Listening Banner */}
      {isListening && (
        <div className="bg-blue-600 text-white p-2.5 px-4 text-xs font-bold flex items-center justify-between animate-pulse">
          <span className="flex items-center gap-2">
            <Mic className="w-4 h-4 text-white animate-bounce" />
            <span>{lang === 'hi' ? 'सुन रहा हूँ... बोलिए' : 'Listening... Speak now'}</span>
          </span>
          <span className="text-[10px] bg-white/20 px-2 py-0.5 rounded">Voice AI</span>
        </div>
      )}

      {/* Message History */}
      <div className="flex-1 overflow-y-auto p-4 space-y-3 bg-slate-50 text-xs">
        {messages.map((m) => (
          <div
            key={m.id}
            className={`flex flex-col ${m.sender === 'user' ? 'items-end' : 'items-start'}`}
          >
            <div
              className={`max-w-[88%] p-3 rounded-2xl ${
                m.sender === 'user'
                  ? 'bg-blue-600 text-white rounded-br-none shadow-sm'
                  : 'bg-white text-slate-800 border border-slate-200 shadow-sm rounded-bl-none'
              }`}
            >
              <p className="leading-relaxed whitespace-pre-line">{m.text}</p>

              {/* Embedded Product Card in Chat */}
              {m.productCard && (
                <div className="mt-3 p-3 bg-slate-50 border border-slate-200 rounded-xl space-y-2 text-slate-800">
                  <div className="flex items-center justify-between">
                    <div>
                      <span className="font-bold text-xs text-slate-900 block">{m.productCard.name}</span>
                      <span className="text-[10px] text-slate-500">{m.productCard.bank}</span>
                    </div>
                    <span className="text-[10px] font-bold text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded border border-emerald-100">
                      {m.productCard.rate}
                    </span>
                  </div>

                  <div className="flex justify-between items-center text-[11px] pt-1 border-t border-slate-200">
                    <span className="text-slate-500">Monthly EMI: <strong>{m.productCard.emi}</strong></span>
                    <button
                      onClick={() => {
                        if (onApplyProduct) {
                          onApplyProduct(m.productCard);
                          onClose();
                        }
                      }}
                      className="px-2.5 py-1 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-[11px] font-bold transition flex items-center gap-1 shadow-2xs"
                    >
                      <span>{lang === 'hi' ? 'अप्लाई करें' : 'Apply Now'}</span>
                      <ArrowRight className="w-3 h-3" />
                    </button>
                  </div>
                </div>
              )}
            </div>

            {/* Quick Prompt Suggestion Chips */}
            {m.actions && m.actions.length > 0 && (
              <div className="flex flex-wrap gap-1.5 mt-2">
                {m.actions.map((act, aIdx) => (
                  <button
                    key={aIdx}
                    onClick={() => handleSend(act)}
                    className="bg-white hover:bg-blue-50 text-blue-700 border border-blue-200 px-2.5 py-1 rounded-full text-[11px] font-medium transition flex items-center gap-1 shadow-2xs"
                  >
                    <span>{act}</span>
                    <ArrowRight className="w-3 h-3" />
                  </button>
                ))}
              </div>
            )}
          </div>
        ))}

        {loading && (
          <div className="flex items-center gap-2 text-slate-400 text-xs">
            <div className="w-6 h-6 rounded-full bg-blue-100 flex items-center justify-center text-blue-600">
              <Bot className="w-3.5 h-3.5" />
            </div>
            <span>{lang === 'hi' ? 'नोवा विश्लेषण कर रहा है...' : 'Nova is calculating best rates...'}</span>
          </div>
        )}
        <div ref={messagesEndRef} />
      </div>

      {/* Input Bar */}
      <div className="p-3 bg-white border-t border-slate-200">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            handleSend();
          }}
          className="flex items-center gap-2"
        >
          {/* Simulated Voice Microphone Button */}
          <button
            type="button"
            onClick={handleVoiceListen}
            className={`p-2 rounded-xl transition ${
              isListening
                ? 'bg-rose-500 text-white animate-pulse'
                : 'bg-slate-100 hover:bg-slate-200 text-slate-600'
            }`}
            title="Simulated Voice Assistant"
          >
            <Mic className="w-4 h-4" />
          </button>

          <input
            type="text"
            placeholder={
              lang === 'hi'
                ? 'लोन, कार्ड, ईएमआई के बारे में पूछें...'
                : 'Ask about loans, cards, EMI, credit score...'
            }
            value={input}
            onChange={(e) => setInput(e.target.value)}
            className="flex-1 px-3 py-2 text-xs bg-slate-100 hover:bg-slate-50 focus:bg-white border border-transparent focus:border-blue-400 rounded-xl outline-none transition"
          />

          <button
            type="submit"
            disabled={!input.trim()}
            className="p-2 bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white rounded-xl transition"
          >
            <Send className="w-4 h-4" />
          </button>
        </form>
      </div>
    </div>
  );
}

export default AiChatDrawer;
