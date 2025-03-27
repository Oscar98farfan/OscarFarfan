const hamburgerMenu = document.querySelector('.hamburger-menu');
const sideMenu = document.querySelector('.side-menu');
const overlay = document.querySelector('.overlay');

hamburgerMenu.addEventListener('click', () => {
    sideMenu.classList.toggle('open');
    overlay.classList.toggle('active');
});

overlay.addEventListener('click', () => {
    sideMenu.classList.remove('open');
    overlay.classList.remove('active');
})


function sendToWhatsApp(event) {
    event.preventDefault();
    
    // Validación básica
    const name = document.getElementById('name').value.trim();
    const email = document.getElementById('email').value.trim();
    const subject = document.getElementById('subject').value.trim();
    const message = document.getElementById('message').value.trim();
    
    if (!name || !email || !message) {
        alert('Por favor, completa todos los campos requeridos.');
        return;
    }
    
    // Validar formato de email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
        alert('Por favor, introduce un email válido.');
        return;
    }
    
    // Formatear el mensaje para WhatsApp
    const whatsappMessage = 
        `*Nuevo mensaje desde tu portafolio*%0A%0A` +
        `*Nombre:* ${name}%0A` +
        `*Email:* ${email}%0A` +
        `*Asunto:* ${subject}%0A%0A` +
        `*Mensaje:*%0A${message}`;
    
    // Tu número de WhatsApp (con código de país)
    const phoneNumber = "573114888796"; // Reemplaza con tu número
    
    // Crear el enlace de WhatsApp
    const whatsappLink = `https://wa.me/${phoneNumber}?text=${whatsappMessage}`;
    
    // Mostrar mensaje de éxito
    const submitBtn = document.querySelector('.submit-btn');
    submitBtn.innerHTML = '✓ Abriendo WhatsApp...';
    submitBtn.style.backgroundColor = 'var(--azul-oscuro)';
    
    // Pequeña pausa para mostrar el mensaje de éxito
    setTimeout(() => {
        // Abrir WhatsApp en una nueva pestaña
        window.open(whatsappLink, '_blank');
        
        // Resetear el formulario después de un momento
        setTimeout(() => {
            document.getElementById('contactForm').reset();
            submitBtn.innerHTML = 'Enviar a WhatsApp';
            submitBtn.style.backgroundColor = '';
        }, 1000);
    }, 500);
}