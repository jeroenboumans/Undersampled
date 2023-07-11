import Alpine from 'alpinejs'
import persist from '@alpinejs/persist'

// export default {
//     window.Alpine = Alpine
//     Alpine.start()
// }

const name = "Jesse";
const age = 40;
function init(message){
    window.Alpine = Alpine
    Alpine.plugin(persist)
    Alpine.start()
    console.log(message)
}
export {name, age, init};

init();

// // On page load or when changing themes, best to add inline in `head` to avoid FOUC
// if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
//     document.documentElement.classList.add('dark')
// } else {
//     document.documentElement.classList.remove('dark')
// }
//
// // Whenever the user explicitly chooses light mode
// localStorage.theme = 'light'
//
// // Whenever the user explicitly chooses dark mode
// localStorage.theme = 'dark'
//
// // Whenever the user explicitly chooses to respect the OS preference
// localStorage.removeItem('theme')