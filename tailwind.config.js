/** @type {import('tailwindcss').Config} */
module.exports = {
  darkMode: 'class',
  plugins: [
      // require('@tailwindcss/forms')
      // require('@tailwindcss/aspect-ratio'),
  ],
  content: [
    '_site/**/*.html',
    '_includes/**/*.html',
    '_layouts/**/*.html',
    '*.markdown'
  ],
  theme: {
    fontFamily: {
      "noto-sans": ['Noto Sans', 'sans-serif'],
      "noto-serif": ['Noto Serif', 'serif'],
    },
    extend: {
      colors: {
        'red': '#ff1000', // blue: 5e00ff, red: ff4700
        'black': '#000',
        'white': '#FFFFFF',
        'gray': '#f5f5f5',
        'gray-darkest': '#171717',
        'gray-darked': '#2a2a2a',
        'gray-near-darkest': 'rgb(26,26,26)',
        'gray-dark': '#383838',
        'gray-darker': '#7a7a7a',
        'light': '#dcdcdc',
        'gray-dark-20%': 'rgba(56,56,56,0.2)',
        'gray-light': '#F5F5F5',
      },
    }
  }
}

