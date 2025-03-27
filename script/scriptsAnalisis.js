// Variables para el carrusel
let posicionActual = 0;
const imagenes = document.querySelectorAll('.carrusel-imagenes img');
const totalImagenes = imagenes.length;
const carruselImagenes = document.querySelector('.carrusel-imagenes');
const contenedorIndicadores = document.querySelector('.carrusel-indicadores');

// Inicializar el carrusel
function inicializarCarrusel() {
    if (totalImagenes > 0) {
        // Establecer el ancho del contenedor de imágenes
        carruselImagenes.style.width = `${totalImagenes * 100}%`;
        
        // Establecer el ancho de cada imagen
        imagenes.forEach(img => {
            img.style.width = `${100 / totalImagenes}%`;
        });
        
        // Crear indicadores
        crearIndicadores();
        
        // Mostrar la primera imagen
        mostrarImagen(0);
        
        // Iniciar rotación automática
        setInterval(() => {
            moverCarrusel(1);
        }, 5000);
    }
}

// Crear indicadores para el carrusel
function crearIndicadores() {
    if (contenedorIndicadores) {
        for (let i = 0; i < totalImagenes; i++) {
            const indicador = document.createElement('div');
            indicador.classList.add('indicador');
            if (i === 0) indicador.classList.add('activo');
            
            indicador.addEventListener('click', () => {
                mostrarImagen(i);
            });
            
            contenedorIndicadores.appendChild(indicador);
        }
    }
}

// Actualizar indicadores
function actualizarIndicadores(posicion) {
    const indicadores = document.querySelectorAll('.indicador');
    indicadores.forEach((indicador, index) => {
        if (index === posicion) {
            indicador.classList.add('activo');
        } else {
            indicador.classList.remove('activo');
        }
    });
}

// Función para mostrar una imagen específica
function mostrarImagen(posicion) {
    // Asegurarse de que la posición esté dentro de los límites
    if (posicion >= totalImagenes) {
        posicion = 0;
    } else if (posicion < 0) {
        posicion = totalImagenes - 1;
    }
    
    // Actualizar la posición actual
    posicionActual = posicion;
    
    // Mover el carrusel
    const desplazamiento = -posicionActual * (100 / totalImagenes);
    carruselImagenes.style.transform = `translateX(${desplazamiento}%)`;
    
    // Actualizar indicadores
    actualizarIndicadores(posicionActual);
}

// Función para mover el carrusel
function moverCarrusel(direccion) {
    mostrarImagen(posicionActual + direccion);
}

// Inicializar cuando el DOM esté cargado
document.addEventListener('DOMContentLoaded', inicializarCarrusel);