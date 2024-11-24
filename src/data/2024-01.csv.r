# process.stdout.write("jerston,test\n1,2\n3,4");


library(tidyverse)

v <- read_csv(
  glue::glue("src/data/2024.01.csv"),
  col_types = cols(
    # index
    col_integer(),
    # donde_estas_trabajando
    col_character(),
    # dedicacion
    col_character(),
    # tipo_de_contrato
    col_character(),
    # ultimo_salario_mensual_o_retiro_bruto_en_pesos_argentinos
    col_number(),
    # ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos
    col_number(),
    # pagos_en_dolares
    col_character(),
    # si_tu_sueldo_esta_dolarizado_cual_fue_el_ultimo_valor_del_dolar_que_tomaron
    col_number(),
    # recibis_algun_tipo_de_bono
    col_character(),
    # a_que_esta_atado_el_bono
    col_character(),
    # tuviste_actualizaciones_de_tus_ingresos_laborales_durante_2024
    col_character(),
    # de_que_fue_el_ajuste_total_acumulado
    col_number(),
    # en_que_mes_fue_el_ultimo_ajuste
    col_character(),
    # como_consideras_que_estan_tus_ingresos_laborales_comparados_con_el_semestre_anterior
    col_integer(),
    # contas_con_beneficios_adicionales
    col_character(),
    # que_tan_conforme_estas_con_tus_ingresos_laborales
    col_integer(),
    # estas_buscando_trabajo
    col_character(),
    # trabajo_de
    col_character(),
    # anos_de_experiencia
    col_integer(),
    # antiguedad_en_la_empresa_actual
    col_integer(),
    # anos_en_el_puesto_actual
    col_integer(),
    # cuantas_personas_tenes_a_cargo
    col_integer(),
    # plataformas_que_utilizas_en_tu_puesto_actual
    col_character(),
    # lenguajes_de_programacion_o_tecnologias_que_utilices_en_tu_puesto_actual
    col_character(),
    # frameworksherramientas_y_librerias_que_utilices_en_tu_puesto_actual
    col_character(),
    # bases_de_datos
    col_character(),
    # qa_testing
    col_character(),
    # cantidad_de_personas_en_tu_organizacion
    col_character(),
    # modalidad_de_trabajo
    col_character(),
    # si_trabajas_bajo_un_esquema_hibrido_cuantos_dias_a_la_semana_vas_a_la_oficina
    col_integer(),
    # en_los_ultimos_6_mesesse_aplico_alguna_politica_de_ajustes_salariales
    col_character(),
    # en_los_ultimos_6_meseshubo_reduccion_de_personal
    col_character(),
    # la_recomendas_como_un_buen_lugar_para_trabajar
    col_integer(),
    # que_tanto_estas_usando_copilotchatgpt_u_otras_herramientas_de_ia_para_tu_trabajo
    col_integer(),
    # salir_o_seguir_contestando
    col_character(),
    # maximo_nivel_de_estudios
    col_character(),
    # estado
    col_character(),
    # carrera
    col_character(),
    # institucion_educativa
    col_character(),
    # salir_o_seguir_contestando_sobre_las_guardias
    col_character(),
    # tenes_guardias
    col_character(),
    # cuanto_cobras_por_guardia
    col_number(),
    # aclara_el_numero_que_ingresaste_en_el_campo_anterior
    col_character(),
    # salir_o_seguir_contestando_sobre_estudios
    col_character(),
    # tengo_edad
    col_integer(),
    # genero
    col_character(),
    # sueldo_dolarizado
    col_character(),
    # seniority
    col_character(),
    # _sal
    col_number(),
  )
) |>
  mutate(genero = if_else(
    str_detect(
      genero,
      regex("^Hombre|Varón Cis|Hombre Cis|Varon|Varón|Masculino$", ignore_case = TRUE)
    ), "Hombre Cis",
    if_else(
      str_detect(
        genero,
        regex("^Mujer|Mujer Cis$", ignore_case = TRUE)
      ), "Mujer Cis",
      if_else(
        str_detect(
          genero,
          regex("^heterosexual|normal$", ignore_case = TRUE)
        ), NA,
        genero
      )
    )
  )) |>
  filter(!is.na(genero) & !is.na(ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos))

# v |>
# group_by(conformidad)|>
# count()

# v |>
## group_by(genero, año, semestre) |>
# group_by(genero) |>
# count() |>
# arrange(desc(n))

col <- quo(ultimo_salario_mensual_o_retiro_neto_en_pesos_argentinos)

v |>
  filter(between(UQ(col), quantile(UQ(col), 0.035), quantile(UQ(col), 1 - 0.035))) |>
  write_csv(stdout(), na = "")
