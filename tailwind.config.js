/** @type {import('tailwindcss').Config} */
export const content = ['./app/**/*.{gjs,gts,hbs,html,js,ts}'];
export const theme = {
  extend: {},
};
export const plugins = [require('@tailwindcss/typography'), require('daisyui')];
export const daisyui = {
  themes: [
    'light',
    'dark',
    'acid',
    'aqua',
    'autumn',
    'black',
    'bumblebee',
    'business',
    'cmyk',
    'coffee',
    'corporate',
    'cupcake',
    'cyberpunk',
    'dim',
    'dracula',
    'emerald',
    'fantasy',
    'forest',
    'garden',
    'halloween',
    'lemonade',
    'lofi',
    'luxury',
    'night',
    'nord',
    'pastel',
    'retro',
    'sunset',
    'synthwave',
    'valentine',
    'winter',
    'wireframe',
  ],
};
