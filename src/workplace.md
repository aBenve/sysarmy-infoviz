---
title: workplace
sql: 
  db: ./data/2024-01.csv 
---


### By type of contract


```sql id=contract_type

SELECT tipo_de_contrato AS contract_type, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
WHERE tipo_de_contrato IS NOT NULL
GROUP BY tipo_de_contrato

```

```js

const contractType = Plot.plot({
  height: 400,
  width: 800,   
  marginLeft: 330,
  marginRight: 100,    
  x: {
    label: "Amount of participants"
  },
  y: {
    label: "Contract type"
  },
  
  marks: [
    Plot.barX(contract_type, {
        x: "percentage",
        y: "contract_type",
        sort: { y: "-x" },
        tip: true
    }),

    Plot.text(contract_type, {
      x: "percentage",
      y: "contract_type",
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


display(contractType)

```


### By amount of salary in dollars

```sql id=salary_in_dollars display

SELECT 
    COALESCE(pagos_en_dolares, 'No Dolarizado') AS salary_in_dollars, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY pagos_en_dolares

```

```js

const salaryInDollars = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 320,
  marginRight: 100,
  marks: [
  Plot.barX(salary_in_dollars, {
    x: "percentage",
    y: "salary_in_dollars",
    sort: { y: "-x" },
    tip: true
  }),
  Plot.text(salary_in_dollars, {
    text: d => `${d.salary_in_dollars}: ${d.percentage}%`,
    dy: 5,
    dx: 5,
    font: "Arial",
    fontSize: 12,
    fill: "black"
  })
  ]
})

display(salaryInDollars)

```

### By amount of guards

```sql id=amount_of_guards

SELECT 
    CASE tenes_guardias
        WHEN 'Sí, pasiva' THEN 'Yes, passive'
        WHEN 'Sí, activa' THEN 'Yes, active'
        WHEN 'No' THEN 'No'
        ELSE 'Unknown'
    END AS amount_of_guards, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
WHERE tenes_guardias IS NOT NULL
GROUP BY tenes_guardias

```

```js

const amountOfGuards = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 200,
  marginRight: 100,
  marks: [
    Plot.barX(amount_of_guards, {
        x: "percentage",
        y: "amount_of_guards",
        sort: { y: "-x" },
      tip: true
    }),
    Plot.text(amount_of_guards, {
      text: d => `${d.amount_of_guards}: ${d.percentage}%`,
      dy: 5,
      dx: 5,
      font: "Arial",
      fontSize: 12,
      fill: "black"
    })
  ]
})

display(amountOfGuards)

```
### Top 10 best salary

Para que este grafico sea correcto hay que limpiar los datos. Hay un muchacho/a que propone que cobra 440M de pesos.

```sql id=top_10_roles_salary display

WITH median_salary_cte AS (
  SELECT 
    trabajo_de AS role,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos) AS median_salary
  FROM db
  WHERE ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
  GROUP BY trabajo_de
)

SELECT 
  db.trabajo_de AS role,
  db.ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos AS salary,
  AVG(db.ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos) OVER (PARTITION BY db.trabajo_de) AS avg_salary,
  median_salary_cte.median_salary
FROM db
JOIN median_salary_cte ON db.trabajo_de = median_salary_cte.role
WHERE db.ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos IS NOT NULL
GROUP BY db.trabajo_de, db.ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos, median_salary_cte.median_salary
ORDER BY salary DESC
LIMIT 10

```

```js

const top10RolesSalary = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 200,
  marginRight: 100,
    
  marks: [
      Plot.barX(top_10_roles_salary, {
        x: "salary",
        y: "role",
        sort: { y: "-x" },
        tip: true
      }),
  ]
})

display(top10RolesSalary)

```


### By bonus

```sql id=by_bonus

SELECT 
  COALESCE(recibis_algun_tipo_de_bono, 'No Bonus') AS bonus, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY recibis_algun_tipo_de_bono

```

```js

const bonus = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 320,
  marginRight: 100,
  marks: [
      Plot.barX(by_bonus, {
          x: "percentage",
          y: "bonus",
          sort: { y: "-x" },
          tip: true
      })
  ]
})

display(bonus)

```

### By benefits

```sql id=by_benefits 

WITH normalized_benefits AS (
  SELECT
    LOWER(TRIM(UNNEST(STRING_TO_ARRAY(contas_con_beneficios_adicionales, ',')))) AS benefit
  FROM db
  WHERE contas_con_beneficios_adicionales IS NOT NULL
),
aggregated_benefits AS (
  SELECT
    benefit,
    COUNT(*) AS total_count,
    ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
  FROM normalized_benefits
  WHERE benefit != ''
  GROUP BY benefit
)
SELECT *
FROM aggregated_benefits
WHERE total_count > 60
ORDER BY percentage DESC;

```

```js

const benefits = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 320,
  marginRight: 100,
  marks: [
      Plot.barX(by_benefits, {
          x: "percentage",
          y: "benefit",
          sort: { y: "-x" },
          tip: true
      })
  ]
})

display(benefits)

```

### By amount of employees

```sql id=amount_of_employees

SELECT 
  COALESCE(cantidad_de_personas_en_tu_organizacion, 'Unknown') AS amount_of_employees, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY cantidad_de_personas_en_tu_organizacion

```

```js

const amountOfEmployees = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 320,
  marginRight: 100,
  marks: [
      Plot.barX(amount_of_employees, {
          x: "percentage",
          y: "amount_of_employees",
          sort: { y: "-x" },
          tip: true
      })
  ]
})

display(amountOfEmployees)

```

### By work modalities

```sql id=work_modalities

SELECT 
  COALESCE(modalidad_de_trabajo, 'Unknown') AS work_modalities, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY modalidad_de_trabajo

```

```js

const workModalities = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 320,
  marginRight: 100,
  marks: [
      Plot.barX(work_modalities, {
          x: "percentage",
          y: "work_modalities",
          sort: { y: "-x" },
          tip: true
      }),
  ]
})

display(workModalities)

```

### By happiness in the workplace

```sql id=happiness_in_workplace display

SELECT 
  CASE 
      WHEN la_recomendas_como_un_buen_lugar_para_trabajar BETWEEN 0 AND 5  THEN 'Not recommended'
      WHEN la_recomendas_como_un_buen_lugar_para_trabajar BETWEEN 6 AND 7  THEN 'Neutral'
      WHEN la_recomendas_como_un_buen_lugar_para_trabajar BETWEEN 8 AND 10 THEN  'Recommended'
      ELSE 'Unknown'
  END AS happiness_in_workplace, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY happiness_in_workplace

```

```js

const happinessInWorkplace = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 320,
  marginRight: 100,
  marks: [
      Plot.barX(happiness_in_workplace, {
          x: "percentage",
          y: "happiness_in_workplace",
          sort: { y: "-x" },
          tip: true
      })
  ]
})

display(happinessInWorkplace)

```

### By discomfort in the workplace

```sql id=discomfort_in_workplace

SELECT 
  COALESCE(estas_buscando_trabajo, 'Unknown') AS discomfort_in_workplace, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY discomfort_in_workplace

```

```js

const discomfortInWorkplace = Plot.plot({
  height: 400,
  width: 800,
  marginLeft: 320,
  marginRight: 100,
  marks: [
      Plot.barX(discomfort_in_workplace, {
          x: "percentage",
          y: "discomfort_in_workplace",
          sort: { y: "-x" },
          tip: true
      }),
  ]
})

display(discomfortInWorkplace)

```
