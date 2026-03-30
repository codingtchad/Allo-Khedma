/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: '#C96E12',
          dark: '#A5570D',
          light: '#F3C892',
        },
        background: '#FFF8F1',
        surface: '#FFFFFF',
        text: {
          main: '#1F1F1F',
          secondary: '#6B6B6B',
        },
        success: '#2E9B57',
        error: '#D64545',
      },
    },
  },
  plugins: [],
}
