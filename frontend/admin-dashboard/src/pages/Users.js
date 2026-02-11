import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { useAuth } from '../context/AuthContext';
import { Search, X, Eye, Edit, Mail, Phone, Calendar, CheckCircle, XCircle, Smartphone, CreditCard, Trash2, Plus, ShieldCheck, Ban } from 'lucide-react';
import { Badge } from '../components/ui/badge';
import { Button } from '../components/ui/button';

const Users = () => {
  const { API_URL } = useAuth();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  const [isEditing, setIsEditing] = useState(false);
  const [userStats, setUserStats] = useState({ total: 0, active: 0, verified: 0, withSubscription: 0 });
  const [editForm, setEditForm] = useState({ full_name: '', email: '', is_active: true });
  const [userSubs, setUserSubs] = useState([]);
  const [loadingSubs, setLoadingSubs] = useState(false);
  const [plans, setPlans] = useState([]);
  const [showSubCreate, setShowSubCreate] = useState(false);
  const [newSubPlanId, setNewSubPlanId] = useState('');

  useEffect(() => { fetchUsers(); fetchPlans(); }, []);

  const fetchUsers = async () => {
    try {
      const response = await axios.get(`${API_URL}/api/user/users`);
      const userData = response.data || [];
      setUsers(userData);
      setUserStats({
        total: userData.length,
        active: userData.filter(u => u.is_active).length,
        verified: userData.filter(u => u.is_verified).length,
        withSubscription: userData.filter(u => u.has_subscription).length
      });
    } catch (error) {
      console.error('Failed to fetch users:', error);
    } finally {
      setLoading(false);
    }
  };

  const fetchPlans = async () => {
    try {
      const res = await axios.get(`${API_URL}/api/subscription/plans`);
      setPlans(res.data || []);
    } catch (e) { console.error('Plans fetch error', e); }
  };

  const fetchUserSubs = async (userId) => {
    setLoadingSubs(true);
    try {
      const res = await axios.get(`${API_URL}/api/subscription/subscriptions/by-user/${userId}`);
      setUserSubs(Array.isArray(res.data) ? res.data : []);
    } catch (e) {
      console.error('User subs error', e);
      setUserSubs([]);
    } finally {
      setLoadingSubs(false);
    }
  };

  const handleView = (user) => {
    setSelectedUser(user);
    setIsEditing(false);
    setShowModal(true);
    setShowSubCreate(false);
    fetchUserSubs(user.id);
  };

  const handleEdit = (user) => {
    setSelectedUser(user);
    setEditForm({ full_name: user.full_name || '', email: user.email || '', is_active: user.is_active });
    setIsEditing(true);
    setShowModal(true);
    setShowSubCreate(false);
    fetchUserSubs(user.id);
  };

  const handleSave = async () => {
    try {
      await axios.put(`${API_URL}/api/user/users/${selectedUser.id}`, editForm);
      fetchUsers();
      setIsEditing(false);
    } catch (error) {
      alert(error.response?.data?.detail || 'Saqlashda xatolik');
    }
  };

  const handleDelete = async (user) => {
    if (!window.confirm(`"${user.full_name || user.phone_number}" foydalanuvchini o'chirmoqchimisiz?`)) return;
    try {
      await axios.delete(`${API_URL}/api/user/users/${user.id}`);
      fetchUsers();
    } catch (error) {
      alert(error.response?.data?.detail || 'O\'chirishda xatolik');
    }
  };

  const handleApproveSub = async (subId) => {
    try {
      await axios.post(`${API_URL}/api/subscription/subscriptions/${subId}/approve`);
      fetchUserSubs(selectedUser.id);
    } catch (e) { alert(e.response?.data?.detail || 'Xatolik'); }
  };

  const handleCancelSub = async (subId) => {
    if (!window.confirm('Obunani bekor qilasizmi?')) return;
    try {
      await axios.put(`${API_URL}/api/subscription/subscriptions/${subId}?status=cancelled`);
      fetchUserSubs(selectedUser.id);
    } catch (e) { alert(e.response?.data?.detail || 'Xatolik'); }
  };

  const handleDeleteSub = async (subId) => {
    if (!window.confirm('Obunani o\'chirasizmi?')) return;
    try {
      await axios.delete(`${API_URL}/api/subscription/subscriptions/${subId}`);
      fetchUserSubs(selectedUser.id);
      fetchUsers();
    } catch (e) { alert(e.response?.data?.detail || 'Xatolik'); }
  };

  const handleCreateSub = async () => {
    if (!newSubPlanId) { alert('Tarifni tanlang'); return; }
    try {
      await axios.post(`${API_URL}/api/subscription/subscriptions/admin-create?user_id=${selectedUser.id}&plan_id=${newSubPlanId}&status=active`);
      setShowSubCreate(false);
      setNewSubPlanId('');
      fetchUserSubs(selectedUser.id);
      fetchUsers();
    } catch (e) { alert(e.response?.data?.detail || 'Xatolik'); }
  };

  const filteredUsers = users.filter(user =>
    user.full_name?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.email?.toLowerCase().includes(searchTerm.toLowerCase()) ||
    user.phone_number?.includes(searchTerm)
  );

  const getSubStatusBadge = (st) => {
    const m = { active: 'bg-green-100 text-green-800', pending: 'bg-yellow-100 text-yellow-800', expired: 'bg-red-100 text-red-800', cancelled: 'bg-gray-100 text-gray-800' };
    return m[st] || m.pending;
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Foydalanuvchilar</h1>
          <p className="text-gray-600 mt-1">YuvGO mobil ilovasidan ro'yxatdan o'tgan foydalanuvchilar</p>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-blue-100 rounded-lg"><Smartphone className="text-blue-600" size={20} /></div>
            <div><p className="text-2xl font-bold text-gray-900">{userStats.total}</p><p className="text-sm text-gray-500">Jami</p></div>
          </div>
        </div>
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-green-100 rounded-lg"><CheckCircle className="text-green-600" size={20} /></div>
            <div><p className="text-2xl font-bold text-gray-900">{userStats.active}</p><p className="text-sm text-gray-500">Faol</p></div>
          </div>
        </div>
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-purple-100 rounded-lg"><Phone className="text-purple-600" size={20} /></div>
            <div><p className="text-2xl font-bold text-gray-900">{userStats.verified}</p><p className="text-sm text-gray-500">Tasdiqlangan</p></div>
          </div>
        </div>
        <div className="bg-white rounded-xl p-4 border border-gray-200">
          <div className="flex items-center gap-3">
            <div className="p-2 bg-orange-100 rounded-lg"><CreditCard className="text-orange-600" size={20} /></div>
            <div><p className="text-2xl font-bold text-gray-900">{userStats.withSubscription}</p><p className="text-sm text-gray-500">Obunali</p></div>
          </div>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow">
        <div className="p-4 border-b">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input type="text" placeholder="Qidirish (ism, telefon, email)..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg" />
          </div>
        </div>

        {loading ? (
          <div className="flex items-center justify-center h-64"><div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600"></div></div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Foydalanuvchi</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Telefon</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Holat</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Ro'yxatdan o'tgan</th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Amallar</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {filteredUsers.map((user) => (
                  <tr key={user.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-gray-900">{user.full_name || 'N/A'}</div>
                      <div className="text-sm text-gray-500">{user.email || ''}</div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">{user.phone_number}</td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`px-2 py-1 inline-flex text-xs leading-5 font-semibold rounded-full ${user.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'}`}>
                        {user.is_active ? 'Faol' : 'Nofaol'}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">{new Date(user.created_at).toLocaleDateString()}</td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <button onClick={() => handleView(user)} className="text-blue-600 hover:text-blue-900 mr-2 inline-flex items-center gap-1"><Eye size={16} /> Ko'rish</button>
                      <button onClick={() => handleEdit(user)} className="text-gray-600 hover:text-gray-900 mr-2 inline-flex items-center gap-1"><Edit size={16} /> Tahrir</button>
                      <button onClick={() => handleDelete(user)} className="text-red-500 hover:text-red-700 inline-flex items-center gap-1"><Trash2 size={16} /></button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* View/Edit Modal with Subscription Management */}
      {showModal && selectedUser && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg p-6 w-full max-w-3xl max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-gray-900">{isEditing ? 'Foydalanuvchini tahrirlash' : 'Foydalanuvchi ma\'lumotlari'}</h2>
              <button onClick={() => setShowModal(false)} className="text-gray-400 hover:text-gray-600"><X size={24} /></button>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Ism</label>
                {isEditing ? (
                  <input type="text" value={editForm.full_name} onChange={(e) => setEditForm({ ...editForm, full_name: e.target.value })} className="w-full px-3 py-2 border border-gray-300 rounded-lg" />
                ) : (
                  <p className="text-gray-900 py-2">{selectedUser.full_name || 'N/A'}</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1 flex items-center gap-2"><Mail size={14} /> Email</label>
                {isEditing ? (
                  <input type="email" value={editForm.email} onChange={(e) => setEditForm({ ...editForm, email: e.target.value })} className="w-full px-3 py-2 border border-gray-300 rounded-lg" />
                ) : (
                  <p className="text-gray-900 py-2">{selectedUser.email || '—'}</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1 flex items-center gap-2"><Phone size={14} /> Telefon</label>
                <p className="text-gray-900 py-2">{selectedUser.phone_number}</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Holat</label>
                {isEditing ? (
                  <label className="flex items-center gap-2 py-2"><input type="checkbox" checked={editForm.is_active} onChange={(e) => setEditForm({ ...editForm, is_active: e.target.checked })} className="w-4 h-4" /><span className="text-sm">Faol</span></label>
                ) : (
                  <Badge variant={selectedUser.is_active ? "success" : "destructive"}>{selectedUser.is_active ? 'Faol' : 'Nofaol'}</Badge>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1 flex items-center gap-2"><Calendar size={14} /> Ro'yxatdan o'tgan</label>
                <p className="text-gray-900 py-2">{new Date(selectedUser.created_at).toLocaleString()}</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">ID</label>
                <p className="text-gray-500 font-mono text-xs py-2">{selectedUser.id}</p>
              </div>
            </div>

            {isEditing && (
              <div className="flex gap-3 mb-6">
                <Button onClick={handleSave} className="flex-1">Saqlash</Button>
                <Button variant="outline" onClick={() => setIsEditing(false)} className="flex-1">Bekor qilish</Button>
              </div>
            )}

            {!isEditing && (
              <div className="flex gap-3 mb-6">
                <Button onClick={() => setIsEditing(true)} variant="outline" className="gap-2"><Edit size={14} /> Tahrirlash</Button>
              </div>
            )}

            {/* Subscription Section */}
            <div className="border-t pt-6">
              <div className="flex items-center justify-between mb-4">
                <h3 className="text-lg font-bold text-gray-900 flex items-center gap-2"><CreditCard size={20} /> Obunalar</h3>
                <Button size="sm" onClick={() => setShowSubCreate(!showSubCreate)} className="gap-1"><Plus size={14} /> Obuna berish</Button>
              </div>

              {showSubCreate && (
                <div className="mb-4 p-4 bg-blue-50 border border-blue-200 rounded-lg">
                  <p className="text-sm font-medium text-gray-700 mb-2">Yangi obuna yaratish</p>
                  <div className="flex gap-2">
                    <select value={newSubPlanId} onChange={e => setNewSubPlanId(e.target.value)} className="flex-1 px-3 py-2 border border-gray-300 rounded-lg text-sm">
                      <option value="">Tarifni tanlang...</option>
                      {plans.map(p => <option key={p.id} value={p.id}>{p.name} — {Number(p.price).toLocaleString()} {p.currency} ({p.duration_days} kun)</option>)}
                    </select>
                    <Button size="sm" onClick={handleCreateSub}>Yaratish</Button>
                    <Button size="sm" variant="outline" onClick={() => { setShowSubCreate(false); setNewSubPlanId(''); }}>Bekor</Button>
                  </div>
                </div>
              )}

              {loadingSubs ? (
                <div className="text-center py-4"><div className="animate-spin rounded-full h-6 w-6 border-b-2 border-primary mx-auto"></div></div>
              ) : userSubs.length === 0 ? (
                <p className="text-gray-500 text-sm text-center py-4">Obunalar mavjud emas</p>
              ) : (
                <div className="space-y-3">
                  {userSubs.map(sub => (
                    <div key={sub.id} className={`border rounded-lg p-4 ${sub.status === 'active' ? 'border-green-200 bg-green-50' : sub.status === 'pending' ? 'border-yellow-200 bg-yellow-50' : 'border-gray-200'}`}>
                      <div className="flex items-center justify-between mb-2">
                        <div className="flex items-center gap-2">
                          <span className="font-medium">{sub.plan?.name || '—'}</span>
                          <span className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-medium ${getSubStatusBadge(sub.status)}`}>
                            {sub.status === 'active' ? 'Faol' : sub.status === 'pending' ? 'Kutilmoqda' : sub.status === 'expired' ? 'Tugagan' : 'Bekor'}
                          </span>
                        </div>
                        <div className="flex items-center gap-1">
                          {sub.status === 'pending' && (
                            <Button variant="ghost" size="sm" onClick={() => handleApproveSub(sub.id)} title="Tasdiqlash" className="text-green-600 hover:bg-green-100"><ShieldCheck size={16} /></Button>
                          )}
                          {sub.status === 'active' && (
                            <Button variant="ghost" size="sm" onClick={() => handleCancelSub(sub.id)} title="Bekor qilish" className="text-orange-500 hover:bg-orange-100"><Ban size={16} /></Button>
                          )}
                          <Button variant="ghost" size="sm" onClick={() => handleDeleteSub(sub.id)} title="O'chirish" className="text-red-500 hover:bg-red-100"><Trash2 size={16} /></Button>
                        </div>
                      </div>
                      <div className="grid grid-cols-2 md:grid-cols-4 gap-2 text-sm text-gray-600">
                        <div><span className="text-gray-400">Narxi: </span>{sub.plan?.price ? `${Number(sub.plan.price).toLocaleString()} ${sub.plan.currency}` : '—'}</div>
                        <div><span className="text-gray-400">Muddat: </span>{sub.start_date ? new Date(sub.start_date).toLocaleDateString() : '—'} — {sub.end_date ? new Date(sub.end_date).toLocaleDateString() : '—'}</div>
                        <div><span className="text-gray-400">Tashriflar: </span>{sub.visits_used || 0} / {sub.is_unlimited ? '∞' : (sub.visits_remaining + (sub.visits_used || 0))}</div>
                        <div><span className="text-gray-400">Avtouzaytirish: </span>{sub.auto_renew ? 'Ha' : 'Yo\'q'}</div>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default Users;
