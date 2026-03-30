import React from 'react';
import { Bell, User } from 'lucide-react';

interface HeaderProps {
  title: string;
  onLogout: () => void;
}

const Header = ({ title, onLogout }: HeaderProps) => {
  return (
    <header className="bg-surface border-b border-gray-200 px-6 py-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold text-text-main">{title}</h1>

        <div className="flex items-center gap-4">
          <button className="p-2 hover:bg-gray-100 rounded-lg transition-colors relative">
            <Bell size={20} className="text-text-secondary" />
            <span className="absolute top-1 right-1 w-2 h-2 bg-error rounded-full"></span>
          </button>

          <div className="flex items-center gap-3 pl-4 border-l border-gray-200">
            <div className="w-8 h-8 bg-primary/10 rounded-full flex items-center justify-center">
              <User size={18} className="text-primary" />
            </div>
            <div>
              <p className="text-sm font-medium text-text-main">Admin</p>
              <p className="text-xs text-text-secondary">Administrateur</p>
            </div>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
