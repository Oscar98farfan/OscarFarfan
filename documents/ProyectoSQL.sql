-- Creación de Tablas

use tienda;
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    categoria VARCHAR(50),
    precio DECIMAL(10,2),
    stock INT
);
CREATE TABLE categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(50),
    descripcion TEXT
);
CREATE TABLE proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    contacto VARCHAR(100),
    telefono VARCHAR(20),
    ciudad VARCHAR(50)
);
CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    cargo VARCHAR(50),
    correo VARCHAR(100),
    fecha_ingreso DATE
);
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    id_empleado INT REFERENCES empleados(id_empleado),
    fecha DATE,
    total DECIMAL(10,2)
);
CREATE TABLE detalle_venta (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INT REFERENCES ventas(id_venta),
    id_producto INT REFERENCES productos(id_producto),
    cantidad INT,
    precio_unitario DECIMAL(10,2)
);
CREATE TABLE devoluciones (
    id_devolucion SERIAL PRIMARY KEY,
    id_venta INT REFERENCES ventas(id_venta),
    fecha DATE,
    motivo TEXT
);
CREATE TABLE pagos (
    id_pago SERIAL PRIMARY KEY,
    id_cliente INT REFERENCES clientes(id_cliente),
    fecha DATE,
    monto DECIMAL(10,2),
    metodo_pago VARCHAR(50)
);


-- Consultas Realizadas
-- Total Ventas por año y mes
SELECT 
EXTRACT(YEAR FROM fecha) AS año, EXTRACT(MONTH FROM fecha) AS mes, SUM(total) AS Total_Ventas
FROM ventas
GROUP BY año,mes
ORDER BY año,mes;

-- Top 10 prodcutos mas Vendidos
SELECT p.nombre, SUM(dv.cantidad) AS Cantidad_Vendida FROM productos p
JOIN detalle_venta dv ON dv.id_producto = p.id_producto
GROUP BY p.id_producto, p.nombre
ORDER BY SUM(dv.cantidad) Desc
LIMIT 10;

-- Categorias con mayor ingreso
SELECT p.categoria, SUM(dv.cantidad * dv.precio_unitario) AS Ingreso_Total, COUNT(p.categoria) FROM productos p
JOIN detalle_venta dv ON dv.id_producto = p.id_producto
GROUP BY p.categoria
ORDER BY ingreso_total Desc;

-- Clientes con mas ventas 
SELECT cl.nombre As "Nombre Cliente" , SUM(v.total) As ventas_Totales, COUNT(v.id_cliente) As Cantidad_ventas 
FROM clientes cl
JOIN ventas v ON v.id_cliente = cl.id_cliente
GROUP BY cl.id_cliente
ORDER BY   Cantidad_ventas Desc
LIMIT 10;

-- Total mensual de ingresos (Ventas - Devoluciones)
SELECT 
    EXTRACT(YEAR FROM v.fecha) AS año,
    EXTRACT(MONTH FROM v.fecha) AS mes,
    SUM(v.total) - COALESCE(SUM(dv.total), 0) AS ingresos_netos
FROM ventas v
LEFT JOIN devoluciones d ON v.id_venta = d.id_venta
LEFT JOIN ventas dv ON d.id_venta = dv.id_venta
GROUP BY año, mes
ORDER BY año, mes;

-- Empleados con mas ventas
SELECT e.nombre, SUM(v.total) FROM empleados e
JOIN ventas v ON v.id_empleado = e.id_empleado
GROUP BY v.id_empleado
ORDER BY v.total Desc;

-- Ventas por mes y por empleado
SELECT EXTRACT(YEAR FROM v.fecha) As Año, EXTRACT(MONTH FROM v.fecha) As Mes, e.nombre, SUM(v.total) 
FROM empleados e
JOIN ventas v ON e.id_empleado = v.id_empleado
GROUP BY Año, Mes, e.id_empleado, e.nombre
ORDER BY Año, Mes, v.total Desc;



-- Inserción de datos
INSERT INTO categorias (nombre, descripcion) VALUES ('Electrónica', 'Descripción de Electrónica');
INSERT INTO categorias (nombre, descripcion) VALUES ('Ropa', 'Descripción de Ropa');
INSERT INTO categorias (nombre, descripcion) VALUES ('Hogar', 'Descripción de Hogar');
INSERT INTO categorias (nombre, descripcion) VALUES ('Juguetes', 'Descripción de Juguetes');
INSERT INTO categorias (nombre, descripcion) VALUES ('Deportes', 'Descripción de Deportes');
INSERT INTO categorias (nombre, descripcion) VALUES ('Papelería', 'Descripción de Papelería');
INSERT INTO categorias (nombre, descripcion) VALUES ('Mascotas', 'Descripción de Mascotas');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_1', 'cliente1@correo.com', '3005832836', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_2', 'cliente2@correo.com', '3008284685', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_3', 'cliente3@correo.com', '3003811622', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_4', 'cliente4@correo.com', '3004423845', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_5', 'cliente5@correo.com', '3009437992', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_6', 'cliente6@correo.com', '3003273434', 'Cartagena');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_7', 'cliente7@correo.com', '3003248800', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_8', 'cliente8@correo.com', '3006302559', 'Cartagena');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_9', 'cliente9@correo.com', '3005796440', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_10', 'cliente10@correo.com', '3003918358', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_11', 'cliente11@correo.com', '3003916002', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_12', 'cliente12@correo.com', '3003943939', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_13', 'cliente13@correo.com', '3002721109', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_14', 'cliente14@correo.com', '3008585068', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_15', 'cliente15@correo.com', '3001616014', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_16', 'cliente16@correo.com', '3003604930', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_17', 'cliente17@correo.com', '3008468769', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_18', 'cliente18@correo.com', '3005999050', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_19', 'cliente19@correo.com', '3001758307', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_20', 'cliente20@correo.com', '3005637180', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_21', 'cliente21@correo.com', '3009286572', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_22', 'cliente22@correo.com', '3003370945', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_23', 'cliente23@correo.com', '3008465575', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_24', 'cliente24@correo.com', '3002010950', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_25', 'cliente25@correo.com', '3001318237', 'Cartagena');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_26', 'cliente26@correo.com', '3007372396', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_27', 'cliente27@correo.com', '3008033238', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_28', 'cliente28@correo.com', '3005196761', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_29', 'cliente29@correo.com', '3002259976', 'Cartagena');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_30', 'cliente30@correo.com', '3007835425', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_31', 'cliente31@correo.com', '3006709085', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_32', 'cliente32@correo.com', '3009618529', 'Cartagena');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_33', 'cliente33@correo.com', '3005209659', 'Cartagena');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_34', 'cliente34@correo.com', '3002759028', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_35', 'cliente35@correo.com', '3001779576', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_36', 'cliente36@correo.com', '3006197412', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_37', 'cliente37@correo.com', '3001225098', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_38', 'cliente38@correo.com', '3001415277', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_39', 'cliente39@correo.com', '3005766055', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_40', 'cliente40@correo.com', '3005348337', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_41', 'cliente41@correo.com', '3003526052', 'Cartagena');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_42', 'cliente42@correo.com', '3008589354', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_43', 'cliente43@correo.com', '3005069080', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_44', 'cliente44@correo.com', '3007920932', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_45', 'cliente45@correo.com', '3006053885', 'Bogotá');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_46', 'cliente46@correo.com', '3008292977', 'Medellín');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_47', 'cliente47@correo.com', '3003432761', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_48', 'cliente48@correo.com', '3005104482', 'Cali');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_49', 'cliente49@correo.com', '3002845212', 'Barranquilla');
INSERT INTO clientes (nombre, correo, telefono, ciudad) VALUES ('Cliente_50', 'cliente50@correo.com', '3002112223', 'Medellín');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_1', 'contacto1@correo.com', '3103665077', 'Cali');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_2', 'contacto2@correo.com', '3102254389', 'Barranquilla');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_3', 'contacto3@correo.com', '3101254613', 'Barranquilla');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_4', 'contacto4@correo.com', '3101055904', 'Cali');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_5', 'contacto5@correo.com', '3104237175', 'Barranquilla');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_6', 'contacto6@correo.com', '3107360262', 'Cartagena');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_7', 'contacto7@correo.com', '3101028687', 'Cali');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_8', 'contacto8@correo.com', '3104140062', 'Barranquilla');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_9', 'contacto9@correo.com', '3109506609', 'Medellín');
INSERT INTO proveedores (nombre, contacto, telefono, ciudad) VALUES ('Proveedor_10', 'contacto10@correo.com', '3102070602', 'Cali');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_1', 'Vendedor', 'emp1@empresa.com', '2022-02-01');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_2', 'Vendedor', 'emp2@empresa.com', '2020-09-20');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_3', 'Cajero', 'emp3@empresa.com', '2024-03-01');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_4', 'Bodeguero', 'emp4@empresa.com', '2021-06-05');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_5', 'Administrador', 'emp5@empresa.com', '2023-07-09');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_6', 'Bodeguero', 'emp6@empresa.com', '2021-12-27');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_7', 'Cajero', 'emp7@empresa.com', '2020-06-12');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_8', 'Bodeguero', 'emp8@empresa.com', '2021-01-20');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_9', 'Bodeguero', 'emp9@empresa.com', '2021-03-30');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_10', 'Cajero', 'emp10@empresa.com', '2022-08-12');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_11', 'Cajero', 'emp11@empresa.com', '2024-09-16');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_12', 'Cajero', 'emp12@empresa.com', '2024-08-25');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_13', 'Cajero', 'emp13@empresa.com', '2020-05-11');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_14', 'Vendedor', 'emp14@empresa.com', '2022-07-23');
INSERT INTO empleados (nombre, cargo, correo, fecha_ingreso) VALUES ('Empleado_15', 'Cajero', 'emp15@empresa.com', '2020-11-06');
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_1', 'Papelería', 395.11, 21);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_2', 'Papelería', 199.78, 31);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_3', 'Deportes', 365.54, 22);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_4', 'Papelería', 48.36, 29);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_5', 'Ropa', 51.98, 11);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_6', 'Papelería', 233.01, 29);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_7', 'Ropa', 341.27, 31);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_8', 'Papelería', 199.71, 62);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_9', 'Hogar', 326.8, 76);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_10', 'Deportes', 376.68, 34);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_11', 'Electrónica', 126.23, 69);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_12', 'Mascotas', 279.51, 99);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_13', 'Juguetes', 325.56, 31);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_14', 'Ropa', 353.49, 72);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_15', 'Ropa', 23.14, 57);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_16', 'Deportes', 450.91, 44);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_17', 'Juguetes', 403.43, 32);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_18', 'Papelería', 289.65, 72);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_19', 'Electrónica', 176.32, 25);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_20', 'Ropa', 202.4, 42);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_21', 'Ropa', 280.06, 93);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_22', 'Juguetes', 398.04, 30);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_23', 'Juguetes', 458.55, 85);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_24', 'Electrónica', 264.89, 57);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_25', 'Ropa', 361.61, 61);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_26', 'Hogar', 34.12, 26);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_27', 'Electrónica', 173.21, 50);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_28', 'Juguetes', 50.04, 50);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_29', 'Electrónica', 331.72, 28);
INSERT INTO productos (nombre, categoria, precio, stock) VALUES ('Producto_30', 'Mascotas', 454.62, 87);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (25, 11, '2023-11-21', 3253.46);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 11, 2, 391.27);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 25, 3, 407.14);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 10, 1, 138.56);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 29, 1, 426.01);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (1, 27, 3, 228.31);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (25, 6, '2024-10-10', 1000.01);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (2, 10, 2, 412.72);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (2, 11, 3, 58.19);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (29, 14, '2023-08-30', 1554.54);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 7, 2, 53.75);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 8, 2, 399.67);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 12, 2, 141.06);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 1, 3, 116.41);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (3, 19, 1, 16.35);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (13, 7, '2023-05-05', 362.51);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (4, 15, 1, 362.51);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (17, 7, '2023-11-06', 2388.59);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 20, 3, 395.77);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 29, 2, 365.41);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (5, 22, 1, 470.46);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (25, 2, '2023-08-23', 3366.35);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 8, 2, 46.11);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 21, 2, 147.48);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 27, 3, 454.64);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 17, 2, 198.85);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (6, 11, 3, 405.85);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (3, 1, '2024-11-21', 1242.55);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (7, 12, 1, 427.27);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (7, 27, 2, 57.44);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (7, 2, 1, 424.88);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (7, 21, 3, 91.84);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (36, 4, '2024-02-13', 2864.4);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (8, 23, 3, 418.13);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (8, 20, 2, 408.27);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (8, 3, 3, 264.49);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (24, 12, '2023-04-10', 2325.18);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (9, 23, 2, 446.74);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (9, 25, 3, 169.06);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (9, 25, 2, 462.26);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (7, 5, '2023-04-05', 3404.9);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 18, 3, 415.84);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 2, 2, 367.62);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 7, 3, 421.14);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (10, 7, 1, 158.72);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (6, 10, '2023-09-30', 2270.23);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (11, 15, 1, 453.89);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (11, 10, 1, 296.03);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (11, 19, 2, 410.34);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (11, 6, 3, 82.56);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (11, 10, 1, 451.95);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (26, 4, '2023-12-16', 1645.8);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 28, 3, 177.64);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 2, 3, 18.49);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (12, 20, 3, 352.47);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (42, 14, '2023-10-08', 54.04);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (13, 1, 1, 54.04);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (29, 4, '2024-05-13', 2161.97);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (14, 18, 1, 460.36);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (14, 13, 3, 210.71);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (14, 27, 1, 88.37);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (14, 2, 3, 50.39);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (14, 26, 2, 414.97);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (37, 1, '2024-06-25', 1533.11);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (15, 2, 2, 148.31);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (15, 30, 1, 391.31);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (15, 7, 1, 89.87);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (15, 12, 3, 251.77);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (19, 10, '2024-11-20', 1124.8);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (16, 1, 1, 33.1);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (16, 14, 3, 363.9);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (9, 7, '2024-02-04', 2740.21);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 16, 2, 424.14);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 14, 1, 390.01);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 20, 3, 445.82);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 21, 1, 120.51);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (17, 23, 3, 14.65);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (23, 10, '2023-04-21', 1473.34);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 30, 3, 164.13);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 2, 1, 203.72);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 1, 1, 202.87);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 11, 2, 122.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (18, 22, 3, 110.02);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (44, 15, '2023-07-25', 2141.85);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (19, 8, 2, 364.56);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (19, 4, 1, 441.69);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (19, 15, 2, 485.52);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (37, 2, '2023-09-17', 1648.86);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 21, 1, 198.38);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 8, 1, 171.1);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 24, 2, 341.58);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (20, 8, 3, 198.74);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (30, 3, '2023-08-27', 2217.13);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 23, 2, 54.98);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 12, 2, 59.54);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 21, 2, 381.49);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (21, 25, 3, 408.37);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (31, 15, '2024-12-13', 1964.71);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (22, 13, 2, 281.18);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (22, 19, 3, 467.45);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (35, 13, '2023-07-05', 2204.87);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (23, 23, 2, 282.01);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (23, 9, 2, 490.04);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (23, 29, 2, 164.74);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (23, 13, 3, 33.67);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (23, 10, 2, 115.14);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (48, 12, '2023-11-29', 1611.85);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (24, 3, 3, 374.19);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (24, 28, 2, 223.5);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (24, 18, 2, 21.14);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (44, 15, '2024-05-04', 669.09);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (25, 14, 3, 223.03);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (23, 14, '2024-05-17', 736.31);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (26, 12, 3, 155.13);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (26, 6, 2, 125.99);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (26, 25, 1, 18.94);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (12, 11, '2024-01-20', 2185.83);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 12, 1, 491.77);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 27, 1, 423.95);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 15, 3, 214.75);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (27, 17, 2, 312.93);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (46, 13, '2024-12-11', 1421.91);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (28, 5, 1, 13.33);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (28, 17, 2, 313.11);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (28, 1, 2, 391.18);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (31, 8, '2023-12-12', 2172.41);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (29, 6, 2, 212.09);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (29, 5, 2, 183.2);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (29, 30, 3, 316.45);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (29, 22, 1, 432.48);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (50, 2, '2024-01-04', 949.51);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (30, 4, 1, 83.72);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (30, 13, 1, 233.69);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (30, 4, 3, 210.7);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (9, 10, '2024-12-05', 2031.03);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (31, 5, 3, 96.88);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (31, 30, 3, 443.17);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (31, 27, 1, 410.88);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (48, 11, '2024-11-01', 2827.01);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 24, 1, 258.24);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 7, 2, 484.5);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 17, 3, 171.58);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 2, 2, 60.46);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (32, 11, 3, 321.37);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (28, 14, '2024-07-07', 747.23);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (33, 16, 3, 12.64);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (33, 27, 2, 67.53);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (33, 22, 2, 228.19);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (33, 9, 1, 117.87);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (11, 9, '2023-06-18', 2516.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (34, 20, 2, 382.17);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (34, 17, 1, 167.35);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (34, 5, 2, 300.41);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (34, 19, 3, 65.35);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (34, 3, 3, 262.53);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (7, 11, '2024-12-26', 3295.23);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 18, 1, 426.23);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 7, 3, 341.04);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 9, 3, 361.85);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 17, 1, 317.21);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (35, 27, 1, 443.12);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (3, 7, '2023-01-16', 510.36);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (36, 28, 3, 170.12);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (19, 12, '2024-11-01', 3076.83);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 16, 3, 469.39);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 16, 1, 76.17);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 13, 1, 247.48);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 30, 1, 360.8);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (37, 22, 3, 328.07);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (41, 8, '2024-10-24', 2326.76);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 10, 2, 417.01);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 15, 2, 293.66);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 20, 2, 63.39);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 10, 2, 221.4);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (38, 21, 1, 335.84);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (10, 11, '2023-02-08', 416.4);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (39, 12, 3, 138.8);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (2, 10, '2023-06-18', 489.26);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (40, 28, 2, 244.63);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (1, 7, '2024-01-21', 224.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (41, 2, 1, 224.15);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (29, 4, '2023-11-22', 1838.77);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (42, 8, 3, 446.66);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (42, 10, 1, 498.79);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (46, 15, '2024-07-09', 314.58);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (43, 18, 1, 314.58);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (34, 5, '2023-04-01', 2875.67);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (44, 3, 2, 347.96);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (44, 6, 2, 228.65);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (44, 10, 3, 415.29);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (44, 16, 2, 97.8);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (44, 22, 2, 140.49);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (38, 12, '2024-03-20', 2521.2);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 17, 3, 392.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 8, 3, 216.39);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 3, 3, 129.98);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 11, 3, 91.65);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (45, 7, 1, 30.69);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (19, 5, '2024-03-29', 1729.33);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (46, 16, 3, 366.65);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (46, 19, 2, 314.69);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (6, 3, '2023-03-04', 170.55);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (47, 29, 3, 56.85);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (35, 13, '2024-11-22', 1546.52);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (48, 21, 2, 131.74);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (48, 29, 3, 427.68);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (48, 5, '2023-07-19', 118.06);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (49, 7, 1, 118.06);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (30, 7, '2024-12-01', 4038.86);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 4, 3, 319.69);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 13, 3, 200.48);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 10, 2, 446.21);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 21, 1, 129.58);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (50, 4, 3, 485.45);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (6, 12, '2024-11-18', 1377.39);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (51, 14, 3, 459.13);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (46, 15, '2023-08-19', 1571.97);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (52, 13, 3, 312.84);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (52, 9, 3, 211.15);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (29, 13, '2024-02-22', 788.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (53, 10, 2, 326.65);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (53, 6, 1, 134.85);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (31, 11, '2024-03-14', 3132.85);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (54, 8, 1, 268.63);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (54, 24, 3, 363.89);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (54, 10, 2, 426.36);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (54, 12, 1, 375.24);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (54, 26, 3, 181.53);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (9, 7, '2024-02-17', 1624.28);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (55, 28, 2, 428.0);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (55, 8, 2, 384.14);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (11, 3, '2023-10-23', 1811.09);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (56, 11, 1, 190.0);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (56, 14, 2, 183.53);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (56, 30, 1, 400.87);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (56, 13, 2, 191.98);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (56, 26, 3, 156.4);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (45, 11, '2023-09-16', 121.25);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (57, 24, 1, 121.25);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (31, 10, '2024-08-26', 1990.87);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (58, 30, 2, 95.06);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (58, 9, 1, 311.28);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (58, 24, 3, 385.55);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (58, 24, 1, 332.82);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (44, 14, '2023-02-04', 2503.09);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (59, 3, 1, 88.94);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (59, 17, 3, 277.22);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (59, 8, 1, 494.63);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (59, 11, 3, 362.62);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (15, 7, '2023-10-12', 1715.72);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (60, 22, 2, 223.57);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (60, 8, 1, 96.44);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (60, 20, 1, 405.26);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (60, 25, 2, 270.4);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (60, 27, 1, 226.08);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (17, 8, '2023-11-22', 4137.66);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (61, 2, 3, 377.03);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (61, 12, 3, 463.47);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (61, 10, 3, 402.16);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (61, 8, 2, 204.84);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (37, 15, '2023-12-07', 1317.36);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (62, 8, 3, 423.09);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (62, 3, 1, 48.09);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (43, 8, '2023-11-23', 2124.06);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (63, 2, 3, 234.27);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (63, 20, 3, 473.75);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (42, 4, '2023-11-11', 1587.05);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (64, 6, 1, 332.87);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (64, 10, 1, 159.8);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (64, 21, 2, 379.06);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (64, 16, 1, 336.26);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (41, 15, '2023-04-26', 991.11);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (65, 30, 1, 48.07);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (65, 19, 3, 269.5);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (65, 30, 1, 70.96);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (65, 5, 1, 25.95);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (65, 9, 1, 37.63);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (33, 8, '2023-03-01', 1212.96);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (66, 29, 3, 404.32);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (37, 2, '2024-02-27', 3653.75);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (67, 5, 3, 262.38);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (67, 8, 3, 324.3);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (67, 5, 3, 110.05);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (67, 9, 1, 369.44);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (67, 23, 3, 398.04);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (31, 4, '2023-04-06', 2059.02);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (68, 21, 2, 250.28);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (68, 9, 3, 218.37);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (68, 16, 1, 79.13);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (68, 4, 2, 299.69);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (68, 15, 2, 112.42);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (44, 13, '2024-04-12', 1279.83);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (69, 2, 1, 445.24);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (69, 17, 1, 399.79);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (69, 9, 1, 434.8);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (20, 8, '2023-06-26', 1596.41);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (70, 13, 2, 289.79);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (70, 25, 3, 215.38);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (70, 11, 2, 30.97);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (70, 25, 1, 308.75);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (40, 1, '2023-08-03', 1983.58);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (71, 1, 1, 213.47);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (71, 4, 2, 210.62);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (71, 8, 3, 315.86);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (71, 6, 1, 401.29);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (26, 3, '2024-01-02', 1615.24);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (72, 23, 2, 130.55);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (72, 21, 1, 247.91);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (72, 20, 1, 365.09);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (72, 8, 2, 370.57);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (50, 15, '2023-02-27', 439.37);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (73, 24, 1, 439.37);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (39, 11, '2024-09-07', 2602.09);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (74, 22, 3, 21.16);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (74, 2, 3, 315.25);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (74, 1, 3, 471.44);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (74, 10, 2, 89.27);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (29, 9, '2024-12-07', 684.46);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (75, 8, 2, 144.03);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (75, 18, 1, 396.4);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (4, 13, '2024-09-11', 2762.3);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (76, 2, 1, 84.66);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (76, 8, 3, 432.26);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (76, 12, 3, 136.38);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (76, 2, 2, 485.86);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (5, 3, '2023-02-16', 909.3);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (77, 24, 3, 303.1);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (20, 5, '2023-03-03', 40.48);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (78, 17, 2, 20.24);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (11, 1, '2023-08-15', 3072.91);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (79, 9, 3, 308.57);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (79, 9, 3, 254.68);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (79, 6, 3, 74.32);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (79, 10, 2, 389.81);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (79, 21, 1, 380.58);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (39, 14, '2024-01-19', 1194.68);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (80, 17, 3, 369.22);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (80, 18, 1, 87.02);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (26, 3, '2023-09-22', 1522.2);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (81, 6, 3, 279.61);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (81, 4, 3, 227.79);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (6, 6, '2023-11-14', 2169.99);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (82, 9, 1, 79.47);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (82, 8, 1, 340.03);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (82, 21, 3, 272.25);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (82, 28, 3, 16.76);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (82, 12, 2, 441.73);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (6, 11, '2024-10-18', 1291.75);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (83, 10, 2, 134.48);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (83, 28, 1, 412.62);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (83, 10, 3, 203.39);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (23, 14, '2024-05-17', 214.56);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (84, 11, 3, 71.52);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (50, 7, '2024-05-10', 1830.14);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (85, 25, 1, 57.83);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (85, 11, 3, 238.37);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (85, 21, 2, 465.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (85, 3, 3, 42.3);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (25, 6, '2023-08-22', 325.55);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (86, 5, 1, 325.55);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (37, 15, '2024-01-02', 146.75);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (87, 18, 1, 146.75);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (40, 1, '2023-06-22', 2210.0);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (88, 21, 3, 408.17);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (88, 2, 1, 34.28);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (88, 12, 3, 317.07);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (17, 9, '2024-04-30', 3301.18);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (89, 13, 3, 469.16);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (89, 29, 1, 467.13);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (89, 6, 1, 446.74);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (89, 28, 1, 437.93);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (89, 5, 2, 270.95);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (40, 4, '2024-06-16', 3251.01);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (90, 19, 3, 394.24);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (90, 27, 3, 103.1);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (90, 20, 3, 375.16);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (90, 21, 3, 160.81);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (90, 1, 3, 50.36);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (34, 1, '2024-04-05', 1550.92);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (91, 29, 2, 114.78);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (91, 19, 1, 426.84);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (91, 27, 1, 169.38);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (91, 15, 2, 306.26);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (91, 19, 1, 112.62);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (12, 6, '2024-02-03', 2612.6);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (92, 4, 1, 97.71);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (92, 30, 3, 254.57);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (92, 15, 3, 416.84);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (92, 14, 2, 250.33);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (45, 5, '2024-03-01', 934.43);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (93, 11, 2, 304.59);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (93, 28, 2, 26.55);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (93, 7, 1, 174.77);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (93, 14, 1, 97.38);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (11, 10, '2023-11-01', 3760.31);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (94, 5, 3, 217.55);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (94, 28, 3, 420.67);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (94, 18, 2, 425.68);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (94, 29, 2, 270.21);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (94, 27, 3, 151.29);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (42, 7, '2023-07-26', 1954.28);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (95, 10, 2, 462.12);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (95, 14, 1, 360.2);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (95, 7, 2, 334.92);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (42, 12, '2024-06-24', 2081.58);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (96, 24, 2, 127.66);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (96, 20, 2, 126.05);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (96, 28, 1, 195.24);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (96, 25, 2, 407.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (96, 3, 2, 282.31);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (17, 5, '2023-10-04', 1125.8);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (97, 19, 2, 374.44);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (97, 17, 1, 376.92);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (49, 3, '2023-01-24', 1458.59);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (98, 7, 1, 61.15);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (98, 13, 3, 163.64);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (98, 20, 1, 306.68);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (98, 9, 1, 389.45);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (98, 11, 3, 70.13);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (1, 1, '2023-10-01', 1208.07);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (99, 28, 3, 402.69);
INSERT INTO ventas (id_cliente, id_empleado, fecha, total) VALUES (48, 12, '2024-04-02', 1942.02);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (100, 4, 3, 444.3);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (100, 26, 2, 81.21);
INSERT INTO detalle_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES (100, 3, 2, 223.35);
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (70, '2024-05-30', 'Entrega incorrecta');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (97, '2023-01-17', 'Entrega incorrecta');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (30, '2023-07-04', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (23, '2024-10-10', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (77, '2024-05-11', 'Producto defectuoso');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (28, '2024-12-16', 'Producto defectuoso');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (87, '2024-10-10', 'Entrega incorrecta');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (9, '2023-12-06', 'Producto defectuoso');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (40, '2024-01-09', 'Producto defectuoso');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (31, '2023-05-01', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (75, '2023-01-17', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (32, '2023-03-19', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (97, '2024-03-28', 'Producto defectuoso');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (27, '2023-10-24', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (51, '2024-12-20', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (84, '2023-12-10', 'Producto defectuoso');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (21, '2024-06-18', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (25, '2023-06-11', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (29, '2024-06-21', 'Cambio de opinión');
INSERT INTO devoluciones (id_venta, fecha, motivo) VALUES (91, '2023-04-16', 'Cambio de opinión');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (35, '2023-05-30', 545.18, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (34, '2024-03-13', 480.54, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (27, '2023-04-12', 183.37, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (6, '2023-02-04', 419.65, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (30, '2023-11-27', 73.3, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (20, '2024-08-01', 104.02, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (37, '2024-07-03', 721.87, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (42, '2023-05-27', 503.72, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (18, '2023-08-09', 249.19, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (5, '2024-01-21', 532.72, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (21, '2024-11-17', 467.4, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (11, '2023-04-15', 263.15, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (37, '2023-11-17', 90.5, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (18, '2024-05-11', 657.3, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (12, '2023-01-05', 406.64, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (48, '2023-12-25', 380.91, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (37, '2023-09-17', 488.39, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (39, '2023-04-23', 330.96, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (34, '2023-02-22', 448.62, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (44, '2023-12-20', 759.19, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (37, '2024-12-26', 249.06, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (29, '2024-07-14', 449.85, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (7, '2023-05-07', 559.13, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (22, '2023-06-21', 787.68, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (47, '2024-05-29', 226.51, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (22, '2023-12-16', 210.19, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (44, '2024-01-12', 310.37, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (28, '2023-12-19', 516.35, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (23, '2024-09-23', 150.42, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (11, '2023-12-10', 477.6, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (47, '2024-02-12', 478.26, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (42, '2023-03-27', 138.5, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (38, '2023-02-22', 480.17, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (9, '2023-02-09', 645.06, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (48, '2023-09-11', 573.57, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (18, '2024-08-05', 273.28, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (35, '2024-04-27', 387.53, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (49, '2024-09-18', 353.81, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (32, '2024-03-05', 60.33, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (1, '2023-08-06', 659.23, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (24, '2024-07-11', 777.13, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (12, '2023-05-27', 349.04, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (45, '2024-12-10', 310.1, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (35, '2023-01-04', 715.74, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (36, '2023-04-16', 618.79, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (20, '2024-04-21', 76.66, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (41, '2024-06-07', 240.73, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (6, '2024-11-09', 100.48, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (38, '2023-01-20', 224.95, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (18, '2023-04-02', 552.61, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (35, '2023-12-09', 699.53, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (5, '2023-02-25', 756.52, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (38, '2023-11-28', 474.22, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (16, '2023-12-30', 481.98, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (37, '2024-01-20', 351.72, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (50, '2023-03-27', 422.13, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (41, '2024-09-24', 725.87, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (14, '2023-05-03', 355.92, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (43, '2023-04-08', 459.99, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (7, '2023-10-30', 266.94, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (16, '2024-02-18', 749.12, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (3, '2023-04-08', 576.19, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (39, '2023-05-08', 794.03, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (1, '2024-04-13', 114.12, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (19, '2024-07-24', 784.62, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (50, '2024-04-15', 140.31, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (13, '2024-09-21', 287.51, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (47, '2023-01-25', 138.44, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (8, '2024-03-20', 577.64, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (34, '2023-01-25', 457.82, 'Tarjeta de crédito');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (26, '2025-01-01', 782.88, 'Efectivo');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (38, '2024-05-02', 699.6, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (27, '2024-08-20', 171.78, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (37, '2023-11-03', 354.75, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (24, '2023-12-02', 265.44, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (9, '2023-10-22', 745.7, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (30, '2023-09-30', 781.31, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (43, '2023-09-15', 305.51, 'PSE');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (2, '2024-07-24', 160.71, 'Transferencia');
INSERT INTO pagos (id_cliente, fecha, monto, metodo_pago) VALUES (48, '2023-08-04', 172.79, 'PSE');


