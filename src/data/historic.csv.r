# process.stdout.write("jerston,test\n1,2\n3,4");


library(tidyverse)
library(lubridate)

read_semester <- function(year, semester) {
  library(readr)
  library(dplyr)

  read_csv(
    glue::glue("src/data/{sprintf('%04d', year)}.{sprintf('%02d', semester)}.csv"),
    col_types = cols(.default = col_character())
  ) |>
    mutate(
      año = year,
      semestre = semester,
    )
}

v <- read_semester(2016, 1) |>
  select(
    genero = Soy,
    salario = `Salario mensual (AR$)`,
    tipo_salario = `Bruto o neto?`,
    conformidad = `Qué tan conforme estás con tu sueldo?`,
    año,
    semestre,
  ) |>
  bind_rows(
    read_semester(2016, 2) |>
      select(
        genero = Soy,
        salario = `Salario mensual (en tu moneda local)`,
        tipo_salario = `Bruto o neto?`,
        conformidad = `Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2017, 1) |>
      select(
        genero = Soy,
        salario = `Salario mensual (en tu moneda local)`,
        tipo_salario = `Bruto o neto?`,
        conformidad = `Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2017, 2) |>
      select(
        genero = `Me identifico`,
        salario = `Salario mensual (en tu moneda local)`,
        tipo_salario = `¿Bruto o neto?`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2018, 1) |>
      select(
        genero = `Me identifico`,
        salario = `Salario mensual (en tu moneda local)`,
        tipo_salario = `¿Bruto o neto?`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2018, 2) |>
      select(
        genero = `Me identifico`,
        salario = `Salario mensual (en tu moneda local)`,
        tipo_salario = `¿Bruto o neto?`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  mutate(
    bruto = ifelse(tipo_salario == "Bruto", salario, NA),
    neto = ifelse(tipo_salario == "Neto", salario, NA),
  ) |>
  select(-tipo_salario, -salario) |>
  bind_rows(
    read_semester(2019, 1) |>
      select(
        genero = `Me identifico`,
        bruto = `Salario mensual BRUTO (en tu moneda local)`,
        neto = `Salario mensual NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2019, 2) |>
      select(
        genero = `Me identifico`,
        bruto = `Salario mensual BRUTO (en tu moneda local)`,
        neto = `Salario mensual NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2020, 1) |>
      select(
        genero = `Me identifico`,
        bruto = `Salario mensual BRUTO (en tu moneda local)`,
        neto = `Salario mensual NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2020, 2) |>
      select(
        genero = `Me identifico`,
        bruto = `Salario mensual BRUTO (en tu moneda local)`,
        neto = `Salario mensual NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2021, 1) |>
      select(
        genero = `Me identifico`,
        bruto = `Salario mensual o retiro BRUTO (en tu moneda local)`,
        neto = `Salario mensual o retiro NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2021, 2) |>
      select(
        genero = `Me identifico`,
        bruto = `Salario mensual o retiro BRUTO (en tu moneda local)`,
        neto = `Salario mensual o retiro NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2022, 1) |>
      select(
        genero = `Me identifico (género)`,
        bruto = `Salario mensual o retiro BRUTO (en tu moneda local)`,
        neto = `Salario mensual o retiro NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tu sueldo?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2022, 2) |>
      select(
        genero = `Me identifico (género)`,
        bruto = `Último salario mensual  o retiro BRUTO (en tu moneda local)`,
        neto = `Último salario mensual o retiro NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tus ingresos laborales?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2023, 1) |>
      select(
        genero = `Me identifico (género)`,
        bruto = `Último salario mensual  o retiro BRUTO (en tu moneda local)`,
        neto = `Último salario mensual o retiro NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tus ingresos laborales?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2023, 2) |>
      select(
        genero = `Me identifico (género)`,
        bruto = `Último salario mensual  o retiro BRUTO (en tu moneda local)`,
        neto = `Último salario mensual o retiro NETO (en tu moneda local)`,
        conformidad = `¿Qué tan conforme estás con tus ingresos laborales?`,
        año,
        semestre,
      )
  ) |>
  bind_rows(
    read_semester(2024, 1) |>
      select(
        genero = genero,
        bruto = ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos,
        neto = ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos,
        conformidad = que_tan_conforme_estas_con_tus_ingresos_laborales,
        año,
        semestre,
      )
  ) |>
  mutate(
    bruto = as.numeric(bruto),
    neto = as.numeric(neto),
    conformidad = as.numeric(conformidad),
  ) |>
  select(-neto, salario = bruto) |>
  mutate(genero = case_when(
    str_detect(
      genero,
      regex("^Hombre|Varón Cis|Hombre Cis|Varon|Varón|Masculino$", ignore_case = TRUE)
    ) ~ "Hombre Cis",
    str_detect(
      genero,
      regex("^Mujer|Mujer Cis$", ignore_case = TRUE)
    ) ~ "Mujer Cis",
    str_detect(
      genero,
      regex("^heterosexual|normal$", ignore_case = TRUE)
    ) ~ NA_character_,
    TRUE ~ genero
  )) |>
  filter(!is.na(conformidad) & !is.na(salario) & !is.na(genero))

# v |>
# group_by(conformidad)|>
# count()

# v |>
## group_by(genero, año, semestre) |>
# group_by(genero) |>
# count() |>
# arrange(desc(n))

v |>
  group_by(año, semestre) |>
  filter(between(salario, quantile(salario, 0.05), quantile(salario, 0.95))) |>
  ungroup() |>
  mutate(fecha = make_date(año, if_else(semestre == 1, 1, 7), 1)) |>
  write_csv(stdout())
