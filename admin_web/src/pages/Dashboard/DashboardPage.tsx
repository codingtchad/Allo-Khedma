import React, { useState, useEffect } from 'react';
import { useAuth } from '../../context/AuthContext';
import { statsService } from '../../services/statsService';
import { artisanService } from '../../services/artisanService';
import { requestService } from '../../services/requestService';
import Sidebar from '../../components/layout/Sidebar';
import Header from '../../components/layout/Header';
import StatsCard from '../../components/dashboard/StatsCard';
import { Users, UserCheck, ClipboardList, TrendingUp } from 'lucide-react';

const DashboardPage = () => {
  const { logout } = useAuth();
  const [stats, setStats] = useState({
    total_artisans: 0,
    active_artisans: 0,
    pending_requests: 0,
    total_users: 0,
  });
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadStats();
  }, []);

  const loadStats = async () => {
    try {
      const data = await statsService.getDashboardStats();
      setStats(data);
    } catch (error) {
      console.error('Erreur lors du chargement des statistiques:', error);
    } finally {
      setIsLoading(false);
    }
  };

  const statCards = [
    {
      title: 'Total Artisans',
      value: stats.total_artisans,
      icon: Users,
      color: 'text-primary',
      bgColor: 'bg-primary/10',
    },
    {
      title: 'Artisans Actifs',
      value: stats.active_artisans,
      icon: UserCheck,
      color: 'text-success',
      bgColor: 'bg-success/10',
    },
    {
      title: 'Demandes en attente',
      value: stats.pending_requests,
      icon: ClipboardList,
      color: 'text-orange-500',
      bgColor: 'bg-orange-500/10',
    },
    {
      title: 'Utilisateurs',
      value: stats.total_users,
      icon: TrendingUp,
      color: 'text-blue-500',
      bgColor: 'bg-blue-500/10',
    },
  ];

  if (isLoading) {
    return (
      <div className="min-h-screen bg-background flex items-center justify-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  return (
    <div className="flex h-screen bg-background">
      <Sidebar />
      <div className="flex-1 flex flex-col overflow-hidden">
        <Header title="Tableau de bord" onLogout={logout} />
        <main className="flex-1 overflow-y-auto p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            {statCards.map((stat) => (
              <StatsCard key={stat.title} {...stat} />
            ))}
          </div>

          <div className="bg-surface rounded-2xl shadow-sm p-6">
            <h2 className="text-xl font-bold text-text-main mb-4">Activité récente</h2>
            <p className="text-text-secondary">Les dernières activités seront affichées ici.</p>
          </div>
        </main>
      </div>
    </div>
  );
};

export default DashboardPage;
