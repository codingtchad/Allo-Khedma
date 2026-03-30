import api from './api';

export interface ArtisanRequest {
  id: number;
  full_name: string;
  phone: string;
  whatsapp_phone: string;
  category_name: string;
  city: string;
  district: string;
  description: string;
  status: 'pending' | 'approved' | 'rejected';
  created_at: string;
  reviewed_at?: string;
}

export const requestService = {
  getAll: async () => {
    const response = await api.get<ArtisanRequest[]>('/admin/artisan-requests');
    return response.data;
  },

  approve: async (id: number) => {
    const response = await api.post(`/admin/artisan-requests/${id}/approve`);
    return response.data;
  },

  reject: async (id: number, reason?: string) => {
    const response = await api.post(`/admin/artisan-requests/${id}/reject`, { reason });
    return response.data;
  },
};
