const plugin = require('tailwindcss/plugin');

module.exports = {
  theme: {
    // https://javisperez.github.io/tailwindcolorshades/#/
    extend: {
      colors: {
        'gullgray': {
          100: '#F5F8F9',
          200: '#E5EDF0',
          300: '#D5E2E7',
          400: '#B6CDD5',
          500: '#97B7C3',
          600: '#88A5B0',
          700: '#5B6E75',
          800: '#445258',
          900: '#2D373B',
        },
        'galliano': {
          100: '#FDF8E8',
          200: '#FAEDC6',
          300: '#F6E1A4',
          400: '#F0CB5F',
          500: '#E9B51B',
          600: '#D2A318',
          700: '#8C6D10',
          800: '#69510C',
          900: '#463608',
        },
        'blackcurrant': {
          100: '#EBEAEB',
          200: '#CCCBCE',
          300: '#ADABB1',
          400: '#706c76',
          500: '#3e3947',
          600: '#332d3b',
          700: '#2e2935',
          800: '#1F1B23',
          900: '#0F0E12',
        },
      },
    },
  },
  variants: {},
  plugins: [
    plugin(function({ addUtilities, addComponents, e, prefix, config }) {
      addUtilities({
        // VIEW HEIGHT
        '.h-v10': {
          height: '10vh',
        },
        '.h-v20': {
          height: '20vh',
        },
        '.h-v30': {
          height: '30vh',
        },
        '.h-v40': {
          height: '40vh',
        },
        '.h-v50': {
          height: '50vh',
        },
        '.h-v60': {
          height: '60vh',
        },
        '.h-v70': {
          height: '70vh',
        },
        '.h-v80': {
          height: '80vh',
        },
        '.h-v90': {
          height: '90vh',
        },
        '.h-v100': {
          height: '100vh',
        },
      }, {
        variants: ['responsive', 'hover', 'focus']
      });
    }),
  ],
}
