import React from 'react';
import { LucideIcon } from 'lucide-react';

interface StatsCardProps {
  title: string;
  value: number;
  icon: LucideIcon;
  color: string;
  bgColor: string;
}

const StatsCard = ({ title, value, icon: Icon, color, bgColor }: StatsCardProps) => {
  return (
    <div className="bg-surface rounded-2xl shadow-sm p-6 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between mb-4">
        <div className={`p-3 rounded-lg ${bgColor}`}>
          <Icon size={24} className={color} />
        </div>
        <span className="text-3xl font-bold text-text-main">{value}</span>
      </div>
      <h3 className="text-sm font-medium text-text-secondary">{title}</h3>
    </div>
  );
};

export default StatsCard;
