// Navbar scroll shadow
const navbar = document.querySelector('.navbar');
window.addEventListener('scroll', () => {
  if (window.scrollY > 10) {
    navbar.classList.add('scrolled');
  } else {
    navbar.classList.remove('scrolled');
  }
});

// Mobile menu toggle
const menuToggle = document.querySelector('.menu-toggle');
const navLinks = document.querySelector('.navbar-links');

menuToggle.addEventListener('click', () => {
  const isOpen = navLinks.classList.toggle('open');
  menuToggle.setAttribute('aria-expanded', isOpen);
});

// Close mobile menu on link click
navLinks.querySelectorAll('a').forEach(link => {
  link.addEventListener('click', () => {
    navLinks.classList.remove('open');
    menuToggle.setAttribute('aria-expanded', 'false');
  });
});

// Active nav link highlighting on scroll
const sections = document.querySelectorAll('section[id]');
const navItems = document.querySelectorAll('.navbar-links a');

const activeObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const id = entry.target.getAttribute('id');
      navItems.forEach(item => {
        item.classList.toggle('active', item.getAttribute('href') === `#${id}`);
      });
    }
  });
}, {
  rootMargin: '-80px 0px -60% 0px',
  threshold: 0
});

sections.forEach(section => activeObserver.observe(section));

// Scroll-triggered fade-in animations
const fadeElements = document.querySelectorAll('.section-inner, .project-card, .writing-card');

fadeElements.forEach((el, i) => {
  el.classList.add('fade-in');
  // Stagger cards within a grid
  if (el.classList.contains('project-card') || el.classList.contains('writing-card')) {
    const siblings = Array.from(el.parentElement.children);
    const index = siblings.indexOf(el);
    el.style.transitionDelay = `${index * 0.1}s`;
  }
});

const fadeObserver = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('visible');
      fadeObserver.unobserve(entry.target);
    }
  });
}, {
  rootMargin: '0px 0px -60px 0px',
  threshold: 0.1
});

fadeElements.forEach(el => fadeObserver.observe(el));
