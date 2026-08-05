-- Crea las 6 tablas del modelo de datos de Ironary.
-- Ejecutar una sola vez, sobre la base de datos Ironary (ver 001_create_database.sql).
-- Orden importante: las tablas con FOREIGN KEY deben crearse despues de las
-- tablas a las que hacen referencia.

Use Ironary;
GO

-- Catalogo maestro de ejercicios. Se define una sola vez y se reutiliza
-- desde RoutineExercises y LoggedSets, para no duplicar el nombre del
-- ejercicio en cada registro.
CREATE TABLE Exercises (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    MuscleGroup NVARCHAR(50) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
);
GO

-- Nombres de rutina (Pull, Push, Pierna...). Es el contenedor que se llena
-- de ejercicios a traves de RoutineExercises.
CREATE TABLE Routines (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(50) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE()
)
GO

-- Tabla intermedia (relacion muchos-a-muchos entre Routines y Exercises).
-- Representa el PLAN: que ejercicios lleva cada rutina, en que orden
-- (SortOrder) y cuantas series se planean (TargetSets). No guarda lo que
-- realmente se ejecuto, eso vive en LoggedSets.
CREATE TABLE RoutineExercises(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    RoutineId INT NOT NULL,
    ExerciseId INT NOT NULL,
    SortOrder INT NOT NULL,
    TargetSets INT NOT NULL,
    CONSTRAINT FK_RoutineExercises_Routine FOREIGN KEY (RoutineId) REFERENCES Routines(Id),
    CONSTRAINT FK_RoutineExercises_Exercise FOREIGN KEY (ExerciseId) REFERENCES Exercises(Id)
);
GO

-- Asigna una rutina a cada dia de la semana (Weekday: 1=Lunes...7=Domingo).
-- El UNIQUE en Weekday garantiza que cada dia tenga una sola rutina asignada.
-- De aqui la app deduce automaticamente "hoy toca X rutina".
CREATE TABLE DayAssignments (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    Weekday TINYINT NOT NULL,
    RoutineId INT NOT NULL,
    CONSTRAINT FK_DayAssignments_Routine FOREIGN KEY (RoutineId) REFERENCES Routines(Id),
    CONSTRAINT UQ_DayAssignments_Weekday UNIQUE (Weekday)
);
GO

-- Una fila por cada vez que se entrena. StartTime/EndTime permiten NULL
-- porque EndTime se llena hasta que termina la sesion; de la resta entre
-- ambos se calcula la duracion. RoutineId conserva de que rutina se partio,
-- aunque los ejercicios se hayan ajustado ese dia.
CREATE TABLE WorkoutSessions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SessionDate DATE NOT NULL,
    RoutineId INT NOT NULL,
    StartTime DATETIME2 NULL,
    EndTime DATETIME2 NULL,
    Notes NVARCHAR(500) NULL,
    CONSTRAINT FK_WorkoutSessions_Routine FOREIGN KEY (RoutineId) REFERENCES Routines(Id)
);
GO

-- El historial real, serie por serie: peso y repeticiones registrados en
-- cada sesion. Es la tabla fuente para calcular PRs, graficas de progreso
-- y la sugerencia basada en la ultima sesion (no se guardan como datos
-- aparte, se calculan siempre desde aqui).
CREATE TABLE LoggedSets (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    SessionId INT NOT NULL,
    ExerciseId INT NOT NULL,
    SetNumber INT NOT NULL,
    WeightKg DECIMAL(5,2) NOT NULL,
    Reps INT NOT NULL,
    CONSTRAINT FK_LoggedSets_Session FOREIGN KEY (SessionId) REFERENCES WorkoutSessions(Id),
    CONSTRAINT FK_LoggedSets_Exercise FOREIGN KEY (ExerciseId) REFERENCES Exercises(Id),
    CONSTRAINT CK_LoggedSets_Reps CHECK (Reps >= 0),
    CONSTRAINT CK_LoggedSets_WeightKg CHECK (WeightKg >= 0)
);
GO
