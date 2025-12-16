import React from 'react';
import { Eye, Edit, Trash2, MoreVertical } from 'lucide-react';

const CleanTable = ({ 
  columns, 
  data, 
  onView, 
  onEdit, 
  onDelete,
  loading = false 
}) => {
  if (loading) {
    return (
      <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
        <div className="p-12 text-center">
          <div className="w-12 h-12 border-4 border-gray-200 border-t-gray-900 rounded-full animate-spin mx-auto mb-4"></div>
          <p className="text-gray-500">Загрузка...</p>
        </div>
      </div>
    );
  }

  if (!data || data.length === 0) {
    return (
      <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
        <div className="p-12 text-center">
          <p className="text-gray-500">Нет данных</p>
        </div>
      </div>
    );
  }

  return (
    <div className="bg-white rounded-lg border border-gray-200 overflow-hidden">
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead className="bg-gray-50 border-b border-gray-200">
            <tr>
              {columns.map((column, index) => (
                <th
                  key={index}
                  className="px-6 py-3 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider"
                >
                  {column.header}
                </th>
              ))}
              <th className="px-6 py-3 text-right text-xs font-semibold text-gray-600 uppercase tracking-wider">
                Действия
              </th>
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-200">
            {data.map((row, rowIndex) => (
              <tr 
                key={rowIndex}
                className="hover:bg-gray-50 transition-colors"
              >
                {columns.map((column, colIndex) => (
                  <td
                    key={colIndex}
                    className="px-6 py-4 whitespace-nowrap"
                  >
                    {column.render ? column.render(row) : (
                      <span className="text-sm text-gray-900">
                        {row[column.accessor]}
                      </span>
                    )}
                  </td>
                ))}
                <td className="px-6 py-4 whitespace-nowrap text-right">
                  <div className="flex items-center justify-end gap-2">
                    {onView && (
                      <button
                        onClick={() => onView(row)}
                        className="p-2 text-gray-600 hover:bg-gray-100 rounded-md transition-colors"
                        title="Просмотр"
                      >
                        <Eye size={16} />
                      </button>
                    )}
                    {onEdit && (
                      <button
                        onClick={() => onEdit(row)}
                        className="p-2 text-blue-600 hover:bg-blue-50 rounded-md transition-colors"
                        title="Редактировать"
                      >
                        <Edit size={16} />
                      </button>
                    )}
                    {onDelete && (
                      <button
                        onClick={() => onDelete(row)}
                        className="p-2 text-red-600 hover:bg-red-50 rounded-md transition-colors"
                        title="Удалить"
                      >
                        <Trash2 size={16} />
                      </button>
                    )}
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

// Status Badge Component
export const StatusBadge = ({ status }) => {
  const statusStyles = {
    active: 'bg-green-50 text-green-700 border-green-200',
    inactive: 'bg-gray-50 text-gray-700 border-gray-200',
    pending: 'bg-yellow-50 text-yellow-700 border-yellow-200',
    suspended: 'bg-red-50 text-red-700 border-red-200',
  };

  const statusLabels = {
    active: 'Активный',
    inactive: 'Неактивный',
    pending: 'В ожидании',
    suspended: 'Приостановлен',
  };

  const style = statusStyles[status?.toLowerCase()] || statusStyles.inactive;
  const label = statusLabels[status?.toLowerCase()] || status;

  return (
    <span className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${style}`}>
      {label}
    </span>
  );
};

// User Cell Component
export const UserCell = ({ name, email, avatar }) => (
  <div className="flex items-center gap-3">
    {avatar ? (
      <img src={avatar} alt={name} className="w-10 h-10 rounded-full" />
    ) : (
      <div className="w-10 h-10 rounded-full bg-gray-200 flex items-center justify-center text-gray-700 font-semibold text-sm">
        {name?.charAt(0) || 'U'}
      </div>
    )}
    <div>
      <p className="text-sm font-semibold text-gray-900">{name}</p>
      {email && <p className="text-xs text-gray-500">{email}</p>}
    </div>
  </div>
);

// Date Cell Component
export const DateCell = ({ date }) => {
  if (!date) return <span className="text-sm text-gray-500">—</span>;
  
  const formattedDate = new Date(date).toLocaleDateString('ru-RU', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric'
  });

  return <span className="text-sm text-gray-900">{formattedDate}</span>;
};

// Phone Cell Component
export const PhoneCell = ({ phone }) => (
  <span className="text-sm text-gray-900 font-mono">{phone || '—'}</span>
);

export default CleanTable;
