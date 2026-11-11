# The Basics of Google Cloud Compute: Challenge Lab — con GitHub Codespaces

Solución automatizada del Challenge Lab final del curso **Google Cloud Computing Foundations: Cloud Computing Fundamentals** (skill badge *The Basics of Google Cloud Compute*), lista para ejecutarse desde **GitHub Codespaces** en vez de Cloud Shell.

| Tarea | Qué se crea | Script |
|---|---|---|
| 1 | Bucket de Cloud Storage multirregional **US** | `scripts/01-bucket.sh` |
| 2 | VM `my-instance` (e2-medium, Debian, 10 GB, HTTP) + disco `mydisk` de 200 GB adjunto | `scripts/02-vm-disco.sh` |
| 3 | Servidor web **NGINX** instalado y respondiendo | `scripts/03-nginx.sh` |

## Cómo correrlo

1. Inicia el laboratorio en Google Skills y deja abierto el panel con **Username, Password, Project ID**, la **zona** y el **nombre del bucket**.
2. En este repositorio: **Code → Codespaces → Create codespace on main**. Al abrir, se instala `gcloud` automáticamente (1–2 min).
3. En la terminal del Codespace:

```bash
./lab.sh configurar   # pega Project ID, zona y nombre del bucket
./lab.sh login        # abre el enlace, entra con la cuenta DEL LAB, pega el código
./lab.sh todo         # ejecuta las tareas 1, 2 y 3 y verifica
```

4. Pulsa **Check my progress** en cada tarea del laboratorio.

También puedes usar `./lab.sh` sin argumentos para ver un menú, o correr cada tarea por separado: `./lab.sh bucket`, `./lab.sh vm`, `./lab.sh nginx`, `./lab.sh verificar`.

## Notas

- Los scripts son **idempotentes**: si un recurso ya existe, no lo vuelven a crear; puedes repetirlos sin problema.
- Inicia sesión con la cuenta **temporal del laboratorio**, no con tu cuenta personal (evita cobros).
- Si `gcloud compute ssh` falla, `03-nginx.sh` instala NGINX automáticamente con un *startup-script* y reinicia la VM.
- `lab.env` contiene los datos de tu laboratorio y no se sube al repositorio.
- El documento con el desarrollo completo de la guía está en [`docs/`](docs/).
