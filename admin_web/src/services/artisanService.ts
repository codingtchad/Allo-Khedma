import api from './api';

export interface Artisan {
  id: number;
  full_name: string;
  phone: string;
  whatsapp_phone: string;
  category: string;
  city: string;
  district: string;
  description: string;
  is_available: boolean;
  rating: number;
  photo_url?: string;
  created_at: string;
}

export interface CreateArtisanDto {
  full_name: string;
  phone: string;
  whatsapp_phone: string;
  category_id: number;
  city: string;
  district: string;
  description: string;
  is_available?: boolean;
}

export const artisanService = {
  getAll: async () => {
    const response = await api.get<Artisan[]>('/admin/artisans');
    return response.data;
  },

  getById: async (id: number) => {
    const response = await api.get<Artisan>(`/admin/artisans/${id}`);
    return response.data;
  },

  create: async (data: CreateArtisanDto) => {
    const response = await api.post<Artisan>('/admin/artisans', data);
    return response.data;
  },

  update: async (id: number, data: Partial<CreateArtisanDto>) => {
    const response = await api.put<Artisan>(`/admin/artisans/${id}`, data);
    return response.data;
  },

  delete: async (id: number) => {
    await api.delete(`/admin/artisans/${id}`);
  },

  toggleAvailability: async (id: number) => {
    const response = await api.patch<Artisan>(`/admin/artisans/${id}/toggle-availability`);
    return response.data;
  },
};
