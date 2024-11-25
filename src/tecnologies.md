---
title: Tecnologies
theme: dashboard
toc: false

sql:
  db: ./data/2024-01.csv
---

# Tecnologies

This is a summary of the technologies used by the participants.


<div class="grid grid-cols-2">
    <div class="card">
        ${resize((width) => participantsPerPlatform(platforms, {width}))}
    </div>
    <div class="card">
        ${resize((width) => participantsPerLanguage(programming_languages, {width}))}
    </div>
</div>
<div class="grid grid-cols-2">
    <div class="card">
        ${resize((width) => participantsPerFramework(frameworks_tools_libraries, {width}))}
    </div>
    <div class="card">
        ${resize((width) => participantsPerDatabase(databases, {width}))}
    </div>
</div>
<div class="grid grid-cols-2">
    <div class="card">
        ${resize((width) => participantsPerTestingTool(qa_testing, {width}))}
    </div>
    <div class="card">
        ${resize((width) => iaUse(ia_use, {width}))}
    </div>
</div>

```sql id=platforms

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
function participantsPerPlatform(data, { width }) {
  const sortOtherToEnd = Array.from(data).sort((a, b) => {
    // Ensure "Other" is always last
    if (a.platform === "Other") return 1;
    if (b.platform === "Other") return -1;
    // Otherwise, sort by percentage descending
    return b.percentage - a.percentage;
  });

  return Plot.plot({
    title: "By platform",
    height: 600,
    width: width,
    marginLeft: 200,
    marginRight: 50,

    x: {
      label: "Percentage of participants",
    },
    y: {
      label: "Platform",
      grid: true,
      domain: sortOtherToEnd.map((d) => d.platform), // Use sorted order for roles
    },

    marks: [
      Plot.barX(data, {
        y: "platform",
        x: "percentage",
        fill: (d) => (d.platform === "Other" ? "#EFB118" : "#4269D0"),
        sort: { y: "-x" },
        tip: true,
      }),
    ],
  });
}
```

```sql id=programming_languages

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
function participantsPerLanguage(data, { width }) {
  const sortOtherToEnd = Array.from(data).sort((a, b) => {
    // Ensure "Other" is always last
    if (a.language === "Other") return 1;
    if (b.language === "Other") return -1;
    // Otherwise, sort by percentage descending
    return b.percentage - a.percentage;
  });

  return Plot.plot({
    title: "By programming language",
    height: 600,
    width: width,
    marginLeft: 200,
    marginRight: 50,

    x: {
      label: "Percentage of participants",
    },
    y: {
      label: "Language",
      grid: true,
      domain: sortOtherToEnd.map((d) => d.language),
    },

    marks: [
      Plot.barX(data, {
        y: "language",
        x: "percentage",
        fill: (d) => (d.language === "Other" ? "#EFB118" : "#4269D0"),
        sort: { y: "-x" },
        tip: true,
      }),
    ],
  });
}
```

```sql id=frameworks_tools_libraries

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
function participantsPerFramework(data, { width }) {
  const sortOtherToEnd = Array.from(data).sort((a, b) => {
    // Ensure "Other" is always last
    if (a.framework === "Other") return 1;
    if (b.framework === "Other") return -1;
    // Otherwise, sort by percentage descending
    return b.percentage - a.percentage;
  });

  return Plot.plot({
    title: "By framework, tools and libraries",
    height: 600,
    width: width,
    marginLeft: 200,

    marginRight: 50,

    x: {
      label: "Percentage of participants",
    },
    y: {
      label: "Framework",
      grid: true,
      domain: sortOtherToEnd.map((d) => d.framework),
    },

    marks: [
      Plot.barX(data, {
        y: "framework",
        x: "percentage",
        fill: (d) => (d.framework === "Other" ? "#EFB118" : "#4269D0"),
        sort: { y: "-x" },
        tip: true,
      }),
    ],
  });
}
```

```sql id=databases

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
function participantsPerDatabase(data, { width }) {
  const sortOtherToEnd = Array.from(data).sort((a, b) => {
    // Ensure "Other" is always last
    if (a.database === "Other") return 1;
    if (b.database === "Other") return -1;
    // Otherwise, sort by percentage descending
    return b.percentage - a.percentage;
  });

  return Plot.plot({
    title: "By data bases",
    height: 600,
    width: width,
    marginLeft: 200,

    marginRight: 50,

    x: {
      label: "Percentage of participants",
    },
    y: {
      label: "Database",
      grid: true,
      domain: sortOtherToEnd.map((d) => d.database),
    },

    marks: [
      Plot.barX(data, {
        y: "database",
        x: "percentage",
        fill: (d) => (d.database === "Other" ? "#EFB118" : "#4269D0"),
        sort: { y: "-x" },
        tip: true,
      }),
    ],
  });
}
```

```sql id=qa_testing

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
function participantsPerTestingTool(data, { width }) {
  const sortOtherToEnd = Array.from(data).sort((a, b) => {
    // Ensure "Other" is always last
    if (a.testing_tool === "Other") return 1;
    if (b.testing_tool === "Other") return -1;
    // Otherwise, sort by percentage descending
    return b.percentage - a.percentage;
  });

  return Plot.plot({
    title: "By Qa/Testing",
    height: 600,
    width: width,
    marginLeft: 200,

    marginRight: 50,

    x: {
      label: "Percentage of participants",
    },
    y: {
      label: "Testing Tool",
      grid: true,
      domain: sortOtherToEnd.map((d) => d.testing_tool),
    },

    marks: [
      Plot.barX(data, {
        y: "testing_tool",
        x: "percentage",
        fill: (d) => (d.testing_tool === "Other" ? "#EFB118" : "#4269D0"),
        sort: { y: "-x" },
        tip: true,
      }),
    ],
  });
}
```

```sql id=ia_use

SELECT que_tanto_estas_usando_copilotchatgpt_u_otras_herramientas_de_ia_para_tu_trabajo AS ia_use,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
WHERE que_tanto_estas_usando_copilotchatgpt_u_otras_herramientas_de_ia_para_tu_trabajo IS NOT NULL
GROUP BY que_tanto_estas_usando_copilotchatgpt_u_otras_herramientas_de_ia_para_tu_trabajo

```

```js
function iaUse(data, { width }) {
  return Plot.plot({
    title: "By AI use",
    height: 600,
    width: width,
    marginLeft: 50,
    marginRight: 50,
    x: {
      label: "Amount of participants",
    },
    y: {
      label: "AI use",
    },

    marks: [
      Plot.barY(data, {
        y: "percentage",
        x: "ia_use",
        sort: { x: "-y" },
        tip: true,
      }),

      Plot.text(data, {
        x: "percentage",
        y: "ia_use",
        text: (d) => `${d.percentage}%`,
        dx: 40,
        align: "left",
        baseline: "middle",
        color: "black",
        font: "Arial",
        fontSize: 12,
      }),
    ],
  });
}
```
