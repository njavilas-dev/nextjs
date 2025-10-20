# Vercel Deployment Scripts

Scripts para gestionar deployments de Vercel de forma modular y reutilizable.

## Scripts Disponibles

### Scripts Principales

- **`deploy.sh`** - Script principal para deployments
- **`deploy-builder.sh`** - Deploy específico para builder
- **`deploy-viewer.sh`** - Deploy específico para viewer

### Scripts de Funciones

- **`remove-deployments.sh`** - Eliminar deployments existentes
- **`create-production.sh`** - Crear deployment de producción
- **`create-preview.sh`** - Crear deployment de preview
- **`ls-deployments.sh`** - Listar deployments

## Uso

### Script Principal
```bash
# Deploy builder en preview (default)
./scripts/deploy.sh builder

# Deploy builder en production
./scripts/deploy.sh builder production

# Deploy viewer en preview
./scripts/deploy.sh viewer preview
```

### Scripts Específicos
```bash
# Deploy builder
./scripts/deploy-builder.sh preview
./scripts/deploy-builder.sh production

# Deploy viewer
./scripts/deploy-viewer.sh preview
./scripts/deploy-viewer.sh production
```

### Scripts de Funciones
```bash
# Eliminar deployments
./scripts/remove-deployments.sh builder preview
./scripts/remove-deployments.sh viewer production

# Crear deployments
./scripts/create-preview.sh builder
./scripts/create-production.sh viewer

# Listar deployments
./scripts/ls-deployments.sh builder
./scripts/ls-deployments.sh viewer
```

## Variables de Entorno Requeridas

- `VERCEL_TOKEN` - Token de autenticación de Vercel

## Características

- ✅ **Modular** - Cada función en su propio script
- ✅ **Reutilizable** - Scripts independientes
- ✅ **Validación** - Verificación de parámetros y variables
- ✅ **Manejo de errores** - `set -e` para fallar rápido
- ✅ **Metadata** - Branch, app y environment en deployments
- ✅ **Limpieza** - Elimina deployments duplicados automáticamente
- ✅ **Archive** - Usa `--archive=tgz` para uploads eficientes

## Ejemplos de Uso en CI/CD

```bash
# En GitHub Actions
export VERCEL_TOKEN="${{ secrets.VERCEL_TOKEN }}"
./scripts/deploy.sh builder preview
./scripts/deploy.sh viewer production
```
