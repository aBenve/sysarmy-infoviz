# Sysarmy

This is an [Observable Framework](https://observablehq.com/framework) app. To start the local preview server, run:

```
npm run dev
```

Then visit <http://localhost:3000> to preview your app.

For more, see <https://observablehq.com/framework/getting-started>.

## Project structure

A typical Framework project looks like this:

```ini
.
├─ src
│  ├─ components
│  │  └─ timeline.js           # an importable module
│  ├─ data
│  │  ├─ launches.csv.js       # a data loader
│  │  └─ events.json           # a static data file
│  ├─ example-dashboard.md     # a page
│  ├─ example-report.md        # another page
│  └─ index.md                 # the home page
├─ .gitignore
├─ observablehq.config.js      # the app config file
├─ package.json
└─ README.md
```

**`src`** - This is the “source root” — where your source files live. Pages go here. Each page is a Markdown file. Observable Framework uses [file-based routing](https://observablehq.com/framework/routing), which means that the name of the file controls where the page is served. You can create as many pages as you like. Use folders to organize your pages.

**`src/index.md`** - This is the home page for your app. You can have as many additional pages as you’d like, but you should always have a home page, too.

**`src/data`** - You can put [data loaders](https://observablehq.com/framework/loaders) or static data files anywhere in your source root, but we recommend putting them here.

**`src/components`** - You can put shared [JavaScript modules](https://observablehq.com/framework/javascript/imports) anywhere in your source root, but we recommend putting them here. This helps you pull code out of Markdown files and into JavaScript modules, making it easier to reuse code across pages, write tests and run linters, and even share code with vanilla web applications.

**`observablehq.config.js`** - This is the [app configuration](https://observablehq.com/framework/config) file, such as the pages and sections in the sidebar navigation, and the app’s title.

## Command reference

| Command           | Description                                              |
| ----------------- | -------------------------------------------------------- |
| `npm install`            | Install or reinstall dependencies                        |
| `npm run dev`        | Start local preview server                               |
| `npm run build`      | Build your static site, generating `./dist`              |
| `npm run deploy`     | Deploy your app to Observable                            |
| `npm run clean`      | Clear the local data loader cache                        |
| `npm run observable` | Run commands like `observable help`                      |

# Sobre el trabajo
Este proyecto fue realizado por alumnos de la materia Visualización de la Información en el ITBA.

Se basa en la ![encuesta](https://sueldos.openqube.io/encuesta-sueldos-2024.01/) semestral realizada por la comunidad Sysarmy que detalla el estado actual, junto a un análisis histórico, de los trabajos en el área de sistemas en la República Argentina.

Se recopilaron los datos publicados por sysarmy para cada semestre de los últimos 10 años y se generaron en base a los mismos dos datasets, uno con la información del último semestre (primer semestre 2024) y el otro con todo el contenido histórico. Se realizó de esta forma debido a la enorme variación en la información recolectada (preguntas y opciones presentadas a los encuestados), por lo que el dataset histórico es más reducido ya que está limitado a las preguntas que son comunes a todos los semestres.

En base a estos datos se implementaron los gráficos presentados en la última encuesta de Sysarmy, utilizando el Observable Framework.

## Participantes
- Agustin Benvenuto
- Alan Sartorio
- Agustin Galarza

## Graficos Realizados

1. Perfil de los participantes:
    1. por provincia y CABA
    2. por rol 
    3. por experiencia (0-1, 2, 3, 4-5, 6-8, 9-13, 14-21, 22-43)
        4. por anios en la compania actual
        5. por anios en el puesto actual
    6. por nivel educativo (stackeado por completo, en curso, incompleto)
        7. por carrera estudiada
        8. por universidad
    7. por demografia - genero
2. Salarios
    1. historico en varias monedas
    2. segun contrato dolarizados vs en pesos agrupado por junior, semi-senior o senior
    3. segun puesto agrupado por junior, semi-senior o senior
    4. segun educacion agrupado por dolarizado o no
    5. segun carrera y experiencia (agrupado por junior, semi-senior o senior)
    6. segun tecnologias usadas agrupado por junior, semi-senior o senior
    7. segun lenguajes usados agrupado por junior, semi-senior o senior
3. Genero (hombre, mujer y otroa)
    1. cantidad 
    2. salarios
    3. historico de participacion
    4. historico salarios
    5. historico de conformidad
    6. formacion 
    7. experiencia
    8. conformidad
    9. salario ajustado por inflacion (raro este)
    10. posicion de liderazgo
4. Tecnologias
    1. plataformas que usan
    2. lenguajes de programacion
    3. frameworks, herramientas y librerias
    4. bases de datos
    5. QA/testing
    6. que tanto usan IA? del 0 al 5
5. Trabajo
    1. tipo de contrato
    2. porcentaje del sueldo dolarizado (no dolarizado, 100%, parcialmente, dolarizado pero??)
    3. realiza guardias ? (sin, guardias activas, guardias pasivas)
    4. tipo de contrato y sus sueldos mezclado con el porcentaje dolarizado
    5. Compensaciones. hay bono? 
    6. hay beneficios extra?
    7. porcentaje de ajuste por inflacion
    8. caracteristicas de la empresa - cantidad de gente
    9. modalidad de trabajo - remoto, presencial o hibrido
    10. recomiendan el lugar? promotores, pasivos, detractores
    11. buscan cambiar de lugar? escuchando propuestas, no busca o en busqueda activa

