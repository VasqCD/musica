# 🎵 MusicPlayer — Reproductor de Música con Flutter

Aplicación móvil construida con **Flutter** que consume la **iTunes Search API** de Apple para buscar y reproducir vistas previas de canciones.

---

## 📋 Tabla de contenidos

1. [Descripción del proyecto](#descripción-del-proyecto)
2. [Requisitos previos](#requisitos-previos)
3. [Instrucciones de despliegue](#instrucciones-de-despliegue)
4. [Librerías utilizadas](#librerías-utilizadas)
5. [Arquitectura del proyecto](#arquitectura-del-proyecto)
6. [Clases y métodos principales](#clases-y-métodos-principales)
7. [Widgets de la interfaz](#widgets-de-la-interfaz)
8. [Flujo de datos](#flujo-de-datos)

---

## Descripción del proyecto

MusicPlayer permite al usuario:

- **Explorar** canciones populares del género Rock al abrir la app.
- **Buscar** canciones, artistas o álbumes escribiendo en la barra de búsqueda.
- **Reproducir** vistas previas de 30 segundos de las canciones (audio directo de iTunes).
- **Controlar** la reproducción: play, pausa, adelantar 10 segundos, reiniciar y navegar entre canciones de la lista.

---

## Requisitos previos

Antes de ejecutar el proyecto necesitas tener instalado:

| Herramienta | Versión mínima | Instalación |
|-------------|---------------|-------------|
| Flutter SDK | 3.10.x o superior | https://docs.flutter.dev/get-started/install |
| Dart SDK | 3.10.8 o superior | Incluido con Flutter |
| Android Studio | Cualquier versión reciente | https://developer.android.com/studio |
| Xcode (solo macOS) | 14 o superior | App Store de macOS |
| Git | Cualquier versión | https://git-scm.com |

> **Verifica tu instalación** ejecutando en la terminal:
> ```bash
> flutter doctor
> ```
> Todos los ítems deben mostrar una ✓ verde (o advertencias menores aceptables).

---

## Instrucciones de despliegue

### 1. Clonar el repositorio

```bash
git clone https://github.com/VasqCD/musica.git
cd musica
```

### 2. Instalar las dependencias

Flutter descarga automáticamente todos los paquetes definidos en `pubspec.yaml`:

```bash
flutter pub get
```

Este comando descarga e instala:
- `get` (GetX — gestión de estado y navegación)
- `http` (peticiones HTTP a la API de iTunes)
- `audioplayers` (reproducción de audio)
- `cached_network_image` (imágenes con caché)
- `cupertino_icons` (íconos estilo iOS)

### 3. Conectar un dispositivo o iniciar un emulador

**Opción A — Dispositivo físico Android:**
1. Activa el **modo desarrollador** en tu teléfono.
2. Habilita la **depuración USB**.
3. Conecta el teléfono por cable USB.
4. Verifica que Flutter lo detecte: `flutter devices`

**Opción B — Emulador Android:**
```bash
# Listar emuladores disponibles
flutter emulators

# Iniciar un emulador
flutter emulators --launch <nombre_del_emulador>
```

**Opción C — Simulador iOS (solo macOS):**
```bash
open -a Simulator
```

### 4. Ejecutar la aplicación

```bash
flutter run
```

Para seleccionar un dispositivo específico si hay varios conectados:
```bash
flutter run -d <device_id>
```

### 5. Compilar para producción

**Android (APK):**
```bash
flutter build apk --release
# El archivo se genera en: build/app/outputs/flutter-apk/app-release.apk
```

**Android (App Bundle para Google Play):**
```bash
flutter build appbundle --release
```

**iOS (solo macOS):**
```bash
flutter build ios --release
```

---

## Librerías utilizadas

### `get: ^4.7.3` — GetX
> Paquete todo-en-uno para Flutter que proporciona:
> - **Gestión de estado reactiva**: variables `Rx` que notifican automáticamente a la UI cuando cambian.
> - **Inyección de dependencias**: `Get.put()` y `Get.find()` para registrar y obtener instancias.
> - **Navegación sin contexto**: `Get.to()`, `Get.back()` sin necesidad de `BuildContext`.
> - **Binding de controladores**: `BindingsBuilder` para registrar controladores ligados a rutas.

Documentación: https://pub.dev/packages/get

---

### `http: ^1.6.0` — HTTP
> Librería oficial de Dart para realizar peticiones HTTP.
> Se usa en `ItunesService` para hacer peticiones `GET` a la iTunes Search API.
> Devuelve un `Future<Response>` con el código de estado y el cuerpo JSON.

Documentación: https://pub.dev/packages/http

---

### `audioplayers: ^6.6.0` — AudioPlayers
> Paquete para reproducir audio desde URLs remotas o archivos locales.
> Se usa en `PlayerController` para:
> - `play(UrlSource(url))`: cargar y reproducir audio desde una URL.
> - `pause()` / `resume()`: controlar la reproducción.
> - `seek(Duration)`: saltar a un punto específico.
> - Streams: `onPositionChanged`, `onDurationChanged`, `onPlayerStateChanged`.

Documentación: https://pub.dev/packages/audioplayers

---

### `cached_network_image: ^3.4.1` — CachedNetworkImage
> Widget que descarga imágenes desde URLs y las almacena en caché local.
> Se usa en `CardTrack` y `DescriptionTrack` para mostrar las portadas de álbumes.
> Ventajas:
> - Evita descargar la misma imagen varias veces.
> - Muestra un `placeholder` mientras carga.
> - Muestra un `errorWidget` si la descarga falla.

Documentación: https://pub.dev/packages/cached_network_image

---

### `cupertino_icons: ^1.0.8` — Cupertino Icons
> Fuente de íconos estilo iOS para usar con `CupertinoIcons` en Flutter.
> Incluido por defecto en proyectos Flutter nuevos.

Documentación: https://pub.dev/packages/cupertino_icons

---

## Arquitectura del proyecto

El proyecto sigue una **arquitectura en capas** inspirada en el patrón MVC/GetX:

```
lib/
├── main.dart                     # Punto de entrada de la app
├── core/
│   └── theme/
│       └── app_theme.dart        # Temas visual claro y oscuro
├── models/
│   └── track_model.dart          # Modelo de datos de una canción
├── services/
│   └── itunes_service.dart       # Comunicación con la API de iTunes
├── controllers/
│   ├── home_controller.dart      # Estado y lógica de la pantalla principal
│   └── player_controller.dart   # Estado y lógica del reproductor
└── views/
    ├── home_view.dart            # Pantalla principal (lista de canciones)
    ├── search_bar.dart           # Widget de barra de búsqueda
    ├── card_track.dart           # Widget de tarjeta de canción
    └── description_track.dart   # Pantalla del reproductor
```

### Capas

| Capa | Carpeta | Responsabilidad |
|------|---------|-----------------|
| **Vista** | `views/` | Construir la interfaz de usuario. No contiene lógica de negocio. |
| **Controlador** | `controllers/` | Gestionar el estado reactivo y la lógica de la UI. |
| **Servicio** | `services/` | Comunicación con APIs externas (HTTP). |
| **Modelo** | `models/` | Definir la estructura de los datos. |
| **Core** | `core/` | Configuraciones globales (tema, constantes). |

---

## Clases y métodos principales

### `MusicPlayer` (main.dart)
Widget raíz de la app. Configura `GetMaterialApp` con el tema y la pantalla inicial.

| Método | Descripción |
|--------|-------------|
| `build(context)` | Construye el `GetMaterialApp` con tema claro y `HomeView` como pantalla inicial. |

---

### `TrackModel` (models/track_model.dart)
Representa una canción devuelta por la API de iTunes.

| Método / Constructor | Descripción |
|----------------------|-------------|
| `TrackModel({...})` | Constructor con todos los campos requeridos. |
| `TrackModel.fromJson(json)` | Convierte un `Map<String, dynamic>` (JSON) en un objeto `TrackModel`. |
| `toJson()` | Convierte el objeto de vuelta a un `Map<String, dynamic>`. |
| `trackModelFromJson(str)` | Función global: parsea un String JSON completo. |
| `trackModelToJson(data)` | Función global: serializa un `TrackModel` a String JSON. |

**Propiedades clave:**
- `trackName` — nombre de la canción
- `artistName` — nombre del artista
- `previewUrl` — URL del audio de 30 s
- `artworkUrl60` / `artworkUrl100` — URLs de la portada
- `trackTimeMillis` — duración en milisegundos

---

### `ItunesService` (services/itunes_service.dart)
Realiza peticiones HTTP a la iTunes Search API.

| Método | Descripción |
|--------|-------------|
| `buscarCanciones(consulta, {limite, atributo})` | Hace un `GET` a iTunes y devuelve `Future<List<TrackModel>>`. |

---

### `HomeController` (controllers/home_controller.dart)
Controlador GetX de la pantalla principal. Gestiona las listas de canciones y la búsqueda.

| Variable reactiva | Tipo | Descripción |
|-------------------|------|-------------|
| `canciones` | `RxList<TrackModel>` | Resultados de búsqueda del usuario. |
| `cancionesPopulares` | `RxList<TrackModel>` | Canciones populares cargadas al inicio. |
| `cargando` | `RxBool` | `true` mientras se espera la API. |
| `mensajeError` | `RxString` | Mensaje de error activo (vacío = sin error). |
| `ultimaBusqueda` | `RxString` | Último texto buscado por el usuario. |

| Método | Descripción |
|--------|-------------|
| `onInit()` | Llamado automáticamente por GetX; inicia `cargarPopulares()`. |
| `cargarPopulares()` | Carga 20 canciones de Rock desde iTunes al inicio de la app. |
| `buscarCancionDebounce(consulta)` | Inicia la búsqueda con retraso de 1 s para evitar peticiones excesivas. |
| `buscarCanciones(consulta)` | Hace la petición real a `ItunesService` y actualiza `canciones`. |

---

### `PlayerController` (controllers/player_controller.dart)
Controlador GetX del reproductor de audio.

| Variable reactiva | Tipo | Descripción |
|-------------------|------|-------------|
| `cancion` | `Rx<TrackModel?>` | Canción actualmente en reproducción. |
| `estaReproduciendo` | `RxBool` | `true` si el audio está sonando. |
| `cargando` | `RxBool` | `true` mientras el audio carga. |
| `mensajeError` | `RxString` | Error de reproducción (vacío = sin error). |
| `posicion` | `Rx<Duration>` | Tiempo transcurrido de reproducción. |
| `duracion` | `Rx<Duration?>` | Duración total del audio. |

| Método | Descripción |
|--------|-------------|
| `onInit()` | Lee `Get.arguments` para obtener la canción inicial e inicia la reproducción. |
| `reproducir(track, {lista, indice})` | Cambia la canción y comienza la reproducción. |
| `alternarPlayPause()` | Pausa si está reproduciendo, reanuda si está pausado. |
| `irA(pos)` | Salta a una posición específica del audio (usado por el Slider). |
| `reiniciar()` | Vuelve al inicio de la canción (seek a 0). |
| `adelantar({segundos})` | Adelanta N segundos (por defecto 10). |
| `cancionAnterior()` | Va a la canción anterior en la lista. |
| `cancionSiguiente()` | Va a la siguiente canción en la lista. |
| `onClose()` | Libera el `AudioPlayer` al destruirse el controlador. |

---

## Widgets de la interfaz

### `HomeView` (views/home_view.dart)
Pantalla principal de la aplicación.

- Extiende `StatelessWidget`.
- Usa `CustomScrollView` con slivers para un scroll eficiente.
- Contiene `SearchBarCustom` y una lista de `CardTrack`.
- El widget `Obx` observa `HomeController` y muestra resultados de búsqueda o canciones populares.

| Método | Descripción |
|--------|-------------|
| `build(context)` | Construye el `Scaffold` con el `CustomScrollView` y todos los slivers. |
| `_construirContenido(context, controlador)` | Decide qué lista mostrar (búsqueda, populares, error o vacía). |

---

### `SearchBarCustom` (views/search_bar.dart)
Barra de búsqueda con botón de limpiar.

- Extiende `StatefulWidget` para gestionar el `TextEditingController`.
- Llama a `HomeController.buscarCancionDebounce` en cada cambio de texto.

| Método | Descripción |
|--------|-------------|
| `_alBuscar(valor)` | Se llama en cada pulsación de tecla; delega a `HomeController`. |
| `_limpiar()` | Borra el campo de texto y resetea la búsqueda. |
| `build(context)` | Construye el `Container` con el `TextField` y sus íconos. |
| `dispose()` | Libera el `TextEditingController` al destruirse el widget. |

---

### `CardTrack` (views/card_track.dart)
Tarjeta de canción en la lista.

- Extiende `StatelessWidget`.
- Muestra portada, nombre, artista y duración.
- Al tocar, inicia la reproducción y navega a `DescriptionTrack`.

| Método | Descripción |
|--------|-------------|
| `build(context)` | Construye el `GestureDetector` + `ListTile` con imagen, textos y duración. |
| `_placeholderAlbum(context)` | Retorna un contenedor gris con ícono musical (placeholder de imagen). |

---

### `DescriptionTrack` (views/description_track.dart)
Pantalla del reproductor de música.

- Extiende `StatelessWidget`.
- Muestra portada grande, nombre, artista, slider de progreso y controles.
- Usa `Obx` para reaccionar a los cambios del `PlayerController`.

| Método | Descripción |
|--------|-------------|
| `build(context)` | Construye el `Scaffold` con `AppBar` y el cuerpo reactivo `Obx`. |
| `_formatear(d)` | Formatea una `Duration` como `"m:ss"` para los labels de tiempo. |
| `_placeholderAlbum(context)` | Retorna el placeholder grande (280×280 px) para la portada. |

---

### `AppTheme` (core/theme/app_theme.dart)
Define los temas visuales de la app.

| Getter | Descripción |
|--------|-------------|
| `AppTheme.light` | Tema claro con fondo blanco y verde primario (#1DB954). |
| `AppTheme.dark` | Tema oscuro con fondo casi negro (#121212) y verde primario. |

---

## Flujo de datos

```
Usuario escribe en SearchBarCustom
    ↓
SearchBarCustom._alBuscar(valor)
    ↓
HomeController.buscarCancionDebounce(consulta)   ← debounce 1 segundo
    ↓
HomeController.buscarCanciones(consulta)
    ↓
ItunesService.buscarCanciones(consulta)          ← petición HTTP GET
    ↓
iTunes Search API (https://itunes.apple.com/search)
    ↓
List<TrackModel> (JSON → objetos Dart)
    ↓
HomeController.canciones.value = resultados      ← RxList actualizado
    ↓
HomeView se reconstruye automáticamente (Obx)    ← lista visible en pantalla

Usuario toca una CardTrack
    ↓
PlayerController.reproducir(track, lista, indice)
    ↓
PlayerController._cargarYReproducir(track)
    ↓
AudioPlayer.play(UrlSource(previewUrl))          ← audio desde iTunes
    ↓
PlayerController.estaReproduciendo = true        ← Rx notifica a DescriptionTrack
```
