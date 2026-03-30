import api from './api';

export interface LogEntry {
  id: number;
  action: string;
  user_id: number;
  details: string;
  timestamp: string;
}

export const logService = {
  getAll: async () => {
    const response = await api.get<LogEntry[]>('/admin/logs');
    return response.data;
  },

  getByUser: async (userId: number) => {
    const response = await api.get<LogEntry[]>(`/admin/logs/user/${userId}`);
    return response.data;
  },
};
