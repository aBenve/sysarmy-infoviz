---
title: Salary distribution
sql: 
  db: ./data/salary-survey-2024.csv 
---

## General Salary Distribution


```sql id=salaries
SELECT ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos
FROM "db"

```

```js
const salaryDistribution = Plot.plot({
  height: 400,
  width: 800,
  x: {
    label: "Salary (in ARS)"
  },
  y: {
    label: "Frequency"
  },
  marks: [
        Plot.rectY(salaries, Plot.binX({y: "count"}, {x: "ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos"})),

  ]
})



display(salaryDistribution)
```