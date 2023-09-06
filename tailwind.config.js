module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require('@tailwindcss/forms'),
  ],
  theme: {
    extend: {
      keyframes: {
        fadeIn: {
          '0%': { opacity: 0 },
          '100%': { opacity: 1 },
        },
        slideInLeft: {
          '0%': { transform: 'translateX(-100%)' },
          '100%': { transform: 'translateX(0)' },
        },
        slideInRight: {
          '0%': { transform: 'translateX(100%)' },
          '100%': { transform: 'translateX(0)' },
        },
        slideInUp: {
          '0%': { transform: 'translateY(100%)' },
          '100%': { transform: 'translateY(0)' },
        },
      },
      animation: {
        fadeIn: 'fadeIn 1s ease-in-out',
        slideInLeft: 'slideInLeft 1s ease-in-out',
        slideInRight: 'slideInRight 1s ease-in-out',
        slideInUp: 'slideInUp 1s ease-in-out',
      },
    },
  },
}
