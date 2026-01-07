{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "091f1506",
   "metadata": {
    "papermill": {
     "duration": 0.003227,
     "end_time": "2026-01-07T01:51:51.742291",
     "exception": false,
     "start_time": "2026-01-07T01:51:51.739064",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Задание 1"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "39082577",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-07T01:51:51.752295Z",
     "iopub.status.busy": "2026-01-07T01:51:51.750151Z",
     "iopub.status.idle": "2026-01-07T01:51:53.346879Z",
     "shell.execute_reply": "2026-01-07T01:51:53.344748Z"
    },
    "papermill": {
     "duration": 1.60449,
     "end_time": "2026-01-07T01:51:53.349529",
     "exception": false,
     "start_time": "2026-01-07T01:51:51.745039",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mAttaching core tidyverse packages\u001b[22m ──────────────────────── tidyverse 2.0.0 ──\n",
      "\u001b[32m✔\u001b[39m \u001b[34mdplyr    \u001b[39m 1.1.4     \u001b[32m✔\u001b[39m \u001b[34mreadr    \u001b[39m 2.1.5\n",
      "\u001b[32m✔\u001b[39m \u001b[34mforcats  \u001b[39m 1.0.0     \u001b[32m✔\u001b[39m \u001b[34mstringr  \u001b[39m 1.5.1\n",
      "\u001b[32m✔\u001b[39m \u001b[34mggplot2  \u001b[39m 3.5.1     \u001b[32m✔\u001b[39m \u001b[34mtibble   \u001b[39m 3.2.1\n",
      "\u001b[32m✔\u001b[39m \u001b[34mlubridate\u001b[39m 1.9.3     \u001b[32m✔\u001b[39m \u001b[34mtidyr    \u001b[39m 1.3.1\n",
      "\u001b[32m✔\u001b[39m \u001b[34mpurrr    \u001b[39m 1.0.2     \n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "── \u001b[1mConflicts\u001b[22m ────────────────────────────────────────── tidyverse_conflicts() ──\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mfilter()\u001b[39m masks \u001b[34mstats\u001b[39m::filter()\n",
      "\u001b[31m✖\u001b[39m \u001b[34mdplyr\u001b[39m::\u001b[32mlag()\u001b[39m    masks \u001b[34mstats\u001b[39m::lag()\n",
      "\u001b[36mℹ\u001b[39m Use the conflicted package (\u001b[3m\u001b[34m<http://conflicted.r-lib.org/>\u001b[39m\u001b[23m) to force all conflicts to become errors\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Всего оценок: 20314 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Пользователь оценил ресторанов: 26 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Найдено похожих пользователей: 50 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 6 × 3\u001b[39m\n",
      "  Visitor_ID_neighbor correlation common_count\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m                     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m        \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m V0384                     1.00             3\n",
      "\u001b[90m2\u001b[39m V0908                     0.984            3\n",
      "\u001b[90m3\u001b[39m V0008                     0.912            6\n",
      "\u001b[90m4\u001b[39m V0565                     0.876            6\n",
      "\u001b[90m5\u001b[39m V0107                     0.866            6\n",
      "\u001b[90m6\u001b[39m V0241                     0.858            7\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "======================================================\n",
      "   РЕКОМЕНДАЦИИ ДЛЯ ПОЛЬЗОВАТЕЛЯ V0521 \n",
      "======================================================\n",
      "  Restaurant_ID       Name       Cuisine Avg_Bill_RUB predicted_rating count\n",
      "1          R024      Pinch        Fusion         2893         4.061765    17\n",
      "2          R031 Natakhtari       Italian         3412         3.911429    14\n",
      "3          R046    Harvest      Japanese         5453         3.902000    10\n",
      "4          R032 Expedition         Asian         4513         3.780556    18\n",
      "5          R044    Pushkin Mediterranean         5211         3.716875    16\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "\n",
    "# Загрузка\n",
    "ratings_df <- read.csv(\"/kaggle/input/restaurant-recommendation/ratings.csv\")\n",
    "restaurants_df <- read.csv(\"/kaggle/input/restaurant-recommendation/restaurants.csv\")\n",
    "target_user <- \"V0521\"\n",
    "\n",
    "cat(\"Всего оценок:\", nrow(ratings_df), \"\\n\")\n",
    "\n",
    "# 1. Оценки целевого пользователя\n",
    "target_ratings <- ratings_df %>% filter(Visitor_ID == target_user)\n",
    "cat(\"Пользователь оценил ресторанов:\", nrow(target_ratings), \"\\n\")\n",
    "\n",
    "# 2. Ищем \"соседей\" (тех, кто оценивал те же рестораны)\n",
    "common_ratings <- ratings_df %>% \n",
    "  filter(Restaurant_ID %in% target_ratings$Restaurant_ID, Visitor_ID != target_user)\n",
    "\n",
    "# 3. Считаем корреляцию с каждым соседом\n",
    "similar_users <- common_ratings %>%\n",
    "  inner_join(target_ratings, by = \"Restaurant_ID\", suffix = c(\"_neighbor\", \"_target\")) %>%\n",
    "  group_by(Visitor_ID_neighbor) %>%\n",
    "  summarise(\n",
    "    correlation = cor(Rating_neighbor, Rating_target, use = \"complete.obs\"),\n",
    "    common_count = n() \n",
    "  ) %>%\n",
    "  filter(common_count >= 3, !is.na(correlation)) %>% \n",
    "  arrange(desc(correlation)) %>%\n",
    "  head(50) \n",
    "\n",
    "cat(\"Найдено похожих пользователей:\", nrow(similar_users), \"\\n\")\n",
    "print(head(similar_users))\n",
    "\n",
    "# 4. Рекомендуем то, что лайкали эти \"соседи\" (но чего не видел V0521)\n",
    "recommendations <- ratings_df %>%\n",
    "  filter(Visitor_ID %in% similar_users$Visitor_ID_neighbor) %>% \n",
    "  filter(!(Restaurant_ID %in% target_ratings$Restaurant_ID)) %>% \n",
    "  group_by(Restaurant_ID) %>%\n",
    "  summarise(\n",
    "    predicted_rating = mean(Rating), \n",
    "    count = n()\n",
    "  ) %>%\n",
    "  filter(count >= 2) %>% \n",
    "  arrange(desc(predicted_rating)) %>%\n",
    "  head(5)\n",
    "\n",
    "# 5. Вывод красивого результата\n",
    "if(nrow(recommendations) > 0) {\n",
    "  result_table <- restaurants_df %>% \n",
    "    filter(Restaurant_ID %in% recommendations$Restaurant_ID) %>% \n",
    "    select(Restaurant_ID, Name, Cuisine, Avg_Bill_RUB) %>%\n",
    "    left_join(recommendations, by = \"Restaurant_ID\") %>%\n",
    "    arrange(desc(predicted_rating))\n",
    "  \n",
    "  cat(\"\\n======================================================\\n\")\n",
    "  cat(\"   РЕКОМЕНДАЦИИ ДЛЯ ПОЛЬЗОВАТЕЛЯ\", target_user, \"\\n\")\n",
    "  cat(\"======================================================\\n\")\n",
    "  print(result_table)\n",
    "} else {\n",
    "  cat(\"Не удалось найти рекомендации (мало пересечений с другими пользователями).\\n\")\n",
    "}\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "a7725651",
   "metadata": {
    "papermill": {
     "duration": 0.003257,
     "end_time": "2026-01-07T01:51:53.356228",
     "exception": false,
     "start_time": "2026-01-07T01:51:53.352971",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Библиотека recommenderlab из коробки работать не захотела, поэтому пришлось заставить машину реализовывать что-то похожее на tydiverse.\n",
    "Делалось это так:\n",
    "Искали пользователей, которые оценивали те же рестораны, что и подопытный. (минимум 3 общих оценки)\n",
    "Считали корреляцию оценок (брали топ-50 пользователей с корреляцией >0.85\n",
    "Брали топ похожих юзеров и смотрели, что они лайкали (с учетом того, что подопытный там не был)\n",
    "Результаты видно в последней таблице. Ранжировалось оно по предсказанной оценке, последний столбец - количество похожих пользователей, которые оценили ресторан."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "31f1c113",
   "metadata": {
    "papermill": {
     "duration": 0.003184,
     "end_time": "2026-01-07T01:51:53.362599",
     "exception": false,
     "start_time": "2026-01-07T01:51:53.359415",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Задание 2"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "7d58ccb7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-07T01:51:53.415785Z",
     "iopub.status.busy": "2026-01-07T01:51:53.370912Z",
     "iopub.status.idle": "2026-01-07T01:51:53.618142Z",
     "shell.execute_reply": "2026-01-07T01:51:53.616096Z"
    },
    "papermill": {
     "duration": 0.255151,
     "end_time": "2026-01-07T01:51:53.620726",
     "exception": false,
     "start_time": "2026-01-07T01:51:53.365575",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Всего пользователей: 1000 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Топ профессий:\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "         Sales        Medical        Student        Finance Service Worker \n",
      "           115            109            109            106            104 \n",
      "      Creative  IT Specialist        Manager      Scientist   Entrepreneur \n",
      "            98             97             96             87             79 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Статистика по экстраверсии:\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. \n",
      " 0.0000  0.3700  0.4900  0.4955  0.6100  1.0000 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Порог высокой экстраверсии (Top-25%): 0.61 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Найдено целевых студентов: 36 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Оценок от этой группы: 729 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "ТОП-10: БЕЗ ОГРАНИЧЕНИЙ \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "   Restaurant_ID                  Name       Cuisine Bill Rating Votes\n",
      "1           R023 Cristal Room Baccarat        French 6023   4.72    13\n",
      "2           R041                  Aist Mediterranean 5174   4.31    13\n",
      "3           R014                 Onest      Author's 5936   4.23    15\n",
      "4           R012                  Maya       Italian 5227   4.14    11\n",
      "5           R016                Padron Mediterranean 4316   4.13    14\n",
      "6           R020                 Peshi        Fusion 5212   4.11    16\n",
      "7           R029              Chemodan       Italian 4062   4.11    10\n",
      "8           R011                Probka      Georgian 3747   4.08    13\n",
      "9           R001          Twins Garden       Seafood 5306   4.07    14\n",
      "10          R031            Natakhtari       Italian 3412   4.04    11\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "ТОП-10: БЮДЖЕТ ДО 3000р\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "  Restaurant_ID             Name       Cuisine Bill Rating Votes\n",
      "1          R040            Alice        Fusion 2637   3.81    18\n",
      "2          R024            Pinch        Fusion 2893   3.69    18\n",
      "3          R034           Butler      Georgian 2967   3.68    17\n",
      "4          R027      Wine & Crab       Russian 2744   3.61    19\n",
      "5          R030      Dr. Zhivago         Asian 2952   3.51    16\n",
      "6          R005           Selfie       Seafood 2810   3.49    14\n",
      "7          R042       AQ Kitchen      Author's 2506   3.39    16\n",
      "8          R017 15 Kitchen + Bar Mediterranean 1667   3.35    20\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Средний чек в 'Мечтах': 4842 руб.\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Средний чек в 'Реальности': 2647 руб.\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "\n",
    "# 1. Загрузка данных \n",
    "base_path <- \"/kaggle/input/restaurant-recommendation\"\n",
    "visitors_df <- read.csv(file.path(base_path, \"visitors.csv\"))\n",
    "ratings_df <- read.csv(file.path(base_path, \"ratings.csv\"))\n",
    "restaurants_df <- read.csv(file.path(base_path, \"restaurants.csv\"))\n",
    "\n",
    "cat(\"Всего пользователей:\", nrow(visitors_df), \"\\n\")\n",
    "\n",
    "# 2. Анализ профессий\n",
    "cat(\"\\nТоп профессий:\\n\")\n",
    "print(head(sort(table(visitors_df$Profession), decreasing=TRUE), 10))\n",
    "\n",
    "# 3. Фильтрация целевой группы\n",
    "cat(\"\\nСтатистика по экстраверсии:\\n\")\n",
    "print(summary(visitors_df$Big5_Extraversion))\n",
    "\n",
    "threshold_extraversion <- quantile(visitors_df$Big5_Extraversion, 0.75) # Топ-25% самых экстравертных\n",
    "cat(\"\\nПорог высокой экстраверсии (Top-25%):\", threshold_extraversion, \"\\n\")\n",
    "\n",
    "target_visitors <- visitors_df %>%\n",
    "  filter(Profession == \"Student\",\n",
    "         Big5_Extraversion >= threshold_extraversion)\n",
    "\n",
    "cat(\"\\nНайдено целевых студентов:\", nrow(target_visitors), \"\\n\")\n",
    "\n",
    "# 4. Поиск любимых ресторанов этой группы\n",
    "target_ratings <- ratings_df %>%\n",
    "  filter(Visitor_ID %in% target_visitors$Visitor_ID)\n",
    "\n",
    "cat(\"Оценок от этой группы:\", nrow(target_ratings), \"\\n\")\n",
    "\n",
    "# Функция для расчета топа\n",
    "get_top_places <- function(ratings_data, restaurants_data, limit_budget = NULL) {\n",
    "  if(!is.null(limit_budget)) {\n",
    "    valid_ids <- restaurants_data %>% \n",
    "      filter(Avg_Bill_RUB <= limit_budget) %>% \n",
    "      pull(Restaurant_ID)\n",
    "    ratings_data <- ratings_data %>% \n",
    "      filter(Restaurant_ID %in% valid_ids)\n",
    "  }\n",
    "  \n",
    "  top_ids <- ratings_data %>%\n",
    "    group_by(Restaurant_ID) %>%\n",
    "    summarise(\n",
    "      Rating = round(mean(Rating), 2),\n",
    "      Votes = n()\n",
    "    ) %>%\n",
    "    filter(Votes >= 3) %>% \n",
    "    arrange(desc(Rating)) %>%\n",
    "    head(10)\n",
    "  \n",
    "  restaurants_data %>%\n",
    "    select(Restaurant_ID, Name, Cuisine, Bill = Avg_Bill_RUB) %>%\n",
    "    inner_join(top_ids, by = \"Restaurant_ID\") %>%\n",
    "    arrange(desc(Rating))\n",
    "}\n",
    "\n",
    "# 3. Генерируем два топа (ИСПРАВЛЕНО: target_ratings вместо student_ratings)\n",
    "top_overall <- get_top_places(target_ratings, restaurants_df, limit_budget = NULL)\n",
    "top_budget  <- get_top_places(target_ratings, restaurants_df, limit_budget = 3000)\n",
    "\n",
    "# 4. Вывод\n",
    "cat(\"\\nТОП-10: БЕЗ ОГРАНИЧЕНИЙ \\n\")\n",
    "print(top_overall)\n",
    "\n",
    "cat(\"\\nТОП-10: БЮДЖЕТ ДО 3000р\\n\")\n",
    "print(top_budget)\n",
    "\n",
    "# Бонус: Сравнение среднего чека в топах\n",
    "cat(\"\\nСредний чек в 'Мечтах':\", round(mean(top_overall$Bill)), \"руб.\\n\")\n",
    "cat(\"Средний чек в 'Реальности':\", round(mean(top_budget$Bill)), \"руб.\\n\")"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f9fb56a3",
   "metadata": {
    "papermill": {
     "duration": 0.003834,
     "end_time": "2026-01-07T01:51:53.628487",
     "exception": false,
     "start_time": "2026-01-07T01:51:53.624653",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Студентов тут вообще мало, верхний квартиль это всего 36 человек. Оценок в среднем по 20 на человека. \n",
    "Студентики тоже богатые, конечно.  Средний чек 4800 в предсказанных ресторанах без ограничений.\n",
    "Поэтому был составлен дополнительный спиок, с учетом ограничения в 3000 (хотя по-моему за один раз набить пузо это все равно много для студента). Оценок соседей, в среднем, там больше, кстати.\n",
    "Но предсказанный рейтинг заметно ниже. \n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "4c2ccfed",
   "metadata": {
    "papermill": {
     "duration": 0.003887,
     "end_time": "2026-01-07T01:51:53.636316",
     "exception": false,
     "start_time": "2026-01-07T01:51:53.632429",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Задание 3"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "862bd2bc",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-07T01:51:53.648264Z",
     "iopub.status.busy": "2026-01-07T01:51:53.646406Z",
     "iopub.status.idle": "2026-01-07T01:51:53.873524Z",
     "shell.execute_reply": "2026-01-07T01:51:53.871359Z"
    },
    "papermill": {
     "duration": 0.235838,
     "end_time": "2026-01-07T01:51:53.876035",
     "exception": false,
     "start_time": "2026-01-07T01:51:53.640197",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Пользователь: V0091 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Оценок: 23 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Любимые кухни пользователя (по лайкам):\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "        Cuisine n\n",
      "1        Fusion 4\n",
      "2      Japanese 3\n",
      "3         Asian 1\n",
      "4      Author's 1\n",
      "5      Georgian 1\n",
      "6 Mediterranean 1\n",
      "7       Russian 1\n",
      "8       Seafood 1\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Найдено похожих пользователей: 30 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "--- ТОП-10 РЕКОМЕНДАЦИЙ (ГИБРИДНАЯ МОДЕЛЬ) ---\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "   Restaurant_ID             Name       Cuisine Avg_Bill_RUB UBCF_Score\n",
      "1           R043         Pavilion         Asian         3855   4.365000\n",
      "2           R008         Biologie         Asian         3185   3.886667\n",
      "3           R014            Onest      Author's         5936   4.360000\n",
      "4           R049 Margarita Bistro      Georgian         3019   4.200000\n",
      "5           R022        Severyane        Fusion         5170   3.615000\n",
      "6           R031       Natakhtari       Italian         3412   4.606667\n",
      "7           R033    Assunta Madre       Russian         3981   3.920000\n",
      "8           R041             Aist Mediterranean         5174   3.831250\n",
      "9           R005           Selfie       Seafood         2810   3.743636\n",
      "10          R018         La Marée         Asian         5289   3.205556\n",
      "   Content_Score Hybrid_Score\n",
      "1            1.0     5.365000\n",
      "2            1.0     4.886667\n",
      "3            0.5     4.860000\n",
      "4            0.5     4.700000\n",
      "5            1.0     4.615000\n",
      "6            0.0     4.606667\n",
      "7            0.5     4.420000\n",
      "8            0.5     4.331250\n",
      "9            0.5     4.243636\n",
      "10           1.0     4.205556\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "\n",
    "# 1. Загрузка\n",
    "base_path <- \"/kaggle/input/restaurant-recommendation\"\n",
    "ratings_df <- read.csv(file.path(base_path, \"ratings.csv\"))\n",
    "restaurants_df <- read.csv(file.path(base_path, \"restaurants.csv\"))\n",
    "target_user <- \"V0091\" # Проверяем формат ID\n",
    "\n",
    "# Проверка, есть ли юзер\n",
    "if(!(target_user %in% ratings_df$Visitor_ID)) {\n",
    "  stop(\"Пользователь не найден!\")\n",
    "}\n",
    "\n",
    "cat(\"Пользователь:\", target_user, \"\\n\")\n",
    "user_ratings <- ratings_df %>% filter(Visitor_ID == target_user)\n",
    "cat(\"Оценок:\", nrow(user_ratings), \"\\n\")\n",
    "\n",
    "# --- ЧАСТЬ 1: Content-Based (Любимые кухни) ---\n",
    "# Смотрим, какие кухни он оценивал высоко (> 3.5)\n",
    "liked_cuisines <- user_ratings %>%\n",
    "  left_join(restaurants_df, by = \"Restaurant_ID\") %>%\n",
    "  filter(Rating >= 4.0) %>%\n",
    "  count(Cuisine) %>%\n",
    "  arrange(desc(n))\n",
    "\n",
    "cat(\"\\nЛюбимые кухни пользователя (по лайкам):\\n\")\n",
    "print(liked_cuisines)\n",
    "\n",
    "# Даем баллы ресторанам за кухню\n",
    "# Если кухня в топе любимых - даем бонус\n",
    "top_cuisines <- liked_cuisines$Cuisine[1:3] # Топ-3 любимых кухни\n",
    "restaurants_df$Content_Score <- ifelse(restaurants_df$Cuisine %in% top_cuisines, 1.0, 0)\n",
    "# Если кухня вообще есть в его списке - даем 0.5\n",
    "all_liked_cuisines <- liked_cuisines$Cuisine\n",
    "restaurants_df$Content_Score <- ifelse(restaurants_df$Cuisine %in% all_liked_cuisines & \n",
    "                                         !restaurants_df$Cuisine %in% top_cuisines, \n",
    "                                       0.5, restaurants_df$Content_Score)\n",
    "\n",
    "# --- ЧАСТЬ 2: User-Based (Коллаборативная) ---\n",
    "# Используем наш ручной метод UBCF, так как он надежнее\n",
    "# Ищем соседей\n",
    "common_ratings <- ratings_df %>% \n",
    "  filter(Restaurant_ID %in% user_ratings$Restaurant_ID, Visitor_ID != target_user)\n",
    "\n",
    "similar_users <- common_ratings %>%\n",
    "  inner_join(user_ratings, by = \"Restaurant_ID\", suffix = c(\"_neighbor\", \"_target\")) %>%\n",
    "  group_by(Visitor_ID_neighbor) %>%\n",
    "  summarise(\n",
    "    correlation = cor(Rating_neighbor, Rating_target, use = \"complete.obs\"),\n",
    "    common_count = n()\n",
    "  ) %>%\n",
    "  filter(common_count >= 3, correlation > 0.5) %>%\n",
    "  arrange(desc(correlation)) %>%\n",
    "  head(30) # Топ-30 соседей\n",
    "\n",
    "cat(\"\\nНайдено похожих пользователей:\", nrow(similar_users), \"\\n\")\n",
    "\n",
    "# Предсказываем рейтинг UBCF\n",
    "ubcf_recs <- ratings_df %>%\n",
    "  filter(Visitor_ID %in% similar_users$Visitor_ID_neighbor) %>%\n",
    "  filter(!(Restaurant_ID %in% user_ratings$Restaurant_ID)) %>%\n",
    "  group_by(Restaurant_ID) %>%\n",
    "  summarise(\n",
    "    UBCF_Score = mean(Rating),\n",
    "    Votes = n()\n",
    "  ) %>%\n",
    "  filter(Votes >= 2)\n",
    "\n",
    "# --- ЧАСТЬ 3: Гибридное слияние ---\n",
    "# Объединяем Content и User Scores\n",
    "# Hybrid = 0.7 * UBCF + 0.3 * Content (веса можно менять)\n",
    "# Нормализуем: Content (0-1) переводим в шкалу (1-5) -> 1=5.0, 0=3.0 (базовый)\n",
    "\n",
    "final_recs <- restaurants_df %>%\n",
    "  left_join(ubcf_recs, by = \"Restaurant_ID\") %>%\n",
    "  # Если UBCF нет, ставим средний рейтинг по больнице (или 0)\n",
    "  replace_na(list(UBCF_Score = 0)) %>%\n",
    "  # Фильтруем: только те, где есть хоть какой-то сигнал (либо UBCF > 0, либо Кухня подходит)\n",
    "  filter(UBCF_Score > 0 | Content_Score > 0) %>%\n",
    "  mutate(\n",
    "    # Нормализуем Content Score до шкалы рейтинга (бонус до +1 балла)\n",
    "    Content_Bonus = Content_Score * 1.0, \n",
    "    # Формула Гибрида: Рейтинг от соседей + Бонус за любимую кухню\n",
    "    Hybrid_Score = UBCF_Score + Content_Bonus\n",
    "  ) %>%\n",
    "  arrange(desc(Hybrid_Score)) %>%\n",
    "  head(10) %>%\n",
    "  select(Restaurant_ID, Name, Cuisine, Avg_Bill_RUB, UBCF_Score, Content_Score, Hybrid_Score)\n",
    "\n",
    "cat(\"\\n--- ТОП-10 РЕКОМЕНДАЦИЙ (ГИБРИДНАЯ МОДЕЛЬ) ---\\n\")\n",
    "print(final_recs)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "0ea989e8",
   "metadata": {
    "papermill": {
     "duration": 0.004286,
     "end_time": "2026-01-07T01:51:53.884728",
     "exception": false,
     "start_time": "2026-01-07T01:51:53.880442",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "С библиотека для гибридного анализа все сложно, поэтому было решено пойти чуть более легким путем. Коллаборативная фильтрация делалась также, как и в первом задании. Контентная фильтрация проводилось путем анализа того, какие рестораны лайкает пользователь чаще. В топ по лайкам вошли фьюжн и японская кухня, поэтому они получили +1 балл за совпадение по контенту, остальные виды кухни с 1+ лайком получили по 0.5 балла. Гибридным баллом просто является сумма баллов на основе двух фильтраций. В топе у нас достаточно разнообразон все, но чаще всего встречается азиатская кухня, которая, кстати имеет только один балл от пользователя. Пользователь поставил больше одного лайка только японской и фьюжен кухням. Но японской в топе нет вообще, фьюжн встретилась только один раз. Возможно стоит пересмотреть количество выдаваемых баллов за лайки пользователя. Ресторане почти все лежат в ценовом диапазоне 3000+, что на основе прошлого задания можно считать средне-высоким классом. "
   ]
  }
 ],
 "metadata": {
  "kaggle": {
   "accelerator": "none",
   "dataSources": [
    {
     "datasetId": 7484282,
     "sourceId": 11905798,
     "sourceType": "datasetVersion"
    }
   ],
   "dockerImageVersionId": 30749,
   "isGpuEnabled": false,
   "isInternetEnabled": true,
   "language": "r",
   "sourceType": "notebook"
  },
  "kernelspec": {
   "display_name": "R",
   "language": "R",
   "name": "ir"
  },
  "language_info": {
   "codemirror_mode": "r",
   "file_extension": ".r",
   "mimetype": "text/x-r-source",
   "name": "R",
   "pygments_lexer": "r",
   "version": "4.4.0"
  },
  "papermill": {
   "default_parameters": {},
   "duration": 5.724162,
   "end_time": "2026-01-07T01:51:54.011341",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2026-01-07T01:51:48.287179",
   "version": "2.6.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
