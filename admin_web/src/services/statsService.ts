import api from './api';

export interface DashboardStats {
  total_artisans: number;
  active_artisans: number;
  pending_requests: number;
  total_users: number;
  recent_activity: number;
}

export const statsService = {
  getDashboardStats: async () => {
    const response = await api.get<DashboardStats>('/admin/stats');
    return response.data;
  },
};
