---
title: Workplace
theme: dashboard
toc: false

sql: 
  db: ./data/2024-01.csv 
---

# Workplace

In this section we will analyze the data related to the workplace.

### By type of contract

```sql id=contract_type

SELECT tipo_de_contrato AS contract_type, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
WHERE tipo_de_contrato IS NOT NULL
GROUP BY tipo_de_contrato

```

<div class="grid grid-cols-2">
  <div class="card">
    ${resize((width) => contractType(contract_type, {width}))}
  </div>
    <div class="card">
    ${resize((width) => salaryInDollars(salary_in_dollars, {width}))}
  </div>
    
<div class="card">
    ${resize((width) => amountOfGuards(amount_of_guards, {width}))}
  </div>   
<div class="card">
    ${resize((width) => top10RolesSalary(top_10_roles_salary, {width}))}
  </div>   
</div>

```js

function contractType(data, {width}){
  return Plot.plot({
          title: "By type of contract",
          height: 200,
          width: width,   
          marginLeft: 300,
          marginRight: 70,
          x: {
            label: "Amount of participants"
          },
          y: {
            label: "Contract type"
          },
          
          marks: [
            Plot.barX(data, {
                x: "percentage",
                y: "contract_type",
                sort: { y: "-x" },
                tip: true
            }),

            Plot.text(data, {
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

}


```


<!-- ### By amount of salary in dollars -->

```sql id=salary_in_dollars

SELECT 
    COALESCE(pagos_en_dolares, 'No Dolarizado') AS salary_in_dollars, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY pagos_en_dolares

```

```js

function salaryInDollars(data, {width}) {
    return Plot.plot({
      height: 200,
        title: "By amount of salary in dollars",
      width: width,
      marginLeft: 290,

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
}

```

<!-- ### By amount of guards -->

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

function amountOfGuards(data, {width}){
  return  Plot.plot({
        title: "By guards",
      height: 200,
      width: width,
      marginLeft: 200,
      marginRight: 100,
      marks: [
        Plot.barX(data, {
            x: "percentage",
            y: "amount_of_guards",
            sort: { y: "-x" },
          tip: true
        }),
        Plot.text(data, {
          text: d => `${d.amount_of_guards}: ${d.percentage}%`,
          dy: 5,
          dx: 5,
          font: "Arial",
          fontSize: 12,
          fill: "black"
        })
      ]
    })
}


```
<!-- ### Top 10 best salary -->

```sql id=top_10_roles_salary

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

function top10RolesSalary(data, {width}) {
  return Plot.plot({
    title: "Top 10 best salary",
    height: 200,
    width: width,
    marginLeft: 150,
    marginRight: 10,
    color: {
      legend: true,
      domain: ["Average Salary", "Median Salary"],
      range: ["red", "white"],
      label: "Salary Type"
    },
    marks: [
      Plot.barX(data, {
        x: "avg_salary",
        y: "role",
        opacity: 0.7,
        fill: "red",
        sort: { y: "-x" },
        tip: true
      }),
      Plot.barX(data, {
        x: "median_salary",
        y: "role",
        fill: "white",
        opacity: 0.7,
        sort: { y: "-x" },
        tip: true
      })
    ]
  });
}


```


### By compensation
This section will analyze the data related to compensation, like bonuses and benefits.



<div class="grid grid-cols-2">
  <div class="card">
    ${resize((width) => bonus(by_bonus, {width}))}
  </div>
    <div class="card">
    ${resize((width) => benefits(by_benefits, {width}))}
  </div>
      
</div>

```sql id=by_bonus

SELECT 
  COALESCE(recibis_algun_tipo_de_bono, 'No Bonus') AS bonus, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY recibis_algun_tipo_de_bono

```

```js

function bonus(data, {width}) {return Plot.plot({
  title: "By bonus",
  height: 400,
  width: width,
  marginLeft: 150,
  marks: [
      Plot.barX(by_bonus, {
          x: "percentage",
          y: "bonus",
          sort: { y: "-x" },
          tip: true
      })
  ]
})}

```

<!-- ### By benefits -->

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
WHERE total_count > 60 AND benefit != 'etc)' AND benefit != 'ualá)'
ORDER BY percentage DESC;

```

```js

function benefits(data, {width}){ return Plot.plot({
  title: "By benefits",
  height: 400,
  width: width,
  marginLeft: 300,

  marks: [
      Plot.barX(by_benefits, {
          x: "percentage",
          y: "benefit",
          sort: { y: "-x" },
          tip: true
      })
  ]
})}

```

### By company 

<div class="grid grid-cols-2">
  <div class="card">
    ${resize((width) => amountOfEmployees(amount_of_employees, {width}))}
  </div>
  <div class="card">
    ${resize((width) => workModalities(work_modalities, {width}))}
  </div>
  <div class="card">
    ${resize((width) => happinessInWorkplace(happiness_in_workplace, {width}))}
  </div>
  <div class="card">
    ${resize((width) => discomfortInWorkplace(discomfort_in_workplace, {width}))}
  </div>
      
</div>

```sql id=amount_of_employees

SELECT 
  COALESCE(cantidad_de_personas_en_tu_organizacion, 'Unknown') AS amount_of_employees, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY cantidad_de_personas_en_tu_organizacion

```

```js

function amountOfEmployees (data, {width}) { return Plot.plot({
  title: "By amount of employees",
  height: 400,
  width: width,
  marginLeft: 180,

  marks: [
      Plot.barX(data, {
          x: "percentage",
          y: "amount_of_employees",
          sort: { y: "-x" },
          tip: true
      })
  ]
})}

```

<!-- ### By work modalities -->

```sql id=work_modalities

SELECT 
  COALESCE(modalidad_de_trabajo, 'Unknown') AS work_modalities, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY modalidad_de_trabajo

```

```js

function workModalities(data, {width}) {return  Plot.plot({
  title: "By work modalities",
  height: 400,
  width: width,


  marks: [
      Plot.barY(data, {
          y: "percentage",
          x: "work_modalities",
          sort: { x: "-y" },
          tip: true
      }),
  ]
})}

```

<!-- ### By happiness in the workplace -->

```sql id=happiness_in_workplace 

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

function happinessInWorkplace(data, {width})  {return Plot.plot({
  title: "By happiness in the workplace",
  height: 400,
  width: width,

    x: {
      label: "Different levels of happiness"
    },

    y: {
      label: "Amount of participants"
    },
    
  marks: [
      Plot.barY(data, {
          y: "percentage",
          x: "happiness_in_workplace",
          sort: { x: "-y" },
          tip: true
      })
  ]
})}

```

<!-- ### By discomfort in the workplace -->

```sql id=discomfort_in_workplace

SELECT 
  COALESCE(estas_buscando_trabajo, 'Unknown') AS discomfort_in_workplace, 
  COUNT(*) AS total_count,
  ROUND((COUNT(*) * 1.0 / SUM(COUNT(*)) OVER ()) * 100, 1) AS percentage
FROM db
GROUP BY discomfort_in_workplace

```

```js

function discomfortInWorkplace(data, {width}) {return Plot.plot({
  title: "By discomfort in the workplace",
  width: width,
    
    x: {
      label: "Different levels of discomfort"
    },

    y: {
      label: "Amount of participants"
    },

  marks: [
      Plot.barY(data, {
          y: "percentage",
          x: "discomfort_in_workplace",
          sort: { x: "-y" },
          tip: true
      }),
  ]
})}

```
