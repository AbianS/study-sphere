<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo-small.svg" width="200" alt="Nest Logo" /></a>
</p>

## Iniciar Backend

### Instalar dependencias
```
pnpm i
```

### Levantar base de datos posgresql con Docker (En caso de no tener docker, puedes usar un servidor local de postgresql)

```
docker compose up -d
```

Cambiar `.env` para conectar a la base de datos.

### Iniciar Prisma Orm

```
npx prisma db push
npx prisma generate
```

### Ejecutar el backend en modo desarrollo

```
pnpm start:dev
```
