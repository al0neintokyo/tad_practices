{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "49fd5c77",
   "metadata": {
    "papermill": {
     "duration": 0.005282,
     "end_time": "2026-01-05T21:53:50.775596",
     "exception": false,
     "start_time": "2026-01-05T21:53:50.770314",
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
   "id": "46c81455",
   "metadata": {
    "_execution_state": "idle",
    "_uuid": "051d70d956493feee0c6d64651c6a088724dca2a",
    "execution": {
     "iopub.execute_input": "2026-01-05T21:53:50.788274Z",
     "iopub.status.busy": "2026-01-05T21:53:50.786018Z",
     "iopub.status.idle": "2026-01-05T21:53:54.667293Z",
     "shell.execute_reply": "2026-01-05T21:53:54.664177Z"
    },
    "papermill": {
     "duration": 3.892025,
     "end_time": "2026-01-05T21:53:54.671938",
     "exception": false,
     "start_time": "2026-01-05T21:53:50.779913",
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
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Loading required package: lattice\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘caret’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:purrr’:\n",
      "\n",
      "    lift\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:httr’:\n",
      "\n",
      "    progress\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Full Model RMSE: 3976914\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Full Model R2: 0.212\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "tibble [4,800 × 7] (S3: tbl_df/tbl/data.frame)\n",
      " $ PRICE       : num [1:4800] 3.15e+05 1.95e+08 2.60e+05 6.90e+04 5.50e+07 ...\n",
      " $ TYPE        : chr [1:4800] \"Condo for sale\" \"Condo for sale\" \"House for sale\" \"Condo for sale\" ...\n",
      " $ BEDS        : num [1:4800] 2 7 4 3 7 5 2 8 1 2 ...\n",
      " $ BATH        : num [1:4800] 2 10 2 1 2.37 ...\n",
      " $ PROPERTYSQFT: num [1:4800] 1400 17545 2015 445 14175 ...\n",
      " $ LATITUDE    : num [1:4800] 40.8 40.8 40.5 40.8 40.8 ...\n",
      " $ LONGITUDE   : num [1:4800] -74 -74 -74.2 -74 -74 ...\n"
     ]
    }
   ],
   "source": [
    "# --- Блок 1: Загрузка и Модель со всеми признаками ---\n",
    "library(tidyverse)\n",
    "library(caret)\n",
    "\n",
    "# 1. Загрузка\n",
    "df <- read_csv(\"/kaggle/input/new-york-housing-market/NY-House-Dataset.csv\", show_col_types = FALSE)\n",
    "\n",
    "# 2. Предобработка\n",
    "\n",
    "df_clean <- df %>%\n",
    "  select(PRICE, TYPE, BEDS, BATH, PROPERTYSQFT, LATITUDE, LONGITUDE) %>%\n",
    "  filter(PRICE < 1000000000) %>% \n",
    "  na.omit()\n",
    "\n",
    "# 3. Делим на Train/Test (80/20)\n",
    "set.seed(123)\n",
    "index <- createDataPartition(df_clean$PRICE, p = 0.8, list = FALSE)\n",
    "train_data <- df_clean[index, ]\n",
    "test_data  <- df_clean[-index, ]\n",
    "\n",
    "# 4. Модель 1: Все признаки (lm автоматически сделает dummy для TYPE)\n",
    "model_full <- lm(PRICE ~ ., data = train_data)\n",
    "\n",
    "# 5. Оценка качества\n",
    "pred_full <- predict(model_full, newdata = test_data)\n",
    "rmse_full <- RMSE(pred_full, test_data$PRICE)\n",
    "r2_full <- R2(pred_full, test_data$PRICE)\n",
    "\n",
    "print(paste(\"Full Model RMSE:\", round(rmse_full, 0)))\n",
    "print(paste(\"Full Model R2:\", round(r2_full, 3)))\n",
    "str(df_clean)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "a0872f35",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:53:54.750457Z",
     "iopub.status.busy": "2026-01-05T21:53:54.692837Z",
     "iopub.status.idle": "2026-01-05T21:53:55.181211Z",
     "shell.execute_reply": "2026-01-05T21:53:55.179286Z"
    },
    "papermill": {
     "duration": 0.502829,
     "end_time": "2026-01-05T21:53:55.183817",
     "exception": false,
     "start_time": "2026-01-05T21:53:54.680988",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "corrplot 0.92 loaded\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Отобранные признаки:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"PRICE\"        \"BEDS\"         \"BATH\"         \"PROPERTYSQFT\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Filtered Model RMSE: 4026913\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Filtered Model R2: 0.199\"\n"
     ]
    },
    {
     "data": {
      "image/png": "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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "library(corrplot)\n",
    "\n",
    "# 1. Готовим данные для корреляции (только числа, TYPE придется убрать временно)\n",
    "numeric_cols <- train_data %>% select_if(is.numeric)\n",
    "cor_matrix <- cor(numeric_cols)\n",
    "\n",
    "# Визуализация корреляции\n",
    "corrplot(cor_matrix, method = \"number\", type = \"upper\", tl.cex = 0.8)\n",
    "\n",
    "# 2. Фильтрация: Оставляем только те, где корреляция с PRICE > 0.1 (по модулю)\n",
    "cor_with_price <- abs(cor_matrix[\"PRICE\", ])\n",
    "selected_features <- names(cor_with_price[cor_with_price > 0.1])\n",
    "print(\"Отобранные признаки:\")\n",
    "print(selected_features)\n",
    "\n",
    "# 3. Формируем формулу только из отобранных переменных (+ TYPE вернем, он важен)\n",
    "if (!(\"TYPE\" %in% selected_features)) {\n",
    "  final_features <- c(selected_features, \"TYPE\")\n",
    "} else {\n",
    "  final_features <- selected_features\n",
    "}\n",
    "\n",
    "# 4. Модель 2: Только отобранные признаки\n",
    "formula_str <- paste(\"PRICE ~\", paste(setdiff(final_features, \"PRICE\"), collapse = \" + \"))\n",
    "model_filtered <- lm(as.formula(formula_str), data = train_data)\n",
    "\n",
    "# 5. Оценка качества новой модели\n",
    "pred_filtered <- predict(model_filtered, newdata = test_data)\n",
    "rmse_filtered <- RMSE(pred_filtered, test_data$PRICE)\n",
    "r2_filtered <- R2(pred_filtered, test_data$PRICE)\n",
    "\n",
    "print(paste(\"Filtered Model RMSE:\", round(rmse_filtered, 0)))\n",
    "print(paste(\"Filtered Model R2:\", round(r2_filtered, 3)))\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "c45829e1",
   "metadata": {
    "papermill": {
     "duration": 0.005812,
     "end_time": "2026-01-05T21:53:55.195712",
     "exception": false,
     "start_time": "2026-01-05T21:53:55.189900",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Изначальная модель на полных данных объясняет 21% разброса цен. RMSE = 3.98 млн.\n",
    "После корреляционного анализа оставили признаки, которые имеют хоть какую-либо связь с ценой, price, beds, bath, propertysqft\n",
    "Модель на отобранных признаках объясняет 19.9% дисперсии и rmse 4.02 млн.\n",
    "Упрощенная модель хоть и показала слегка меньшую точность, зато мы убрали мусорные данные в виде адрессов и географических координат."
   ]
  },
  {
   "cell_type": "markdown",
   "id": "8de17f69",
   "metadata": {
    "papermill": {
     "duration": 0.005923,
     "end_time": "2026-01-05T21:53:55.207601",
     "exception": false,
     "start_time": "2026-01-05T21:53:55.201678",
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
   "execution_count": 3,
   "id": "7bbf760d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:53:55.223749Z",
     "iopub.status.busy": "2026-01-05T21:53:55.222084Z",
     "iopub.status.idle": "2026-01-05T21:55:06.038331Z",
     "shell.execute_reply": "2026-01-05T21:55:06.035260Z"
    },
    "papermill": {
     "duration": 70.830581,
     "end_time": "2026-01-05T21:55:06.044314",
     "exception": false,
     "start_time": "2026-01-05T21:53:55.213733",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy FULL: 0.7434\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Топ признаков:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      " [1] \"gender\"              \"height_cm\"           \"hemoglobin\"         \n",
      " [4] \"Gtp\"                 \"age\"                 \"ALT\"                \n",
      " [7] \"triglyceride\"        \"AST\"                 \"weight_kg\"          \n",
      "[10] \"serum.creatinine\"    \"tartar\"              \"fasting.blood.sugar\"\n",
      "[13] \"Cholesterol\"         \"HDL\"                 \"LDL\"                \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy RFE: 0.7416\"\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "library(caret)\n",
    "\n",
    "# 1. Загрузка и ЯВНОЕ переименование\n",
    "df <- read_csv(\"/kaggle/input/body-signal-of-smoking/smoking.csv\", show_col_types = FALSE)\n",
    "\n",
    "# Переименовываем проблемные колонки вручную\n",
    "df <- df %>%\n",
    "  rename(\n",
    "    height_cm = `height(cm)`,\n",
    "    weight_kg = `weight(kg)`,\n",
    "    waist_cm = `waist(cm)`,\n",
    "    eyesight_left = `eyesight(left)`,\n",
    "    eyesight_right = `eyesight(right)`,\n",
    "    hearing_left = `hearing(left)`,\n",
    "    hearing_right = `hearing(right)`\n",
    "  )\n",
    "\n",
    "# На всякий случай чистим все остальные имена\n",
    "colnames(df) <- make.names(colnames(df))\n",
    "\n",
    "# 2. Предобработка (удаляем ID, константы, NA)\n",
    "unique_counts <- map_dbl(df, n_distinct)\n",
    "cols_to_remove <- names(unique_counts[unique_counts == 1])\n",
    "\n",
    "df_clean <- df %>%\n",
    "  select(-ID, -all_of(cols_to_remove)) %>%\n",
    "  mutate(across(where(is.character), as.factor)) %>%\n",
    "  mutate(smoking = as.factor(smoking)) %>%\n",
    "  na.omit()\n",
    "\n",
    "# 3. Делим на Train/Test\n",
    "set.seed(42)\n",
    "index <- createDataPartition(df_clean$smoking, p = 0.8, list = FALSE)\n",
    "train_data <- df_clean[index, ]\n",
    "test_data  <- df_clean[-index, ]\n",
    "\n",
    "# 4. Модель 1: Все признаки\n",
    "model_full <- train(smoking ~ ., data = train_data, method = \"glm\", family = \"binomial\")\n",
    "pred_full <- predict(model_full, newdata = test_data)\n",
    "acc_full <- confusionMatrix(pred_full, test_data$smoking)$overall['Accuracy']\n",
    "print(paste(\"Accuracy FULL:\", round(acc_full, 4)))\n",
    "\n",
    "# 5. RFE (Отбор признаков)\n",
    "set.seed(123)\n",
    "subsample <- train_data %>% sample_n(1000)\n",
    "\n",
    "control <- rfeControl(functions = rfFuncs, method = \"cv\", number = 5)\n",
    "results_rfe <- rfe(\n",
    "  x = subsample %>% select(-smoking), \n",
    "  y = subsample$smoking,\n",
    "  sizes = c(5, 10, 15),\n",
    "  rfeControl = control\n",
    ")\n",
    "\n",
    "print(\"Топ признаков:\")\n",
    "print(predictors(results_rfe))\n",
    "# 6. Модель 2: На отобранных признаках\n",
    "selected_vars <- predictors(results_rfe)\n",
    "# Теперь имена height_cm безопасны\n",
    "formula_rfe <- as.formula(paste(\"smoking ~\", paste(selected_vars, collapse = \" + \")))\n",
    "\n",
    "model_rfe <- train(formula_rfe, data = train_data, method = \"glm\", family = \"binomial\")\n",
    "pred_rfe <- predict(model_rfe, newdata = test_data)\n",
    "acc_rfe <- confusionMatrix(pred_rfe, test_data$smoking)$overall['Accuracy']\n",
    "\n",
    "print(paste(\"Accuracy RFE:\", round(acc_rfe, 4)))\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "a73ff08a",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:55:06.078938Z",
     "iopub.status.busy": "2026-01-05T21:55:06.076207Z",
     "iopub.status.idle": "2026-01-05T21:55:24.473471Z",
     "shell.execute_reply": "2026-01-05T21:55:24.470340Z"
    },
    "papermill": {
     "duration": 18.420222,
     "end_time": "2026-01-05T21:55:24.480056",
     "exception": false,
     "start_time": "2026-01-05T21:55:06.059834",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Пробуем только эти 10:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      " [1] \"gender\"           \"height_cm\"        \"hemoglobin\"       \"Gtp\"             \n",
      " [5] \"age\"              \"ALT\"              \"triglyceride\"     \"AST\"             \n",
      " [9] \"weight_kg\"        \"serum.creatinine\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy (10 признаков): 0.7353\"\n"
     ]
    }
   ],
   "source": [
    "# Берем список лучших признаков из RFE, но режем его до первых 10\n",
    "top_10_vars <- predictors(results_rfe)[1:10]\n",
    "\n",
    "print(\"Пробуем только эти 10:\")\n",
    "print(top_10_vars)\n",
    "\n",
    "# Строим формулу для 10 признаков\n",
    "formula_10 <- as.formula(paste(\"smoking ~\", paste(top_10_vars, collapse = \" + \")))\n",
    "\n",
    "# Обучаем модель\n",
    "model_10 <- train(formula_10, data = train_data, method = \"glm\", family = \"binomial\")\n",
    "\n",
    "# Проверяем\n",
    "pred_10 <- predict(model_10, newdata = test_data)\n",
    "acc_10 <- confusionMatrix(pred_10, test_data$smoking)$overall['Accuracy']\n",
    "print(paste(\"Accuracy (10 признаков):\", round(acc_10, 4)))\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "9a3a524c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:55:24.509356Z",
     "iopub.status.busy": "2026-01-05T21:55:24.506719Z",
     "iopub.status.idle": "2026-01-05T21:55:39.780044Z",
     "shell.execute_reply": "2026-01-05T21:55:39.776961Z"
    },
    "papermill": {
     "duration": 15.294092,
     "end_time": "2026-01-05T21:55:39.785745",
     "exception": false,
     "start_time": "2026-01-05T21:55:24.491653",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Пробуем только эти 5:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"gender\"     \"height_cm\"  \"hemoglobin\" \"Gtp\"        \"age\"       \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy (10 признаков): 0.7353\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy (5 признаков): 0.7134\"\n"
     ]
    }
   ],
   "source": [
    "\n",
    "top_5_vars <- predictors(results_rfe)[1:5]\n",
    "\n",
    "print(\"Пробуем только эти 5:\")\n",
    "print(top_5_vars)\n",
    "\n",
    "# Строим формулу для 10 признаков\n",
    "formula_5 <- as.formula(paste(\"smoking ~\", paste(top_5_vars, collapse = \" + \")))\n",
    "\n",
    "# Обучаем модель\n",
    "model_5 <- train(formula_5, data = train_data, method = \"glm\", family = \"binomial\")\n",
    "\n",
    "# Проверяем\n",
    "pred_5 <- predict(model_5, newdata = test_data)\n",
    "acc_5 <- confusionMatrix(pred_5, test_data$smoking)$overall['Accuracy']\n",
    "\n",
    "print(paste(\"Accuracy (10 признаков):\", round(acc_10, 4)))\n",
    "print(paste(\"Accuracy (5 признаков):\", round(acc_5, 4)))"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "cbb33703",
   "metadata": {
    "papermill": {
     "duration": 0.012237,
     "end_time": "2026-01-05T21:55:39.810338",
     "exception": false,
     "start_time": "2026-01-05T21:55:39.798101",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Модель построенная на полном наборе данных имела точность 0.7434, потом я скормил алгоритму отбора признаков возможность взять до 15 признаков, на них точность получилась 0.7416, разница незначительная, зато вычислительная сложность заметно упала. Потом протестил насколько упадет точность, если дать модели не 15, а 10 и 5 признаков. Разница с полной моделью получилась 0,0101 и 0,03 соответственно. С учетом области решаемой задачи (медецина), я считаю оптимальным оставить в качестве конечного решения модель с 15 признаками. "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "badca9d9",
   "metadata": {
    "papermill": {
     "duration": 0.01194,
     "end_time": "2026-01-05T21:55:39.834274",
     "exception": false,
     "start_time": "2026-01-05T21:55:39.822334",
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
   "execution_count": 6,
   "id": "0d545c96",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:55:39.862065Z",
     "iopub.status.busy": "2026-01-05T21:55:39.860537Z",
     "iopub.status.idle": "2026-01-05T21:55:43.322469Z",
     "shell.execute_reply": "2026-01-05T21:55:43.320620Z"
    },
    "papermill": {
     "duration": 3.478707,
     "end_time": "2026-01-05T21:55:43.325023",
     "exception": false,
     "start_time": "2026-01-05T21:55:39.846316",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘janitor’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following objects are masked from ‘package:stats’:\n",
      "\n",
      "    chisq.test, fisher.test\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\u001b[1mRows: \u001b[22m\u001b[34m1000000\u001b[39m \u001b[1mColumns: \u001b[22m\u001b[34m16\u001b[39m\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\u001b[36m──\u001b[39m \u001b[1mColumn specification\u001b[22m \u001b[36m────────────────────────────────────────────────────────\u001b[39m\n",
      "\u001b[1mDelimiter:\u001b[22m \",\"\n",
      "\u001b[31mchr\u001b[39m (9): Product ID, Product Name, Category, Supplier ID, Customer Age Group...\n",
      "\u001b[32mdbl\u001b[39m (7): Price, Discount, Tax Rate, Stock Level, Shipping Cost, Return Rate,...\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "\u001b[36mℹ\u001b[39m Use `spec()` to retrieve the full column specification for this data.\n",
      "\u001b[36mℹ\u001b[39m Specify the column types or set `show_col_types = FALSE` to quiet this message.\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Структура датасета:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Rows: 1,000,000\n",
      "Columns: 16\n",
      "$ product_id         \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"P6879\", \"P5132\", \"P2941\", \"P8545\", \"P4594\", \"P1388…\n",
      "$ product_name       \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Jacket\", \"Camera\", \"Sneakers\", \"Cookbooks\", \"Camer…\n",
      "$ category           \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Apparel\", \"Electronics\", \"Footwear\", \"Books\", \"Ele…\n",
      "$ price              \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 53.85, 761.26, 1756.76, 295.24, 832.00, 584.19, 134…\n",
      "$ discount           \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 5, 10, 5, 10, 10, 15, 0, 0, 25, 20, 15, 5, 20, 15, …\n",
      "$ tax_rate           \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 15, 15, 8, 15, 12, 8, 10, 15, 5, 8, 10, 12, 8, 15, …\n",
      "$ stock_level        \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 150, 224, 468, 25, 340, 204, 493, 349, 237, 132, 30…\n",
      "$ supplier_id        \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"S535\", \"S583\", \"S118\", \"S104\", \"S331\", \"S523\", \"S8…\n",
      "$ customer_age_group \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"35-44\", \"25-34\", \"25-34\", \"18-24\", \"55+\", \"45-54\",…\n",
      "$ customer_location  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"New York, USA\", \"London, UK\", \"Tokyo, Japan\", \"Par…\n",
      "$ customer_gender    \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Male\", \"Female\", \"Non-Binary\", \"Female\", \"Male\", \"…\n",
      "$ shipping_cost      \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 23.32, 20.88, 16.43, 27.49, 45.93, 40.12, 35.91, 46…\n",
      "$ shipping_method    \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Standard\", \"Overnight\", \"Standard\", \"Standard\", \"O…\n",
      "$ return_rate        \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 4.49, 16.11, 4.93, 1.31, 4.37, 19.03, 17.73, 4.79, …\n",
      "$ seasonality        \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"Yes\", \"No\", \"No\", \"No\", \"No\", \"No\", \"Yes\", \"No\", \"…\n",
      "$ popularity_index   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 56, 79, 40, 93, 56, 91, 41, 60, 90, 96, 36, 66, 57,…\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Всего пропусков в данных: 0\"\n"
     ]
    },
    {
     "data": {
      "image/png": "iVBORw0KGgoAAAANSUhEUgAABLAAAASwCAIAAABkQySYAAAABmJLR0QA/wD/AP+gvaeTAAAg\nAElEQVR4nOzdeVxU5eLH8ecMO8gmiCAqECrikuJu1jUR90yTTNw1tfJeNTXN9WdqmZlalpal\nZSSaS6a5lpqa5a5o7ruCCIgsguwwy+8PzBBHQII5c2Y+71ev1x3POR6/3dPIfOc8z3MknU4n\nAAAAAADmRyV3AAAAAACAPCiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAA\nYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAA\nAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiE\nAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCm\nKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAA\nYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAA\nAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiE\nAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCm\nKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAA\nYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAA\nAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiE\nAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCm\nKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAA\nYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAAAABgpiiEAAAAAGCmKIQAAAAAYKYohAAA\n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\n5b1kVmPxiiIQAgAA2bNgSjnnEJazeEWxZBQAAMiepja/JO0dQZMWxXNAIAQAALKn1OaXpD2H\nMDGHEAAAgDwQCAEAgOyxqUwqBEIAACB7FpZz35eyFq8oeggBAIDsadO7d5R6CFPdVKZ0b7BU\nPA8EQgAAIINK276UZ5fRyMueMpaMAgAAWVTWLr+8tBAKhAAAQAYtmFzOwfTlLF5RLBkFAACy\np3bd3hFRLBaLjcUUyxaLxebieSAQAgAAGbSohzDl5Z16CAEAAEjda78bOWzI1t3bd91yp71H\n3DXuk08s/vaq0z+/5YBOtR023Gyb//nhXQvL1tMoEAIAABmUtU1lpv3zskEHnjlpvV2vGnXt\n0IHTLzxyu7Men/KxZz434osHnn19v72Pu/WXP/3fr27x8x8cudNpj6Z/QRFhySgAAJBF88s5\nO74cxUd+/fKa3seO++XI2qqIQ45o/UzPaw8bftXkUUufecpVT6875PZ7rjoiIuLAb2zy+pMH\n/PiY4rVvl+NunjuEAABA9tT27hURkUQUU/1KWhRPT+PC/17+xqzNzzm1timBVR176XZzp/z0\nmTl1S588ua6xfd9+zT+uN7BTsX5qXZpb5ywmEAIAANlTqCpERCSRpKoUCJuKp2f+tPsbkmTQ\n0PWaj3TfdpeIuO+D+UuffN1hm0789dF3PvHKvLr5E56577j/G7/RV2+uLU90s2QUAADInqRY\nlltmpebBf7wyvuu99zYfrK2tHTZsWKtWrVa6bMOCiRExoO3i/FXddpOImDivYemTv3LbsyeO\n+8yRu212ZEREdN3025PuPmaln3rZBEIAACB75k95vxxl32xYEBG3/f7+235/f8vjjz766J57\n7rn8dYr17744/r3S99W1/ftUFyOisNQ4i8aPG6J4yzGfv+nVDmeNvOKLW/Z5f/wTPzr3ym0P\n2vjV35xbjnuEAiEAAJA9tev2iohikjQmaW4J2rdVm4g4bv+v7nXEoYufq7Z29913X6E6cyff\nMHjwJaXve2x2/8RHNoyICfPrm09omD8hIj7TvvWSD3zn/06448Vv//GtK/dZPyJij7332Tbp\nteN55/z7+CsHdl2JV7RsAiEAAJA9hUIhSnPpyzAiYptNNzvooINWpUKnfhcnycXNPzYumFhd\nOOPlJ96PAU2hbsZLT0XE13q0W+KBc//7aEQctdM6zUe6f+6EiB8998L0KEMgtKkMAACQPUlS\n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"
     },
     "metadata": {
      "image/png": {
       "height": 600,
       "width": 600
      }
     },
     "output_type": "display_data"
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "library(janitor)  # Для удобной очистки имен столбцов\n",
    "library(corrplot) # Для матрицы корреляций\n",
    "library(caret)    # Для машинного обучения (понадобится позже)\n",
    "\n",
    "# 1. Загрузка данных\n",
    "# Обычно на Kaggle данные лежат в папке /kaggle/input/... или в корне\n",
    "# Если файл называется иначе, поправьте путь\n",
    "df <- read_csv(\"/kaggle/input/e-commerce-dataset/diversified_ecommerce_dataset.csv\") %>%\n",
    "  clean_names() # Приводим названия к формату snake_case (product_id, tax_rate...)\n",
    "\n",
    "# 2. Смотрим структуру\n",
    "print(\"Структура датасета:\")\n",
    "glimpse(df)\n",
    "\n",
    "# 3. Проверка пропусков\n",
    "print(paste(\"Всего пропусков в данных:\", sum(is.na(df))))\n",
    "\n",
    "# 4. Матрица корреляций для выбора целевой переменной\n",
    "# Оставляем только числовые колонки для анализа связей\n",
    "numeric_df <- df %>% select(where(is.numeric))\n",
    "\n",
    "# Строим корреляционную матрицу\n",
    "cor_matrix <- cor(numeric_df, use = \"complete.obs\")\n",
    "\n",
    "# Визуализация\n",
    "options(repr.plot.width=10, repr.plot.height=10) # Размер графика для Kaggle\n",
    "corrplot(cor_matrix, \n",
    "         method = \"color\", \n",
    "         type = \"upper\", \n",
    "         addCoef.col = \"black\", # Добавляем цифры корреляции\n",
    "         tl.col = \"black\", \n",
    "         number.cex = 0.7,\n",
    "         diag = FALSE)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "422e8b1e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:55:43.345442Z",
     "iopub.status.busy": "2026-01-05T21:55:43.343887Z",
     "iopub.status.idle": "2026-01-05T21:55:43.696959Z",
     "shell.execute_reply": "2026-01-05T21:55:43.694843Z"
    },
    "papermill": {
     "duration": 0.365807,
     "end_time": "2026-01-05T21:55:43.699391",
     "exception": false,
     "start_time": "2026-01-05T21:55:43.333584",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Thank you for using fastDummies!\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "To acknowledge our work, please cite the package:\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Kaplan, J. & Schlegel, B. (2023). fastDummies: Fast Creation of Dummy (Binary) Columns and Rows from Categorical Variables. Version 1.7.1. URL: https://github.com/jacobkap/fastDummies, https://jacobkap.github.io/fastDummies/.\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Количество уникальных значений в категориях:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 1 × 6\u001b[39m\n",
      "  category customer_age_group customer_location customer_gender shipping_method\n",
      "     \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m              \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m             \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m           \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m           \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m        5                  5                15               3               3\n",
      "\u001b[90m# ℹ 1 more variable: seasonality <int>\u001b[39m\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Размерность после кодирования: 50000 x 34\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Данные готовы к обучению моделей.\"\n"
     ]
    }
   ],
   "source": [
    "library(caret)   # Для кодирования и разбиения\n",
    "library(fastDummies) # Быстрое создание дамми-переменных\n",
    "\n",
    "# 1. Отбор данных и уменьшение размерности (Сэмплирование)\n",
    "set.seed(123)\n",
    "# Берем 5% данных (50,000 строк), этого достаточно для стат. значимости\n",
    "# и это спасет нас от зависания на Stepwise-регрессии\n",
    "df_sample <- df %>%\n",
    "  sample_frac(0.05) %>% \n",
    "  select(-product_id, -product_name, -supplier_id) # Удаляем ID, они бесполезны\n",
    "\n",
    "# 2. Проверка кардинальности (сколько уникальных значений в тексте)\n",
    "# Если Customer Location имеет 1000 городов, это создаст 1000 колонок.\n",
    "# Оставим только те категории, где < 50 уникальных значений, чтобы не раздувать данные\n",
    "cat_check <- df_sample %>%\n",
    "  select(where(is.character)) %>%\n",
    "  summarise_all(n_distinct)\n",
    "print(\"Количество уникальных значений в категориях:\")\n",
    "print(cat_check)\n",
    "\n",
    "# 3. One-Hot Encoding (Превращаем категории в 0 и 1)\n",
    "# dummy_cols автоматически находит character столбцы\n",
    "df_encoded <- dummy_cols(df_sample, \n",
    "                         remove_first_dummy = TRUE, # Избегаем мультиколлинеарности\n",
    "                         remove_selected_columns = TRUE) %>%\n",
    "  clean_names()\n",
    "\n",
    "print(paste(\"Размерность после кодирования:\", paste(dim(df_encoded), collapse = \" x \")))\n",
    "\n",
    "# 4. Разделение на Train и Test (70/30)\n",
    "train_index <- createDataPartition(df_encoded$price, p = 0.7, list = FALSE)\n",
    "train_data <- df_encoded[train_index, ]\n",
    "test_data  <- df_encoded[-train_index, ]\n",
    "\n",
    "print(\"Данные готовы к обучению моделей.\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "d4ab1bc4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:55:43.721084Z",
     "iopub.status.busy": "2026-01-05T21:55:43.719533Z",
     "iopub.status.idle": "2026-01-05T21:55:51.319662Z",
     "shell.execute_reply": "2026-01-05T21:55:51.316644Z"
    },
    "papermill": {
     "duration": 7.61655,
     "end_time": "2026-01-05T21:55:51.324719",
     "exception": false,
     "start_time": "2026-01-05T21:55:43.708169",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Топ-5 корреляций Спирмена с Price:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                           price customer_location_toronto_canada \n",
      "                     1.000000000                     -0.010190172 \n",
      "   customer_location_phoenix_usa            customer_age_group_55 \n",
      "                     0.009235150                      0.006625283 \n",
      "   customer_location_houston_usa \n",
      "                     0.005966842 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Обучение PCR (Снижение размерности)...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Обучение Stepwise (Отбор признаков)...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Результаты моделей (RMSE и R2):\"\n"
     ]
    },
    {
     "data": {
      "text/plain": [
       "\n",
       "Call:\n",
       "summary.resamples(object = results)\n",
       "\n",
       "Models: PCR, Stepwise \n",
       "Number of resamples: 5 \n",
       "\n",
       "MAE \n",
       "             Min.  1st Qu.   Median     Mean  3rd Qu.     Max. NA's\n",
       "PCR      495.7877 498.3821 498.8133 499.1453 500.3858 502.3574    0\n",
       "Stepwise 496.9328 498.4472 499.4117 499.1540 499.9751 501.0031    0\n",
       "\n",
       "RMSE \n",
       "             Min.  1st Qu.   Median     Mean  3rd Qu.     Max. NA's\n",
       "PCR      574.0993 574.3634 575.4524 575.6542 576.4196 577.9362    0\n",
       "Stepwise 573.3928 575.0571 576.0720 575.6789 576.8298 577.0427    0\n",
       "\n",
       "Rsquared \n",
       "                 Min.      1st Qu.       Median         Mean      3rd Qu.\n",
       "PCR      8.220350e-07 6.765257e-06 2.461277e-05 7.421457e-05 4.942969e-05\n",
       "Stepwise 5.236397e-06 6.638555e-06 2.940810e-05 8.512769e-05 1.452989e-04\n",
       "                 Max. NA's\n",
       "PCR      0.0002894431    0\n",
       "Stepwise 0.0002390565    0\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Точность на тестовой выборке (PCR): RMSE = 575.88 R2 = 8e-05\"\n"
     ]
    }
   ],
   "source": [
    "library(caret)\n",
    "library(leaps) # Для leapSeq (Stepwise regression)\n",
    "\n",
    "\n",
    "cor_spearman <- cor(train_data %>% select(where(is.numeric)), method = \"spearman\")\n",
    "# Вытаскиваем только корреляции с price\n",
    "price_cor <- cor_spearman[\"price\", ]\n",
    "price_cor <- price_cor[order(abs(price_cor), decreasing = TRUE)] # Сортируем\n",
    "print(\"Топ-5 корреляций Спирмена с Price:\")\n",
    "print(head(price_cor, 5))\n",
    "\n",
    "# --- 2. Обучение моделей ---\n",
    "# Cross-Validation: 5 фолдов\n",
    "train_control <- trainControl(method = \"cv\", number = 5)\n",
    "\n",
    "print(\"Обучение PCR (Снижение размерности)...\")\n",
    "model_pcr <- train(price ~ ., data = train_data, \n",
    "                   method = \"pcr\",\n",
    "                   trControl = train_control,\n",
    "                   preProcess = c(\"center\", \"scale\"),\n",
    "                   tuneLength = 10)\n",
    "\n",
    "print(\"Обучение Stepwise (Отбор признаков)...\")\n",
    "model_step <- train(price ~ ., data = train_data, \n",
    "                    method = \"leapSeq\", \n",
    "                    trControl = train_control,\n",
    "                    tuneGrid = data.frame(nvmax = 1:5)) # Ограничим до 5 переменных для скорости\n",
    "\n",
    "# --- 3. Сравнение результатов ---\n",
    "results <- resamples(list(PCR = model_pcr, Stepwise = model_step))\n",
    "\n",
    "print(\"Результаты моделей (RMSE и R2):\")\n",
    "summary(results)\n",
    "\n",
    "# --- 4. Финальный тест на отложенной выборке ---\n",
    "pred_pcr <- predict(model_pcr, newdata = test_data)\n",
    "rmse_test <- RMSE(pred_pcr, test_data$price)\n",
    "r2_test <- R2(pred_pcr, test_data$price)\n",
    "\n",
    "print(paste(\"Точность на тестовой выборке (PCR): RMSE =\", round(rmse_test, 2), \"R2 =\", round(r2_test, 5)))\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "1c8ec950",
   "metadata": {
    "papermill": {
     "duration": 0.016272,
     "end_time": "2026-01-05T21:55:51.357390",
     "exception": false,
     "start_time": "2026-01-05T21:55:51.341118",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Между данными практически нулевая корреляция. Соответственно обе модели, показали около нулевой результат. RMSE около 570, что много, с учетом того, что цены лежат в диапазоне от 10 до 2000. Stepwise алгоритм, который использовали никак не ухудшил и не улучшил решение на полных данных, потому что задача изначально не решилась. "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "ed96c182",
   "metadata": {
    "papermill": {
     "duration": 0.016279,
     "end_time": "2026-01-05T21:55:51.389994",
     "exception": false,
     "start_time": "2026-01-05T21:55:51.373715",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Задание 4\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "6d35a49d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:55:51.422344Z",
     "iopub.status.busy": "2026-01-05T21:55:51.420784Z",
     "iopub.status.idle": "2026-01-05T21:55:51.795991Z",
     "shell.execute_reply": "2026-01-05T21:55:51.793846Z"
    },
    "papermill": {
     "duration": 0.392588,
     "end_time": "2026-01-05T21:55:51.799021",
     "exception": false,
     "start_time": "2026-01-05T21:55:51.406433",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Данные очищены. Размер:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] 55692    25\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Разделение завершено.\"\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "library(caret)\n",
    "library(janitor) # Если нет - library(tidyverse) хватит, но clean_names удобнее\n",
    "\n",
    "# 1. Загрузка\n",
    "# Если путь другой - поправь\n",
    "df <- read_csv(\"/kaggle/input/body-signal-of-smoking/smoking.csv\", show_col_types = FALSE)\n",
    "\n",
    "# 2. Переименование (чтобы убрать скобки и пробелы)\n",
    "df <- df %>%\n",
    "  clean_names() %>% # Автоматически делает height_cm, eyesight_left\n",
    "  rename(\n",
    "    height_cm = height_cm,\n",
    "    weight_kg = weight_kg\n",
    "    # janitor обычно справляется сам, но если что - имена станут snake_case\n",
    "  )\n",
    "\n",
    "# 3. Чистка\n",
    "# Убираем ID и колонки где всего 1 значение (например oral)\n",
    "df_clean <- df %>%\n",
    "  select(-id) %>%\n",
    "  select(where(~n_distinct(.) > 1)) %>% # Оставляет только те, где >1 значения\n",
    "  mutate(\n",
    "    gender = ifelse(gender == \"M\", 1, 0),\n",
    "    tartar = ifelse(tartar == \"Y\", 1, 0),\n",
    "    smoking = as.factor(ifelse(smoking == 1, \"Smoker\", \"NonSmoker\"))\n",
    "  ) %>%\n",
    "  na.omit()\n",
    "\n",
    "print(\"Данные очищены. Размер:\")\n",
    "print(dim(df_clean))\n",
    "\n",
    "# 4. Разделение на Train/Test\n",
    "set.seed(42)\n",
    "index <- createDataPartition(df_clean$smoking, p = 0.8, list = FALSE)\n",
    "train_data <- df_clean[index, ]\n",
    "test_data  <- df_clean[-index, ]\n",
    "\n",
    "print(\"Разделение завершено.\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "8fe76009",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-05T21:55:51.821259Z",
     "iopub.status.busy": "2026-01-05T21:55:51.819722Z",
     "iopub.status.idle": "2026-01-05T21:57:24.284240Z",
     "shell.execute_reply": "2026-01-05T21:57:24.280088Z"
    },
    "papermill": {
     "duration": 92.481518,
     "end_time": "2026-01-05T21:57:24.289753",
     "exception": false,
     "start_time": "2026-01-05T21:55:51.808235",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"--- 1. Full Model (Все признаки) ---\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy FULL: 0.7434\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"--- 2. RFE (Отбор признаков) ---\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Лучшие признаки по мнению RFE:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      " [1] \"gender\"       \"height_cm\"    \"gtp\"          \"hemoglobin\"   \"age\"         \n",
      " [6] \"ast\"          \"triglyceride\" \"alt\"          \"weight_kg\"    \"ldl\"         \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy RFE: 0.7324\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"--- 3. PCA (Снижение размерности) ---\"\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“Setting row names on a tibble is deprecated.”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Accuracy PCA: 0.7336\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Осталось компонент: 19\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                   Method  Accuracy\n",
      "1              Full Model 0.7434010\n",
      "2 Feature Selection (RFE) 0.7324475\n",
      "3    Dim. Reduction (PCA) 0.7336147\n"
     ]
    }
   ],
   "source": [
    "library(caret)\n",
    "\n",
    "print(\"--- 1. Full Model (Все признаки) ---\")\n",
    "# Обучаем простую логистическую регрессию\n",
    "model_full <- train(smoking ~ ., data = train_data, \n",
    "                    method = \"glm\", family = \"binomial\")\n",
    "pred_full <- predict(model_full, newdata = test_data)\n",
    "acc_full <- confusionMatrix(pred_full, test_data$smoking)$overall['Accuracy']\n",
    "print(paste(\"Accuracy FULL:\", round(acc_full, 4)))\n",
    "\n",
    "\n",
    "print(\"--- 2. RFE (Отбор признаков) ---\")\n",
    "set.seed(123)\n",
    "# Берем подвыборку для быстрого отбора признаков\n",
    "subsample <- train_data %>% sample_n(2000)\n",
    "\n",
    "# Настройка RFE (используем Random Forest для оценки важности - rfFuncs)\n",
    "control_rfe <- rfeControl(functions = rfFuncs, method = \"cv\", number = 5)\n",
    "\n",
    "# Запускаем отбор (ищем оптимальное кол-во: 5, 10 или 15 признаков)\n",
    "results_rfe <- rfe(x = subsample %>% select(-smoking), \n",
    "                   y = subsample$smoking,\n",
    "                   sizes = c(5, 10, 15),\n",
    "                   rfeControl = control_rfe)\n",
    "\n",
    "print(\"Лучшие признаки по мнению RFE:\")\n",
    "print(predictors(results_rfe))\n",
    "\n",
    "# Обучаем финальную модель ТОЛЬКО на отобранных признаках\n",
    "# Используем все данные (train_data), но только нужные колонки\n",
    "selected_vars <- predictors(results_rfe)\n",
    "train_rfe_data <- train_data %>% select(all_of(selected_vars), smoking)\n",
    "test_rfe_data  <- test_data %>% select(all_of(selected_vars), smoking)\n",
    "\n",
    "model_rfe <- train(smoking ~ ., data = train_rfe_data, \n",
    "                   method = \"glm\", family = \"binomial\")\n",
    "pred_rfe <- predict(model_rfe, newdata = test_rfe_data)\n",
    "acc_rfe <- confusionMatrix(pred_rfe, test_rfe_data$smoking)$overall['Accuracy']\n",
    "print(paste(\"Accuracy RFE:\", round(acc_rfe, 4)))\n",
    "\n",
    "\n",
    "print(\"--- 3. PCA (Снижение размерности) ---\")\n",
    "# Явно отделяем X и Y, чтобы избежать ошибки\n",
    "train_x <- train_data %>% select(-smoking)\n",
    "train_y <- train_data$smoking\n",
    "test_x  <- test_data %>% select(-smoking)\n",
    "\n",
    "model_pca <- train(x = train_x, \n",
    "                   y = train_y, \n",
    "                   method = \"glm\", family = \"binomial\",\n",
    "                   preProcess = c(\"center\", \"scale\", \"pca\"), # Сжатие\n",
    "                   trControl = trainControl(method = \"none\", preProcOptions = list(thresh = 0.95)))\n",
    "\n",
    "pred_pca <- predict(model_pca, newdata = test_x)\n",
    "acc_pca <- confusionMatrix(pred_pca, test_data$smoking)$overall['Accuracy']\n",
    "print(paste(\"Accuracy PCA:\", round(acc_pca, 4)))\n",
    "print(paste(\"Осталось компонент:\", length(model_pca$preProcess$rotation[1,])))\n",
    "\n",
    "\n",
    "# --- Итог ---\n",
    "final_results <- data.frame(\n",
    "  Method = c(\"Full Model\", \"Feature Selection (RFE)\", \"Dim. Reduction (PCA)\"),\n",
    "  Accuracy = c(acc_full, acc_rfe, acc_pca)\n",
    ")\n",
    "print(final_results)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "7ee87d31",
   "metadata": {
    "papermill": {
     "duration": 0.014421,
     "end_time": "2026-01-05T21:57:24.331394",
     "exception": false,
     "start_time": "2026-01-05T21:57:24.316973",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Базовая модель на 24 признаках дала точность 0.7434010. RFE отобрал 10 ключевых признаков (в прошлый раз было 15, скорее всего потому что для ускорения его работы для отбора признаков использовались подвыборки). RFE на 10 признаках дал точность 0.7324475. PCA на 19 признаках (с сохранением 95% дисперсии) дал точность 0.7336147. Оба алгоритма отработали хорошо, но для конечного решения я бы оставил RFE, потому что PCA создает абстрактные компоненты, с которыми потом заметно сложнее работать людям из отрасли (врачам в данном случае)"
   ]
  }
 ],
 "metadata": {
  "kaggle": {
   "accelerator": "none",
   "dataSources": [
    {
     "datasetId": 2157551,
     "sourceId": 3637312,
     "sourceType": "datasetVersion"
    },
    {
     "datasetId": 4269029,
     "sourceId": 7351086,
     "sourceType": "datasetVersion"
    },
    {
     "datasetId": 6193920,
     "sourceId": 10052484,
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
   "duration": 216.947685,
   "end_time": "2026-01-05T21:57:24.463955",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2026-01-05T21:53:47.516270",
   "version": "2.6.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
