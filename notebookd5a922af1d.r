{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "7079da99",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:10:08.919300Z",
     "iopub.status.busy": "2026-01-13T10:10:08.916748Z",
     "iopub.status.idle": "2026-01-13T10:11:50.544365Z",
     "shell.execute_reply": "2026-01-13T10:11:50.542358Z"
    },
    "papermill": {
     "duration": 101.642691,
     "end_time": "2026-01-13T10:11:50.547839",
     "exception": false,
     "start_time": "2026-01-13T10:10:08.905148",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Installing package into ‘/usr/local/lib/R/site-library’\n",
      "(as ‘lib’ is unspecified)\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Installing package into ‘/usr/local/lib/R/site-library’\n",
      "(as ‘lib’ is unspecified)\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "also installing the dependency ‘mrfDepth’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Loading required package: ggplot2\n",
      "\n"
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
      "The following object is masked from ‘package:httr’:\n",
      "\n",
      "    progress\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘caretEnsemble’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:ggplot2’:\n",
      "\n",
      "    autoplot\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘dplyr’\n",
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
      "    filter, lag\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following objects are masked from ‘package:base’:\n",
      "\n",
      "    intersect, setdiff, setequal, union\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Type 'citation(\"pROC\")' for a citation.\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘pROC’\n",
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
      "    cov, smooth, var\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘kernlab’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:ggplot2’:\n",
      "\n",
      "    alpha\n",
      "\n",
      "\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК 0: БИБЛИОТЕКИ И ДАННЫЕ ---\n",
    "install.packages(\"coRanking\")\n",
    "install.packages(\"rospca\")\n",
    "\n",
    "library(caret)\n",
    "library(caretEnsemble)\n",
    "library(dplyr)\n",
    "library(infotheo)\n",
    "library(ggplot2)\n",
    "library(haven)\n",
    "library(pROC)\n",
    "library(tidyr)\n",
    "library(FactoMineR)\n",
    "library(kernlab)\n",
    "library(coRanking)\n",
    "library(rospca)\n",
    "# чтение RLMS-файла\n",
    "df <- read_sav(\"/kaggle/input/kursovaya/r33i_os_84.sav\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "6adf82dd",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:11:50.606857Z",
     "iopub.status.busy": "2026-01-13T10:11:50.568767Z",
     "iopub.status.idle": "2026-01-13T10:11:50.726125Z",
     "shell.execute_reply": "2026-01-13T10:11:50.724218Z"
    },
    "papermill": {
     "duration": 0.171689,
     "end_time": "2026-01-13T10:11:50.728837",
     "exception": false,
     "start_time": "2026-01-13T10:11:50.557148",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# --- БЛОК 1: EDA И FEATURE ENGINEERING ДЛЯ АНАЛИЗА ПРИЗНАКОВ ---\n",
    "\n",
    "df_eda <- df %>%\n",
    "  filter(cc_age >= 7 & cc_age < 18) %>%\n",
    "  select(\n",
    "    health_score = ccm3,\n",
    "    age          = cc_age,\n",
    "    weight       = ccm1,\n",
    "    height       = ccm2,\n",
    "    grades       = cck3.5,\n",
    "    class_size   = cck3.2,\n",
    "    internet     = ccj123,\n",
    "    has_phone    = ccj125.1,\n",
    "    screen_limit = cck27,\n",
    "    sport_freq   = cck7.5,\n",
    "    pe_lessons   = cck7.1,\n",
    "    friends_meet = cck8.20,\n",
    "    hospital_3m  = ccl20,\n",
    "    minor_illness= ccl5.1,\n",
    "    checkup      = ccl26,\n",
    "    region,\n",
    "    status\n",
    "  ) %>%\n",
    "  mutate(across(everything(), ~ ifelse(. > 9000, NA, .))) %>%\n",
    "  na.omit() %>%\n",
    "  mutate(\n",
    "    bmi        = weight / ((height/100)^2),\n",
    "    age_sq     = age^2,\n",
    "    bmi_sq     = bmi^2,\n",
    "    friends_sq = friends_meet^2,\n",
    "    target     = factor(ifelse(health_score <= 2, \"Healthy\", \"Not_Healthy\"))\n",
    "  ) %>%\n",
    "  select(-health_score)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 3,
   "id": "c3c72f99",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:11:50.751606Z",
     "iopub.status.busy": "2026-01-13T10:11:50.749971Z",
     "iopub.status.idle": "2026-01-13T10:11:50.771034Z",
     "shell.execute_reply": "2026-01-13T10:11:50.768679Z"
    },
    "papermill": {
     "duration": 0.036134,
     "end_time": "2026-01-13T10:11:50.774374",
     "exception": false,
     "start_time": "2026-01-13T10:11:50.738240",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "X_dr <- df_eda %>%\n",
    "  select(where(is.numeric)) %>%\n",
    "  select(-age_sq, -bmi_sq, -friends_sq) %>%  # можно оставить только \"сырые\" признаки\n",
    "  as.data.frame()"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "eac7d7bb",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:11:50.797071Z",
     "iopub.status.busy": "2026-01-13T10:11:50.795363Z",
     "iopub.status.idle": "2026-01-13T10:11:50.811020Z",
     "shell.execute_reply": "2026-01-13T10:11:50.809131Z"
    },
    "papermill": {
     "duration": 0.029821,
     "end_time": "2026-01-13T10:11:50.813504",
     "exception": false,
     "start_time": "2026-01-13T10:11:50.783683",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "compute_dr_metrics <- function(original, reduced, name) {\n",
    "  Q_matrix <- coranking(original, reduced)\n",
    "  data.frame(\n",
    "    Method = name,\n",
    "    LCMC   = mean(LCMC(Q_matrix)),\n",
    "    R_NX   = mean(R_NX(Q_matrix)),\n",
    "    Q_NX   = mean(Q_NX(Q_matrix)),\n",
    "    AUC_ln_K = AUC_ln_K(R_NX(Q_matrix))\n",
    "  )\n",
    "}\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "f6e009e4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:11:50.835580Z",
     "iopub.status.busy": "2026-01-13T10:11:50.833963Z",
     "iopub.status.idle": "2026-01-13T10:11:54.274065Z",
     "shell.execute_reply": "2026-01-13T10:11:54.271946Z"
    },
    "papermill": {
     "duration": 3.45387,
     "end_time": "2026-01-13T10:11:54.276516",
     "exception": false,
     "start_time": "2026-01-13T10:11:50.822646",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in rankmatrix(dX, input = \"dist\", use):\n",
      "“0 outside of diagonal in distance matrix”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "      Method        LCMC        R_NX      Q_NX   AUC_ln_K\n",
      "1        PCA  0.08567309  0.19116443 0.5870815 0.10272088\n",
      "2 Robust PCA  0.39973061  0.86132200 0.9011391 0.61267035\n",
      "3 Kernel PCA -0.01536611 -0.05263019 0.4860423 0.01837379\n"
     ]
    }
   ],
   "source": [
    "\n",
    "# 1. Берём числовые признаки\n",
    "X_dr_raw <- df_eda %>%\n",
    "  select(where(is.numeric)) %>%\n",
    "  as.data.frame()\n",
    "\n",
    "# 2. Убираем константные/нулевые по дисперсии колонки\n",
    "var_vec <- sapply(X_dr_raw, var, na.rm = TRUE)\n",
    "X_dr <- X_dr_raw[, var_vec > 0]\n",
    "\n",
    "# 3. Далее используем X_dr во всех методах DR\n",
    "# --- PCA ---\n",
    "pca_result <- prcomp(X_dr, center = TRUE, scale. = TRUE)\n",
    "Base_1_pca <- as.data.frame(pca_result$x[, 1:2])\n",
    "\n",
    "# --- Robust PCA ---\n",
    "pca_robust <- robpca(X_dr, k = 2)\n",
    "Base_1_pca_robust <- as.data.frame(pca_robust$scores)\n",
    "\n",
    "# --- Kernel PCA ---\n",
    "pca_kernel <- kpca(~., data = X_dr, kernel = \"rbfdot\", features = 2)\n",
    "Base_1_pca_kernel <- as.data.frame(rotated(pca_kernel))\n",
    "\n",
    "compute_metrics <- function(original, reduced, name) {\n",
    "  Q_matrix <- coranking(original, reduced)\n",
    "  data.frame(\n",
    "    Method = name,\n",
    "    LCMC   = mean(LCMC(Q_matrix)),\n",
    "    R_NX   = mean(R_NX(Q_matrix)),\n",
    "    Q_NX   = mean(Q_NX(Q_matrix)),\n",
    "    AUC_ln_K = AUC_ln_K(R_NX(Q_matrix))\n",
    "  )\n",
    "}\n",
    "\n",
    "dr_results <- dplyr::bind_rows(\n",
    "  compute_metrics(X_dr, Base_1_pca,         \"PCA\"),\n",
    "  compute_metrics(X_dr, Base_1_pca_robust,  \"Robust PCA\"),\n",
    "  compute_metrics(X_dr, Base_1_pca_kernel,  \"Kernel PCA\")\n",
    ")\n",
    "\n",
    "print(dr_results)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "70457926",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:11:54.298676Z",
     "iopub.status.busy": "2026-01-13T10:11:54.297094Z",
     "iopub.status.idle": "2026-01-13T10:11:54.464718Z",
     "shell.execute_reply": "2026-01-13T10:11:54.462530Z"
    },
    "papermill": {
     "duration": 0.181516,
     "end_time": "2026-01-13T10:11:54.467245",
     "exception": false,
     "start_time": "2026-01-13T10:11:54.285729",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Удаляем почти константные колонки (train):\"\n",
      "[1] \"internet\"    \"pe_lessons\"  \"hospital_3m\"\n"
     ]
    }
   ],
   "source": [
    "df_mod <- df %>%\n",
    "  filter(cc_age >= 7 & cc_age < 18) %>%\n",
    "  select(\n",
    "    health_score = ccm3,\n",
    "    age          = cc_age,\n",
    "    weight       = ccm1,\n",
    "    height       = ccm2,\n",
    "    grades       = cck3.5,\n",
    "    class_size   = cck3.2,\n",
    "    internet     = ccj123,\n",
    "    has_phone    = ccj125.1,\n",
    "    screen_limit = cck27,\n",
    "    sport_freq   = cck7.5,\n",
    "    pe_lessons   = cck7.1,\n",
    "    friends_meet = cck8.20,\n",
    "    hospital_3m  = ccl20,\n",
    "    minor_illness= ccl5.1,\n",
    "    checkup      = ccl26,\n",
    "    region,\n",
    "    status\n",
    "  ) %>%\n",
    "  mutate(across(everything(), ~ ifelse(. > 9000, NA, .))) %>%\n",
    "  mutate(\n",
    "    sport_freq   = ifelse(is.na(sport_freq),   0, sport_freq),\n",
    "    friends_meet = ifelse(is.na(friends_meet), 3, friends_meet),\n",
    "    minor_illness= ifelse(is.na(minor_illness),2, minor_illness)\n",
    "  ) %>%\n",
    "  mutate(\n",
    "    bmi        = weight / ((height/100)^2),\n",
    "    age_sq     = age^2,\n",
    "    bmi_sq     = bmi^2,\n",
    "    friends_sq = friends_meet^2,\n",
    "    target = factor(\n",
    "      ifelse(health_score <= 2, \"Healthy\", \"Not_Healthy\"),\n",
    "      levels = c(\"Healthy\",\"Not_Healthy\")\n",
    "    )\n",
    "  ) %>%\n",
    "  select(-health_score, -bmi) %>%\n",
    "  na.omit()\n",
    "\n",
    "# Честное разделение\n",
    "set.seed(123)\n",
    "train_idx <- createDataPartition(df_mod$target, p = 0.8, list = FALSE)\n",
    "df_train <- df_mod[train_idx, ]\n",
    "df_test  <- df_mod[-train_idx, ]\n",
    "\n",
    "# Near Zero Variance – только по train, но чистим и test\n",
    "nzv <- nearZeroVar(df_train, saveMetrics = TRUE)\n",
    "if (any(nzv$nzv)) {\n",
    "  print(\"Удаляем почти константные колонки (train):\")\n",
    "  print(rownames(nzv)[nzv$nzv])\n",
    "  df_train <- df_train[, !nzv$nzv]\n",
    "  df_test  <- df_test[,  !nzv$nzv]\n",
    "}"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "60372687",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:11:54.489605Z",
     "iopub.status.busy": "2026-01-13T10:11:54.488001Z",
     "iopub.status.idle": "2026-01-13T10:12:04.045835Z",
     "shell.execute_reply": "2026-01-13T10:12:04.043978Z"
    },
    "papermill": {
     "duration": 9.572472,
     "end_time": "2026-01-13T10:12:04.048977",
     "exception": false,
     "start_time": "2026-01-13T10:11:54.476505",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# --- RF FULL: все признаки без DR ---\n",
    "\n",
    "set.seed(123)\n",
    "ctrl_rf <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "rf_full <- train(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  method = \"rf\",\n",
    "  trControl = ctrl_rf,\n",
    "  tuneLength = 3\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "10f2fa35",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:04.071547Z",
     "iopub.status.busy": "2026-01-13T10:12:04.069957Z",
     "iopub.status.idle": "2026-01-13T10:12:10.595114Z",
     "shell.execute_reply": "2026-01-13T10:12:10.593196Z"
    },
    "papermill": {
     "duration": 6.539529,
     "end_time": "2026-01-13T10:12:10.597926",
     "exception": false,
     "start_time": "2026-01-13T10:12:04.058397",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "rf variable importance\n",
      "\n",
      "              Overall\n",
      "bmi_sq        100.000\n",
      "region         72.675\n",
      "height         57.668\n",
      "weight         54.958\n",
      "grades         48.943\n",
      "age_sq         27.195\n",
      "age            26.670\n",
      "sport_freq     23.687\n",
      "status         14.024\n",
      "friends_meet   13.172\n",
      "friends_sq     12.469\n",
      "class_size     10.522\n",
      "checkup         9.499\n",
      "screen_limit    7.188\n",
      "has_phone       2.894\n",
      "minor_illness   0.000\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Топовые признаки для RF:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      " [1] \"bmi_sq\"       \"region\"       \"height\"       \"weight\"       \"grades\"      \n",
      " [6] \"age_sq\"       \"age\"          \"sport_freq\"   \"status\"       \"friends_meet\"\n"
     ]
    }
   ],
   "source": [
    "# --- ВАЖНОСТЬ ПРИЗНАКОВ ДЛЯ RF ---\n",
    "\n",
    "rf_varimp <- varImp(rf_full, scale = TRUE)\n",
    "print(rf_varimp)\n",
    "\n",
    "# Выбираем топ-10 признаков по важности\n",
    "top_k <- 10\n",
    "top_feats <- rownames(rf_varimp$importance)[\n",
    "  order(rf_varimp$importance$Overall, decreasing = TRUE)\n",
    "][1:top_k]\n",
    "\n",
    "print(\"Топовые признаки для RF:\")\n",
    "print(top_feats)\n",
    "\n",
    "# Формируем датасеты только с этими признаками\n",
    "df_train_rf_top <- df_train %>%\n",
    "  select(all_of(c(\"target\", top_feats)))\n",
    "\n",
    "df_test_rf_top <- df_test %>%\n",
    "  select(all_of(c(\"target\", top_feats)))\n",
    "\n",
    "# --- RF TOP-K: модель только на отобранных признаках ---\n",
    "\n",
    "set.seed(123)\n",
    "rf_topk <- train(\n",
    "  target ~ .,\n",
    "  data = df_train_rf_top,\n",
    "  method = \"rf\",\n",
    "  trControl = ctrl_rf,\n",
    "  tuneLength = 3\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "08d6cd46",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:10.621539Z",
     "iopub.status.busy": "2026-01-13T10:12:10.619891Z",
     "iopub.status.idle": "2026-01-13T10:12:10.635132Z",
     "shell.execute_reply": "2026-01-13T10:12:10.633219Z"
    },
    "papermill": {
     "duration": 0.029837,
     "end_time": "2026-01-13T10:12:10.637670",
     "exception": false,
     "start_time": "2026-01-13T10:12:10.607833",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# --- ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ МЕТРИК ---\n",
    "\n",
    "get_full_metrics <- function(model, model_name, data) {\n",
    "  preds <- predict(model, newdata = data)\n",
    "  probs <- tryCatch(\n",
    "    predict(model, newdata = data, type = \"prob\"),\n",
    "    error = function(e) NULL\n",
    "  )\n",
    "\n",
    "  cm <- confusionMatrix(preds, data$target)\n",
    "\n",
    "  acc  <- cm$overall[\"Accuracy\"]\n",
    "  kap  <- cm$overall[\"Kappa\"]\n",
    "  sens <- cm$byClass[\"Sensitivity\"]\n",
    "  spec <- cm$byClass[\"Specificity\"]\n",
    "  ppv  <- cm$byClass[\"Pos Pred Value\"]\n",
    "  npv  <- cm$byClass[\"Neg Pred Value\"]\n",
    "  f1   <- cm$byClass[\"F1\"]\n",
    "\n",
    "  data.frame(\n",
    "    Model       = model_name,\n",
    "    Accuracy    = round(acc, 4),\n",
    "    Kappa       = round(kap, 4),\n",
    "    Sensitivity = round(sens, 4),\n",
    "    Specificity = round(spec, 4),\n",
    "    Precision   = round(ppv, 4),\n",
    "    NPV         = round(npv, 4),\n",
    "    F1          = round(f1, 4),\n",
    "    row.names   = NULL\n",
    "  )\n",
    "}\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "39f1b607",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:10.660635Z",
     "iopub.status.busy": "2026-01-13T10:12:10.659041Z",
     "iopub.status.idle": "2026-01-13T10:12:10.781929Z",
     "shell.execute_reply": "2026-01-13T10:12:10.779814Z"
    },
    "papermill": {
     "duration": 0.137231,
     "end_time": "2026-01-13T10:12:10.784593",
     "exception": false,
     "start_time": "2026-01-13T10:12:10.647362",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "    Model Accuracy  Kappa Sensitivity Specificity Precision    NPV    F1\n",
      "1 RF full   0.8274 0.2528      0.9706      0.2188    0.8408 0.6364 0.901\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "      Model Accuracy  Kappa Sensitivity Specificity Precision    NPV     F1\n",
      "1 RF top-10   0.8155 0.1749      0.9706      0.1562    0.8302 0.5556 0.8949\n"
     ]
    }
   ],
   "source": [
    "# --- МЕТРИКИ RF FULL vs RF TOP-K ---\n",
    "\n",
    "metrics_rf_full <- get_full_metrics(rf_full,  \"RF full\",  df_test)\n",
    "metrics_rf_topk <- get_full_metrics(rf_topk, \"RF top-10\", df_test_rf_top)\n",
    "\n",
    "print(metrics_rf_full)\n",
    "print(metrics_rf_topk)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "207f2653",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:10.808096Z",
     "iopub.status.busy": "2026-01-13T10:12:10.806427Z",
     "iopub.status.idle": "2026-01-13T10:12:28.605503Z",
     "shell.execute_reply": "2026-01-13T10:12:28.603599Z"
    },
    "papermill": {
     "duration": 17.814853,
     "end_time": "2026-01-13T10:12:28.609289",
     "exception": false,
     "start_time": "2026-01-13T10:12:10.794436",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "# --- XGB FULL: все признаки без DR ---\n",
    "\n",
    "set.seed(123)\n",
    "ctrl_xgb <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "xgb_full <- train(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  method = \"xgbTree\",\n",
    "  trControl = ctrl_xgb,\n",
    "  tuneLength = 3,\n",
    "  verbosity = 0\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "8a2ced73",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:28.633598Z",
     "iopub.status.busy": "2026-01-13T10:12:28.631697Z",
     "iopub.status.idle": "2026-01-13T10:12:45.350323Z",
     "shell.execute_reply": "2026-01-13T10:12:45.348362Z"
    },
    "papermill": {
     "duration": 16.734619,
     "end_time": "2026-01-13T10:12:45.354173",
     "exception": false,
     "start_time": "2026-01-13T10:12:28.619554",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "df_train_xgb_top <- df_train %>%\n",
    "  select(all_of(c(\"target\", top_feats)))\n",
    "\n",
    "df_test_xgb_top <- df_test %>%\n",
    "  select(all_of(c(\"target\", top_feats)))\n",
    "\n",
    "set.seed(123)\n",
    "xgb_topk <- train(\n",
    "  target ~ .,\n",
    "  data = df_train_xgb_top,\n",
    "  method = \"xgbTree\",\n",
    "  trControl = ctrl_xgb,\n",
    "  tuneLength = 3,\n",
    "  verbosity = 0\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "75e46b63",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:45.378412Z",
     "iopub.status.busy": "2026-01-13T10:12:45.376726Z",
     "iopub.status.idle": "2026-01-13T10:12:45.464851Z",
     "shell.execute_reply": "2026-01-13T10:12:45.462312Z"
    },
    "papermill": {
     "duration": 0.103207,
     "end_time": "2026-01-13T10:12:45.468139",
     "exception": false,
     "start_time": "2026-01-13T10:12:45.364932",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "     Model Accuracy  Kappa Sensitivity Specificity Precision    NPV     F1\n",
      "1 XGB full   0.8274 0.2281      0.9779      0.1875    0.8365 0.6667 0.9017\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "       Model Accuracy  Kappa Sensitivity Specificity Precision   NPV     F1\n",
      "1 XGB top-10   0.8214 0.1881      0.9779      0.1562    0.8312 0.625 0.8986\n"
     ]
    }
   ],
   "source": [
    "metrics_xgb_full <- get_full_metrics(xgb_full,  \"XGB full\",  df_test)\n",
    "metrics_xgb_topk <- get_full_metrics(xgb_topk, \"XGB top-10\", df_test_xgb_top)\n",
    "\n",
    "print(metrics_xgb_full)\n",
    "print(metrics_xgb_topk)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "e7c87cb2",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:45.491578Z",
     "iopub.status.busy": "2026-01-13T10:12:45.489866Z",
     "iopub.status.idle": "2026-01-13T10:12:45.860917Z",
     "shell.execute_reply": "2026-01-13T10:12:45.858193Z"
    },
    "papermill": {
     "duration": 0.386869,
     "end_time": "2026-01-13T10:12:45.864866",
     "exception": false,
     "start_time": "2026-01-13T10:12:45.477997",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    }
   ],
   "source": [
    "# --- GLM FULL: все признаки без DR ---\n",
    "\n",
    "set.seed(123)\n",
    "ctrl_glm <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "glm_full <- train(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  method = \"glm\",\n",
    "  trControl = ctrl_glm\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "6e40da36",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:45.902127Z",
     "iopub.status.busy": "2026-01-13T10:12:45.897899Z",
     "iopub.status.idle": "2026-01-13T10:12:46.905346Z",
     "shell.execute_reply": "2026-01-13T10:12:46.903493Z"
    },
    "papermill": {
     "duration": 1.028573,
     "end_time": "2026-01-13T10:12:46.908754",
     "exception": false,
     "start_time": "2026-01-13T10:12:45.880181",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Recursive feature selection\n",
      "\n",
      "Outer resampling method: Cross-Validated (5 fold) \n",
      "\n",
      "Resampling performance over subset size:\n",
      "\n",
      " Variables Accuracy   Kappa AccuracySD KappaSD Selected\n",
      "         5   0.8147 0.07913   0.008804 0.05017         \n",
      "         8   0.8147 0.10303   0.005375 0.03436         \n",
      "        12   0.8177 0.10978   0.009101 0.04162        *\n",
      "        16   0.8177 0.10978   0.009101 0.04162         \n",
      "\n",
      "The top 5 variables (out of 12):\n",
      "   has_phone, region, checkup, sport_freq, age\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Отобранные признаки для GLM (RFE):\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      " [1] \"has_phone\"    \"region\"       \"checkup\"      \"sport_freq\"   \"age\"         \n",
      " [6] \"bmi_sq\"       \"class_size\"   \"age_sq\"       \"screen_limit\" \"friends_meet\"\n",
      "[11] \"weight\"       \"friends_sq\"  \n"
     ]
    }
   ],
   "source": [
    "# --- GLM-RFE: отбор признаков для логистической регрессии ---\n",
    "\n",
    "ctrl_rfe_glm <- rfeControl(\n",
    "  functions = lrFuncs,   # логистическая регрессия\n",
    "  method    = \"cv\",\n",
    "  number    = 5\n",
    ")\n",
    "\n",
    "set.seed(123)\n",
    "rfe_glm <- rfe(\n",
    "  x = df_train %>% select(-target),\n",
    "  y = df_train$target,\n",
    "  sizes = c(5, 8, 12, 16),\n",
    "  rfeControl = ctrl_rfe_glm\n",
    ")\n",
    "\n",
    "print(rfe_glm)\n",
    "predictors_glm <- predictors(rfe_glm)  # итоговый список признаков\n",
    "print(\"Отобранные признаки для GLM (RFE):\")\n",
    "print(predictors_glm)\n",
    "\n",
    "df_train_glm_rfe <- df_train %>%\n",
    "  select(all_of(c(\"target\", predictors_glm)))\n",
    "\n",
    "df_test_glm_rfe <- df_test %>%\n",
    "  select(all_of(c(\"target\", predictors_glm)))\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "f595e5f5",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:46.933561Z",
     "iopub.status.busy": "2026-01-13T10:12:46.931858Z",
     "iopub.status.idle": "2026-01-13T10:12:47.179410Z",
     "shell.execute_reply": "2026-01-13T10:12:47.177509Z"
    },
    "papermill": {
     "duration": 0.262411,
     "end_time": "2026-01-13T10:12:47.181749",
     "exception": false,
     "start_time": "2026-01-13T10:12:46.919338",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    }
   ],
   "source": [
    "set.seed(123)\n",
    "glm_rfe <- train(\n",
    "  target ~ .,\n",
    "  data = df_train_glm_rfe,\n",
    "  method = \"glm\",\n",
    "  trControl = ctrl_glm\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "id": "899a4d78",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:47.207059Z",
     "iopub.status.busy": "2026-01-13T10:12:47.205429Z",
     "iopub.status.idle": "2026-01-13T10:12:47.253480Z",
     "shell.execute_reply": "2026-01-13T10:12:47.251482Z"
    },
    "papermill": {
     "duration": 0.063474,
     "end_time": "2026-01-13T10:12:47.256011",
     "exception": false,
     "start_time": "2026-01-13T10:12:47.192537",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "     Model Accuracy  Kappa Sensitivity Specificity Precision    NPV     F1\n",
      "1 GLM full   0.8155 0.1468      0.9779       0.125    0.8261 0.5714 0.8956\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "    Model Accuracy  Kappa Sensitivity Specificity Precision    NPV     F1\n",
      "1 GLM RFE   0.8155 0.1468      0.9779       0.125    0.8261 0.5714 0.8956\n"
     ]
    }
   ],
   "source": [
    "metrics_glm_full <- get_full_metrics(glm_full, \"GLM full\", df_test)\n",
    "metrics_glm_rfe  <- get_full_metrics(glm_rfe,  \"GLM RFE\",  df_test_glm_rfe)\n",
    "\n",
    "print(metrics_glm_full)\n",
    "print(metrics_glm_rfe)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 18,
   "id": "a07e2fa1",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:12:47.282423Z",
     "iopub.status.busy": "2026-01-13T10:12:47.280808Z",
     "iopub.status.idle": "2026-01-13T10:13:02.375104Z",
     "shell.execute_reply": "2026-01-13T10:13:02.372479Z"
    },
    "papermill": {
     "duration": 15.111207,
     "end_time": "2026-01-13T10:13:02.378741",
     "exception": false,
     "start_time": "2026-01-13T10:12:47.267534",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in robpca(X_train, k = 3):\n",
      "“Computing all directions for this value of n can take very long, we\n",
      "            recommend to set ndir to 5000.”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "tibble [680 × 4] (S3: tbl_df/tbl/data.frame)\n",
      " $ target     : Factor w/ 2 levels \"Healthy\",\"Not_Healthy\": 1 1 2 2 1 1 1 1 2 1 ...\n",
      " $ PC_robust_1: num [1:680] -23.5 -80.4 -80.3 -80.2 -80.5 ...\n",
      " $ PC_robust_2: num [1:680] -21.15 -2.78 -18.72 -13.21 -29.83 ...\n",
      " $ PC_robust_3: num [1:680] -3.38 5.43 -3.15 4.45 -1.08 ...\n",
      " - attr(*, \"na.action\")= 'omit' Named int [1:847] 1 2 3 4 5 6 7 8 9 10 ...\n",
      "  ..- attr(*, \"names\")= chr [1:847] \"1\" \"2\" \"3\" \"4\" ...\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК DR: ROBUST PCA ДЛЯ МОДЕЛЕЙ ---\n",
    "\n",
    "\n",
    "# Берём только числовые признаки из train (без target)\n",
    "X_train_raw <- df_train %>%\n",
    "  select(where(is.numeric)) %>%\n",
    "  select(-age_sq, -bmi_sq, -friends_sq) %>%  # оставляем \"сырые\" числа\n",
    "  as.data.frame()\n",
    "\n",
    "# Убираем константы\n",
    "var_vec <- sapply(X_train_raw, var, na.rm = TRUE)\n",
    "X_train <- X_train_raw[, var_vec > 0]\n",
    "\n",
    "# Robust PCA на train: возьмём 3 компоненты\n",
    "set.seed(123)\n",
    "rob_res <- robpca(X_train, k = 3)\n",
    "\n",
    "PC_train <- as.data.frame(rob_res$scores)\n",
    "colnames(PC_train) <- paste0(\"PC_robust_\", 1:3)\n",
    "\n",
    "# Те же столбцы в test\n",
    "X_test_raw <- df_test %>%\n",
    "  select(colnames(X_train_raw)) %>%\n",
    "  as.data.frame()\n",
    "\n",
    "X_test <- X_test_raw[, colnames(X_train)]  # те же переменные, что в X_train\n",
    "\n",
    "# Применяем ту же трансформацию к test\n",
    "PC_test <- as.data.frame(\n",
    "  scale(X_test, center = rob_res$center, scale = FALSE) %*%\n",
    "    rob_res$loadings[, 1:3]\n",
    ")\n",
    "colnames(PC_test) <- paste0(\"PC_robust_\", 1:3)\n",
    "\n",
    "# Итоговые датасеты для моделей с DR\n",
    "df_train_dr <- df_train %>%\n",
    "  select(target) %>%\n",
    "  bind_cols(PC_train)\n",
    "\n",
    "df_test_dr <- df_test %>%\n",
    "  select(target) %>%\n",
    "  bind_cols(PC_test)\n",
    "\n",
    "str(df_train_dr)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 19,
   "id": "92ff965e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:02.418648Z",
     "iopub.status.busy": "2026-01-13T10:13:02.416429Z",
     "iopub.status.idle": "2026-01-13T10:13:05.080198Z",
     "shell.execute_reply": "2026-01-13T10:13:05.078169Z"
    },
    "papermill": {
     "duration": 2.686655,
     "end_time": "2026-01-13T10:13:05.082840",
     "exception": false,
     "start_time": "2026-01-13T10:13:02.396185",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "     Model Accuracy  Kappa Sensitivity Specificity Precision    NPV     F1\n",
      "1 kNN full   0.7976 0.1377      0.9485      0.1562    0.8269 0.4167 0.8836\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "       Model Accuracy  Kappa Sensitivity Specificity Precision   NPV     F1\n",
      "1 kNN MI top   0.8214 0.1881      0.9779      0.1562    0.8312 0.625 0.8986\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "             Model Accuracy  Kappa Sensitivity Specificity Precision    NPV\n",
      "1 kNN + Robust PCA   0.8155 0.1468      0.9779       0.125    0.8261 0.5714\n",
      "      F1\n",
      "1 0.8956\n"
     ]
    }
   ],
   "source": [
    "# --- kNN FULL (если ещё не обучен) ---\n",
    "set.seed(123)\n",
    "ctrl_knn <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "knn_full <- train(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  method = \"knn\",\n",
    "  trControl = ctrl_knn,\n",
    "  tuneLength = 10,\n",
    "  preProcess = c(\"center\",\"scale\")\n",
    ")\n",
    "\n",
    "# --- kNN MI TOP (после фильтрации top_feats_knn по available_feats) ---\n",
    "# 1. Явно задаём список признаков для kNN (из MI / RFE и т.п.)\n",
    "top_feats_knn <- c(\n",
    "  \"age\", \"weight\", \"height\", \"grades\",\n",
    "  \"class_size\", \"sport_freq\", \"friends_meet\"\n",
    "  # здесь именно тот набор, который ты использовал раньше\n",
    ")\n",
    "\n",
    "# 2. Учитываем, какие признаки реально есть после всех фильтраций\n",
    "available_feats <- setdiff(colnames(df_train), c(\"target\"))\n",
    "\n",
    "top_feats_knn <- intersect(top_feats_knn, available_feats)\n",
    "\n",
    "\n",
    "df_train_knn_mi <- df_train %>%\n",
    "  select(all_of(c(\"target\", top_feats_knn)))\n",
    "df_test_knn_mi <- df_test %>%\n",
    "  select(all_of(c(\"target\", top_feats_knn)))\n",
    "\n",
    "set.seed(123)\n",
    "knn_mi <- train(\n",
    "  target ~ .,\n",
    "  data = df_train_knn_mi,\n",
    "  method = \"knn\",\n",
    "  trControl = ctrl_knn,\n",
    "  tuneLength = 10,\n",
    "  preProcess = c(\"center\",\"scale\")\n",
    ")\n",
    "\n",
    "# --- kNN + ROBUST PCA ---\n",
    "set.seed(123)\n",
    "knn_dr <- train(\n",
    "  target ~ .,\n",
    "  data = df_train_dr,\n",
    "  method = \"knn\",\n",
    "  trControl = ctrl_knn,\n",
    "  tuneLength = 10,\n",
    "  preProcess = c(\"center\",\"scale\")\n",
    ")\n",
    "\n",
    "# Метрики\n",
    "metrics_knn_full <- get_full_metrics(knn_full, \"kNN full\", df_test)\n",
    "metrics_knn_mi   <- get_full_metrics(knn_mi,   \"kNN MI top\", df_test_knn_mi)\n",
    "metrics_knn_dr   <- get_full_metrics(knn_dr,   \"kNN + Robust PCA\", df_test_dr)\n",
    "\n",
    "print(metrics_knn_full)\n",
    "print(metrics_knn_mi)\n",
    "print(metrics_knn_dr)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 20,
   "id": "3e59d314",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:05.109534Z",
     "iopub.status.busy": "2026-01-13T10:13:05.107947Z",
     "iopub.status.idle": "2026-01-13T10:13:10.932924Z",
     "shell.execute_reply": "2026-01-13T10:13:10.930260Z"
    },
    "papermill": {
     "duration": 5.842609,
     "end_time": "2026-01-13T10:13:10.937008",
     "exception": false,
     "start_time": "2026-01-13T10:13:05.094399",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "     Model Accuracy Kappa Sensitivity Specificity Precision    NPV     F1\n",
      "1 SVM full   0.8214  0.16      0.9853       0.125    0.8272 0.6667 0.8993\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "             Model Accuracy  Kappa Sensitivity Specificity Precision NPV     F1\n",
      "1 SVM + Robust PCA   0.8155 0.1167      0.9853      0.0938    0.8221 0.6 0.8963\n"
     ]
    }
   ],
   "source": [
    "# --- SVM FULL (radial) ---\n",
    "\n",
    "set.seed(123)\n",
    "ctrl_svm <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "svm_full <- train(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  method = \"svmRadial\",\n",
    "  trControl = ctrl_svm,\n",
    "  tuneLength = 3,\n",
    "  preProcess = c(\"center\",\"scale\")\n",
    ")\n",
    "\n",
    "# --- SVM + ROBUST PCA ---\n",
    "\n",
    "set.seed(123)\n",
    "svm_dr <- train(\n",
    "  target ~ .,\n",
    "  data = df_train_dr,\n",
    "  method = \"svmRadial\",\n",
    "  trControl = ctrl_svm,\n",
    "  tuneLength = 3,\n",
    "  preProcess = c(\"center\",\"scale\")\n",
    ")\n",
    "\n",
    "metrics_svm_full <- get_full_metrics(svm_full, \"SVM full\", df_test)\n",
    "metrics_svm_dr   <- get_full_metrics(svm_dr,   \"SVM + Robust PCA\", df_test_dr)\n",
    "\n",
    "print(metrics_svm_full)\n",
    "print(metrics_svm_dr)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 21,
   "id": "0cc66c8f",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:10.978540Z",
     "iopub.status.busy": "2026-01-13T10:13:10.975404Z",
     "iopub.status.idle": "2026-01-13T10:13:40.911244Z",
     "shell.execute_reply": "2026-01-13T10:13:40.908565Z"
    },
    "papermill": {
     "duration": 29.959866,
     "end_time": "2026-01-13T10:13:40.914594",
     "exception": false,
     "start_time": "2026-01-13T10:13:10.954728",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in trControlCheck(x = trControl, y = target):\n",
      "“indexes not defined in trControl.  Attempting to set them ourselves, so each model in the ensemble will have the same resampling indexes.”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    }
   ],
   "source": [
    "library(caretEnsemble)\n",
    "\n",
    "# 1. Собираем caretList из уже обученных моделей\n",
    "model_list_stack <- caretList(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  trControl = trainControl(\n",
    "    method = \"cv\",\n",
    "    number = 5,\n",
    "    classProbs = TRUE,\n",
    "    savePredictions = \"final\"\n",
    "  ),\n",
    "  tuneList = list(\n",
    "    rf_full   = caretModelSpec(method = \"rf\"),\n",
    "    xgb_full  = caretModelSpec(method = \"xgbTree\"),\n",
    "    glm_rfe   = caretModelSpec(method = \"glm\"),\n",
    "    knn_dr    = caretModelSpec(method = \"knn\"),\n",
    "    svm_full  = caretModelSpec(method = \"svmRadial\")\n",
    "  )\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 22,
   "id": "e8d4870e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:40.959663Z",
     "iopub.status.busy": "2026-01-13T10:13:40.955977Z",
     "iopub.status.idle": "2026-01-13T10:13:43.042498Z",
     "shell.execute_reply": "2026-01-13T10:13:43.039039Z"
    },
    "papermill": {
     "duration": 2.11166,
     "end_time": "2026-01-13T10:13:43.047281",
     "exception": false,
     "start_time": "2026-01-13T10:13:40.935621",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "A glm ensemble of 5 base models: rf_full, xgb_full, glm_rfe, knn_dr, svm_full\n",
      "\n",
      "Ensemble results:\n",
      "Generalized Linear Model \n",
      "\n",
      "680 samples\n",
      "  5 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 544, 545, 543, 545, 543 \n",
      "Resampling results:\n",
      "\n",
      "  Accuracy  Kappa    \n",
      "  0.822051  0.1409256\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "           Model Accuracy Kappa Sensitivity Specificity Precision    NPV     F1\n",
      "1 Stacking (all)   0.8214  0.16      0.9853       0.125    0.8272 0.6667 0.8993\n"
     ]
    }
   ],
   "source": [
    "set.seed(123)\n",
    "ctrl_meta <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "stack_all <- caretStack(\n",
    "  model_list_stack,\n",
    "  method    = \"glm\",\n",
    "  metric    = \"Kappa\",\n",
    "  trControl = ctrl_meta\n",
    ")\n",
    "\n",
    "print(stack_all)\n",
    "\n",
    "metrics_stack_all <- get_full_metrics(stack_all, \"Stacking (all)\", df_test)\n",
    "print(metrics_stack_all)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 23,
   "id": "6e994fa6",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:43.091442Z",
     "iopub.status.busy": "2026-01-13T10:13:43.087037Z",
     "iopub.status.idle": "2026-01-13T10:13:43.331640Z",
     "shell.execute_reply": "2026-01-13T10:13:43.329807Z"
    },
    "papermill": {
     "duration": 0.268923,
     "end_time": "2026-01-13T10:13:43.334912",
     "exception": false,
     "start_time": "2026-01-13T10:13:43.065989",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "set.seed(123)\n",
    "ctrl_glm_dr <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "glm_dr <- train(\n",
    "  target ~ .,\n",
    "  data = df_train_dr,\n",
    "  method = \"glm\",\n",
    "  trControl = ctrl_glm_dr\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 24,
   "id": "728b722a",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:43.362061Z",
     "iopub.status.busy": "2026-01-13T10:13:43.360416Z",
     "iopub.status.idle": "2026-01-13T10:13:43.378572Z",
     "shell.execute_reply": "2026-01-13T10:13:43.376755Z"
    },
    "papermill": {
     "duration": 0.035383,
     "end_time": "2026-01-13T10:13:43.381904",
     "exception": false,
     "start_time": "2026-01-13T10:13:43.346521",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "library(caretEnsemble)\n",
    "\n",
    "model_list_dr_stack <- as.caretList(\n",
    "  list(\n",
    "    glm_dr = glm_dr,\n",
    "    knn_dr = knn_dr,\n",
    "    svm_dr = svm_dr\n",
    "  )\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 25,
   "id": "2bcac7f4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:43.408898Z",
     "iopub.status.busy": "2026-01-13T10:13:43.407297Z",
     "iopub.status.idle": "2026-01-13T10:13:44.758160Z",
     "shell.execute_reply": "2026-01-13T10:13:44.755747Z"
    },
    "papermill": {
     "duration": 1.367918,
     "end_time": "2026-01-13T10:13:44.761406",
     "exception": false,
     "start_time": "2026-01-13T10:13:43.393488",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "A glm ensemble of 3 base models: glm_dr, knn_dr, svm_dr\n",
      "\n",
      "Ensemble results:\n",
      "Generalized Linear Model \n",
      "\n",
      "680 samples\n",
      "  3 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 544, 545, 543, 545, 543 \n",
      "Resampling results:\n",
      "\n",
      "  Accuracy  Kappa    \n",
      "  0.81619   0.1057845\n",
      "\n"
     ]
    }
   ],
   "source": [
    "set.seed(123)\n",
    "ctrl_meta_dr <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "stack_dr <- caretStack(\n",
    "  model_list_dr_stack,\n",
    "  method    = \"glm\",\n",
    "  metric    = \"Kappa\",\n",
    "  trControl = ctrl_meta_dr\n",
    ")\n",
    "\n",
    "print(stack_dr)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 26,
   "id": "dab31170",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:44.788820Z",
     "iopub.status.busy": "2026-01-13T10:13:44.787244Z",
     "iopub.status.idle": "2026-01-13T10:13:44.880593Z",
     "shell.execute_reply": "2026-01-13T10:13:44.877891Z"
    },
    "papermill": {
     "duration": 0.111737,
     "end_time": "2026-01-13T10:13:44.884969",
     "exception": false,
     "start_time": "2026-01-13T10:13:44.773232",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                                    Model Accuracy Kappa Sensitivity\n",
      "1 Stacking DR (GLM+kNN+SVM on Robust PCA)   0.8095 0.104      0.9779\n",
      "  Specificity Precision NPV     F1\n",
      "1      0.0938     0.821 0.5 0.8926\n"
     ]
    }
   ],
   "source": [
    "metrics_stack_dr <- get_full_metrics(\n",
    "  stack_dr,\n",
    "  \"Stacking DR (GLM+kNN+SVM on Robust PCA)\",\n",
    "  df_test_dr\n",
    ")\n",
    "\n",
    "print(metrics_stack_dr)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 27,
   "id": "6434ae6c",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:44.926909Z",
     "iopub.status.busy": "2026-01-13T10:13:44.924537Z",
     "iopub.status.idle": "2026-01-13T10:13:44.950627Z",
     "shell.execute_reply": "2026-01-13T10:13:44.947954Z"
    },
    "papermill": {
     "duration": 0.051631,
     "end_time": "2026-01-13T10:13:44.954976",
     "exception": false,
     "start_time": "2026-01-13T10:13:44.903345",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "set.seed(123)\n",
    "ctrl_up <- trainControl(\n",
    "  method          = \"cv\",\n",
    "  number          = 5,\n",
    "  sampling        = \"up\",   # upsampling\n",
    "  classProbs      = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 28,
   "id": "747b2653",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:44.988966Z",
     "iopub.status.busy": "2026-01-13T10:13:44.987236Z",
     "iopub.status.idle": "2026-01-13T10:13:59.939672Z",
     "shell.execute_reply": "2026-01-13T10:13:59.937569Z"
    },
    "papermill": {
     "duration": 14.970715,
     "end_time": "2026-01-13T10:13:59.942645",
     "exception": false,
     "start_time": "2026-01-13T10:13:44.971930",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Random Forest \n",
      "\n",
      "680 samples\n",
      " 16 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 544, 545, 543, 545, 543 \n",
      "Addtional sampling using up-sampling\n",
      "\n",
      "Resampling results across tuning parameters:\n",
      "\n",
      "  mtry  Accuracy   Kappa    \n",
      "   2    0.8029002  0.1477716\n",
      "   9    0.7734765  0.1083101\n",
      "  16    0.7896318  0.1848945\n",
      "\n",
      "Accuracy was used to select the optimal model using the largest value.\n",
      "The final value used for the model was mtry = 2.\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "          Model Accuracy  Kappa Sensitivity Specificity Precision   NPV    F1\n",
      "1 RF upsampling   0.7857 0.1409      0.9265      0.1875    0.8289 0.375 0.875\n"
     ]
    }
   ],
   "source": [
    "set.seed(123)\n",
    "rf_up <- train(\n",
    "  target ~ .,\n",
    "  data      = df_train,\n",
    "  method    = \"rf\",\n",
    "  trControl = ctrl_up,\n",
    "  tuneLength = 3\n",
    ")\n",
    "\n",
    "print(rf_up)\n",
    "metrics_rf_up <- get_full_metrics(rf_up, \"RF upsampling\", df_test)\n",
    "print(metrics_rf_up)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 29,
   "id": "5d8eafc2",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:13:59.971099Z",
     "iopub.status.busy": "2026-01-13T10:13:59.969425Z",
     "iopub.status.idle": "2026-01-13T10:14:37.612178Z",
     "shell.execute_reply": "2026-01-13T10:14:37.609916Z"
    },
    "papermill": {
     "duration": 37.660431,
     "end_time": "2026-01-13T10:14:37.615730",
     "exception": false,
     "start_time": "2026-01-13T10:13:59.955299",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in trControlCheck(x = trControl, y = target):\n",
      "“indexes not defined in trControl.  Attempting to set them ourselves, so each model in the ensemble will have the same resampling indexes.”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“glm.fit: fitted probabilities numerically 0 or 1 occurred”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "A glm ensemble of 3 base models: rf_up, xgb_up, glm_up\n",
      "\n",
      "Ensemble results:\n",
      "Generalized Linear Model \n",
      "\n",
      "680 samples\n",
      "  3 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 544, 545, 543, 545, 543 \n",
      "Addtional sampling using up-sampling\n",
      "\n",
      "Resampling results:\n",
      "\n",
      "  Accuracy   Kappa    \n",
      "  0.6279905  0.1106601\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                Model Accuracy  Kappa Sensitivity Specificity Precision    NPV\n",
      "1 Stacking upsampling    0.631 0.1191      0.6618         0.5    0.8491 0.2581\n",
      "      F1\n",
      "1 0.7438\n"
     ]
    }
   ],
   "source": [
    "library(caretEnsemble)\n",
    "\n",
    "set.seed(123)\n",
    "ctrl_up_stack <- trainControl(\n",
    "  method          = \"cv\",\n",
    "  number          = 5,\n",
    "  sampling        = \"up\",\n",
    "  classProbs      = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "models_up <- caretList(\n",
    "  target ~ .,\n",
    "  data      = df_train,\n",
    "  trControl = ctrl_up_stack,\n",
    "  tuneList  = list(\n",
    "    rf_up  = caretModelSpec(method = \"rf\",      tuneLength = 3),\n",
    "    xgb_up = caretModelSpec(method = \"xgbTree\", tuneLength = 3),\n",
    "    glm_up = caretModelSpec(method = \"glm\")\n",
    "  )\n",
    ")\n",
    "\n",
    "set.seed(123)\n",
    "stack_up <- caretStack(\n",
    "  models_up,\n",
    "  method    = \"glm\",\n",
    "  metric    = \"Kappa\",\n",
    "  trControl = ctrl_up_stack\n",
    ")\n",
    "\n",
    "print(stack_up)\n",
    "metrics_stack_up <- get_full_metrics(stack_up, \"Stacking upsampling\", df_test)\n",
    "print(metrics_stack_up)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 30,
   "id": "cf6bef9e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:14:37.645994Z",
     "iopub.status.busy": "2026-01-13T10:14:37.644383Z",
     "iopub.status.idle": "2026-01-13T10:14:38.271507Z",
     "shell.execute_reply": "2026-01-13T10:14:38.268987Z"
    },
    "papermill": {
     "duration": 0.644772,
     "end_time": "2026-01-13T10:14:38.274861",
     "exception": false,
     "start_time": "2026-01-13T10:14:37.630089",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"=== ВСЕ МОДЕЛИ НА TEST ===\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                   Model Accuracy  Kappa Sensitivity Specificity Precision\n",
      "1                RF full   0.8274 0.2528      0.9706      0.2188    0.8408\n",
      "2               XGB full   0.8274 0.2281      0.9779      0.1875    0.8365\n",
      "3     GLM (RFE features)   0.8155 0.1468      0.9779      0.1250    0.8261\n",
      "4               kNN full   0.7976 0.1377      0.9485      0.1562    0.8269\n",
      "5      kNN (MI features)   0.8155 0.1468      0.9779      0.1250    0.8261\n",
      "6               SVM full   0.8214 0.1600      0.9853      0.1250    0.8272\n",
      "7       kNN + Robust PCA   0.8155 0.1468      0.9779      0.1250    0.8261\n",
      "8       SVM + Robust PCA   0.8155 0.1167      0.9853      0.0938    0.8221\n",
      "9         Stacking (all)   0.8214 0.1600      0.9853      0.1250    0.8272\n",
      "10           Stacking DR   0.8095 0.1040      0.9779      0.0938    0.8210\n",
      "11       RF + upsampling   0.7857 0.1409      0.9265      0.1875    0.8289\n",
      "12 Stacking + upsampling   0.6310 0.1191      0.6618      0.5000    0.8491\n",
      "      NPV     F1\n",
      "1  0.6364 0.9010\n",
      "2  0.6667 0.9017\n",
      "3  0.5714 0.8956\n",
      "4  0.4167 0.8836\n",
      "5  0.5714 0.8956\n",
      "6  0.6667 0.8993\n",
      "7  0.5714 0.8956\n",
      "8  0.6000 0.8963\n",
      "9  0.6667 0.8993\n",
      "10 0.5000 0.8926\n",
      "11 0.3750 0.8750\n",
      "12 0.2581 0.7438\n"
     ]
    }
   ],
   "source": [
    "metrics_all <- dplyr::bind_rows(\n",
    "  # --- БАЗОВЫЕ МОДЕЛИ НА df_test ---\n",
    "  get_full_metrics(rf_full,    \"RF full\",               df_test),\n",
    "  get_full_metrics(xgb_full,   \"XGB full\",              df_test),\n",
    "  get_full_metrics(glm_rfe,    \"GLM (RFE features)\",    df_test),\n",
    "  get_full_metrics(knn_full,   \"kNN full\",              df_test),\n",
    "  get_full_metrics(knn_mi,     \"kNN (MI features)\",     df_test),\n",
    "  get_full_metrics(svm_full,   \"SVM full\",              df_test),\n",
    "\n",
    "  # --- DR / ROBUST PCA (df_test_dr) ---\n",
    "  get_full_metrics(knn_dr,     \"kNN + Robust PCA\",      df_test_dr),\n",
    "  get_full_metrics(svm_dr,     \"SVM + Robust PCA\",      df_test_dr)\n",
    "  # если есть:\n",
    "  # get_full_metrics(glm_dr,  \"GLM + Robust PCA\",       df_test_dr),\n",
    "\n",
    "  ,\n",
    "  # --- СТЭКИНГИ ---\n",
    "  get_full_metrics(stack_all,  \"Stacking (all)\",        df_test),\n",
    "  get_full_metrics(stack_dr,   \"Stacking DR\",           df_test_dr),\n",
    "\n",
    "  # --- UPSAMPLING ---\n",
    "  get_full_metrics(rf_up,      \"RF + upsampling\",       df_test),\n",
    "  get_full_metrics(stack_up,   \"Stacking + upsampling\", df_test)\n",
    ")\n",
    "\n",
    "print(\"=== ВСЕ МОДЕЛИ НА TEST ===\")\n",
    "print(metrics_all)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 31,
   "id": "6ba1be53",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:14:38.303594Z",
     "iopub.status.busy": "2026-01-13T10:14:38.302027Z",
     "iopub.status.idle": "2026-01-13T10:14:38.317770Z",
     "shell.execute_reply": "2026-01-13T10:14:38.315992Z"
    },
    "papermill": {
     "duration": 0.033582,
     "end_time": "2026-01-13T10:14:38.320961",
     "exception": false,
     "start_time": "2026-01-13T10:14:38.287379",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "print_confusion <- function(model, model_name, data) {\n",
    "  preds <- predict(model, newdata = data)\n",
    "  cm    <- caret::confusionMatrix(preds, data$target)\n",
    "\n",
    "  cat(\"\\n=============================\\n\")\n",
    "  cat(paste0(model_name, \"\\n\"))\n",
    "  cat(\"=============================\\n\")\n",
    "\n",
    "  print(cm$table)\n",
    "\n",
    "  cat(paste0(\"Accuracy: \", round(cm$overall[\"Accuracy\"], 4), \"\\n\"))\n",
    "  cat(paste0(\"Kappa:    \", round(cm$overall[\"Kappa\"], 4), \"\\n\"))\n",
    "  cat(paste0(\"Sens (Healthy):    \", round(cm$byClass[\"Sensitivity\"], 4), \"\\n\"))\n",
    "  cat(paste0(\"Spec (NotHealthy): \", round(cm$byClass[\"Specificity\"], 4), \"\\n\"))\n",
    "  cat(\"\\n\")\n",
    "}\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 32,
   "id": "5224fa42",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:14:38.351067Z",
     "iopub.status.busy": "2026-01-13T10:14:38.349409Z",
     "iopub.status.idle": "2026-01-13T10:14:38.399836Z",
     "shell.execute_reply": "2026-01-13T10:14:38.397375Z"
    },
    "papermill": {
     "duration": 0.069414,
     "end_time": "2026-01-13T10:14:38.402912",
     "exception": false,
     "start_time": "2026-01-13T10:14:38.333498",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=============================\n",
      "RF full\n",
      "=============================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         132          25\n",
      "  Not_Healthy       4           7\n",
      "Accuracy: 0.8274\n",
      "Kappa:    0.2528\n",
      "Sens (Healthy):    0.9706\n",
      "Spec (NotHealthy): 0.2188\n",
      "\n"
     ]
    }
   ],
   "source": [
    "print_confusion(rf_full,   \"RF full\",        df_test)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 33,
   "id": "213d9df4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:14:38.431845Z",
     "iopub.status.busy": "2026-01-13T10:14:38.430185Z",
     "iopub.status.idle": "2026-01-13T10:14:43.369630Z",
     "shell.execute_reply": "2026-01-13T10:14:43.367298Z"
    },
    "papermill": {
     "duration": 4.957558,
     "end_time": "2026-01-13T10:14:43.373008",
     "exception": false,
     "start_time": "2026-01-13T10:14:38.415450",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 3 × 7\u001b[39m\n",
      "  status n_train n_test Accuracy Sensitivity Specificity    F1\n",
      "   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m  \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m    \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m      2     207     51    0.843       1          0      0.915\n",
      "\u001b[90m2\u001b[39m      1     274     68    0.735       1          0.052\u001b[4m6\u001b[24m 0.845\n",
      "\u001b[90m3\u001b[39m      4     149     40    0.95        0.974      0      0.974\n"
     ]
    }
   ],
   "source": [
    "run_by_status <- function(value) {\n",
    "  sub_train <- df_train %>% filter(status == value)\n",
    "  sub_test  <- df_test  %>% filter(status == value)\n",
    "\n",
    "  if (nrow(sub_train) < 50 | nrow(sub_test) < 30) return(NULL)\n",
    "\n",
    "  set.seed(123)\n",
    "  ctrl_sub <- trainControl(method = \"cv\", number = 5, classProbs = TRUE)\n",
    "\n",
    "  model_sub <- train(\n",
    "    target ~ .,\n",
    "    data = sub_train %>% select(-status),\n",
    "    method = \"rf\",\n",
    "    trControl = ctrl_sub,\n",
    "    tuneLength = 2\n",
    "  )\n",
    "\n",
    "  metrics <- get_full_metrics(\n",
    "    model_sub,\n",
    "    paste0(\"RF status=\", value),\n",
    "    sub_test %>% select(-status)\n",
    "  )\n",
    "\n",
    "  tibble::tibble(\n",
    "    status = value,\n",
    "    n_train = nrow(sub_train),\n",
    "    n_test  = nrow(sub_test),\n",
    "    Accuracy   = metrics$Accuracy,\n",
    "    Sensitivity= metrics$Sensitivity,\n",
    "    Specificity= metrics$Specificity,\n",
    "    F1         = metrics$F1\n",
    "  )\n",
    "}\n",
    "\n",
    "status_levels <- unique(df_mod$status)\n",
    "status_table  <- purrr::map_dfr(status_levels, run_by_status)\n",
    "print(status_table)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "aa3e5e03",
   "metadata": {
    "papermill": {
     "duration": 0.012493,
     "end_time": "2026-01-13T10:14:43.398123",
     "exception": false,
     "start_time": "2026-01-13T10:14:43.385630",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "результат Г"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 34,
   "id": "7bd88a81",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:14:43.426926Z",
     "iopub.status.busy": "2026-01-13T10:14:43.425271Z",
     "iopub.status.idle": "2026-01-13T10:14:44.105300Z",
     "shell.execute_reply": "2026-01-13T10:14:44.102389Z"
    },
    "papermill": {
     "duration": 0.698146,
     "end_time": "2026-01-13T10:14:44.108741",
     "exception": false,
     "start_time": "2026-01-13T10:14:43.410595",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 2 × 7\u001b[39m\n",
      "  region n_train n_test Accuracy Sensitivity Specificity    F1\n",
      "   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m  \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m    \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m    138      65     19    0.790           1           0 0.882\n",
      "\u001b[90m2\u001b[39m    142      47     11    0.909           1           0 0.952\n"
     ]
    }
   ],
   "source": [
    "run_by_region <- function(value) {\n",
    "  sub_train <- df_train %>% filter(region == value)\n",
    "  sub_test  <- df_test  %>% filter(region == value)\n",
    "\n",
    "  # временно без отсечки\n",
    "  if (nrow(sub_train) < 20 | nrow(sub_test) < 10) {\n",
    "    return(NULL)\n",
    "  }\n",
    "\n",
    "  set.seed(123)\n",
    "  ctrl_sub <- trainControl(\n",
    "    method = \"cv\",\n",
    "    number = 3,\n",
    "    classProbs = TRUE\n",
    "  )\n",
    "\n",
    "  model_sub_rf <- train(\n",
    "    target ~ .,\n",
    "    data      = sub_train %>% select(-region),\n",
    "    method    = \"rf\",\n",
    "    trControl = ctrl_sub,\n",
    "    tuneLength = 1\n",
    "  )\n",
    "\n",
    "  metrics <- get_full_metrics(\n",
    "    model_sub_rf,\n",
    "    paste0(\"RF (region = \", value, \")\"),\n",
    "    sub_test %>% select(-region)\n",
    "  )\n",
    "\n",
    "  tibble::tibble(\n",
    "    region      = value,\n",
    "    n_train     = nrow(sub_train),\n",
    "    n_test      = nrow(sub_test),\n",
    "    Accuracy    = metrics$Accuracy,\n",
    "    Sensitivity = metrics$Sensitivity,\n",
    "    Specificity = metrics$Specificity,\n",
    "    F1          = metrics$F1\n",
    "  )\n",
    "}\n",
    "\n",
    "region_levels <- sort(unique(df_mod$region))\n",
    "region_table  <- purrr::map_dfr(region_levels, run_by_region)\n",
    "\n",
    "print(region_table)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 35,
   "id": "58b8f8c2",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:14:44.138383Z",
     "iopub.status.busy": "2026-01-13T10:14:44.136739Z",
     "iopub.status.idle": "2026-01-13T10:14:44.159890Z",
     "shell.execute_reply": "2026-01-13T10:14:44.158004Z"
    },
    "papermill": {
     "duration": 0.041624,
     "end_time": "2026-01-13T10:14:44.163239",
     "exception": false,
     "start_time": "2026-01-13T10:14:44.121615",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [],
   "source": [
    "df_train <- df_train %>%\n",
    "  mutate(age_group = ifelse(age <= 12, \"7-12\", \"13-17\"))\n",
    "\n",
    "df_test <- df_test %>%\n",
    "  mutate(age_group = ifelse(age <= 12, \"7-12\", \"13-17\"))\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 36,
   "id": "1f3e1b33",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T10:14:44.192403Z",
     "iopub.status.busy": "2026-01-13T10:14:44.190709Z",
     "iopub.status.idle": "2026-01-13T10:14:50.466225Z",
     "shell.execute_reply": "2026-01-13T10:14:50.463746Z"
    },
    "papermill": {
     "duration": 6.293632,
     "end_time": "2026-01-13T10:14:50.469656",
     "exception": false,
     "start_time": "2026-01-13T10:14:44.176024",
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
      "Attaching package: ‘purrr’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:kernlab’:\n",
      "\n",
      "    cross\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:caret’:\n",
      "\n",
      "    lift\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 2 × 7\u001b[39m\n",
      "  age_group n_train n_test Accuracy Sensitivity Specificity    F1\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m  \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m    \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m 7-12          495    118    0.848       1          0.052\u001b[4m6\u001b[24m 0.917\n",
      "\u001b[90m2\u001b[39m 13-17         185     50    0.76        0.946      0.231  0.854\n"
     ]
    }
   ],
   "source": [
    "library(dplyr)\n",
    "library(caret)\n",
    "library(purrr)\n",
    "library(tibble)\n",
    "\n",
    "run_by_age <- function(value) {\n",
    "  sub_train <- df_train %>% filter(age_group == value)\n",
    "  sub_test  <- df_test  %>% filter(age_group == value)\n",
    "\n",
    "  if (nrow(sub_train) < 50 | nrow(sub_test) < 30) {\n",
    "    return(NULL)\n",
    "  }\n",
    "\n",
    "  set.seed(123)\n",
    "  ctrl_sub <- trainControl(\n",
    "    method = \"cv\",\n",
    "    number = 5,\n",
    "    classProbs = TRUE\n",
    "  )\n",
    "\n",
    "  model_sub_rf <- train(\n",
    "    target ~ .,\n",
    "    data      = sub_train %>% select(-age_group),\n",
    "    method    = \"rf\",\n",
    "    trControl = ctrl_sub,\n",
    "    tuneLength = 2\n",
    "  )\n",
    "\n",
    "  metrics <- get_full_metrics(\n",
    "    model_sub_rf,\n",
    "    paste0(\"RF (age_group = \", value, \")\"),\n",
    "    sub_test %>% select(-age_group)\n",
    "  )\n",
    "\n",
    "  tibble(\n",
    "    age_group   = value,\n",
    "    n_train     = nrow(sub_train),\n",
    "    n_test      = nrow(sub_test),\n",
    "    Accuracy    = metrics$Accuracy,\n",
    "    Sensitivity = metrics$Sensitivity,\n",
    "    Specificity = metrics$Specificity,\n",
    "    F1          = metrics$F1\n",
    "  )\n",
    "}\n",
    "\n",
    "age_groups  <- c(\"7-12\", \"13-17\")\n",
    "age_table   <- map_dfr(age_groups, run_by_age)\n",
    "\n",
    "print(age_table)\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "9e018f3c",
   "metadata": {
    "papermill": {
     "duration": 0.013043,
     "end_time": "2026-01-13T10:14:50.495736",
     "exception": false,
     "start_time": "2026-01-13T10:14:50.482693",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "вот тут вменяемый результат"
   ]
  }
 ],
 "metadata": {
  "kaggle": {
   "accelerator": "none",
   "dataSources": [
    {
     "datasetId": 9241577,
     "sourceId": 14468732,
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
   "duration": 284.870819,
   "end_time": "2026-01-13T10:14:50.630818",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2026-01-13T10:10:05.759999",
   "version": "2.6.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
