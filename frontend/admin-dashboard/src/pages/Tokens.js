import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Coins, Search, Plus, Minus, History, RefreshCw, ChevronDown, ChevronUp } from 'lucide-react';

const fmt = (n) => Number(n || 0).toLocaleString('ru-RU');

export default function Tokens() {
  const { API_URL } = useAuth();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [expandedUser, setExpandedUser] = useState(null);
  const [txHistory, setTxHistory] = useState({});
  const [txLoading, setTxLoading] = useState({});
  const [adjustModal, setAdjustModal] = useState(null); // { userId, userName, balance }
  const [adjustAmount, setAdjustAmount] = useState('');
  const [adjustDesc, setAdjustDesc] = useState('');
  const [adjusting, setAdjusting] = useState(false);
  const [adjustError, setAdjustError] = useState('');

  const authHeaders = () => {
    const token = localStorage.getItem('access_token');
    return token ? { Authorization: `Bearer ${token}` } : {};
  };

  const loadUsers = async () => {
    setLoading(true);
    try {
      const res = await axios.get(`${API_URL}/api/mobile/admin/tokens/users?limit=200`, {
        headers: authHeaders(),
      });
      setUsers(res.data?.users || []);
    } catch (e) {
      console.error('Token users load error:', e);
    } finally {
      setLoading(false);
    }
  };

  const loadHistory = async (userId) => {
    if (txHistory[userId]) return;
    setTxLoading((p) => ({ ...p, [userId]: true }));
    try {
      const res = await axios.get(`${API_URL}/api/mobile/admin/tokens/transactions/${userId}`, {
        headers: authHeaders(),
      });
      setTxHistory((p) => ({ ...p, [userId]: res.data?.transactions || [] }));
    } catch (e) {
      setTxHistory((p) => ({ ...p, [userId]: [] }));
    } finally {
      setTxLoading((p) => ({ ...p, [userId]: false }));
    }
  };

  const toggleExpand = (userId) => {
    if (expandedUser === userId) {
      setExpandedUser(null);
    } else {
      setExpandedUser(userId);
      loadHistory(userId);
    }
  };

  const openAdjust = (user) => {
    setAdjustModal(user);
    setAdjustAmount('');
    setAdjustDesc('');
    setAdjustError('');
  };

  const submitAdjust = async () => {
    const amount = parseFloat(adjustAmount);
    if (!amount || isNaN(amount)) { setAdjustError('Miqdorni kiriting'); return; }
    setAdjusting(true);
    setAdjustError('');
    try {
      await axios.post(
        `${API_URL}/api/mobile/admin/tokens/adjust`,
        {
          user_id: adjustModal.user_id,
          amount,
          description: adjustDesc || undefined,
        },
        { headers: authHeaders() }
      );
      setAdjustModal(null);
      // Refresh user list + invalidate history cache for this user
      setTxHistory((p) => { const n = { ...p }; delete n[adjustModal.user_id]; return n; });
      await loadUsers();
    } catch (e) {
      setAdjustError(e.response?.data?.detail || 'Xatolik yuz berdi');
    } finally {
      setAdjusting(false);
    }
  };

  useEffect(() => { loadUsers(); }, []);

  const filtered = users.filter((u) => {
    const q = search.toLowerCase();
    return (
      !q ||
      (u.user_name || '').toLowerCase().includes(q) ||
      (u.user_phone || '').includes(q)
    );
  });

  const txTypeLabel = (type) => {
    switch (type) {
      case 'topup': return { label: 'To\'ldirish', color: 'text-green-600 bg-green-50' };
      case 'spend': return { label: 'To\'lov', color: 'text-red-600 bg-red-50' };
      case 'refund': return { label: 'Qaytarish', color: 'text-blue-600 bg-blue-50' };
      case 'admin_adjust': return { label: 'Admin', color: 'text-purple-600 bg-purple-50' };
      default: return { label: type, color: 'text-gray-600 bg-gray-50' };
    }
  };

  const fmtDate = (iso) => {
    if (!iso) return '—';
    try {
      const d = new Date(iso);
      return `${d.getDate().toString().padStart(2,'0')}.${(d.getMonth()+1).toString().padStart(2,'0')}.${d.getFullYear()} ${d.getHours().toString().padStart(2,'0')}:${d.getMinutes().toString().padStart(2,'0')}`;
    } catch { return iso; }
  };

  return (
    <div className="p-6 space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-gray-900 flex items-center gap-2">
            <Coins className="w-7 h-7 text-yellow-500" />
            YuvGo Tokenlar
          </h1>
          <p className="text-sm text-gray-500 mt-1">1 token = 1 000 UZS · Foydalanuvchilar balansini boshqarish</p>
        </div>
        <button
          onClick={loadUsers}
          className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 rounded-xl text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
        >
          <RefreshCw className="w-4 h-4" />
          Yangilash
        </button>
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-3 gap-4">
        <div className="bg-white rounded-2xl border border-gray-100 p-5 shadow-sm">
          <p className="text-sm text-gray-500">Jami foydalanuvchilar</p>
          <p className="text-3xl font-black text-gray-900 mt-1">{users.length}</p>
        </div>
        <div className="bg-white rounded-2xl border border-gray-100 p-5 shadow-sm">
          <p className="text-sm text-gray-500">Jami muomalada tokenlar</p>
          <p className="text-3xl font-black text-yellow-500 mt-1">
            {fmt(users.reduce((s, u) => s + Number(u.balance || 0), 0))} tkn
          </p>
        </div>
        <div className="bg-white rounded-2xl border border-gray-100 p-5 shadow-sm">
          <p className="text-sm text-gray-500">UZS ekvivalent</p>
          <p className="text-3xl font-black text-gray-900 mt-1">
            {fmt(users.reduce((s, u) => s + Number(u.balance_uzs || 0), 0))}
          </p>
        </div>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        <input
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Ism yoki telefon raqami bo'yicha qidirish..."
          className="w-full pl-9 pr-4 py-2.5 border border-gray-200 rounded-xl text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400 focus:border-transparent"
        />
      </div>

      {/* Table */}
      <div className="bg-white rounded-2xl border border-gray-100 shadow-sm overflow-hidden">
        {loading ? (
          <div className="flex items-center justify-center py-16">
            <div className="w-8 h-8 border-4 border-yellow-200 border-t-yellow-500 rounded-full animate-spin" />
          </div>
        ) : filtered.length === 0 ? (
          <div className="text-center py-16 text-gray-400">
            <Coins className="w-12 h-12 mx-auto mb-3 opacity-30" />
            <p>Foydalanuvchilar topilmadi</p>
          </div>
        ) : (
          <div className="divide-y divide-gray-50">
            {/* Header row */}
            <div className="grid grid-cols-12 gap-2 px-5 py-3 bg-gray-50 text-xs font-semibold text-gray-500 uppercase tracking-wide">
              <div className="col-span-3">Foydalanuvchi</div>
              <div className="col-span-2 text-right">Balans</div>
              <div className="col-span-2 text-right">UZS</div>
              <div className="col-span-2 text-right">Jami kirim</div>
              <div className="col-span-2 text-right">Jami chiqim</div>
              <div className="col-span-1" />
            </div>

            {filtered.map((u) => (
              <React.Fragment key={u.user_id}>
                <div className="grid grid-cols-12 gap-2 px-5 py-4 items-center hover:bg-gray-50 transition-colors">
                  <div className="col-span-3">
                    <p className="font-semibold text-gray-900 text-sm">{u.user_name || '—'}</p>
                    <p className="text-xs text-gray-400">{u.user_phone || '—'}</p>
                  </div>
                  <div className="col-span-2 text-right">
                    <span className="inline-flex items-center gap-1 px-2.5 py-1 bg-yellow-50 text-yellow-700 rounded-lg font-bold text-sm">
                      <Coins className="w-3.5 h-3.5" />
                      {fmt(u.balance)} tkn
                    </span>
                  </div>
                  <div className="col-span-2 text-right text-sm text-gray-600 font-medium">
                    {fmt(u.balance_uzs)}
                  </div>
                  <div className="col-span-2 text-right text-sm text-green-600 font-medium">
                    +{fmt(u.total_earned)}
                  </div>
                  <div className="col-span-2 text-right text-sm text-red-500 font-medium">
                    −{fmt(u.total_spent)}
                  </div>
                  <div className="col-span-1 flex items-center justify-end gap-1">
                    <button
                      onClick={() => openAdjust(u)}
                      title="Balansni o'zgartirish"
                      className="p-1.5 rounded-lg hover:bg-yellow-50 text-yellow-600 transition-colors"
                    >
                      <Plus className="w-4 h-4" />
                    </button>
                    <button
                      onClick={() => toggleExpand(u.user_id)}
                      title="Tarix"
                      className="p-1.5 rounded-lg hover:bg-gray-100 text-gray-500 transition-colors"
                    >
                      {expandedUser === u.user_id ? <ChevronUp className="w-4 h-4" /> : <ChevronDown className="w-4 h-4" />}
                    </button>
                  </div>
                </div>

                {/* Expanded transaction history */}
                {expandedUser === u.user_id && (
                  <div className="bg-gray-50 px-5 py-4 border-t border-gray-100">
                    <div className="flex items-center gap-2 mb-3">
                      <History className="w-4 h-4 text-gray-500" />
                      <span className="text-sm font-semibold text-gray-700">Tranzaksiyalar tarixi</span>
                    </div>
                    {txLoading[u.user_id] ? (
                      <div className="flex justify-center py-4">
                        <div className="w-5 h-5 border-2 border-yellow-300 border-t-yellow-500 rounded-full animate-spin" />
                      </div>
                    ) : (txHistory[u.user_id] || []).length === 0 ? (
                      <p className="text-sm text-gray-400 text-center py-3">Tranzaksiyalar yo'q</p>
                    ) : (
                      <div className="space-y-2 max-h-64 overflow-y-auto">
                        {(txHistory[u.user_id] || []).map((t) => {
                          const { label, color } = txTypeLabel(t.type);
                          const isCredit = t.amount > 0;
                          return (
                            <div key={t.id} className="flex items-center gap-3 bg-white rounded-xl px-4 py-3">
                              <span className={`text-xs font-semibold px-2 py-0.5 rounded-md ${color}`}>{label}</span>
                              <span className="text-xs text-gray-500 flex-1 truncate">{t.description || '—'}</span>
                              <span className={`text-sm font-bold ${isCredit ? 'text-green-600' : 'text-red-500'}`}>
                                {isCredit ? '+' : ''}{fmt(t.amount)} tkn
                              </span>
                              <span className="text-xs text-gray-400 w-32 text-right shrink-0">{fmtDate(t.created_at)}</span>
                            </div>
                          );
                        })}
                      </div>
                    )}
                  </div>
                )}
              </React.Fragment>
            ))}
          </div>
        )}
      </div>

      {/* Adjust Modal */}
      {adjustModal && (
        <div className="fixed inset-0 bg-black/40 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-2xl shadow-2xl w-full max-w-md p-6">
            <h2 className="text-lg font-bold text-gray-900 mb-1">Balansni o'zgartirish</h2>
            <p className="text-sm text-gray-500 mb-5">
              <span className="font-semibold text-gray-700">{adjustModal.user_name || adjustModal.user_phone}</span>
              {' — '}hozirgi balans: <span className="font-bold text-yellow-600">{fmt(adjustModal.balance)} tkn</span>
            </p>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Miqdor (token) <span className="text-gray-400">— manfiy = ayirish</span>
                </label>
                <input
                  type="number"
                  value={adjustAmount}
                  onChange={(e) => setAdjustAmount(e.target.value)}
                  placeholder="Masalan: 100 yoki -50"
                  className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400"
                />
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Izoh (ixtiyoriy)</label>
                <input
                  type="text"
                  value={adjustDesc}
                  onChange={(e) => setAdjustDesc(e.target.value)}
                  placeholder="Masalan: Kompensatsiya"
                  className="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-yellow-400"
                />
              </div>
              {adjustError && (
                <p className="text-sm text-red-600 bg-red-50 rounded-lg px-3 py-2">{adjustError}</p>
              )}
            </div>

            <div className="flex gap-3 mt-6">
              <button
                onClick={() => setAdjustModal(null)}
                className="flex-1 py-2.5 border border-gray-200 rounded-xl text-sm font-medium text-gray-700 hover:bg-gray-50 transition-colors"
              >
                Bekor qilish
              </button>
              <button
                onClick={submitAdjust}
                disabled={adjusting}
                className="flex-1 py-2.5 bg-yellow-400 rounded-xl text-sm font-bold text-gray-900 hover:bg-yellow-500 transition-colors disabled:opacity-60"
              >
                {adjusting ? 'Saqlanmoqda...' : 'Saqlash'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
