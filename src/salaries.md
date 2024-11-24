---
title: Salaries
sql: 
  db: ./data/2024.01.csv 
---

### Median Salaries
TODO

### By contract type and experience
This explains the difference in salaries if it is in dollars or pesos, and the difference in salaries in relation with the experience.

```sql id=salary_per_contract

WITH categorized_salaries AS (
    SELECT 
        seniority,
        CASE 
            WHEN si_tu_sueldo_esta_dolarizado_cual_fue_el_ultimo_valor_del_dolar_que_tomaron IS NOT NULL THEN 'dolarized'
            ELSE 'not dolarized'
        END AS salary_type,
        ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos AS salary
    FROM "db"
    WHERE 
        ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
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
    AVG(salary) AS median_salary
FROM ranked_salaries
WHERE 
    row_num IN ((total_count + 1) / 2, (total_count + 2) / 2) 
GROUP BY seniority, salary_type
ORDER BY seniority, salary_type;

```

```js

const salaryPerContract = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 100,
  marginRight: 100,

  x: {
    label: "Salary",

  },
  y: {
    label: "Contract type",
  },

  fy:{
    label: "Salary type",
    domain: ["Junior", "Semi-Senior", "Senior"],
    },
  marks: [
    Plot.barX(salary_per_contract, { 
      x: "median_salary", 
      y: "salary_type", 
      fy: "seniority",
      fill: "seniority",
        tip: true
    }),
  
  ]
});


display(salaryPerContract);
```


### By job title and experience

```sql id=salary_per_job_title
WITH categorized_salaries AS (
    SELECT 
        seniority,
        trabajo_de AS job_title,
        ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos AS salary
    FROM "db"
    WHERE 
        ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
        AND seniority IS NOT NULL
        AND trabajo_de IS NOT NULL
),

percentiles AS (
    SELECT 
        seniority,
        job_title,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary) AS q1,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) AS q3
    FROM categorized_salaries
    GROUP BY seniority, job_title
),

iqr_filtered AS (
    SELECT 
        c.seniority,
        c.job_title,
        c.salary,
        p.q1,
        p.q3,
        p.q3 - p.q1 AS iqr
    FROM categorized_salaries c
    INNER JOIN percentiles p
        ON c.seniority = p.seniority AND c.job_title = p.job_title
    WHERE c.salary BETWEEN (p.q1 - 3.5 * (p.q3 - p.q1)) AND (p.q3 + 3.5 * (p.q3 - p.q1))
),

ranked_salaries AS (
    SELECT 
        seniority,
        job_title,
        salary,
        ROW_NUMBER() OVER (PARTITION BY seniority, job_title ORDER BY salary) AS row_num,
        COUNT(*) OVER (PARTITION BY seniority, job_title) AS total_count
    FROM iqr_filtered
)

SELECT 
    seniority,
    job_title,
    AVG(salary) AS median_salary
FROM ranked_salaries
WHERE 
    row_num IN ((total_count + 1) / 2, (total_count + 2) / 2)
GROUP BY seniority, job_title
ORDER BY seniority, job_title;

```

```js

const salaryPerJobTitle = Plot.plot({
  height: 1000,
  width: 1000,
  marginLeft: 350,
  marginBottom: 100,
  marginRight: 50,

  x: {
    label: "Job Title",
  },
  y: {
    label: "Median Salary",
    grid: true,
  },
  color: {
    legend: true,
    label: "Seniority",
    domain: ["Junior", "Semi-Senior", "Senior"],
    scheme: "tableau10",
  },
  marks: [
    Plot.barX(salary_per_job_title, {
      y: "job_title",
      x: "median_salary", 
      fill: "seniority",
      title: (d) => `${d.seniority}: ${d.median_salary}`,
      sort: { y: "-x",  },
        tip: true
    }),
  ],
});


display(salaryPerJobTitle);
```
### By education and contract type

```sql id=salary_per_education_contract
WITH categorized_salaries AS (
  SELECT 
    maximo_nivel_de_estudios AS education_level,
    CASE 
      WHEN si_tu_sueldo_esta_dolarizado_cual_fue_el_ultimo_valor_del_dolar_que_tomaron IS NOT NULL THEN 'dolarized'
      ELSE 'not dolarized'
    END AS salary_type,
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE 
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
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
  AVG(salary) AS median_salary
FROM ranked_salaries
WHERE 
  row_num IN ((total_count + 1) / 2, (total_count + 2) / 2)
GROUP BY education_level, salary_type
ORDER BY education_level, salary_type;
```

```js
const salaryPerEducationContract = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 100,
  marginRight: 100,

  x: {
  label: "Salary",
  },
  y: {
  label: "Education Level",
  },

  fy: {
  label: "Salary type",
  domain: ["dolarized", "not dolarized"],
  },
  marks: [
  Plot.barX(salary_per_education_contract, { 
    x: "median_salary", 
    y: "education_level", 
    fy: "salary_type",
    fill: "salary_type",
    tip: true
  }),
  ]
});

display(salaryPerEducationContract);
```

### By career and experience

```sql id=salary_per_career_experience
WITH categorized_salaries AS (
  SELECT 
    seniority,
    carrera AS career,
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE 
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
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
  AVG(salary) AS median_salary
FROM ranked_salaries
WHERE 
  row_num IN ((total_count + 1) / 2, (total_count + 2) / 2)
GROUP BY seniority, career
ORDER BY seniority, career;
```

```js
const salaryPerCareerExperience = Plot.plot({
  height: 2600,
  width: 1000,
  marginLeft: 350,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Career",
  },
  y: {
  label: "Median Salary",
  grid: true,
  },
  color: {
  legend: true,
  label: "Seniority",
  domain: ["Junior", "Semi-Senior", "Senior"],
  scheme: "tableau10",
  },
  marks: [
  Plot.barX(salary_per_career_experience, {
    y: "career",
    x: "median_salary", 
    fill: "seniority",
    title: (d) => `${d.seniority}: ${d.median_salary}`,
    sort: { y: "-x" },
    tip: true
  }),
  ],
});

display(salaryPerCareerExperience);
```

### By technology and experience

```sql id=salary_per_technology_experience
WITH categorized_salaries AS (
  SELECT 
    seniority,
    UNNEST(STRING_TO_ARRAY(plataformas_que_utilizas_en_tu_puesto_actual, ','))::TEXT AS technology,
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE 
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
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
  AVG(salary) AS median_salary
FROM ranked_salaries
WHERE 
  row_num IN ((total_count + 1) / 2, (total_count + 2) / 2)
GROUP BY seniority, technology
ORDER BY seniority, technology;

```

```js
const salaryPerTechnologyExperience = Plot.plot({
  height: 7000,
  width: 1000,
  marginLeft: 350,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Technology",
  },
  y: {
  label: "Median Salary",
  grid: true,
  },
  color: {
  legend: true,
  label: "Seniority",
  domain: ["Junior", "Semi-Senior", "Senior"],
  scheme: "Observable10",
  },
  marks: [
  Plot.barX(salary_per_technology_experience, {
    y: "technology",
    x: "median_salary", 
    fill: "seniority",
    title: (d) => `${d.seniority}: ${d.median_salary}`,
    sort: { y: "-x" },
    tip: true
  }),
  ],
});

display(salaryPerTechnologyExperience);
```

### By programming languages and experience

```sql id=salary_per_language_experience display
WITH categorized_salaries AS (
  SELECT 
    seniority,
    UNNEST(STRING_TO_ARRAY(lenguajes_de_programacion_o_tecnologias_que_utilices_en_tu_puesto_actual, ','))::TEXT AS programming_language,
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos AS salary
  FROM "db"
  WHERE 
    ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
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
  AVG(salary) AS median_salary
FROM ranked_salaries
WHERE 
  row_num IN ((total_count + 1) / 2, (total_count + 2) / 2)
GROUP BY seniority, programming_language
ORDER BY seniority, programming_language;

```

```js
const salaryPerLanguageExperience = Plot.plot({
  height: 4000,
  width: 1000,
  marginLeft: 350,
  marginBottom: 100,
  marginRight: 50,

  x: {
  label: "Programming Language",
  },
  y: {
  label: "Median Salary",
  grid: true,
  },
  color: {
  legend: true,
  label: "Seniority",
  domain: ["Junior", "Semi-Senior", "Senior"],
  scheme: "tableau10",
  },
  marks: [
  Plot.barX(salary_per_language_experience, {
    y: "programming_language",
    x: "median_salary", 
    fill: "seniority",
    title: (d) => `${d.seniority}: ${d.median_salary}`,
    sort: { y: "-x" },
    tip: true
  }),
  ],
});

display(salaryPerLanguageExperience);
```
