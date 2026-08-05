# Guía de Ironary — Cómo crear, entender y poner en marcha el proyecto

Este documento resume el proceso seguido para construir Ironary desde cero, y sirve
como referencia para levantar el entorno de nuevo (en esta máquina o en otra) o para
recordar el "por qué" detrás de cada decisión.

## 1. ¿Qué es Ironary?

Bitácora de entrenamiento personal: registra ejercicios, rutinas por día de la semana,
y el progreso serie por serie (peso, repeticiones) a lo largo del tiempo. Reemplaza un
checklist manual en Notion que se borraba y volvía a llenar cada semana.

**Stack:**
- Backend: Python + Flask
- Base de datos: SQL Server
- Frontend: HTML/CSS/JS → React (por construir)
- Control de versiones: Git + GitHub

## 2. Estructura del proyecto

```
Ironary/
├── backend/
│   ├── app/
│   │   ├── __init__.py       # application factory (create_app)
│   │   └── routes/
│   │       ├── __init__.py
│   │       └── saludo.py     # blueprint de ejemplo
│   ├── venv/                 # entorno virtual (ignorado por git)
│   ├── requirements.txt      # dependencias exactas del backend
│   └── run.py                # punto de entrada de la app
├── docs/
│   └── GUIA.md                # este documento
├── frontend/                  # pendiente (Fase 4/5)
├── .gitignore
├── README.md
└── LICENSE
```

## 3. Cómo levantar el entorno desde cero (en una máquina nueva)

```powershell
# 1. Clonar el repositorio
git clone https://github.com/Jescad29/Ironary.git
cd Ironary/backend

# 2. Crear el entorno virtual
python -m venv venv

# 3. Activarlo
.\venv\Scripts\Activate.ps1

# 4. Instalar dependencias exactas
pip install -r requirements.txt

# 5. Correr el servidor
python run.py
```

El servidor queda disponible en `http://127.0.0.1:5000`. Prueba la ruta de ejemplo:
`http://127.0.0.1:5000/api/saludo`.

**Nota:** `venv/` nunca se sube a git (ver `.gitignore`) porque contiene rutas
absolutas de la máquina donde se creó y se regenera fácilmente con
`requirements.txt`. Si mueves la carpeta del proyecto, hay que borrar y recrear
el venv en la nueva ubicación.

## 4. Arquitectura del backend

Se usa el patrón **Application Factory + Blueprints** (recomendado oficialmente
por Flask para proyectos que crecen más allá de un archivo):

- `run.py` — único punto de entrada; importa `create_app()` y arranca el servidor.
- `app/__init__.py` — la función `create_app()` construye la instancia de Flask y
  registra los blueprints.
- `app/routes/` — un archivo por grupo de endpoints relacionados (ej. `saludo.py`,
  y próximamente `ejercicios.py`, `rutinas.py`, `sesiones.py`).

A futuro, cuando existan más de un par de blueprints, `app/routes/__init__.py`
reexportará los blueprints de cada archivo para simplificar los imports en
`app/__init__.py`.

Capas planeadas conforme crezca el backend:
- **Routes (blueprints):** reciben la petición HTTP, validan entrada.
- **Services:** lógica de negocio (ej. calcular progreso, determinar rutina del día).
- **Data access:** el único lugar que ejecuta queries contra SQL Server (`pyodbc`).

El frontend (HTML/JS y luego React) es un proyecto desacoplado que consume esta
API vía peticiones HTTP — no conoce ni le importa cómo está implementado el backend.

## 5. Flujo de trabajo con Git

- Rama principal: `main`.
- Mensajes de commit siguen **Conventional Commits**:
  - `feat:` — funcionalidad nueva
  - `fix:` — corrección de bug
  - `refactor:` — reorganización sin cambiar comportamiento
  - `chore:` — mantenimiento (config, estructura, dependencias)
  - `docs:` — documentación
- `venv/`, `__pycache__/`, `.env` están en `.gitignore` y nunca se suben.

## 6. Fases del proyecto

| Fase | Contenido | Estado |
|---|---|---|
| 0 | Entorno: venv, Flask, requirements.txt | ✅ Completa |
| 1 | Backend mínimo con rutas de ejemplo (texto y JSON) | ✅ Completa |
| — | Reorganización a `backend/` + Application Factory + Blueprints | ✅ Completa |
| — | Repositorio en GitHub, README, licencia (Apache 2.0) | ✅ Completa |
| 2 | Diseño del modelo de datos y conexión a SQL Server | 🔄 En progreso |
| 3 | API REST completa (CRUD) sobre el modelo de datos | ⏳ Pendiente |
| 4 | Frontend básico con HTML/CSS/JS consumiendo la API | ⏳ Pendiente |
| 5 | Migración del frontend a React | ⏳ Pendiente |
| 6 | Autenticación, pulido y despliegue | ⏳ Pendiente |

## 7. Modelo de datos diseñado (Fase 2)

Seis tablas, pensadas para separar el **plan** (qué ejercicios lleva cada rutina)
de lo **realmente ejecutado** (qué registraste cada día), y para no duplicar datos:

Nombres de tablas y columnas en inglés (convención estándar de la industria);
documentación y comentarios en español.

- `Exercises` — catálogo maestro de ejercicios.
- `Routines` — nombres de rutina (Pull, Push, Pierna...).
- `RoutineExercises` — tabla intermedia (muchos-a-muchos entre rutinas y ejercicios).
- `DayAssignments` — qué rutina corresponde a cada día de la semana.
- `WorkoutSessions` — un registro por cada vez que entrenas (fecha, hora
  inicio/fin, y una nota libre opcional sobre cómo te sentiste).
- `LoggedSets` — el historial real, serie por serie (peso, repeticiones).

**Avance:** la base de datos `Ironary` ya fue creada en el servidor
`LTIGSA25035\SQLEXPRESS` mediante el script versionado
`backend/database/001_create_database.sql`. Las 6 tablas ya existen, creadas con
`backend/database/002_create_tables.sql` (con sus llaves primarias, foráneas y
restricciones `CHECK`/`UNIQUE` correspondientes). Los scripts SQL se numeran en
orden (`001_`, `002_`...) y se guardan en el repositorio para poder recrear la
base de datos completa desde cero en cualquier máquina, igual que con el código.

**Decisión de diseño:** los PRs (récords personales), la "sugerencia basada en tu
última sesión" y las gráficas de progreso **no se guardan como datos aparte** — se
calculan con consultas SQL sobre `SeriesRegistradas` cada vez que se piden. Guardar
datos derivados por separado del dato fuente es una fuente común de inconsistencias
(si corriges o borras una serie, un PR "guardado" quedaría desactualizado).

Detalles de tipos de datos y buenas prácticas de SQL Server se documentarán en
`docs/` una vez creado el script de creación de tablas.

## 8. Alcance del MVP (definido 2026-08-01)

- CRUD completo de ejercicios, rutinas y asignación por día de la semana.
- Registro de sesiones con notas y series (peso/reps) por ejercicio.
- Detección automática de PRs y sugerencia de referencia basada en la última sesión.
- Gráficas de progreso por ejercicio a lo largo del tiempo.
- Frontend **mobile-first**: se diseñará pensando primero en uso desde el celular
  (capturando datos parado en el gym), y se adaptará a escritorio después.

Fuera del MVP por ahora (posible v2): multiusuario/login, seguimiento de peso
corporal/medidas, timer de descanso entre series, exportación de datos.

## 9. Próximos pasos

1. Escribir el script `CREATE TABLE` para las 6 tablas del modelo de datos.
2. Instalar `pyodbc` y conectar Flask con SQL Server (`LTIGSA25035\SQLEXPRESS`,
   Windows Authentication).
3. Construir los primeros endpoints CRUD sobre `Ejercicios`.
