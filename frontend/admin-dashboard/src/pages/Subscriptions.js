import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '../components/ui/card';
import { Button } from '../components/ui/button';
import { 
  CreditCard, 
  Users, 
  DollarSign,
  Calendar,
  CheckCircle,
  XCircle,
  Clock,
  Plus,
  Edit,
  Trash2,
  Search,
  ShieldCheck,
  Ban
} from 'lucide-react';

const Subscriptions = () => {
  const { API_URL } = useAuth();
  const [subscriptions, setSubscriptions] = useState([]);
  const [plans, setPlans] = useState([]);
  const [stats, setStats] = useState({ total: 0, active: 0, pending: 0, expired: 0 });
  const [loading, setLoading] = useState(true);
  const [filter, setFilter] = useState('all');
  const [searchTerm, setSearchTerm] = useState('');
  const [showPlanModal, setShowPlanModal] = useState(false);
  const [editingPlan, setEditingPlan] = useState(null);
  const [showSubModal, setShowSubModal] = useState(false);
  const [editingSub, setEditingSub] = useState(null);
  const [subForm, setSubForm] = useState({ status: '', plan_id: '', end_date: '', visits_used: 0, visits_remaining: 0, is_unlimited: false, auto_renew: false });
  const [planForm, setPlanForm] = useState({ name: '', name_ru: '', name_en: '', description: '', description_ru: '', description_en: '', price: '', currency: 'UZS', duration_days: '', visit_limit: '', is_unlimited: false, is_active: true });
  const [modalError, setModalError] = useState('');
  const [modalSuccess, setModalSuccess] = useState('');

  useEffect(() => { fetchData(); }, []);

  const fetchData = async () => {
    try {
      setLoading(true);
      const plansResponse = await axios.get(`${API_URL}/api/mobile/subscriptions/plans`);
      const plansData = plansResponse.data?.plans || plansResponse.data || [];
      setPlans(plansData);

      let subsData = [];
      try {
        const subsResponse = await axios.get(`${API_URL}/api/subscription/subscriptions/all`);
        subsData = Array.isArray(subsResponse.data) ? subsResponse.data : [];
      } catch (err) {
        console.log('Subscriptions all API error:', err.message);
      }

      setSubscriptions(subsData);
      setStats({
        total: subsData.length,
        active: subsData.filter(s => s.status === 'active').length,
        pending: subsData.filter(s => s.status === 'pending').length,
        expired: subsData.filter(s => s.status === 'expired' || s.status === 'cancelled').length,
      });
    } catch (error) {
      console.error('Error fetching data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async (sub) => {
    if (!window.confirm(`Obunani tasdiqlaysizmi? (${sub.user?.full_name || sub.user?.phone_number || sub.id})`)) return;
    try {
      await axios.post(`${API_URL}/api/subscription/subscriptions/${sub.id}/approve`);
      fetchData();
    } catch (error) {
      alert(error.response?.data?.detail || 'Tasdiqlashda xatolik');
    }
  };

  const handleCancelSub = async (sub) => {
    if (!window.confirm(`Obunani bekor qilasizmi?`)) return;
    try {
      await axios.put(`${API_URL}/api/subscription/subscriptions/${sub.id}?status=cancelled`);
      fetchData();
    } catch (error) {
      alert(error.response?.data?.detail || 'Bekor qilishda xatolik');
    }
  };

  const handleDeleteSub = async (sub) => {
    if (!window.confirm(`Obunani o'chirasizmi? Bu amalni qaytarib bo'lmaydi!`)) return;
    try {
      await axios.delete(`${API_URL}/api/subscription/subscriptions/${sub.id}`);
      fetchData();
    } catch (error) {
      alert(error.response?.data?.detail || 'O\'chirishda xatolik');
    }
  };

  const openEditSub = (sub) => {
    setEditingSub(sub);
    setSubForm({
      status: sub.status || 'active',
      plan_id: sub.plan_id || '',
      end_date: sub.end_date ? sub.end_date.split('T')[0] : '',
      visits_used: sub.visits_used || 0,
      visits_remaining: sub.visits_remaining || 0,
      is_unlimited: sub.is_unlimited || false,
      auto_renew: sub.auto_renew || false,
    });
    setModalError('');
    setModalSuccess('');
    setShowSubModal(true);
  };

  const handleSaveSub = async (e) => {
    e.preventDefault();
    setModalError('');
    try {
      const params = new URLSearchParams();
      params.append('status', subForm.status);
      if (subForm.plan_id) params.append('plan_id', subForm.plan_id);
      if (subForm.end_date) params.append('end_date', subForm.end_date + 'T23:59:59');
      params.append('visits_used', subForm.visits_used);
      params.append('visits_remaining', subForm.visits_remaining);
      params.append('is_unlimited', subForm.is_unlimited);
      params.append('auto_renew', subForm.auto_renew);

      await axios.put(`${API_URL}/api/subscription/subscriptions/${editingSub.id}?${params.toString()}`);
      setModalSuccess('Obuna yangilandi!');
      setTimeout(() => { setShowSubModal(false); fetchData(); }, 1000);
    } catch (error) {
      setModalError(error.response?.data?.detail || 'Saqlashda xatolik');
    }
  };

  const getStatusBadge = (status) => {
    const m = { active: 'bg-green-100 text-green-800', expired: 'bg-red-100 text-red-800', cancelled: 'bg-gray-100 text-gray-800', pending: 'bg-yellow-100 text-yellow-800' };
    return m[status] || m.pending;
  };
  const getStatusIcon = (status) => {
    const m = { active: <CheckCircle className="h-4 w-4" />, expired: <XCircle className="h-4 w-4" />, cancelled: <Ban className="h-4 w-4" />, pending: <Clock className="h-4 w-4" /> };
    return m[status] || m.pending;
  };

  const handleCreatePlan = () => { setEditingPlan(null); setPlanForm({ name: '', name_ru: '', name_en: '', description: '', description_ru: '', description_en: '', price: '', currency: 'UZS', duration_days: '', visit_limit: '', is_unlimited: false, is_active: true }); setModalError(''); setModalSuccess(''); setShowPlanModal(true); };
  const handleEditPlan = (plan) => { setEditingPlan(plan); setPlanForm({ name: plan.name || '', name_ru: plan.name_ru || '', name_en: plan.name_en || '', description: plan.description || '', description_ru: plan.description_ru || '', description_en: plan.description_en || '', price: plan.price, currency: plan.currency, duration_days: plan.duration_days, visit_limit: plan.visit_limit || '', is_unlimited: plan.is_unlimited, is_active: plan.is_active }); setModalError(''); setModalSuccess(''); setShowPlanModal(true); };

  const handleSavePlan = async (e) => {
    e.preventDefault();
    setModalError(''); setModalSuccess('');
    try {
      if (editingPlan) {
        await axios.put(`${API_URL}/api/subscription/plans/${editingPlan.id}`, planForm);
        setModalSuccess('Plan yangilandi!');
      } else {
        await axios.post(`${API_URL}/api/subscription/plans`, planForm);
        setModalSuccess('Plan yaratildi!');
      }
      setTimeout(() => { setShowPlanModal(false); fetchData(); }, 1000);
    } catch (error) {
      setModalError(error.response?.data?.detail || 'Saqlashda xatolik');
    }
  };

  const filtered = subscriptions.filter(sub => {
    const matchFilter = filter === 'all' || sub.status === filter;
    const q = searchTerm.toLowerCase();
    const matchSearch = !q || (sub.user?.full_name || '').toLowerCase().includes(q) || (sub.user?.phone_number || '').includes(q) || (sub.plan?.name || '').toLowerCase().includes(q);
    return matchFilter && matchSearch;
  });

  if (loading) {
    return (<div className="flex items-center justify-center h-64"><div className="text-center"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary mx-auto"></div><p className="mt-4 text-gray-600">Yuklanmoqda...</p></div></div>);
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Obunalar</h1>
          <p className="text-gray-600 mt-1">Foydalanuvchi obunalari va tariflar</p>
        </div>
        <Button onClick={handleCreatePlan} className="gap-2"><Plus className="h-4 w-4" /> Yangi tarif</Button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card><CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2"><CardTitle className="text-sm font-medium">Jami obunalar</CardTitle><CreditCard className="h-4 w-4 text-muted-foreground" /></CardHeader><CardContent><div className="text-2xl font-bold">{stats.total}</div></CardContent></Card>
        <Card><CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2"><CardTitle className="text-sm font-medium">Faol</CardTitle><CheckCircle className="h-4 w-4 text-green-600" /></CardHeader><CardContent><div className="text-2xl font-bold text-green-600">{stats.active}</div></CardContent></Card>
        <Card><CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2"><CardTitle className="text-sm font-medium">Kutilmoqda</CardTitle><Clock className="h-4 w-4 text-yellow-600" /></CardHeader><CardContent><div className="text-2xl font-bold text-yellow-600">{stats.pending}</div></CardContent></Card>
        <Card><CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2"><CardTitle className="text-sm font-medium">Tugagan / Bekor</CardTitle><XCircle className="h-4 w-4 text-red-600" /></CardHeader><CardContent><div className="text-2xl font-bold text-red-600">{stats.expired}</div></CardContent></Card>
      </div>

      {/* Plans */}
      <Card>
        <CardHeader><CardTitle>Tariflar</CardTitle><CardDescription>Mavjud tariflar</CardDescription></CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {plans.map((plan) => (
              <div key={plan.id} className="border rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between mb-2">
                  <h3 className="font-semibold text-lg">{plan.name}</h3>
                  {plan.is_active ? <span className="text-xs bg-green-100 text-green-800 px-2 py-1 rounded">Faol</span> : <span className="text-xs bg-gray-100 text-gray-600 px-2 py-1 rounded">Nofaol</span>}
                </div>
                <div className="space-y-1 mb-2">
                  {plan.name_ru && <p className="text-xs text-gray-500">🇷🇺 {plan.name_ru}</p>}
                  {plan.name_en && <p className="text-xs text-gray-500">🇬🇧 {plan.name_en}</p>}
                </div>
                <p className="text-2xl font-bold text-primary mb-2">{Number(plan.price).toLocaleString()} {plan.currency}</p>
                <p className="text-sm text-gray-600 mb-1">🇺🇿 {plan.description}</p>
                {plan.description_ru && <p className="text-xs text-gray-500 mb-1">🇷🇺 {plan.description_ru}</p>}
                {plan.description_en && <p className="text-xs text-gray-500 mb-3">🇬🇧 {plan.description_en}</p>}
                <div className="space-y-1 text-sm text-gray-600">
                  <div className="flex items-center gap-2"><Calendar className="h-3 w-3" /><span>{plan.duration_days} kun</span></div>
                  <div className="flex items-center gap-2"><Users className="h-3 w-3" /><span>{plan.is_unlimited ? 'Cheksiz' : plan.visit_limit} tashrif</span></div>
                </div>
                <div className="mt-4"><Button onClick={() => handleEditPlan(plan)} variant="outline" size="sm" className="w-full"><Edit className="h-3 w-3 mr-1" /> Tahrirlash</Button></div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Subscriptions List */}
      <Card>
        <CardHeader>
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div><CardTitle>Foydalanuvchi obunalari</CardTitle><CardDescription>Barcha obunalar va ularning holati</CardDescription></div>
            <div className="flex gap-2 flex-wrap">
              {['all', 'active', 'pending', 'expired', 'cancelled'].map(f => (
                <Button key={f} variant={filter === f ? 'default' : 'outline'} size="sm" onClick={() => setFilter(f)}>
                  {f === 'all' ? 'Hammasi' : f === 'active' ? 'Faol' : f === 'pending' ? 'Kutilmoqda' : f === 'expired' ? 'Tugagan' : 'Bekor'}
                </Button>
              ))}
            </div>
          </div>
          <div className="relative mt-3">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" size={18} />
            <input type="text" placeholder="Qidirish (ism, telefon, tarif)..." value={searchTerm} onChange={e => setSearchTerm(e.target.value)} className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg text-sm" />
          </div>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b">
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Foydalanuvchi</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Tarif</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Holat</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Muddat</th>
                  <th className="text-left py-3 px-4 font-medium text-gray-700">Tashriflar</th>
                  <th className="text-right py-3 px-4 font-medium text-gray-700">Amallar</th>
                </tr>
              </thead>
              <tbody>
                {filtered.map((sub) => {
                  const user = sub.user || {};
                  const plan = sub.plan || {};
                  const st = sub.status || 'unknown';
                  return (
                    <tr key={sub.id} className="border-b hover:bg-gray-50">
                      <td className="py-3 px-4">
                        <div className="font-medium">{user.full_name || '—'}</div>
                        <div className="text-sm text-gray-500">{user.phone_number || ''}</div>
                      </td>
                      <td className="py-3 px-4">
                        <div className="font-medium">{plan.name || '—'}</div>
                        <div className="text-sm text-gray-500">{plan.price ? `${Number(plan.price).toLocaleString()} ${plan.currency || 'UZS'}` : ''}</div>
                      </td>
                      <td className="py-3 px-4">
                        <span className={`inline-flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium ${getStatusBadge(st)}`}>
                          {getStatusIcon(st)} {st === 'active' ? 'Faol' : st === 'pending' ? 'Kutilmoqda' : st === 'expired' ? 'Tugagan' : st === 'cancelled' ? 'Bekor' : st}
                        </span>
                      </td>
                      <td className="py-3 px-4 text-sm">
                        <div>{sub.start_date ? new Date(sub.start_date).toLocaleDateString() : '—'}</div>
                        <div className="text-gray-500">{sub.end_date ? `— ${new Date(sub.end_date).toLocaleDateString()}` : ''}</div>
                      </td>
                      <td className="py-3 px-4 text-sm">
                        <span className="font-medium">{sub.visits_used || 0}</span>
                        <span className="text-gray-500"> / {sub.is_unlimited ? '∞' : (sub.visits_remaining + (sub.visits_used || 0)) || plan.visit_limit || '—'}</span>
                      </td>
                      <td className="py-3 px-4">
                        <div className="flex items-center justify-end gap-1">
                          {(st === 'pending') && (
                            <Button variant="ghost" size="sm" onClick={() => handleApprove(sub)} title="Tasdiqlash" className="text-green-600 hover:text-green-800 hover:bg-green-50">
                              <ShieldCheck className="h-4 w-4" />
                            </Button>
                          )}
                          <Button variant="ghost" size="sm" onClick={() => openEditSub(sub)} title="Tahrirlash">
                            <Edit className="h-4 w-4" />
                          </Button>
                          {st === 'active' && (
                            <Button variant="ghost" size="sm" onClick={() => handleCancelSub(sub)} title="Bekor qilish" className="text-orange-500 hover:text-orange-700 hover:bg-orange-50">
                              <Ban className="h-4 w-4" />
                            </Button>
                          )}
                          <Button variant="ghost" size="sm" onClick={() => handleDeleteSub(sub)} title="O'chirish" className="text-red-500 hover:text-red-700 hover:bg-red-50">
                            <Trash2 className="h-4 w-4" />
                          </Button>
                        </div>
                      </td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
          {filtered.length === 0 && (
            <div className="text-center py-12">
              <CreditCard className="h-12 w-12 text-gray-400 mx-auto mb-4" />
              <p className="text-gray-600">Obunalar topilmadi</p>
            </div>
          )}
        </CardContent>
      </Card>

      {/* Edit Subscription Modal */}
      {showSubModal && editingSub && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 w-full max-w-lg max-h-[90vh] overflow-y-auto">
            <h2 className="text-xl font-bold mb-4">Obunani tahrirlash</h2>
            <p className="text-sm text-gray-500 mb-4">{editingSub.user?.full_name || editingSub.user?.phone_number || editingSub.id}</p>
            {modalError && <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg text-sm text-red-600">{modalError}</div>}
            {modalSuccess && <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg text-sm text-green-600">{modalSuccess}</div>}
            <form onSubmit={handleSaveSub} className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Holat</label>
                <select value={subForm.status} onChange={e => setSubForm({...subForm, status: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg">
                  <option value="active">Faol</option>
                  <option value="pending">Kutilmoqda</option>
                  <option value="expired">Tugagan</option>
                  <option value="cancelled">Bekor qilingan</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Tarif</label>
                <select value={subForm.plan_id} onChange={e => setSubForm({...subForm, plan_id: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg">
                  <option value="">— O'zgartirmaslik —</option>
                  {plans.map(p => <option key={p.id} value={p.id}>{p.name} ({Number(p.price).toLocaleString()} {p.currency})</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Tugash sanasi</label>
                <input type="date" value={subForm.end_date} onChange={e => setSubForm({...subForm, end_date: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg" />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Tashriflar (ishlatilgan)</label>
                  <input type="number" min="0" value={subForm.visits_used} onChange={e => setSubForm({...subForm, visits_used: parseInt(e.target.value) || 0})} className="w-full px-3 py-2 border border-gray-300 rounded-lg" />
                </div>
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">Qolgan tashriflar</label>
                  <input type="number" min="0" value={subForm.visits_remaining} onChange={e => setSubForm({...subForm, visits_remaining: parseInt(e.target.value) || 0})} className="w-full px-3 py-2 border border-gray-300 rounded-lg" disabled={subForm.is_unlimited} />
                </div>
              </div>
              <div className="flex items-center gap-4">
                <label className="flex items-center gap-2"><input type="checkbox" checked={subForm.is_unlimited} onChange={e => setSubForm({...subForm, is_unlimited: e.target.checked})} className="w-4 h-4" /><span className="text-sm">Cheksiz</span></label>
                <label className="flex items-center gap-2"><input type="checkbox" checked={subForm.auto_renew} onChange={e => setSubForm({...subForm, auto_renew: e.target.checked})} className="w-4 h-4" /><span className="text-sm">Avtomatik uzaytirish</span></label>
              </div>
              <div className="flex gap-3 pt-4">
                <Button type="submit" className="flex-1">Saqlash</Button>
                <Button type="button" variant="outline" onClick={() => setShowSubModal(false)} className="flex-1">Bekor qilish</Button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Create/Edit Plan Modal */}
      {showPlanModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 w-full max-w-2xl max-h-[90vh] overflow-y-auto">
            <h2 className="text-xl font-bold mb-4">{editingPlan ? 'Tarifni tahrirlash' : 'Yangi tarif yaratish'}</h2>
            {modalError && <div className="mb-4 p-3 bg-red-50 border border-red-200 rounded-lg text-sm text-red-600">{modalError}</div>}
            {modalSuccess && <div className="mb-4 p-3 bg-green-50 border border-green-200 rounded-lg text-sm text-green-600">{modalSuccess}</div>}
            <form onSubmit={handleSavePlan} className="space-y-4">
              {/* Names */}
              <div className="border border-gray-200 rounded-lg p-3 space-y-3">
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Nomi (Name)</p>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-3">
                  <div><label className="block text-xs font-medium text-gray-600 mb-1">🇺🇿 O'zbekcha *</label><input type="text" value={planForm.name} onChange={e => setPlanForm({...planForm, name: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm" required placeholder="Oylik - 10" /></div>
                  <div><label className="block text-xs font-medium text-gray-600 mb-1">🇷🇺 Ruscha</label><input type="text" value={planForm.name_ru} onChange={e => setPlanForm({...planForm, name_ru: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm" placeholder="Месячный - 10" /></div>
                  <div><label className="block text-xs font-medium text-gray-600 mb-1">🇬🇧 English</label><input type="text" value={planForm.name_en} onChange={e => setPlanForm({...planForm, name_en: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm" placeholder="Monthly - 10" /></div>
                </div>
              </div>
              {/* Descriptions */}
              <div className="border border-gray-200 rounded-lg p-3 space-y-3">
                <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide">Tavsif (Description)</p>
                <div><label className="block text-xs font-medium text-gray-600 mb-1">🇺🇿 O'zbekcha *</label><textarea value={planForm.description} onChange={e => setPlanForm({...planForm, description: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm" rows="2" required placeholder="30 kunga 10 ta tashrif" /></div>
                <div><label className="block text-xs font-medium text-gray-600 mb-1">🇷🇺 Ruscha</label><textarea value={planForm.description_ru} onChange={e => setPlanForm({...planForm, description_ru: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm" rows="2" placeholder="10 посещений на 30 дней" /></div>
                <div><label className="block text-xs font-medium text-gray-600 mb-1">🇬🇧 English</label><textarea value={planForm.description_en} onChange={e => setPlanForm({...planForm, description_en: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg text-sm" rows="2" placeholder="10 visits for 30 days" /></div>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div><label className="block text-sm font-medium text-gray-700 mb-1">Narxi (UZS) *</label><input type="number" value={planForm.price} onChange={e => setPlanForm({...planForm, price: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg" required min="0" /></div>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div><label className="block text-sm font-medium text-gray-700 mb-1">Muddat (kun) *</label><input type="number" value={planForm.duration_days} onChange={e => setPlanForm({...planForm, duration_days: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg" required min="1" /></div>
                <div><label className="block text-sm font-medium text-gray-700 mb-1">Tashrif limiti</label><input type="number" value={planForm.visit_limit} onChange={e => setPlanForm({...planForm, visit_limit: e.target.value})} className="w-full px-3 py-2 border border-gray-300 rounded-lg" disabled={planForm.is_unlimited} min="1" /></div>
              </div>
              <div className="flex items-center gap-4">
                <label className="flex items-center gap-2"><input type="checkbox" checked={planForm.is_unlimited} onChange={e => setPlanForm({...planForm, is_unlimited: e.target.checked, visit_limit: e.target.checked ? '' : planForm.visit_limit})} className="w-4 h-4" /><span className="text-sm">Cheksiz tashriflar</span></label>
                <label className="flex items-center gap-2"><input type="checkbox" checked={planForm.is_active} onChange={e => setPlanForm({...planForm, is_active: e.target.checked})} className="w-4 h-4" /><span className="text-sm">Faol (foydalanuvchilarga ko'rinadi)</span></label>
              </div>
              <div className="flex gap-3 pt-4">
                <Button type="submit" className="flex-1">{editingPlan ? 'Yangilash' : 'Yaratish'}</Button>
                <Button type="button" variant="outline" onClick={() => { setShowPlanModal(false); setEditingPlan(null); }} className="flex-1">Bekor qilish</Button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Subscriptions;
