---
title: Salaries
theme: dashboard
toc: false

sql:
  db: ./data/2024-01.csv
  historic: ./data/historic.csv
---

```js
var apesos = (v) => `$${v.toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ",")}`;
```

<div class="grid grid-cols-2">
    <div class="card">
        ${resize((width) => salaryBySemester(salary_per_semester, {width}))}
    </div>
    <div class="card">
        ${resize((width) => salaryPerContract(salary_per_contract, {width}))}
    </div>
</div>
<div class="card">
    ${resize((width) => salaryPerEducationContract(salary_per_education_contract, {width}))}
</div>
<div class="grid grid-cols-2">
    <div class="card">
        ${resize((width) => salaryPerJobTitle(salary_per_job_title, {width}))}
    </div>
    <div class="card">
        ${resize((width) => salaryPerCareerExperience(salary_per_career_experience, {width}))}
    </div>
</div>
<div class="grid grid-cols-2">
    <div class="card">
        ${resize((width) => salaryPerTechnologyExperience(salary_per_technology_experience, {width}))}
    </div>
    <div class="card">
        ${resize((width) => salaryPerLanguageExperience(salary_per_language_experience, {width}))}
    </div>
</div>

```sql id=salary_per_semester

SELECT
    median(salario) AS mean_salary,
    fecha AS date
FROM historic
GROUP BY date;

```

```js
function salaryBySemester(data, { width }) {
  let salaryPerSemesterFixed = Array.from(data).map((o) => ({
    date: new Date(o.date),
    mean_salary: o.mean_salary,
  }));
  return Plot.plot({
    title: "Median Salaries",
    height: 400,
    width: width,
    marginLeft: 100,
    marginRight: 100,

    x: {
      label: "Date",
    },
    y: {
      label: "Median Salary",
      tickFormat: apesos,
    },

    marks: [
      Plot.line(salaryPerSemesterFixed, {
        x: "date",
        y: "mean_salary",
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

```sql id=salary_per_contract

WITH categorized_salaries AS (
    SELECT
        seniority,
        CASE
            WHEN si_tu_sueldo_esta_dolarizado_cual_fue_el_ultimo_valor_del_dolar_que_tomaron IS NOT NULL THEN 'dolarized'
            ELSE 'not dolarized'
        END AS salary_type,
        ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos AS salary
    FROM "db"
    WHERE
        ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos IS NOT NULL
        AND seniority IS NOT NULL
),
ranked_salaries AS (
    SELECT
        seniority,
        salary_type,
        salary,
        ROW_NUMBER() OVER (PARTITION BY seniority, salary_type ORDER BY salary) AS row_num,
        COUNT(*) OVER (PARTITION BY seniority, salary_type) AS total_count
    FROM categorized_salaries
)
SELECT
    seniority,
    salary_type,
    median(salary) AS median_salary
FROM ranked_salaries
WHERE
    row_num IN ((total_count + 1) / 2, (total_count + 2) / 2)
GROUP BY seniority, salary_type
ORDER BY seniority, salary_type;

```

```js
function salaryPerContract(data, { width }) {
  return Plot.plot({
    title: "By contract type and experience",
    subtitle:
      "This explains the difference in salaries if it is in dollars or pesos, and the difference in salaries in relation with the experience.",
    height: 400,
    width: width,
    marginLeft: 100,
    marginRight: 100,

    x: {
      label: "Salary",
      tickFormat: apesos,
    },
    y: {
      label: "Contract type",
    },

    fy: {
      label: "Salary type",
      domain: ["Junior", "Semi-Senior", "Senior"],
    },
    marks: [
      Plot.barX(data, {
        x: "median_salary",
        y: "salary_type",
        fy: "seniority",
        fill: "seniority",
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

```sql id=salary_per_job_title
WITH categorized_salaries AS (
    SELECT
        seniority,
        trabajo_de AS job_title,
        ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos AS salary
    FROM "db"
    WHERE
        ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos IS NOT NULL
        AND seniority IS NOT NULL
        AND trabajo_de IS NOT NULL
),


ranked_salaries AS (
    SELECT
        seniority,
        job_title,
        salary,
        ROW_NUMBER() OVER (PARTITION BY seniority, job_title ORDER BY salary) AS row_num,
        COUNT(*) OVER (PARTITION BY seniority, job_title) AS total_count
    FROM categorized_salaries
)

SELECT
    seniority,
    job_title,
    median(salary) AS median_salary
FROM ranked_salaries
WHERE
    total_count > 10
GROUP BY seniority, job_title
ORDER BY seniority, job_title;

```

```js
function salaryPerJobTitle(data, { width }) {
  return Plot.plot({
    title: "By job title and experience",
    height: 1000,
    width: width,
    marginBottom: 100,
    marginRight: 300,
    grid: true,

    fy: {
      label: "Job Title",
    },
    y: {
      label: null,
    },
    x: {
      label: "Median Salary",
      tickFormat: apesos,
    },
    color: {
      legend: true,
      label: "Seniority",
      domain: ["Junior", "Semi-Senior", "Senior"],
      scheme: "observable10",
    },
    marks: [
      Plot.barX(data, {
        y: "seniority",
        x: "median_salary",
        fy: "job_title",
        fill: "seniority",
        title: (d) => `${d.seniority}: ${apesos(d.median_salary)}`,
        sort: { y: "-x" },
        tip: true,
      }),
      Plot.axisY({ ticks: [] }),
    ],
  });
}
```

```sql id=salary_per_education_contract
WITH categorized_salaries AS (
  SELECT
    maximo_nivel_de_estudios AS education_level,
    CASE
      WHEN si_tu_sueldo_esta_dolarizado_cual_fue_el_ultimo_valor_del_dolar_que_tomaron IS NOT NULL THEN 'dolarized'
      ELSE 'not dolarized'
    END AS salary_type,
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos IS NOT NULL
    AND maximo_nivel_de_estudios IS NOT NULL
),
ranked_salaries AS (
  SELECT
    education_level,
    salary_type,
    salary,
    ROW_NUMBER() OVER (PARTITION BY education_level, salary_type ORDER BY salary) AS row_num,
    COUNT(*) OVER (PARTITION BY education_level, salary_type) AS total_count
  FROM categorized_salaries
)
SELECT
  education_level,
  salary_type,
  median(salary) AS median_salary,
  total_count
FROM ranked_salaries
WHERE total_count > 20
GROUP BY education_level, salary_type, total_count
ORDER BY education_level, salary_type;
```

```js
function salaryPerEducationContract(data, { width }) {
  return Plot.plot({
    title: "By education and contract type",
    height: 400,
    width: width,
    marginLeft: 200,
    marginRight: 100,
    grid: true,

    x: {
      label: "Salary",
      tickFormat: apesos,
    },
    y: {
      label: "Education Level",
    },

    fy: {
      label: "Salary type",
      domain: ["dolarized", "not dolarized"],
    },
    marks: [
      Plot.barX(data, {
        x: "median_salary",
        y: "education_level",
        fy: "salary_type",
        // fill: "salary_type",
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

```sql id=salary_per_career_experience
WITH categorized_salaries AS (
  SELECT
    seniority,
    carrera AS career,
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos IS NOT NULL
    AND seniority IS NOT NULL
    AND carrera IS NOT NULL
),
ranked_salaries AS (
  SELECT
    seniority,
    career,
    salary,
    ROW_NUMBER() OVER (PARTITION BY seniority, career ORDER BY salary) AS row_num,
    COUNT(*) OVER (PARTITION BY seniority, career) AS total_count
  FROM categorized_salaries
)
SELECT
  seniority,
  career,
  median(salary) AS median_salary
FROM ranked_salaries
WHERE
    total_count > 10
GROUP BY seniority, career
ORDER BY seniority, career;
```

```js
function salaryPerCareerExperience(data, { width }) {
  return Plot.plot({
    title: "By career and experience",
    height: 1000,
    width: width,
    marginBottom: 100,
    marginRight: 300,
    grid: true,

    x: {
      label: "Median Salary",
      tickFormat: apesos,
    },
    y: {
      label: null,
    },
    fy: {
      label: "Career",
    },
    color: {
      legend: true,
      label: "Seniority",
      domain: ["Junior", "Semi-Senior", "Senior"],
      scheme: "observable10",
    },
    marks: [
      Plot.barX(data, {
        y: "seniority",
        fy: "career",
        x: "median_salary",
        fill: "seniority",
        title: (d) => `${d.seniority}: ${apesos(d.median_salary)}`,
        sort: { y: "-x" },
        tip: true,
      }),
      Plot.axisY({ ticks: [] }),
    ],
  });
}
```

```sql id=salary_per_technology_experience
WITH categorized_salaries AS (
  SELECT
    seniority,
    UNNEST(STRING_TO_ARRAY(plataformas_que_utilizas_en_tu_puesto_actual, ','))::TEXT AS technology,
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos IS NOT NULL
    AND seniority IS NOT NULL
    AND plataformas_que_utilizas_en_tu_puesto_actual IS NOT NULL
),
ranked_salaries AS (
  SELECT
    seniority,
    TRIM(technology) AS technology, -- Remove extra spaces
    salary,
    ROW_NUMBER() OVER (PARTITION BY seniority, TRIM(technology) ORDER BY salary) AS row_num,
    COUNT(*) OVER (PARTITION BY seniority, TRIM(technology)) AS total_count
  FROM categorized_salaries
)
SELECT
  seniority,
  technology,
  median(salary) AS median_salary
FROM ranked_salaries
WHERE
    total_count > 10
GROUP BY seniority, technology
ORDER BY seniority, technology;

```

```js
function salaryPerTechnologyExperience(data, { width }) {
  return Plot.plot({
    title: "By technology and experience",
    height: 1000,
    width: width,
    // marginLeft: 350,
    marginBottom: 100,
    marginRight: 100,
    grid: true,

    x: {
      label: "Median Salary",
      tickFormat: apesos,
      ticks: 5,
    },
    y: {
      label: null,
    },
    fy: {
      label: "Technology",
    },
    color: {
      legend: true,
      label: "Seniority",
      domain: ["Junior", "Semi-Senior", "Senior"],
      scheme: "Observable10",
    },
    marks: [
      Plot.barX(data, {
        y: "seniority",
        fy: "technology",
        x: "median_salary",
        fill: "seniority",
        title: (d) => `${d.seniority}: ${apesos(d.median_salary)}`,
        sort: { y: "-x" },
        tip: true,
      }),
      Plot.axisY({ ticks: [] }),
    ],
  });
}
```

```sql id=salary_per_language_experience
WITH categorized_salaries AS (
  SELECT
    seniority,
    UNNEST(STRING_TO_ARRAY(lenguajes_de_programacion_o_tecnologias_que_utilices_en_tu_puesto_actual, ','))::TEXT AS programming_language,
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE
    ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos IS NOT NULL
    AND seniority IS NOT NULL
    AND lenguajes_de_programacion_o_tecnologias_que_utilices_en_tu_puesto_actual IS NOT NULL
),
ranked_salaries AS (
  SELECT
    seniority,
    TRIM(programming_language) AS programming_language, -- Remove extra spaces
    salary,
    ROW_NUMBER() OVER (PARTITION BY seniority, TRIM(programming_language) ORDER BY salary) AS row_num,
    COUNT(*) OVER (PARTITION BY seniority, TRIM(programming_language)) AS total_count
  FROM categorized_salaries
)
SELECT
  seniority,
  programming_language,
  median(salary) AS median_salary
FROM ranked_salaries
WHERE
    total_count > 10
GROUP BY seniority, programming_language
ORDER BY seniority, programming_language;

```

```js
function salaryPerLanguageExperience(data, { width }) {
  return Plot.plot({
    title: "By programming languages and experience",
    height: 1000,
    width: width,
    //marginLeft: 350,
    marginBottom: 100,
    marginRight: 150,
    grid: true,

    x: {
      label: "Median Salary",
      tickFormat: apesos,
    },
    y: {
      label: null,
    },
    fy: {
      label: "Programming Language",
    },
    color: {
      legend: true,
      label: "Seniority",
      domain: ["Junior", "Semi-Senior", "Senior"],
      scheme: "observable10",
    },
    marks: [
      Plot.barX(data, {
        y: "seniority",
        fy: "programming_language",
        x: "median_salary",
        fill: "seniority",
        title: (d) => `${d.seniority}: ${apesos(d.median_salary)}`,
        sort: { y: "-x" },
        tip: true,
      }),
      Plot.axisY({ ticks: [] }),
    ],
  });
}
```
