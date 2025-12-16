import React from 'react';
import { ChevronLeft, ChevronRight, Search, Filter, Download } from 'lucide-react';

const ModernTable = ({ 
  columns, 
  data, 
  loading = false,
  onRowClick,
  searchable = true,
  filterable = true,
  exportable = true,
  pagination = true
}) => {
  const [searchTerm, setSearchTerm] = React.useState('');
  const [currentPage, setCurrentPage] = React.useState(1);
  const itemsPerPage = 10;

  // Filter data based on search
  const filteredData = searchTerm
    ? data.filter(row =>
        Object.values(row).some(value =>
          String(value).toLowerCase().includes(searchTerm.toLowerCase())
        )
      )
    : data;

  // Pagination
  const totalPages = Math.ceil(filteredData.length / itemsPerPage);
  const startIndex = (currentPage - 1) * itemsPerPage;
  const paginatedData = pagination 
    ? filteredData.slice(startIndex, startIndex + itemsPerPage)
    : filteredData;

  return (
    <div className="bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">
      {/* Table Header */}
      {(searchable || filterable || exportable) && (
        <div className="p-6 border-b border-gray-100 bg-gradient-to-r from-gray-50 to-white">
          <div className="flex items-center justify-between gap-4">
            {/* Search */}
            {searchable && (
              <div className="flex-1 max-w-md">
                <div className="relative">
                  <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={18} />
                  <input
                    type="text"
                    placeholder="Поиск..."
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full pl-10 pr-4 py-2.5 border-2 border-gray-200 rounded-xl focus:border-yuvgo-cyan focus:ring-4 focus:ring-yuvgo-cyan/10 transition-all outline-none text-sm"
                  />
                </div>
              </div>
            )}

            {/* Actions */}
            <div className="flex items-center gap-2">
              {filterable && (
                <button className="flex items-center gap-2 px-4 py-2.5 border-2 border-gray-200 rounded-xl hover:border-yuvgo-cyan hover:bg-yuvgo-cyan/5 transition-all text-sm font-medium text-gray-700">
                  <Filter size={16} />
                  <span>Фильтр</span>
                </button>
              )}
              {exportable && (
                <button className="flex items-center gap-2 px-4 py-2.5 bg-gradient-to-r from-yuvgo-cyan to-yuvgo-dark text-white rounded-xl hover:shadow-lg transition-all text-sm font-semibold">
                  <Download size={16} />
                  <span>Экспорт</span>
                </button>
              )}
            </div>
          </div>
        </div>
      )}

      {/* Table */}
      <div className="overflow-x-auto">
        <table className="w-full">
          <thead>
            <tr className="bg-gradient-to-r from-gray-50 to-gray-100/50">
              {columns.map((column, index) => (
                <th
                  key={index}
                  className="px-6 py-4 text-left text-xs font-bold text-gray-700 uppercase tracking-wider"
                >
                  {column.header}
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="divide-y divide-gray-100">
            {loading ? (
              <tr>
                <td colSpan={columns.length} className="px-6 py-12 text-center">
                  <div className="flex flex-col items-center gap-3">
                    <div className="w-10 h-10 border-4 border-yuvgo-cyan border-t-transparent rounded-full animate-spin"></div>
                    <p className="text-sm text-gray-500">Загрузка...</p>
                  </div>
                </td>
              </tr>
            ) : paginatedData.length === 0 ? (
              <tr>
                <td colSpan={columns.length} className="px-6 py-12 text-center">
                  <p className="text-gray-500">Данные не найдены</p>
                </td>
              </tr>
            ) : (
              paginatedData.map((row, rowIndex) => (
                <tr
                  key={rowIndex}
                  onClick={() => onRowClick && onRowClick(row)}
                  className={`hover:bg-gradient-to-r hover:from-yuvgo-cyan/5 hover:to-transparent transition-all ${
                    onRowClick ? 'cursor-pointer' : ''
                  }`}
                >
                  {columns.map((column, colIndex) => (
                    <td key={colIndex} className="px-6 py-4 text-sm text-gray-900">
                      {column.render ? column.render(row) : row[column.accessor]}
                    </td>
                  ))}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>

      {/* Pagination */}
      {pagination && totalPages > 1 && (
        <div className="px-6 py-4 border-t border-gray-100 bg-gradient-to-r from-gray-50 to-white">
          <div className="flex items-center justify-between">
            <p className="text-sm text-gray-600">
              Показано <span className="font-semibold">{startIndex + 1}</span> -{' '}
              <span className="font-semibold">
                {Math.min(startIndex + itemsPerPage, filteredData.length)}
              </span>{' '}
              из <span className="font-semibold">{filteredData.length}</span>
            </p>

            <div className="flex items-center gap-2">
              <button
                onClick={() => setCurrentPage(prev => Math.max(1, prev - 1))}
                disabled={currentPage === 1}
                className="p-2 rounded-lg border-2 border-gray-200 hover:border-yuvgo-cyan hover:bg-yuvgo-cyan/5 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
              >
                <ChevronLeft size={18} />
              </button>

              <div className="flex items-center gap-1">
                {[...Array(totalPages)].map((_, index) => (
                  <button
                    key={index}
                    onClick={() => setCurrentPage(index + 1)}
                    className={`w-10 h-10 rounded-lg font-semibold text-sm transition-all ${
                      currentPage === index + 1
                        ? 'bg-gradient-to-r from-yuvgo-cyan to-yuvgo-dark text-white shadow-lg'
                        : 'border-2 border-gray-200 text-gray-700 hover:border-yuvgo-cyan hover:bg-yuvgo-cyan/5'
                    }`}
                  >
                    {index + 1}
                  </button>
                ))}
              </div>

              <button
                onClick={() => setCurrentPage(prev => Math.min(totalPages, prev + 1))}
                disabled={currentPage === totalPages}
                className="p-2 rounded-lg border-2 border-gray-200 hover:border-yuvgo-cyan hover:bg-yuvgo-cyan/5 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
              >
                <ChevronRight size={18} />
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default ModernTable;
