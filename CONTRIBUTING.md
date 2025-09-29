# Guía de contribución

¡Gracias por tu interés en contribuir!

## Flujo de trabajo
1. Abre un issue con la propuesta (en español, claro).
2. Crea una rama desde `main` con el prefijo `feature/` o `fix/`.
3. Commits claros (en español) y pequeños.
4. Abre un Pull Request a `main`, describe cambios y cómo probar.

## Estilo de código
- C# con convenciones de .NET.
- Nombres claros en español.
- Comentarios donde haya lógica de negocio o decisiones no obvias.

## SQL
- Scripts idempotentes (`IF EXISTS / IF NOT EXISTS`).
- Comentarios de cabecera con objetivo del script.
- Pruebas (SELECT/EXEC) al final del script, como comentarios.