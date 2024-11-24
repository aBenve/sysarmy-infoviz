---
title: Gender
sql: 
  db: ./data/salary-survey-2024.csv 
---


### By Gender identity

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

const salaryDistribution = Plot.plot({
  height: 400,
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
    Plot.barX(gender_identity, {x: "percentage", y: "gender", sort: {y: "-x"}, tip: d => `Total count: ${d.total_count}`}),
    Plot.text(gender_identity, {x: "percentage", y: "gender", text: d => `${d.percentage.toFixed(2)} %`, dx: 30, textAnchor: "middle"})
  ]
})


display(salaryDistribution)
```

Claramente los Hombre Cis y Mujeres Cis son la mayoria de los participantes, asi que vamos a tener en cuenta solo estos a partir de ahora.

### Page gap between man and woman

```sql id=wage_gap

WITH gender As (
SELECT
  genero AS gender,
  AVG(ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos) AS average_salary,
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

const salaryDistribution = Plot.plot({
  height: 400,
  width: 800,   
  marginLeft: 200,
  marginRight: 100,    
  x: {
    label: "Amount of participants"
  },
  y: {
    label: "Region"
  },
  color: {
    legend: true,
    label: "Seniority",
    domain: ["Junior", "Semi-Senior", "Senior"],
    scheme: "Observable10",
  },
  marks: [
    Plot.barX(wage_gap, {
        x: "average_salary",
        y: "gender",
        fy: "seniority", //TODO: lo sacamos?
        fill: "seniority",
        sort: { y: "-x" },
        tip:true
    }),
  ]
})

display(salaryDistribution)

```

### Historic pacticipation
TODO
### Historic salaries
TODO
### Historic accordance
TODO

### By studies and completition

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

const studiesCompletionChart = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 150,
  marginRight: 100,
  x: {
    label: "Percentage"
  },
  y: {
    label: "Education Level"
  },
  color: {
    legend: true,
    label: "Education Status",
    domain: ["Completo", "En curso", "Incompleto"],
    scheme: "Observable10",
  },
  marks: [
    Plot.barX(studies_and_completition, {
      x: "percentage",
      y: "education_level",
      fy: "gender",
      fill: "education_status",
      sort: { y: "-x" },
      tip: d => `Total count: ${d.total_count}`
    }),
  ]
})

display(studiesCompletionChart)

```

### Salaries by experience

```sql id=studies


WITH gender As (
SELECT
  genero AS gender,
  anos_de_experiencia AS experience,
  AVG(ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos) AS average_salary,
  COUNT(*) AS total_count, 
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
FROM "db"
GROUP BY genero, anos_de_experiencia
)


SELECT *
FROM gender
WHERE percentage > 1
ORDER BY experience DESC

```

```js 

const studiesLineChart = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 100,
  marginRight: 100,
  x: {
    label: "Experience"
  },
  y: {
    label: "Average Salary"
  },

  color: {
    legend: true,
    label: "gender",
  },

  marks: [
    Plot.line(studies, {x: "experience", y: "average_salary", 
stroke: "gender", curve: "natural"}),
    Plot.dot(studies, {x: "experience", y: "average_salary", fill: "gender", r: 5, tip: d => `Average Salary: ${d.average_salary}`})
  ]
})

display(studiesLineChart)


```

### By participation and experience

```sql id=participation_experience

WITH participation AS (
SELECT
  genero AS gender,
  anos_de_experiencia AS experience,
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 3) AS percentage
FROM "db"
GROUP BY genero, anos_de_experiencia
)

SELECT *
FROM participation
WHERE percentage > 1
ORDER BY experience DESC

```

```js

const participationExperience = Plot.plot({
  height: 400,
  width: 800,   
  marginLeft: 100,
  marginRight: 100,    
  x: {
    label: "Amount of participants"
  },
  y: {
    label: "Experience"
  },
  
  marks: [
    Plot.barX(participation_experience, {
        x: "percentage",
        y: "experience",
        fill: "gender",
        tip:true
    }),
  ]
})

display(participationExperience)

```

### Historic participation by experience
TODO

### By accordance

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

const accordanceChart = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 150,
  marginRight: 100,
  x: {
    label: "Experience Bin",
    domain: ['0-1', '2-3', '4-5', '6-7', '8-9', '10-15', "15+"]
  },
  y: {
    label: "Accordance Level"
  },
  color: {
    legend: true,
    label: "Gender",
    domain: ["Hombre Cis", "Mujer Cis"],
    scheme: "Observable10",
  },
  marks: [
    Plot.line(accordance, {
      x: "experience_bin",
      y: "accordance_level",
      stroke: "gender",
      curve: "linear",
        tip: true
    }),
    Plot.dot(accordance, {
      x: "experience_bin",
      y: "accordance_level",
      r: "percentage",
      fill: "gender",
      r: 5,

    })
  ]
})

display(accordanceChart)

```

