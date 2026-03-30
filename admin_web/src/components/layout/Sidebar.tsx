import React from 'react';
import { Link, useLocation } from 'react-router-dom';
import { Home, Users, ClipboardList, FileText, Settings, LogOut } from 'lucide-react';

const Sidebar = () => {
  const location = useLocation();

  const menuItems = [
    { path: '/dashboard', label: 'Tableau de bord', icon: Home },
    { path: '/artisans', label: 'Artisans', icon: Users },
    { path: '/requests', label: 'Demandes', icon: ClipboardList },
    { path: '/logs', label: 'Logs', icon: FileText },
    { path: '/settings', label: 'Paramètres', icon: Settings },
  ];

  return (
    <div className="w-64 bg-surface border-r border-gray-200 flex flex-col">
      <div className="p-6 border-b border-gray-200">
        <h1 className="text-xl font-bold text-primary">Allo-Khedma</h1>
        <p className="text-xs text-text-secondary mt-1">Admin Panel</p>
      </div>

      <nav className="flex-1 p-4 space-y-2">
        {menuItems.map((item) => {
          const Icon = item.icon;
          const isActive = location.pathname === item.path;

          return (
            <Link
              key={item.path}
              to={item.path}
              className={`flex items-center gap-3 px-4 py-3 rounded-lg transition-colors ${
                isActive
                  ? 'bg-primary/10 text-primary'
                  : 'text-text-secondary hover:bg-gray-50 hover:text-text-main'
              }`}
            >
              <Icon size={20} />
              <span className="font-medium">{item.label}</span>
            </Link>
          );
        })}
      </nav>

      <div className="p-4 border-t border-gray-200">
        <button className="flex items-center gap-3 px-4 py-3 w-full rounded-lg text-text-secondary hover:bg-error/10 hover:text-error transition-colors">
          <LogOut size={20} />
          <span className="font-medium">Déconnexion</span>
        </button>
      </div>
    </div>
  );
};

export default Sidebar;
