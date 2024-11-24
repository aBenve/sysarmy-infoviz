---
title: Tecnologies
sql: 
  db: ./data/salary-survey-2024.csv 
---


### By platform

```sql id=platforms display

WITH all_platforms AS (
  SELECT
    LOWER(TRIM(platform)) AS platform, 
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
  FROM (
    SELECT UNNEST(STRING_TO_ARRAY(TRIM(plataformas_que_utilizas_en_tu_puesto_actual), ','))::TEXT AS platform
    FROM "db"
    WHERE plataformas_que_utilizas_en_tu_puesto_actual IS NOT NULL
  ) AS normalized_platforms
  WHERE platform != '' 
  GROUP BY LOWER(TRIM(platform))
),

filtered_platforms AS (
  SELECT *
  FROM all_platforms
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS platform, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM all_platforms
  WHERE percentage < 1
)

SELECT *
FROM filtered_platforms
ORDER BY 
  CASE WHEN platform = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js

const sortOtherToEnd = Array.from(platforms).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.platform === "Other") return 1;
  if (b.platform === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});

const participantsPerPlatform = Plot.plot({
  height: 800,
  width: 800,
  marginLeft: 200,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Platform",
  },
  y: {
      label: "Percentage of participants",
      grid: true,
        domain: sortOtherToEnd.map(d => d.platform) // Use sorted order for roles

  },

  marks: [
      Plot.barX(platforms, {
        y: "platform",
        x: "percentage", 
        fill: (d) => d.platform === "Other" ? "gray" : "steelblue",
        sort: { y: "-x" },
        tip: true
      }),
  ],
});

display(participantsPerPlatform);

```

### By programming language

```sql id=programming_languages display

WITH all_languages AS (
  SELECT
    LOWER(TRIM(language)) AS language, 
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
  FROM (
    SELECT UNNEST(STRING_TO_ARRAY(TRIM(lenguajes_de_programacion_o_tecnologias_que_utilices_en_tu_puesto_actual), ','))::TEXT AS language
    FROM "db"
    WHERE lenguajes_de_programacion_o_tecnologias_que_utilices_en_tu_puesto_actual IS NOT NULL
  ) AS normalized_languages
  WHERE language IS NOT NULL
  GROUP BY LOWER(TRIM(language))
),

filtered_languages AS (
  SELECT *
  FROM all_languages
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS language, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM all_languages
  WHERE percentage < 1
)

SELECT *

FROM filtered_languages
ORDER BY 
  CASE WHEN language = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js

const sortOtherToEnd = Array.from(programming_languages).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.language === "Other") return 1;
  if (b.language === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});

const participantsPerLanguage = Plot.plot({
  height: 800,
  width: 800,
  marginLeft: 200,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Language",
  },
  y: {
      label: "Percentage of participants",
      grid: true,
        domain: sortOtherToEnd.map(d => d.language)
  },

  marks: [
      Plot.barX(programming_languages, {
        y: "language",
        x: "percentage", 
        fill: (d) => d.language === "Other" ? "gray" : "steelblue",
        sort: { y: "-x" },
        tip: true
      }),
  ],
});

display(participantsPerLanguage);

```
### By framework, tools and libraries

```sql id=frameworks_tools_libraries display

WITH all_frameworks AS (
  SELECT
    LOWER(TRIM(framework)) AS framework, 
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
  FROM (
    SELECT UNNEST(STRING_TO_ARRAY(TRIM(frameworksherramientas_y_librerias_que_utilices_en_tu_puesto_actual), ','))::TEXT AS framework
    FROM "db"
    WHERE frameworksherramientas_y_librerias_que_utilices_en_tu_puesto_actual IS NOT NULL
  ) AS normalized_frameworks
  WHERE framework IS NOT NULL
  GROUP BY LOWER(TRIM(framework))
),

filtered_frameworks AS (
  SELECT *
  FROM all_frameworks
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS framework, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM all_frameworks
  WHERE percentage < 1
)

SELECT *
FROM filtered_frameworks
ORDER BY 
  CASE WHEN framework = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js


const sortOtherToEnd = Array.from(frameworks_tools_libraries).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.framework === "Other") return 1;
  if (b.framework === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});


const participantsPerFramework = Plot.plot({
  height: 800,
  width: 800,
  marginLeft: 200,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Framework",
  },
  y: {
      label: "Percentage of participants",
      grid: true,
      domain: sortOtherToEnd.map(d => d.framework)
  },

  marks: [
      Plot.barX(frameworks_tools_libraries, {
        y: "framework",
        x: "percentage", 
        fill: (d) => d.framework === "Other" ? "gray" : "steelblue",
        sort: { y: "-x" },
        tip: true
      }),
  ],
});

display(participantsPerFramework);

```

### By data bases

```sql id=databases display

WITH all_databases AS (
  SELECT
    LOWER(TRIM(database)) AS database, 
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
  FROM (
    SELECT UNNEST(STRING_TO_ARRAY(TRIM(bases_de_datos), ','))::TEXT AS database
    FROM "db"
    WHERE bases_de_datos IS NOT NULL
  ) AS normalized_databases
  WHERE database IS NOT NULL
  GROUP BY LOWER(TRIM(database))
),

filtered_databases AS (
  SELECT *
  FROM all_databases
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS database, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM all_databases
  WHERE percentage < 1
)

SELECT *
FROM filtered_databases
ORDER BY 
  CASE WHEN database = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js


const sortOtherToEnd = Array.from(databases).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.database === "Other") return 1;
  if (b.database === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});



const participantsPerDatabase = Plot.plot({
  height: 800,
  width: 800,
  marginLeft: 200,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Database",
  },
  y: {
      label: "Percentage of participants",
      grid: true,
      domain: sortOtherToEnd.map(d => d.database)
  },

  marks: [
      Plot.barX(databases, {
        y: "database",
        x: "percentage", 
        fill: (d) => d.database === "Other" ? "gray" : "steelblue",
        sort: { y: "-x" },
        tip: true
      }),
  ],
});

display(participantsPerDatabase);

```

### By Qa/Testing

```sql id=qa_testing display

WITH all_testing_tools AS (
  SELECT
    LOWER(TRIM(testing_tool)) AS testing_tool, 
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
  FROM (
    SELECT UNNEST(STRING_TO_ARRAY(TRIM(qa_testing), ','))::TEXT AS testing_tool
    FROM "db"
    WHERE qa_testing IS NOT NULL
  ) AS normalized_testing_tools
  WHERE testing_tool IS NOT NULL
  GROUP BY LOWER(TRIM(testing_tool))
),

filtered_testing_tools AS (
  SELECT *
  FROM all_testing_tools
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS testing_tool, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM all_testing_tools
  WHERE percentage < 1
)

SELECT *
FROM filtered_testing_tools
ORDER BY 
  CASE WHEN testing_tool = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js

const sortOtherToEnd = Array.from(qa_testing).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.testing_tool === "Other") return 1;
  if (b.testing_tool === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});

const participantsPerTestingTool = Plot.plot({
  height: 800,
  width: 800,
  marginLeft: 200,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Testing Tool",
  },
  y: {
      label: "Percentage of participants",
      grid: true,
      domain: sortOtherToEnd.map(d => d.testing_tool)
  },

  marks: [
      Plot.barX(qa_testing, {
        y: "testing_tool",
        x: "percentage", 
        fill: (d) => d.testing_tool === "Other" ? "gray" : "steelblue",
        sort: { y: "-x" },
        tip: true
      }),
  ],
});

display(participantsPerTestingTool);

```

### By IA use

```sql id=ia_use

SELECT que_tanto_estas_usando_copilotchatgpt_u_otras_herramientas_de_ia_para_tu_trabajo AS ia_use, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
WHERE que_tanto_estas_usando_copilotchatgpt_u_otras_herramientas_de_ia_para_tu_trabajo IS NOT NULL
GROUP BY que_tanto_estas_usando_copilotchatgpt_u_otras_herramientas_de_ia_para_tu_trabajo

```

```js

const iaUse = Plot.plot({
  height: 400,
  width: 800,   
  marginLeft: 100,
  marginRight: 100,    
  x: {
    label: "Amount of participants"
  },
  y: {
    label: "IA use"
  },
  
  marks: [
    Plot.barX(ia_use, {
        x: "percentage",
        y: "ia_use",
        sort: { y: "-x" },
        tip: true
    }),

    Plot.text(ia_use, {
      x: "percentage",
      y: "ia_use",
      text: d => `${d.percentage}%`,
      dx: 40,
      align: "left",
      baseline: "middle",
      color: "black",
      font: "Arial",
      fontSize: 12
    })
  ]
})


display(iaUse)

```

