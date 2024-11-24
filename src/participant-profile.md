---
title: Participant profile
sql: 
  db: ./data/2024-01.csv 
---

```ts
import type * as PlotType from "@observablehq/plot";
let PlotTyped: typeof PlotType = Plot;
```

### From where are the participants?


```sql id=percentage_per_region 

SELECT donde_estas_trabajando AS region, COUNT(*) AS total_count, ROUND((COUNT(*)/SUM(COUNT(*)) OVER ()) * 100, 2) AS percentage
FROM "db"
GROUP BY donde_estas_trabajando

```

```ts 
const salaryDistribution = PlotTyped.plot({
  height: 600,
  width: 800,   
  marginLeft: 200,
  marginRight: 100,    
  x: {
    label: "Amount of participants"
  },
  y: {
    label: "Region"
  },
  marks: [
    PlotTyped.barX(percentage_per_region, {x: "percentage", y: "region", sort: {y: "-x"}, tip: true, title: (d: any) => `Total count: ${d.total_count}`}),
    PlotTyped.text(percentage_per_region, {x: "percentage", y: "region", text: d => `${d.percentage.toFixed(2)} %`, dx: 30, textAnchor: "middle"})
  ]
})


display(salaryDistribution)
```

<!-- ```js

const seeAll = view(Inputs.checkbox(["seeAll"], {label: "See all data"}))

``` -->

### By role

```sql id=roles
WITH role_data AS (
  SELECT trabajo_de AS role, COUNT(*) AS total_count, ROUND((COUNT(*)/SUM(COUNT(*)) OVER ()) * 100, 2) AS percentage
  FROM "db"
  GROUP BY trabajo_de
),
filtered_roles AS (
  SELECT role, total_count, percentage
  FROM role_data
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS role, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM role_data
  WHERE percentage < 1
)
SELECT * 
FROM filtered_roles
ORDER BY 
  CASE WHEN role = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js

const sortOtherToEnd = Array.from(roles).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.role === "Other") return 1;
  if (b.role === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});

const roleDistribution = Plot.plot({
  height: 600,
  width: 800,   
  marginLeft: 200,
  marginRight: 100,    
  x: {
    label: "Percentage of participants",

  },
  y: {
    label: "Role",
    domain: sortOtherToEnd.map(d => d.role) // Use sorted order for roles

  },
  marks: [
    Plot.barX(roles, {x: "percentage", y: "role", tip: true, title: d => `Total count: ${d.total_count}`, fill: (d) => d.role === "Other" ? "yellow" : "purple"}),
    Plot.text(roles, {x: "percentage", y: "role", text: d => `${d.percentage.toFixed(2)} %`, dx: 30, textAnchor: "middle"})
  ]
})


display(roleDistribution)
```

### By experience

```sql id=experience 

SELECT 
  CASE 
    WHEN anos_de_experiencia < 1 THEN '< 1 year'
    WHEN anos_de_experiencia BETWEEN 1 AND 3 THEN '1-3 years'
    WHEN anos_de_experiencia BETWEEN 4 AND 6 THEN '4-6 years'
    WHEN anos_de_experiencia BETWEEN 7 AND 10 THEN '7-10 years'
    WHEN anos_de_experiencia BETWEEN 10 and 15 THEN '10-15 years'
    WHEN anos_de_experiencia BETWEEN 15 and 20 THEN '15-20 years'
    WHEN anos_de_experiencia BETWEEN 20 and 25 THEN '20-25 years'
    ELSE '> 25 years'
  END AS experience_interval,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
FROM "db"
GROUP BY experience_interval
ORDER BY experience_interval
```

```js


// Create a grouped histogram
const experienceDistribution = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 200,
  marginRight: 100,
  x: {
    label: "Percentage of Participants",

  },
  y: {
    label: "Experience Interval (years)",
    domain: ["< 1 year", "1-3 years", "4-6 years", "7-10 years", "10-15 years", "15-20 years", "20-25 years", "> 25 years"]
  },
  marks: [
    Plot.barX(experience, { 
      x: "percentage", 
      y: "experience_interval", 

      title: d => `Total count: ${d.total_count}` 
    }),
    Plot.text(experience, { 
      x: "percentage", 
      y: "experience_interval", 
      text: d => `${d.percentage.toFixed(3)}%`, 
      dx: 10, 
      textAnchor: "start", 

    })
  ]
});

experienceDistribution;


display(experienceDistribution)
```



### Years in current company

```sql id=years_in_company

SELECT 
  CASE 
    WHEN antiguedad_en_la_empresa_actual < 1 THEN '< 1 year'
    WHEN antiguedad_en_la_empresa_actual BETWEEN 1 AND 3 THEN '1-3 years'
    WHEN antiguedad_en_la_empresa_actual BETWEEN 4 AND 6 THEN '4-6 years'
    WHEN antiguedad_en_la_empresa_actual BETWEEN 7 AND 10 THEN '7-10 years'
    WHEN antiguedad_en_la_empresa_actual BETWEEN 10 and 15 THEN '10-15 years'
    WHEN antiguedad_en_la_empresa_actual BETWEEN 15 and 20 THEN '15-20 years'
    WHEN antiguedad_en_la_empresa_actual BETWEEN 20 and 25 THEN '20-25 years'
    ELSE '> 25 years'
  END AS years_in_company_interval,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage

FROM "db"
GROUP BY years_in_company_interval
ORDER BY years_in_company_interval
```

```js


// Create a grouped histogram
const yearsInCompanyDistribution = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 200,
  marginRight: 100,
  x: {
    label: "Percentage of Participants",

  },
  y: {
    label: "Years in Company Interval",
    domain: ["< 1 year", "1-3 years", "4-6 years", "7-10 years", "10-15 years", "15-20 years", "20-25 years", "> 25 years"]
  },
  marks: [
    Plot.barX(years_in_company, { 
      x: "percentage", 
      y: "years_in_company_interval", 

      title: d => `Total count: ${d.total_count}` 
    }),
    Plot.text(years_in_company, { 
      x: "percentage", 
      y: "years_in_company_interval", 
      text: d => `${d.percentage.toFixed(3)}%`, 
      dx: 10, 
      textAnchor: "start", 

    })
  ]
});

display(yearsInCompanyDistribution);
```

### By education level

```sql id=education_level

SELECT 
  maximo_nivel_de_estudios AS education_level, 
  estado AS education_status, 
  COUNT(*) AS total_count, 
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
FROM "db"
WHERE maximo_nivel_de_estudios IS NOT NULL
GROUP BY education_level, estado

```

```js
const educationLevelDistribution = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 200,

  x: {
    label: "Percentage of Participants",

  },
  y: {
    label: "Education Level"
  },
  color: {
    legend: true,
    label: "Education Status",
    scheme: "Observable10"
  },
  marks: [
    Plot.barX(education_level, {
      x: "percentage",
      y: "education_level",
      z: "education_status", 
      fill: "education_status",
      sort: {y: "-x"},
      title: d => `${d.education_status}: ${d.percentage.toFixed(3)}%`
    }),
  ]
});

display(educationLevelDistribution);
```


### Most common career paths

```sql id=career_paths

WITH career_path_data AS (
  SELECT 
    carrera AS career_path, 
    COUNT(*) AS total_count, 
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
  FROM "db"
  WHERE carrera IS NOT NULL
  GROUP BY career_path
),

filtered_career_paths AS (
  SELECT career_path, total_count, percentage
  FROM career_path_data
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS career_path, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM career_path_data
  WHERE percentage < 1
)

SELECT *
FROM filtered_career_paths
ORDER BY 
  CASE WHEN career_path = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js

const sortOtherToEndCareerPaths = Array.from(career_paths).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.career_path === "Other") return 1;
  if (b.career_path === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});

const careerPathsDistribution = Plot.plot({
  height: 600,
  width: 800,   
  marginLeft: 200,
  marginRight: 100,    
  x: {
    label: "Percentage of participants",

  },
  y: {
    label: "Career Path",
    domain: sortOtherToEndCareerPaths.map(d => d.career_path) // Use sorted order for career paths

  },
  marks: [
    Plot.barX(career_paths, {x: "percentage", y: "career_path", tip: true, title: d => `Total count: ${d.total_count}`, fill: (d) => d.career_path === "Other" ? "yellow" : "purple"}),
    Plot.text(career_paths, {x: "percentage", y: "career_path", text: d => `${d.percentage.toFixed(2)} %`, dx: 30, textAnchor: "middle"})
  ]
})

display(careerPathsDistribution)
```


### Most common universities

```sql id=universities

WITH university_data AS (
  SELECT 
    institucion_educativa AS university, 
    COUNT(*) AS total_count, 
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
  FROM "db"
  WHERE institucion_educativa IS NOT NULL
  GROUP BY university
),

filtered_universities AS (
  SELECT university, total_count, percentage
  FROM university_data
  WHERE percentage >= 1
  UNION ALL
  SELECT 'Other' AS university, SUM(total_count) AS total_count, SUM(percentage) AS percentage
  FROM university_data
  WHERE percentage < 1
)

SELECT *
FROM filtered_universities
ORDER BY 
  CASE WHEN university = 'Other' THEN 1 ELSE 0 END, 
  percentage DESC;
```

```js

const sortOtherToEndUniversities = Array.from(universities).sort((a, b) => {
  // Ensure "Other" is always last
  if (a.university === "Other") return 1;
  if (b.university === "Other") return -1;
  // Otherwise, sort by percentage descending
  return b.percentage - a.percentage;
});

const universitiesDistribution = Plot.plot({
  height: 600,
  width: 800,   
  marginLeft: 400,
  marginRight: 100,    
  x: {
    label: "Percentage of participants",

  },
  y: {
    label: "University",
    domain: sortOtherToEndUniversities.map(d => d.university) // Use sorted order for universities

  },
  marks: [
    Plot.barX(universities, {x: "percentage", y: "university", tip: true, title: d => `Total count: ${d.total_count}`, fill: (d) => d.university === "Other" ? "yellow" : "purple"}),
    Plot.text(universities, {x: "percentage", y: "university", text: d => `${d.percentage.toFixed(2)} %`, dx: 30, textAnchor: "middle"})
  ]
})

display(universitiesDistribution)
```


### By gender

```sql id=gender

WITH gender As (
SELECT
  genero AS gender, 
  COUNT(*) AS total_count, 
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
FROM "db"
GROUP BY genero
)


SELECT *
FROM gender
WHERE percentage > 0.1
ORDER BY percentage DESC

    
```

```js

const genderDistribution = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 100,

  x: {
    label: "Percentage of Participants",

  },
  y: {
    label: "Gender"
  },

  marks: [
    Plot.barX(gender, {
      x: "percentage",
      y: "gender",
      sort: {y: "-x"},
      title: d => `${d.gender}: ${d.percentage.toFixed(3)}%`
    }),
  ]
});

display(genderDistribution);

```
