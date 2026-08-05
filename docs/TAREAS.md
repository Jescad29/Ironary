# Lista de tareas — Ironary

Checklist de avance del proyecto. Se actualiza conforme completamos cada paso.
Ver `docs/GUIA.md` para el detalle de arquitectura y decisiones de diseño.

## Fase 0 — Entorno

- [x] Crear entorno virtual (`venv`)
- [x] Instalar Flask
- [x] Generar `requirements.txt`

## Fase 1 — Backend mínimo

- [x] Ruta de ejemplo (`/`) devolviendo texto
- [x] Ruta de ejemplo (`/api/saludo`) devolviendo JSON

## Estructura y buenas prácticas

- [x] Repositorio en GitHub (público, licencia Apache 2.0)
- [x] `.gitignore` (venv, `__pycache__`, `.env`)
- [x] README.md
- [x] Reorganizar proyecto: carpeta `backend/`
- [x] Migrar a Application Factory + Blueprints
- [x] Adoptar Conventional Commits (`feat`, `fix`, `refactor`, `chore`, `docs`)
- [x] `docs/GUIA.md` — guía de arquitectura y puesta en marcha
- [x] Definir alcance del MVP y nombre del proyecto (Ironary)

## Fase 2 — Base de datos (SQL Server)

- [x] Diseñar modelo de datos (6 tablas)
- [x] Crear base de datos `Ironary` en SQL Server (`backend/database/001_create_database.sql`)
- [ ] Escribir script `CREATE TABLE` para las 6 tablas
- [ ] Ejecutar script en `LTIGSA25035\SQLEXPRESS`
- [ ] Instalar `pyodbc`
- [ ] Probar conexión Flask → SQL Server
- [ ] Guardar cadena de conexión en `.env` (no hardcodeada en el código)

## Fase 3 — API REST (CRUD)

- [ ] Endpoint: listar/crear/editar/borrar `Ejercicios`
- [ ] Endpoint: listar/crear/editar/borrar `Rutinas`
- [ ] Endpoint: asignar ejercicios a una rutina (`RutinaEjercicios`)
- [ ] Endpoint: asignar rutina a día de la semana (`AsignacionDias`)
- [ ] Endpoint: obtener "rutina de hoy" automáticamente
- [ ] Endpoint: crear/cerrar sesión de entrenamiento (`SesionesEntrenamiento`)
- [ ] Endpoint: registrar series (`SeriesRegistradas`)
- [ ] Endpoint: consulta de PRs por ejercicio (calculado)
- [ ] Endpoint: sugerencia basada en última sesión (calculado)
- [ ] Endpoint: datos para gráficas de progreso (calculado)

## Fase 4 — Frontend HTML/CSS/JS (mobile-first)

- [ ] Estructura inicial `frontend/`
- [ ] Vista: rutina del día
- [ ] Vista: registrar serie (peso/reps) durante el entrenamiento
- [ ] Vista: historial de sesiones
- [ ] Diseño responsive mobile-first

## Fase 5 — Migración a React

- [ ] Inicializar proyecto React (Vite)
- [ ] Migrar vista: rutina del día
- [ ] Migrar vista: registrar serie
- [ ] Migrar vista: historial
- [ ] Componente: gráficas de progreso
- [ ] Componente: notificación de nuevo PR

## Fase 6 — Pulido y despliegue

- [ ] Autenticación (si se decide agregar)
- [ ] Manejo de errores consistente en la API
- [ ] Despliegue del backend
- [ ] Despliegue del frontend
