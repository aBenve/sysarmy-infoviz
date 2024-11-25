---
title: Gender
theme: dashboard
toc: false

sql:
  db: ./data/2024-01.csv
  historic: ./data/historic.csv
---

```js
var apesos = (v) => `$${v.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`;
```

# Gender

Now let's see if there is a difference in participation, salaries, and accordance

<div class="grid grid-cols-2">
  <div class="card">
      ${resize((width) => genderDistribution(gender_identity, {width}))}
  </div>
  <div class="card">
      ${resize((width) => salaryDistribution(wage_gap, {width}))}
  </div>
</div>
<div class="grid grid-cols-2">
  <div class="card">
      ${resize((width) => historicParticipation(historic_participation, {width}))}
  </div>
  <div class="card">
      ${resize((width) => historicSalaries(historic_salaries, {width}))}
  </div>
</div>
<div class="grid grid-cols-2">
  <div class="card">
      ${resize((width) => historicAccordance(historic_accordance, {width}))}
  </div>
  <div class="card">
      ${resize((width) => studiesCompletionChart(studies_and_completition, {width}))}
  </div>
</div>
<div class="grid grid-cols-2">
  <div class="card">
      ${resize((width) => studiesLineChart(studies, {width}))}
  </div>
  <div class="card">
      ${resize((width) => experienceParticipation(experience_participation, {width}))}
  </div>
</div>
<div class="card">
    ${resize((width) => accordanceChart(accordance, {width}))}
</div>

```sql id=gender_identity


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
function genderDistribution(data, { width }) {
  return Plot.plot({
    title: "By Gender identity",
    height: 400,
    width: width,
    marginLeft: 120,
    marginRight: 100,
    x: {
      label: "Amount of participants",
    },
    y: {
      label: "Region",
    },
    marks: [
      Plot.barX(data, {
        x: "percentage",
        y: "gender",
        sort: { y: "-x" },
        tip: true,
        title: (d) => `Total count: ${d.total_count}`,
      }),
      Plot.text(data, {
        x: "percentage",
        y: "gender",
        text: (d) => `${d.percentage.toFixed(2)} %`,
        dx: 30,
        textAnchor: "middle",
      }),
    ],
  });
}
```

```sql id=wage_gap

WITH gender As (
SELECT
  genero AS gender,
  median(ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos) AS average_salary,
  seniority,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
FROM "db"
GROUP BY genero, seniority
)


SELECT *
FROM gender
WHERE percentage > 1
ORDER BY percentage DESC
```

```js
function salaryDistribution(data, { width }) {
  return Plot.plot({
    title: "Wage gap between man and woman",
    height: 400,
    width: width,
    marginLeft: 100,
    marginRight: 100,
    x: {
      label: "Median Salary",
      tickFormat: apesos,
      ticks: 5,
    },
    y: {
      label: "Region",
    },
    grid: true,

    color: {
      legend: true,
      label: "Seniority",
      domain: ["Junior", "Semi-Senior", "Senior"],
      scheme: "Observable10",
    },
    marks: [
      Plot.barX(data, {
        x: "average_salary",
        y: "gender",
        fy: "seniority", //TODO: lo sacamos?
        fill: "seniority",
        sort: { y: "-x" },
        tip: {
          format: {
            x: apesos,
          },
        },
      }),
    ],
  });
}
```

```sql id=historic_participation
WITH all_historic_participation as (
  select genero as gender, fecha as date, count(*) as count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (partition by fecha)) * 100, 3) AS percentage
  from historic
  group by genero, fecha
)

SELECT *
FROM all_historic_participation
WHERE percentage >= 1
UNION ALL
(
    SELECT 'Other' AS gender, date, SUM(count)::int AS count, SUM(percentage) AS percentage
    FROM all_historic_participation
    WHERE percentage < 1
    group by date
)
order by date
```

```js
function historicParticipation(data, { width }) {
  const historicParticipationFixed = Array.from(data).map((o) => ({
    date: new Date(o.date),
    gender: o.gender,
    count: o.count,
  }));

  return Plot.plot({
    title: "Historic participation",
    height: 400,
    width: width,
    marginLeft: 50,
    marginRight: 50,
    y: {
      label: "Participation (%)",
      percent: true,
    },
    color: {
      legend: true,
      label: "Gender",
      scheme: "Observable10",
    },
    marks: [
      Plot.areaY(
        historicParticipationFixed,
        Plot.stackY(
          {
            offset: "normalize",
            order: "count",
            reverse: true,
          },
          {
            x: "date",
            y: "count",
            tip: true,
            fill: "gender",
          }
        )
      ),
      Plot.ruleY([0, 1]),
    ],
  });
}
```

```sql id=historic_salaries
WITH all_historic_salaries as (
  select genero as gender, fecha as date, array_agg(salario) as salary_sum, count(*) as count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (partition by fecha)) * 100, 3) AS percentage
  from historic
  group by genero, fecha
)

SELECT gender, date, list_median(salary_sum) as salary
from
(
    select *
    FROM all_historic_salaries
    WHERE percentage >= 1
    UNION ALL
    (
        SELECT 'Other' AS gender, date, flatten(array_agg(salary_sum)) AS salary_sum, SUM(count)::int AS count, SUM(percentage) AS percentage
        FROM all_historic_salaries
        WHERE percentage < 1
        group by date
    )
)
order by date
```

```js
function historicSalaries(data, { width }) {
  const historicSalariesFixed = Array.from(data).map((o) => ({
    date: new Date(o.date),
    gender: o.gender,
    salary: o.salary,
  }));

  return Plot.plot({
    title: "Historic salaries",
    height: 400,
    grid: true,
    width: width,
    marginLeft: 100,
    marginRight: 50,
    y: {
      label: "Salary",
      tickFormat: apesos,
    },
    color: {
      legend: true,
      label: "Gender",
      scheme: "Observable10",
    },
    marks: [
      Plot.lineY(historicSalariesFixed, {
        x: "date",
        y: "salary",
        stroke: "gender",
        tip: {
          format: {
            y: apesos,
          },
        },
      }),
    ],
  });
}
```

```sql id=historic_accordance
WITH all_historic_accordance as (
  select genero as gender, fecha as date, array_agg(conformidad::int) as conformities, count(*) as count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (partition by fecha)) * 100, 3) AS percentage
  from historic
  group by genero, fecha
)

SELECT gender, date, list_avg(conformities) as conformity
from
(
    select *
    FROM all_historic_accordance
    WHERE percentage >= 1
    UNION ALL
    (
        SELECT 'Other' AS gender, date, flatten(array_agg(conformities)) AS conformities, SUM(count)::int AS count, SUM(percentage) AS percentage
        FROM all_historic_accordance
        WHERE percentage < 1
        group by date
    )
)
order by date
```

```js
function historicAccordance(data, { width }) {
  const historicAccordanceFixed = Array.from(data).map((o) => ({
    date: new Date(o.date),
    gender: o.gender,
    conformity: o.conformity,
  }));

  return Plot.plot({
    title: "Historic accordance",
    height: 400,
    grid: true,
    width: width,
    marginLeft: 50,
    marginRight: 50,
    y: {
      label: "Accordance",
      domain: [0, 5],
    },
    color: {
      legend: true,
      label: "Gender",
      scheme: "Observable10",
    },
    marks: [
      Plot.lineY(historicAccordanceFixed, {
        x: "date",
        y: "conformity",
        tip: true,
        stroke: "gender",
        curve: "natural",
      }),
    ],
  });
}
```

```sql id=studies_and_completition


WITH studies AS (
SELECT
  genero AS gender,
  maximo_nivel_de_estudios AS education_level,
  estado AS education_status,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY genero)) * 100, 3) AS percentage
FROM "db"
WHERE maximo_nivel_de_estudios IS NOT NULL AND genero IN ('Hombre Cis', 'Mujer Cis')
GROUP BY genero, maximo_nivel_de_estudios, estado
)

SELECT *
FROM studies
WHERE percentage > 1
ORDER BY education_level, education_status
```

```js
function studiesCompletionChart(data, { width }) {
  return Plot.plot({
    title: "By studies and completition",
    height: 400,
    width: width,
    grid: true,

    marginLeft: 150,
    marginRight: 100,
    x: {
      label: "Percentage",
    },
    y: {
      label: "Education Level",
    },
    color: {
      legend: true,
      label: "Education Status",
      domain: ["Completo", "En curso", "Incompleto"],
      scheme: "Observable10",
    },
    marks: [
      Plot.barX(data, {
        x: "percentage",
        y: "education_level",
        fy: "gender",
        fill: "education_status",
        sort: { y: "-x" },
        tip: true,
        title: (d) => `Total count: ${d.total_count}`,
      }),
    ],
  });
}
```

```sql id=studies


WITH gender As (
SELECT
  genero AS gender,
  anos_de_experiencia AS experience,
  median(ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos) AS average_salary,
  COUNT(*) AS total_count
FROM "db"
where genero in ('Hombre Cis', 'Mujer Cis')
GROUP BY genero, anos_de_experiencia
)


SELECT *
FROM gender
ORDER BY experience DESC

```

```js
function studiesLineChart(data, { width }) {
  return Plot.plot({
    title: "Salaries by experience",
    height: 400,
    width: width,
    marginLeft: 100,
    marginRight: 100,
    grid: true,

    x: {
      label: "Experience",
    },
    y: {
      label: "Median Salary",
      tickFormat: apesos,
    },

    color: {
      legend: true,
      label: "gender",
    },

    marks: [
      Plot.line(data, {
        x: "experience",
        y: "average_salary",
        stroke: "gender",
        curve: "natural",
      }),
      Plot.dot(data, {
        x: "experience",
        y: "average_salary",
        fill: "gender",
        r: 5,
        tip: {
          format: {
            y: apesos,
          },
        },
        // title: d => `Median Salary: ${d.average_salary}`
      }),
    ],
  });
}
```

```sql id=experience_participation
WITH all_experience_participation AS (
SELECT
  genero AS gender,
  min(anos_de_experiencia) as experience_min,
  CASE
    WHEN anos_de_experiencia BETWEEN 0 AND 1 THEN '0-1'
    WHEN anos_de_experiencia BETWEEN 2 AND 3 THEN '2-3'
    WHEN anos_de_experiencia BETWEEN 4 AND 5 THEN '4-5'
    WHEN anos_de_experiencia BETWEEN 6 AND 7 THEN '6-7'
    WHEN anos_de_experiencia BETWEEN 8 AND 9 THEN '8-9'
    WHEN anos_de_experiencia BETWEEN 10 AND 15 THEN '10-15'
    ELSE '15+'
  END AS experience_bin,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY genero)) * 100, 3) AS percentage
FROM "db"
WHERE genero IN ('Hombre Cis', 'Mujer Cis')
GROUP BY genero, experience_bin
)

SELECT gender, experience_min, experience_bin, total_count
FROM all_experience_participation
WHERE percentage > 1
ORDER BY experience_min
```

```js
function experienceParticipation(data, { width }) {
  const experienceParticipationFixed = Array.from(data).map((o) => ({
    experience_bin: o.experience_bin,
    experience_min: o.experience_min,
    gender: o.gender,
    total_count: o.total_count,
  }));

  return Plot.plot({
    title: "Participation by experience",
    height: 400,
    width: width,
    marginLeft: 50,

    marginRight: 100,
    x: {
      label: "Experience Bin",
      domain: ["0-1", "2-3", "4-5", "6-7", "8-9", "10-15", "15+"],
    },
    y: {
      label: "Participation (%)",
      percent: true,
    },
    color: {
      legend: true,
      label: "Gender",
      scheme: "Observable10",
    },
    marks: [
      Plot.areaY(
        experienceParticipationFixed,
        Plot.stackY(
          {
            offset: "normalize",
            order: "experience_min",
          },
          {
            x: "experience_bin",
            y: "total_count",
            tip: true,
            fill: "gender",
          }
        )
      ),
      Plot.ruleY([0, 1]),
    ],
  });
}
```

```sql id=accordance
WITH accordance AS (
SELECT
  genero AS gender,
  AVG(que_tan_conforme_estas_con_tus_ingresos_laborales) AS accordance_level,
  CASE
    WHEN anos_de_experiencia BETWEEN 0 AND 1 THEN '0-1'
    WHEN anos_de_experiencia BETWEEN 2 AND 3 THEN '2-3'
    WHEN anos_de_experiencia BETWEEN 4 AND 5 THEN '4-5'
    WHEN anos_de_experiencia BETWEEN 6 AND 7 THEN '6-7'
    WHEN anos_de_experiencia BETWEEN 8 AND 9 THEN '8-9'
    WHEN anos_de_experiencia BETWEEN 10 AND 15 THEN '10-15'
    ELSE '15+'

  END AS experience_bin,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER (PARTITION BY genero)) * 100, 3) AS percentage
FROM "db"
WHERE que_tan_conforme_estas_con_tus_ingresos_laborales IS NOT NULL AND genero IN ('Hombre Cis', 'Mujer Cis')
GROUP BY genero, experience_bin
)

SELECT *
FROM accordance
WHERE percentage > 1
ORDER BY CASE
      WHEN experience_bin = '0-1' THEN 1
      WHEN experience_bin = '2-3' THEN 2
      WHEN experience_bin = '4-5' THEN 3
      WHEN experience_bin = '6-7' THEN 4
      WHEN experience_bin = '8-9' THEN 5
      WHEN experience_bin = '10-15' THEN 6
      ELSE 7
    END

```

```js
function accordanceChart(data, { width }) {
  return Plot.plot({
    title: "By accordance",
    height: 400,
    width: width,
    grid: true,

    marginLeft: 50,
    marginRight: 50,
    x: {
      label: "Experience Bin",
      domain: ["0-1", "2-3", "4-5", "6-7", "8-9", "10-15", "15+"],
    },
    y: {
      label: "Accordance Level",
      domain: [0, 5],
    },
    color: {
      legend: true,
      label: "Gender",
      domain: ["Hombre Cis", "Mujer Cis"],
      scheme: "Observable10",
    },
    marks: [
      Plot.line(data, {
        x: "experience_bin",
        y: "accordance_level",
        stroke: "gender",
        curve: "natural",
        tip: true,
      }),
      Plot.dot(data, {
        x: "experience_bin",
        y: "accordance_level",
        r: "percentage",
        fill: "gender",
        r: 5,
      }),
    ],
  });
}
```
