import tippy from 'tippy.js';
import 'tippy.js/dist/tippy.css';

tippy('[data-tooltip-content]', {
  allowHTML: true,
  content(reference) {
    const id = reference.getAttribute('data-tooltip-content');
    const template = document.getElementById(id);
    return template.innerHTML;
  }
});
