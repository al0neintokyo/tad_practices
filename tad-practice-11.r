{
 "cells": [
  {
   "cell_type": "markdown",
   "id": "978d0f50",
   "metadata": {
    "papermill": {
     "duration": 0.00483,
     "end_time": "2026-01-06T01:32:03.259961",
     "exception": false,
     "start_time": "2026-01-06T01:32:03.255131",
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
   "id": "72fecaa0",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-06T01:32:03.272881Z",
     "iopub.status.busy": "2026-01-06T01:32:03.270502Z",
     "iopub.status.idle": "2026-01-06T01:32:07.544647Z",
     "shell.execute_reply": "2026-01-06T01:32:07.542344Z"
    },
    "papermill": {
     "duration": 4.283638,
     "end_time": "2026-01-06T01:32:07.547986",
     "exception": false,
     "start_time": "2026-01-06T01:32:03.264348",
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
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘xgboost’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:dplyr’:\n",
      "\n",
      "    slice\n",
      "\n",
      "\n"
     ]
    },
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
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Исходные данные:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Rows: 15,393\n",
      "Columns: 7\n",
      "$ id        \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 1…\n",
      "$ from      \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"CPT\", \"CPT\", \"CPT\", \"CPT\", \"CPT\", \"CPT\", \"CPT\", \"CPT\", \"CPT…\n",
      "$ to        \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"DUR\", \"DUR\", \"DUR\", \"DUR\", \"DUR\", \"DUR\", \"DUR\", \"DUR\", \"DUR…\n",
      "$ airline   \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \"FlySafair\", \"LIFT Airline\", \"LIFT Airline\", \"FlySafair\", \"F…\n",
      "$ departure \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 1742053500, 1742015400, 1742038200, 1742057400, 1742055600, …\n",
      "$ arrival   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 1742061000, 1742022900, 1742045700, 1742064900, 1742063100, …\n",
      "$ price     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m 762, 865, 865, 762, 962, 1062, 1062, 1162, 1199, 1314, 762, …\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Данные готовы. Размер тренировочной выборки:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] 12316\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "library(caret)\n",
    "library(xgboost)\n",
    "library(janitor)\n",
    "\n",
    "# 1. Загрузка\n",
    "df <- read_csv(\"/kaggle/input/southern-africa-flight-prices/flights.csv\", show_col_types = FALSE) %>%\n",
    "  clean_names()\n",
    "\n",
    "print(\"Исходные данные:\")\n",
    "glimpse(df)\n",
    "\n",
    "# 2. Предобработка\n",
    "# Удаляем id (мусор)\n",
    "# from, to, airline - категориальные -> в факторы\n",
    "# departure, arrival - оставляем как есть (числа), но линейная модель потребует скейлинга\n",
    "df_model <- df %>%\n",
    "  select(-id) %>%\n",
    "  mutate(across(c(from, to, airline), as.factor)) %>%\n",
    "  na.omit()\n",
    "\n",
    "# 3. Разделение\n",
    "set.seed(123)\n",
    "index <- createDataPartition(df_model$price, p = 0.8, list = FALSE)\n",
    "train_data <- df_model[index, ]\n",
    "test_data  <- df_model[-index, ]\n",
    "\n",
    "print(\"Данные готовы. Размер тренировочной выборки:\")\n",
    "print(nrow(train_data))\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "5046697e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-06T01:32:07.592252Z",
     "iopub.status.busy": "2026-01-06T01:32:07.560031Z",
     "iopub.status.idle": "2026-01-06T01:32:30.662843Z",
     "shell.execute_reply": "2026-01-06T01:32:30.660693Z"
    },
    "papermill": {
     "duration": 23.112348,
     "end_time": "2026-01-06T01:32:30.665261",
     "exception": false,
     "start_time": "2026-01-06T01:32:07.552913",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Обучение Linear Regression...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Обучение XGBoost...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Сравнение точности\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "             Method     RMSE        R2\n",
      "1 Linear Regression 746.7953 0.6860338\n",
      "2           XGBoost 349.0616 0.9319687\n"
     ]
    },
    {
     "data": {
      "image/png": "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\nPT/8nj8/ed+1p87+cePUv63s/MLOvfO3fVb817Hfndf5qQCArZQXegHkRVllZWUqlUpXVFZu\n2uJlo3982Tn1IYSVL0+b8dJbv/3HLxv6VIcQDrz34bt33vvcma/MPmmvEEL9zXecedSgEMLF\nU4ff/sVFD9/UuHM6FYZcfdCUHzzx0qowaOdOLqyixyGzf3jCfpPH/27ykuP77tTJ2QCALXnF\nrlTsN2lI2x/+MfehyprRbVUXQkhX7fmZft1fuuOVtjcHHrDpa/IqelZU1Ry6czrV9mZdeVno\n/OdiQwgh7HPWr88fWnbOx7+xg+YDADYRdqVil+5vvzqbDSGktvyr8lTItGy3snJ4elSWpbKt\nG7e6uD6bLavadpKyb91/4/qnvvepX7zY8fkBgHYJu5Kz65gxG5rn3btiXdubrev/76ZXVw86\nZY9OTjv8kN7Ni3+0OvPOd0W0rnvx1tfX7H787tu+c/d+J/3+4tG/+eyxj7+1oZP/XgBgM19j\nV3J2HvSfp+91w6SPTfrp9y8cWN38s8s+s6TigD80DOz4DOveeOYvf6na/GYqVT569MGjr7um\n74CGoWNP+8aUU/bZvfa1l+bffPllr1UfMuvz+253kvpLZv/bjf0veXH1rgd28gEBAJsIu9KT\nKv/J4w9+5dMXTG4Y++bGyhEfPfHuJ38wqFu64xMsvv9zh97/zptl5XWtLSuq+xz35PyZUy++\n8ptTJr365rravgM/euzn/3TFJftWb/85lkrX3jz7st8d+OVOPhoAYLNUNusnihGtOXPmFHoJ\nXcW4ceMKvQQA8s7X2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgB\nAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAEQilc1mC70G\nAAB2AK/YAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBE\nQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAESivNAL\ngHzZsGHD5ZdfPnTo0LIy/wNTMJlMZsGCBfvvv79dKBRb0BXYha4gk8k899xzU6dOraysLPRa\n8kjYEa0rr7zy0ksvLfQqAOhCysrKpk2bVuhV5JGwI1pDhgwJIVxwwQX19fWFXkvpevTRR5ua\nmuxCAdmCrsAudAVtu9D2n4aICTui1fYpj/r6+okTJxZ6LSWtqanJLhSWLegK7EJX0NTUFP1n\nwyN/eAAApUPYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2AEARELYAQBEQtgBAERC2BGt6urq\nzf+kUOxCwdmCrsAudAUlsgupbDZb6DVAXrS2tj7wwANHHXVUOp0u9FpKl10oOFvQFdiFrqBE\ndkHYAQBEwqdiAQAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHs\nAAAiIewAACIh7AAAIiHsAAAiIewAACIh7AAAIiHsAAAiIewoIpn7b7x47Ii9aqq67Tpg2BkX\nXrt0Q6bTQxLMWcqS3a52Rp29W4/UNnru9Z08PYbil/xJu+Yft44cOXL+6pYdO21J2vG74CDk\nLuddyLQs++HF540eOnDnnSq799xl1JETb5r9Yifn7HKyUCR+NWVUCKF7/5GnTDr96IMHhBB6\nDT9j5cZMZ4YkmLOUJbtd7Y7qV5ku7zbokHcbe8IteX40xaozT9r7zt03hPCnVet37LQlKB+7\n4CDkKtddaG1ZduawuhBCzZ6jTjtn8oRjxlSVpVKp9Fk3LUg8Zxck7CgOqxbdkE6lageduXR9\na9uVn5/34RDC2KanEg9JMGcpS3a72h21ofl/Qwh7HveHvC4+GomftG+9/uLtV08pT6W2mxTO\nQk7ysQsOQq4S7ML87x4aQtjj+O82vx1qrz922+5V6XRl36dXtySbswsSdhSH/544KITwpfnL\nN1/ZuO7lXhVl1X0mJB6SYM5Slux2tTtq1SvfDiEcev3TeVp2ZJLtwtg9em35iZptw85ZyEk+\ndsFByFWCXWj8UE0qlX5k5bvu/Nwpw0IIDQ8tTTZnFyTsKA4NfarLynuuevfr4VcM7hlCmNe8\nIdmQBHOWsmS3q91RSx781xDCqU8uy9OyI5NsF356bdP06dOnT5/+iV122m7YOQs5yccuOAi5\nSrALB/WorKqt3+riy3cdGUIYc9PCZHN2Qb55giKQzayZtWJdt17ja9KpLa9/5ODeIYS7lq9N\nMCTBnKUs2e3qyKjX7l8aQug3b8bx9QfsWtuttne/j51w9p1/eT1PD6SoJX7SnnX+fzQ2NjY2\nNo6v67YDpy1NedoFByEnyXZhxiOPPfboHVtdnH/ryyGEfUb1juYgCDuKQOv6V9ZnshU7Dd/q\neu2w2hDCC2u28y1+7Q5JMGcpS3a7OjJq6QOvhxCaJn95UcWA8RMmjBzUc+7MGaeMGXTRrMU7\n/FEUuzw9aZ2FnOTpdjkIOUm2C8NHjNh/2IAtr7z2SNPp9/y9qvawqz/cO5qDIOwoApmW5SGE\nsnTtVtcrelSEENas3M55a3dIgjlLWbLb1ZFR81aEmto+jT/764KHZt464/YHH3v2hXu/U5Fd\nO/3kY14rup8ykGd5etI6CznJ0+1yEHLS+V3Itq78xbc/PeSIC9eW9b7qgbt7lqeiOQjCjiJQ\nVl4XQsi0Nm91veWtlhBCVU15giEJ5ixlyW5XR0Z9c+HSVSuXXXXGQZv/dvCxU39+zICWNc9+\nZcHyHfYAopCnJ62zkJM83S4HISed3IXnZ/9o7N4DJk27pWLI0bf/deEXDunT+Tm7DmFHEUh3\nG9itLLVx7cKtrjcvbA4h7N29IsGQBHOWsmS3K/FN/sj5+4QQnp+7rDNrjk+enrTOQk4+yNvl\nILyXxLuQ2bjiqk8fPnT85x5dvkvjtXcteXrWxBG9OjlnVyPsKAKpsu4fr+u2bsXv1737MxLz\n/+eNEMK/96lOMCTBnKUs2e3qwKhMa2trJrv1wHRVOoRQUVs0H0k/GHl60joLOcnP7XIQcpNs\nF7KZ1Y1HDv/KLXNHnHzRU68unH5+Q3XZO98nEc1BEHYUhylH7NbasuzKv725+UqmZfkVr6yq\n7tNwaE1lsiEJ5ixlyW7X+49au/yu8vLyvgdevdWoJ374Qghh3Ni+O/pBFL08PWmdhZzs8Nvl\nICSQYBeeuPzj1zz86sjzb5v/62/v02M7uRzJQSj0z1uBDln18g2pVGqXg7+2dtPPA8/+8VuH\nhxCOuGbTDwTPbFy1aNGiv7/yaseHtPsObKkjtyvBLpzav0cqlf7q3Qs3D1ny0PW15WXd+01s\nKabf4vMBSbYLm92yT6+w3d884SzkIsGHoy1tdxcchFzlvgsbD6mprOj+4X++9w2N4yAIO4rG\nL887IITQ/9AJX7vkknNP/mgqlarb76wVbx/R5sXTQwiVPQ7q+JCOvANbavd2JdiFFU/d3L8q\nnUql9h933Jlnn370mAPLU6mKnYbc9uLKD/SxFY9ku9DmvcKuI9OypQQfjjbb7i44CAnktAtr\n3/hdCKG8215jt2fqMys6MmdREHYUkY13f+9Lo4d8aKeKyt79Bn/yC1csfvvX+WXf8yPp+w3p\n2DuwpXZuV7JdaF708IVnnbh3/z5V6Ypeu+3dcM5Ff166Ov+PpXgl24Vs9n3DzlnIUYIPR5u8\n1y44CLnLYRfefOmC9/ns5XF/fq0jcxaFVDa7zZdrAgBQhHzzBABAJIQdAEAkhB0AQCSEHQBA\nJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0A\nQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQd\nAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSE\nHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAk\nhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBA\nJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0A\nQCSEHQBAJIQdAEAkhB0AQCSEHQBAJIQdAEAkhB0AQCSEHQBAJP4fovBC8ccYn9IAAAAASUVO\nRK5CYII="
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
    "print(\"Обучение Linear Regression...\")\n",
    "model_lm <- train(price ~ ., data = train_data, \n",
    "                  method = \"lm\",\n",
    "                  preProcess = c(\"center\", \"scale\"))\n",
    "\n",
    "pred_lm <- predict(model_lm, newdata = test_data)\n",
    "rmse_lm <- RMSE(pred_lm, test_data$price)\n",
    "r2_lm <- R2(pred_lm, test_data$price)\n",
    "\n",
    "print(\"Обучение XGBoost...\")\n",
    "train_x <- model.matrix(price ~ . -1, data = train_data)\n",
    "test_x  <- model.matrix(price ~ . -1, data = test_data)\n",
    "train_y <- train_data$price\n",
    "test_y  <- test_data$price\n",
    "\n",
    "xgb_model <- xgboost(data = train_x, label = train_y,\n",
    "                     nrounds = 500, \n",
    "                     objective = \"reg:squarederror\",\n",
    "                     verbose = 0)\n",
    "\n",
    "pred_xgb <- predict(xgb_model, test_x)\n",
    "rmse_xgb <- RMSE(pred_xgb, test_y)\n",
    "r2_xgb <- R2(pred_xgb, test_y)\n",
    "\n",
    "results <- data.frame(\n",
    "  Method = c(\"Linear Regression\", \"XGBoost\"),\n",
    "  RMSE = c(rmse_lm, rmse_xgb),\n",
    "  R2 = c(r2_lm, r2_xgb)\n",
    ")\n",
    "\n",
    "print(\"Сравнение точности\")\n",
    "print(results)\n",
    "\n",
    "importance <- xgb.importance(feature_names = colnames(train_x), model = xgb_model)\n",
    "xgb.plot.importance(importance, top_n = 10, main = \"Что влияет на цену билета?\")\n"
   ]
  },
  {
   "attachments": {
    "7da8da3c-43ae-461c-94f1-7ae897dac586.png": {
     "image/png": "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"
    }
   },
   "cell_type": "markdown",
   "id": "9c39bfb3",
   "metadata": {
    "papermill": {
     "duration": 0.005592,
     "end_time": "2026-01-06T01:32:30.676516",
     "exception": false,
     "start_time": "2026-01-06T01:32:30.670924",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Нужно предсказать цену на авиабилеты в африканских авиакомпаниях (price).\n",
    "Очевидно, что цены на билеты зависят от маршрута и прочего не совсем линейно. Авиакомпании везде жадные.\n",
    "Линейка дала RMSE = 746.80, R² = 0.686, хороший результат, для не самого замороченного алгоритма. Но ошибка великовата, с учетом того, что почти все билеты лежат в диапазоне цен 0-4000.\n",
    "Градиентный бустинг дал  RMSE = 349.06, R² = 0.932.\n",
    "Самый сильный фактор - авиакомпания, лоукостеры заметно дешевле нормальных авиакомпаний.\n",
    "Потом время вылета, прайм-тайм дороже, чем билеты в 3 часа ночи.\n",
    "Маршрут только на третьем месте).\n",
    "Градиентный бустинг оказался сильно лучше обычной линейной регресси, потому что данные достаточно сложные и линейная регрессия хуже ловит взаимодействия между ними"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "f28c0d89",
   "metadata": {
    "papermill": {
     "duration": 0.005382,
     "end_time": "2026-01-06T01:32:30.687348",
     "exception": false,
     "start_time": "2026-01-06T01:32:30.681966",
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
   "id": "a4dc0590",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-06T01:32:30.702431Z",
     "iopub.status.busy": "2026-01-06T01:32:30.700806Z",
     "iopub.status.idle": "2026-01-06T01:32:31.386026Z",
     "shell.execute_reply": "2026-01-06T01:32:31.383849Z"
    },
    "papermill": {
     "duration": 0.695757,
     "end_time": "2026-01-06T01:32:31.388597",
     "exception": false,
     "start_time": "2026-01-06T01:32:30.692840",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Loading required package: R6\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘lightgbm’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following objects are masked from ‘package:xgboost’:\n",
      "\n",
      "    getinfo, setinfo, slice\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:dplyr’:\n",
      "\n",
      "    slice\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Уровни целевой переменной:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "   Alive Deceased \n",
      "     409      591 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Training XGBoost...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Training LightGBM...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "     Model Accuracy\n",
      "1  XGBoost    0.595\n",
      "2 LightGBM    0.570\n"
     ]
    },
    {
     "data": {
      "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAIAAAByhViMAAAABmJLR0QA/wD/AP+gvaeTAAAg\nAElEQVR4nOzdd2DM9x/H8c+t7CGTiBgRapMYje0au1bRoqT8Wqs1K6jSQZWidmhrtmhr1ChV\npY1GbVpqVdWKWSuRQWRevr8/7nIZskWPj+fjr8vn+/l+7n2fC/fK5ztOpSiKAAAAwNNPbekC\nAAAAUDwIdgAAAJIg2AEAAEiCYAcAACAJgh0AAIAkCHYAAACSINgBAABIgmAHAAAgCYIdAACA\nJAh2AAAAkiDYAQAASIJgBwAAIAmCHQAAgCQIdgAAAJIg2AEAAEiCYAcAACAJgh0AAIAkCHYA\nAACSINgBAABIgmAHAAAgCYIdAACAJAh2AAAAkiDYAQAASIJgBwAAIAmCHQAAgCQIdgAAAJIg\n2AEAAEiCYAcAACAJgh0AAIAkCHYAAACSINgBAABIgmAHAAAgCYIdAACAJAh2AAAAkiDYAQAA\nSIJgBwAAIAmCHQAAgCQIdgAAAJIg2AEAAEiCYAfI6dLmIFW60RGxli4HsLArWwepVCq1WvfN\njXhD0pV6TtbmfyB9t13N1nlsDTfz1hc+/fPh0VITrq6c/9HLrZ/39fGyt9Y5lnCvWKvhqwPH\nbtp7JsdnV+XCytbRy7dWl35jdvwVXfyv+TGIvRBqrPzdvTctXQtyoQCQUcT3L5j/mYdcjLF0\nOYAlpSZeCnCwEkJ4v7DE2HJ58+vmfyC2ru3iDWnmzv+GDzNvcijTM/Mmo/1Lxvo5WuX2qVql\n7eATccnZdsn3s1itcRz5zd+PdRKKoFGdWjVq1KhRo0afdRfNjdPqegohbFxa3EkxWLA25Eal\nFOAXDsDTQUk+te/n/cfP34qKu/v3V3PXRBibG414t427k0ep0v5NWgdWKWXZGoH/3u4x/s1n\nHlOpVEuuxr3h7WBsHO/v8cmxSOPjjivPbQn2E0IoaQ86l/L44c4DIYRKpZ1/+s7QKiUyD7Vp\nbJuun/6c99PZlw764/z2KrZac4tKpcq3SLXGYd31W91K2hXmlT1erjpNdGqaEKLRF3/vG1TF\n2Bjzz1SXKhOEEI2mHtn3boAl60OOLJ0sARSP0xtnNiznkO8/eb8WfX66EGfpYoH/TvL9o646\ntRDCtepHmdvjb2xw0JjOR7JybBCZYlAU5cySduZ/LJX7bcg21IU1g8xb1Rr7Tm9+sP7nPSdO\n/30gfPtXCyY293Uyby3bbnnmHc3trs+tiMxw6+zJ3+eEtDRvrdhj5+OejUJx0Zrmp9EXWVYT\nh5R1EkJobcpeTEi1VG3IDcEOkMEf83trCrAkYKS1Kbv8dLSlSwb+IwdCahp/8/+3599sm8JH\n+5v/XTSfczI1MaKanc4U9RwCsqUWQ/KtWvamI7AanceSA7eyjWZIiRoZ6GnsoFLrdscmmTeZ\nn8W92qaHK+zqblqlcyr3QTG96Ed1+8DusLAwc/CtPnJ5WFjYn9GmV3Rpcxdje+D0E5atEw8j\n2AFPvbjLS6zVGanOuaJ/556v92rkmbHw0PuNlzu8UNZeZ26xcWkalen8mLTUe9+FftC+WT0v\nV2crjdbOsYRfzQbBwyfuu3zf3OdB5Abz7kPOm3LhD10rGFts3ToYFOWXtmXzzpRl2/6S8aSG\nBz8tnfJy60BvTxcrrbWrp3dg65c/Xrot2ylNh0bWMO5r7dRYUQzfzxrTsEo5B2srt9IVOr0+\nZv+1+GyzkbV/LtISMz7O15wvyCQn37uw8L0hzev4uTnZ6WwcvP3q9Hxz4r7L93IcUwjhXnNR\n5t1/al8u89Yf7yZk3hp//feJw4L9/XycbHWuXhWeb9Zh+ood91KLOA8FfBfOftXU+KNKbZv5\nieKufGzuueDf+5k3FfAtK8iMFbDIu2czzoTLPGkpD/42t3c8djuPNy7NcN+YxrQ25eNSs9dp\nSL7VrIS1cRyd3XMrh1Y3Dzvwh8vZOl9c39a8tUVozoHmwe31bdNNOZfx51PGL0ZOwa6Pp71x\nq2fAN9nrT4laN/e9Ts39vdyddTobdy+fZh16z16zOyWHKS9U57S9q+f1bNu0rKeLtVbrUMKt\nev0WwyYuOHfPdHbgpmruD78pbXddN81b0jXjIqiNS0uW7J40BDvgqbckMOO0uRfGrzX+J358\nWj1z46tnohRFSYmPGPZ8Rtpr840p0KQmXQuu7Zbjh6vGynP+kTvGbg8Hu9TEyyWtNMaWxvP/\nUgoT7BKjD71S0zXHPq41Xz4UnWh+dZkDzTev18peobX3Z1kXTh5HsIv6c1WNnE6W11iVnLz9\nysNjCiG0NhUyf5oGlbDJvDVzRonYOtUzfRozK1Gl04G7RZmHxxTsCv6WFWTGHjHYJcUdMLfn\nHeyiTo8ydivd9LscO1zfOeLhZy/Z8KOHey719zBuVWvsryYVLs+YR84a7AzRty59/UlP0xuh\n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\nYII="
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
    "# ура рак печени, у меня тоже такой мог быть, если бы я пить не бросил((((\n",
    "library(tidyverse)\n",
    "library(caret)\n",
    "library(xgboost)\n",
    "library(lightgbm)\n",
    "library(janitor)\n",
    "\n",
    "# 1. Загрузка\n",
    "df <- read_csv(\"/kaggle/input/gallbladder-cancer-patient-dataset/gallbladder_cancer_dataset.csv\", show_col_types = FALSE) %>%\n",
    "  clean_names()\n",
    "\n",
    "# 2. Подготовка\n",
    "print(\"Уровни целевой переменной:\")\n",
    "print(table(df$outcome))\n",
    "\n",
    "df_model <- df %>%\n",
    "  select(-patient_id) %>% \n",
    "  mutate(across(where(is.character), as.factor)) %>%\n",
    "  na.omit()\n",
    "\n",
    "\n",
    "df_model$target <- as.numeric(df_model$outcome) - 1 \n",
    "df_model <- df_model %>% select(-outcome)\n",
    "\n",
    "# 3. Разделение\n",
    "set.seed(42)\n",
    "index <- createDataPartition(df_model$target, p = 0.8, list = FALSE)\n",
    "train_data <- df_model[index, ]\n",
    "test_data  <- df_model[-index, ]\n",
    "\n",
    "train_x <- model.matrix(target ~ . -1, data = train_data)\n",
    "test_x  <- model.matrix(target ~ . -1, data = test_data)\n",
    "train_y <- train_data$target\n",
    "test_y  <- test_data$target\n",
    "\n",
    "#XGBoost\n",
    "print(\"Training XGBoost...\")\n",
    "xgb_model <- xgboost(data = train_x, label = train_y,\n",
    "                     nrounds = 100, objective = \"binary:logistic\", verbose = 0)\n",
    "\n",
    "pred_xgb_prob <- predict(xgb_model, test_x)\n",
    "pred_xgb_class <- ifelse(pred_xgb_prob > 0.5, 1, 0)\n",
    "acc_xgb <- mean(pred_xgb_class == test_y)\n",
    "\n",
    "#LightGBM\n",
    "print(\"Training LightGBM...\")\n",
    "dtrain <- lgb.Dataset(data = train_x, label = train_y)\n",
    "params <- list(objective = \"binary\", metric = \"binary_logloss\")\n",
    "lgb_model <- lgb.train(params, dtrain, nrounds = 100, verbose = -1)\n",
    "\n",
    "pred_lgb_prob <- predict(lgb_model, test_x)\n",
    "pred_lgb_class <- ifelse(pred_lgb_prob > 0.5, 1, 0)\n",
    "acc_lgb <- mean(pred_lgb_class == test_y)\n",
    "\n",
    "# ИТОГ\n",
    "results <- data.frame(\n",
    "  Model = c(\"XGBoost\", \"LightGBM\"),\n",
    "  Accuracy = c(acc_xgb, acc_lgb)\n",
    ")\n",
    "print(results)\n",
    "\n",
    "importance <- xgb.importance(feature_names = colnames(train_x), model = xgb_model)\n",
    "xgb.plot.importance(importance, top_n = 10, main = \"Факторы смертности (XGBoost)\")\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "82e01ab8",
   "metadata": {
    "papermill": {
     "duration": 0.006754,
     "end_time": "2026-01-06T01:32:31.402300",
     "exception": false,
     "start_time": "2026-01-06T01:32:31.395546",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Xgboost дал точность 59.5%, lightGBM дал 57%. Точность не особо высокая в обоих случаях, либо потому данные сложные, либо потому что всего 1000 строк в датасете. \n",
    "Самими сильными предикторами стали: уровень онкомаркеров, индекс массы тела, размер опухоли"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "27b11e5f",
   "metadata": {
    "papermill": {
     "duration": 0.006625,
     "end_time": "2026-01-06T01:32:31.415339",
     "exception": false,
     "start_time": "2026-01-06T01:32:31.408714",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Задание 3 "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "c0e4f4a8",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-06T01:32:31.433542Z",
     "iopub.status.busy": "2026-01-06T01:32:31.431257Z",
     "iopub.status.idle": "2026-01-06T01:34:32.003289Z",
     "shell.execute_reply": "2026-01-06T01:34:32.000850Z"
    },
    "papermill": {
     "duration": 120.584494,
     "end_time": "2026-01-06T01:34:32.006471",
     "exception": false,
     "start_time": "2026-01-06T01:32:31.421977",
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
      "================ LM SUMMARIES (TRAIN) ================\n"
     ]
    },
    {
     "data": {
      "text/plain": [
       "\n",
       "Call:\n",
       "lm(formula = happiness_score ~ sleep_hours + screen_time_per_day_hours, \n",
       "    data = train_df)\n",
       "\n",
       "Residuals:\n",
       "    Min      1Q  Median      3Q     Max \n",
       "-4.5031 -2.1865  0.0225  2.1297  4.7390 \n",
       "\n",
       "Coefficients:\n",
       "                          Estimate Std. Error t value Pr(>|t|)    \n",
       "(Intercept)               4.930139   0.294758  16.726   <2e-16 ***\n",
       "sleep_hours               0.064952   0.037172   1.747   0.0807 .  \n",
       "screen_time_per_day_hours 0.007624   0.031863   0.239   0.8109    \n",
       "---\n",
       "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1\n",
       "\n",
       "Residual standard error: 2.561 on 2096 degrees of freedom\n",
       "Multiple R-squared:  0.001486,\tAdjusted R-squared:  0.0005331 \n",
       "F-statistic:  1.56 on 2 and 2096 DF,  p-value: 0.2105\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "\n",
       "Call:\n",
       "lm(formula = happiness_score ~ sleep_hours + screen_time_per_day_hours + \n",
       "    stress_level + gender, data = train_df)\n",
       "\n",
       "Residuals:\n",
       "    Min      1Q  Median      3Q     Max \n",
       "-4.4997 -2.2413  0.0098  2.1226  4.9236 \n",
       "\n",
       "Coefficients:\n",
       "                           Estimate Std. Error t value Pr(>|t|)    \n",
       "(Intercept)                4.854334   0.317728  15.278   <2e-16 ***\n",
       "sleep_hours                0.065481   0.037179   1.761   0.0783 .  \n",
       "screen_time_per_day_hours  0.008261   0.031886   0.259   0.7956    \n",
       "stress_levelLow           -0.112939   0.137227  -0.823   0.4106    \n",
       "stress_levelModerate      -0.016448   0.137588  -0.120   0.9049    \n",
       "genderMale                 0.245780   0.136127   1.806   0.0711 .  \n",
       "genderOther                0.097915   0.136875   0.715   0.4745    \n",
       "---\n",
       "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1\n",
       "\n",
       "Residual standard error: 2.561 on 2092 degrees of freedom\n",
       "Multiple R-squared:  0.003478,\tAdjusted R-squared:  0.00062 \n",
       "F-statistic: 1.217 on 6 and 2092 DF,  p-value: 0.2944\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "data": {
      "text/plain": [
       "\n",
       "Call:\n",
       "lm(formula = happiness_score ~ sleep_hours + screen_time_per_day_hours + \n",
       "    work_hours_per_week + social_interaction_score + stress_level + \n",
       "    gender, data = train_df)\n",
       "\n",
       "Residuals:\n",
       "    Min      1Q  Median      3Q     Max \n",
       "-4.6347 -2.1968  0.0197  2.1374  4.9376 \n",
       "\n",
       "Coefficients:\n",
       "                           Estimate Std. Error t value Pr(>|t|)    \n",
       "(Intercept)                4.978923   0.386066  12.897   <2e-16 ***\n",
       "sleep_hours                0.065433   0.037157   1.761   0.0784 .  \n",
       "screen_time_per_day_hours  0.008688   0.031867   0.273   0.7852    \n",
       "work_hours_per_week        0.003061   0.004877   0.628   0.5304    \n",
       "social_interaction_score  -0.045010   0.021831  -2.062   0.0394 *  \n",
       "stress_levelLow           -0.109872   0.137204  -0.801   0.4233    \n",
       "stress_levelModerate      -0.018827   0.137524  -0.137   0.8911    \n",
       "genderMale                 0.245730   0.136045   1.806   0.0710 .  \n",
       "genderOther                0.098930   0.136797   0.723   0.4696    \n",
       "---\n",
       "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1\n",
       "\n",
       "Residual standard error: 2.559 on 2090 degrees of freedom\n",
       "Multiple R-squared:  0.005637,\tAdjusted R-squared:  0.001831 \n",
       "F-statistic: 1.481 on 8 and 2090 DF,  p-value: 0.1589\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "================ DIAGNOSTICS (m3) ================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Breusch-Pagan (heteroskedasticity) p-value: 0.2965564 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Shapiro-Wilk (normality of residuals) p-value: 1.046448e-23 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "VIF (multicollinearity):\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                              GVIF Df GVIF^(1/(2*Df))\n",
      "sleep_hours               1.000598  1        1.000299\n",
      "screen_time_per_day_hours 1.001659  1        1.000829\n",
      "work_hours_per_week       1.003574  1        1.001785\n",
      "social_interaction_score  1.002999  1        1.001498\n",
      "stress_level              1.005744  2        1.001433\n",
      "gender                    1.003882  2        1.000969\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Robust (HC1) standard errors for m3:\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "t test of coefficients:\n",
      "\n",
      "                            Estimate Std. Error t value Pr(>|t|)    \n",
      "(Intercept)                4.9789231  0.3885100 12.8154  < 2e-16 ***\n",
      "sleep_hours                0.0654335  0.0376252  1.7391  0.08217 .  \n",
      "screen_time_per_day_hours  0.0086880  0.0317458  0.2737  0.78436    \n",
      "work_hours_per_week        0.0030607  0.0048472  0.6314  0.52783    \n",
      "social_interaction_score  -0.0450103  0.0215851 -2.0852  0.03717 *  \n",
      "stress_levelLow           -0.1098718  0.1380313 -0.7960  0.42613    \n",
      "stress_levelModerate      -0.0188269  0.1365446 -0.1379  0.89035    \n",
      "genderMale                 0.2457296  0.1368236  1.7960  0.07265 .  \n",
      "genderOther                0.0989297  0.1374910  0.7195  0.47189    \n",
      "---\n",
      "Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "================ TEST METRICS (LM) ================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 3 × 4\u001b[39m\n",
      "  Model  RMSE   MAE        R2\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m m1     2.55  2.22 0.000\u001b[4m6\u001b[24m\u001b[4m3\u001b[24m\u001b[4m9\u001b[24m \n",
      "\u001b[90m2\u001b[39m m3     2.56  2.22 0.000\u001b[4m0\u001b[24m\u001b[4m2\u001b[24m\u001b[4m1\u001b[24m6\n",
      "\u001b[90m3\u001b[39m m2     2.56  2.22 0.001\u001b[4m0\u001b[24m\u001b[4m8\u001b[24m  \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      ">>> Best regression by TEST RMSE: m1 \n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message:\n",
      "“\u001b[1m\u001b[22m`parameters.workflow()` was deprecated in tune 0.1.6.9003.\n",
      "\u001b[36mℹ\u001b[39m Please use `hardhat::extract_parameter_set_dials()` instead.”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "================ TEST METRICS (XGBOOST) ================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 1 × 4\u001b[39m\n",
      "  Model          RMSE   MAE       R2\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m         \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m    \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m xgboost_on_m1  2.55  2.21 0.000\u001b[4m2\u001b[24m\u001b[4m2\u001b[24m\u001b[4m6\u001b[24m\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "================ FINAL COMPARISON ================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 4 × 4\u001b[39m\n",
      "  Model          RMSE   MAE        R2\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m         \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m xgboost_on_m1  2.55  2.21 0.000\u001b[4m2\u001b[24m\u001b[4m2\u001b[24m\u001b[4m6\u001b[24m \n",
      "\u001b[90m2\u001b[39m m1             2.55  2.22 0.000\u001b[4m6\u001b[24m\u001b[4m3\u001b[24m\u001b[4m9\u001b[24m \n",
      "\u001b[90m3\u001b[39m m3             2.56  2.22 0.000\u001b[4m0\u001b[24m\u001b[4m2\u001b[24m\u001b[4m1\u001b[24m6\n",
      "\u001b[90m4\u001b[39m m2             2.56  2.22 0.001\u001b[4m0\u001b[24m\u001b[4m8\u001b[24m  \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "================ CONCLUSION (AUTO) ================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Best model by TEST RMSE: xgboost_on_m1 \n",
      "(RMSE=2.549, MAE=2.214, R2=0.000)\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Insignificant terms in best regression (TRAIN, p>0.05):\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 2 × 5\u001b[39m\n",
      "  term                      estimate std.error statistic p.value\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m                        \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m screen_time_per_day_hours  0.007\u001b[4m6\u001b[24m\u001b[4m2\u001b[24m    0.031\u001b[4m9\u001b[24m     0.239  0.811 \n",
      "\u001b[90m2\u001b[39m sleep_hours                0.065\u001b[4m0\u001b[24m     0.037\u001b[4m2\u001b[24m     1.75   0.080\u001b[4m7\u001b[24m\n"
     ]
    }
   ],
   "source": [
    "\n",
    "suppressPackageStartupMessages({\n",
    "  library(tidyverse)\n",
    "  library(broom)\n",
    "  library(dplyr)\n",
    "  library(lmtest)     # bptest\n",
    "  library(sandwich)   # robust SE\n",
    "  library(car)        # vif\n",
    "  library(tidymodels) # recipes + xgboost tuning\n",
    "})\n",
    "\n",
    "set.seed(42)\n",
    "\n",
    "df <- read.csv(\"/kaggle/input/mental-health-and-lifestyle-habits-2019-2024/Mental_Health_Lifestyle_Dataset.csv\")\n",
    "\n",
    "library(janitor)\n",
    "\n",
    "\n",
    "df <- janitor::clean_names(df)\n",
    "\n",
    "\n",
    "df <- df %>%\n",
    "  mutate(\n",
    "    country                 = as.factor(country),\n",
    "    gender                  = as.factor(gender),\n",
    "    exercise_level          = as.factor(exercise_level),\n",
    "    diet_type               = as.factor(diet_type),\n",
    "    stress_level            = as.factor(stress_level),\n",
    "    mental_health_condition = as.factor(mental_health_condition)\n",
    "  )\n",
    "\n",
    "use_cols <- c(\n",
    "  \"happiness_score\",\n",
    "  \"sleep_hours\",\n",
    "  \"work_hours_per_week\",\n",
    "  \"screen_time_per_day_hours\",\n",
    "  \"social_interaction_score\",\n",
    "  \"age\",\n",
    "  \"gender\",\n",
    "  \"stress_level\",\n",
    "  \"exercise_level\",\n",
    "  \"diet_type\",\n",
    "  \"mental_health_condition\",\n",
    "  \"country\"\n",
    ")\n",
    "\n",
    "df <- df %>% drop_na(any_of(use_cols))\n",
    "\n",
    "# 3) Train/Test split ----------------------------------------\n",
    "split_obj <- initial_split(df, prop = 0.7, strata = happiness_score)\n",
    "train_df  <- training(split_obj)\n",
    "test_df   <- testing(split_obj)\n",
    "\n",
    "\n",
    "m1 <- lm(happiness_score ~ sleep_hours + screen_time_per_day_hours, data = train_df)\n",
    "\n",
    "m2 <- lm(happiness_score ~ sleep_hours + screen_time_per_day_hours +\n",
    "           stress_level + gender, data = train_df)\n",
    "\n",
    "m3 <- lm(happiness_score ~ sleep_hours + screen_time_per_day_hours +\n",
    "           work_hours_per_week + social_interaction_score +\n",
    "           stress_level + gender, data = train_df)\n",
    "\n",
    "cat(\"\\n================ LM SUMMARIES (TRAIN) ================\\n\")\n",
    "summary(m1)\n",
    "summary(m2)\n",
    "summary(m3)\n",
    "\n",
    "cat(\"\\n================ DIAGNOSTICS (m3) ================\\n\")\n",
    "cat(\"Breusch-Pagan (heteroskedasticity) p-value:\", bptest(m3)$p.value, \"\\n\")\n",
    "cat(\"Shapiro-Wilk (normality of residuals) p-value:\", shapiro.test(residuals(m3))$p.value, \"\\n\")\n",
    "cat(\"VIF (multicollinearity):\\n\")\n",
    "print(vif(m3))\n",
    "\n",
    "cat(\"\\nRobust (HC1) standard errors for m3:\\n\")\n",
    "print(lmtest::coeftest(m3, vcov. = sandwich::vcovHC(m3, type = \"HC1\")))\n",
    "\n",
    "reg_metrics <- function(actual, pred) {\n",
    "  tibble(\n",
    "    RMSE = yardstick::rmse_vec(actual, pred),\n",
    "    MAE  = yardstick::mae_vec(actual, pred),\n",
    "    R2   = yardstick::rsq_vec(actual, pred)\n",
    "  )\n",
    "}\n",
    "\n",
    "lm_tbl <- tibble(\n",
    "  Model = c(\"m1\",\"m2\",\"m3\"),\n",
    "  Fit = list(m1,m2,m3)\n",
    ") %>%\n",
    "  mutate(\n",
    "    pred = map(Fit, ~ predict(.x, newdata = test_df)),\n",
    "    metrics = map(pred, ~ reg_metrics(test_df$happiness_score, .x))\n",
    "  ) %>%\n",
    "  unnest(metrics) %>%\n",
    "  select(-Fit, -pred) %>%\n",
    "  arrange(RMSE)\n",
    "\n",
    "cat(\"\\n================ TEST METRICS (LM) ================\\n\")\n",
    "print(lm_tbl)\n",
    "\n",
    "best_lm_name <- lm_tbl %>% dplyr::slice(1) %>% dplyr::pull(Model)\n",
    "best_lm_fit  <- list(m1=m1, m2=m2, m3=m3)[[best_lm_name]]\n",
    "\n",
    "cat(\"\\n>>> Best regression by TEST RMSE:\", best_lm_name, \"\\n\")\n",
    "\n",
    "best_formula <- formula(best_lm_fit)\n",
    "best_predictors <- all.vars(best_formula)[-1]  # drop target\n",
    "\n",
    "train_boost <- train_df %>% select(happiness_score, all_of(best_predictors))\n",
    "test_boost  <- test_df  %>% select(happiness_score, all_of(best_predictors))\n",
    "\n",
    "rec <- recipe(happiness_score ~ ., data = train_boost) %>%\n",
    "  step_dummy(all_nominal_predictors()) %>%\n",
    "  step_zv(all_predictors()) %>%\n",
    "  step_normalize(all_numeric_predictors())\n",
    "\n",
    "xgb_spec <- boost_tree(\n",
    "  trees = tune(),\n",
    "  tree_depth = tune(),\n",
    "  learn_rate = tune(),\n",
    "  mtry = tune(),\n",
    "  min_n = tune()\n",
    ") %>%\n",
    "  set_engine(\"xgboost\") %>%\n",
    "  set_mode(\"regression\")\n",
    "\n",
    "wf <- workflow() %>% add_recipe(rec) %>% add_model(xgb_spec)\n",
    "\n",
    "folds <- vfold_cv(train_boost, v = 5)\n",
    "\n",
    "params <- parameters(wf) %>% finalize(train_boost)\n",
    "\n",
    "grid <- grid_latin_hypercube(params, size = 20)\n",
    "\n",
    "tuned <- tune_grid(\n",
    "  wf,\n",
    "  resamples = folds,\n",
    "  grid = grid,\n",
    "  metrics = metric_set(rmse, mae, rsq)\n",
    ")\n",
    "\n",
    "best_params <- select_best(tuned, metric = \"rmse\")\n",
    "final_wf <- finalize_workflow(wf, best_params)\n",
    "final_fit <- fit(final_wf, data = train_boost)\n",
    "\n",
    "xgb_pred <- predict(final_fit, new_data = test_boost) %>% pull(.pred)\n",
    "xgb_met  <- reg_metrics(test_boost$happiness_score, xgb_pred) %>%\n",
    "  mutate(Model = paste0(\"xgboost_on_\", best_lm_name), .before = 1)\n",
    "\n",
    "cat(\"\\n================ TEST METRICS (XGBOOST) ================\\n\")\n",
    "print(xgb_met)\n",
    "\n",
    "final_tbl <- bind_rows(\n",
    "  lm_tbl,\n",
    "  xgb_met\n",
    ")\n",
    "\n",
    "cat(\"\\n================ FINAL COMPARISON ================\\n\")\n",
    "print(final_tbl %>% arrange(RMSE))\n",
    "\n",
    "best_row <- final_tbl[order(final_tbl$RMSE), ][1, ]\n",
    "\n",
    "cat(\"\\n================ CONCLUSION (AUTO) ================\\n\")\n",
    "cat(\n",
    "  \"Best model by TEST RMSE:\", best_row$Model,\n",
    "  sprintf(\"\\n(RMSE=%.3f, MAE=%.3f, R2=%.3f)\\n\", best_row$RMSE, best_row$MAE, best_row$R2)\n",
    ")\n",
    "\n",
    "cat(\"\\nInsignificant terms in best regression (TRAIN, p>0.05):\\n\")\n",
    "print(\n",
    "  broom::tidy(best_lm_fit) %>%\n",
    "    filter(term != \"(Intercept)\", p.value > 0.05) %>%\n",
    "    arrange(desc(p.value))\n",
    ")\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "23276ea7",
   "metadata": {
    "papermill": {
     "duration": 0.008623,
     "end_time": "2026-01-06T01:34:32.028656",
     "exception": false,
     "start_time": "2026-01-06T01:34:32.020033",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "В общем, я так и не смог вытянуть отсюда нормальные цифры, ни с обычными линейными моделями, ни с обычным xgboost, ни с xgboost с подбором гиперпараметров.\n",
    "По тесту шапиро-вилка видно, что остатки распределены не нормально.\n",
    "Мультиколлинеарности нет.\n",
    "В описании датасета нет отметки о том, что он синтетический, но выглядит оно так, как будто  happiness_score это набор случайных чисел, без связи. "
   ]
  },
  {
   "cell_type": "markdown",
   "id": "96066c91",
   "metadata": {
    "papermill": {
     "duration": 0.008574,
     "end_time": "2026-01-06T01:34:32.045449",
     "exception": false,
     "start_time": "2026-01-06T01:34:32.036875",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "# Задание 4"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "e1a2d942",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-06T01:34:32.066242Z",
     "iopub.status.busy": "2026-01-06T01:34:32.064611Z",
     "iopub.status.idle": "2026-01-06T01:36:13.650553Z",
     "shell.execute_reply": "2026-01-06T01:36:13.648573Z"
    },
    "papermill": {
     "duration": 101.600769,
     "end_time": "2026-01-06T01:36:13.654450",
     "exception": false,
     "start_time": "2026-01-06T01:34:32.053681",
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
      "Attaching package: ‘caretEnsemble’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:workflowsets’:\n",
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
      "The following object is masked from ‘package:tune’:\n",
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
      "The following object is masked from ‘package:parsnip’:\n",
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
      "randomForest 4.7-1.1\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Type rfNews() to see new features/changes/bug fixes.\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "\n",
      "Attaching package: ‘randomForest’\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "The following object is masked from ‘package:dplyr’:\n",
      "\n",
      "    combine\n",
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
      "    margin\n",
      "\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"ИТОГОВОЕ СРАВНЕНИЕ\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "               Model  Accuracy\n",
      "1      Random Forest 0.8659330\n",
      "2 Stacking (XGBoost) 0.8554277\n",
      "3                KNN 0.8324162\n",
      "4             LogReg 0.8144072\n"
     ]
    }
   ],
   "source": [
    "library(tidyverse)\n",
    "library(caret)\n",
    "library(caretEnsemble) \n",
    "library(xgboost)\n",
    "library(randomForest)\n",
    "library(janitor)\n",
    "\n",
    "# 1. Загрузка\n",
    "df <- read_csv(\"/kaggle/input/bank-customer-churn-dataset/Bank Customer Churn Prediction.csv\", show_col_types = FALSE) %>%\n",
    "  clean_names()\n",
    "\n",
    "# 2. Подготовка\n",
    "df_model <- df %>%\n",
    "  select(-customer_id) %>%\n",
    "  mutate(\n",
    "    churn = as.factor(make.names(churn)), \n",
    "    country = as.factor(country),\n",
    "    gender = as.factor(gender)\n",
    "  ) %>%\n",
    "  na.omit()\n",
    "\n",
    "# 3. Разделение\n",
    "set.seed(42)\n",
    "index <- createDataPartition(df_model$churn, p = 0.8, list = FALSE)\n",
    "train_data <- df_model[index, ]\n",
    "test_data  <- df_model[-index, ]\n",
    "\n",
    "ctrl <- trainControl(method = \"cv\", number = 5, \n",
    "                     savePredictions = \"final\", \n",
    "                     classProbs = TRUE) \n",
    "\n",
    "\n",
    "\n",
    "# 1. Logistic Regression\n",
    "model_lr <- train(churn ~ ., data = train_data, method = \"glm\", trControl = ctrl)\n",
    "pred_lr_prob <- predict(model_lr, newdata = test_data, type = \"prob\")[,2]\n",
    "\n",
    "# 2. Random Forest\n",
    "model_rf <- train(churn ~ ., data = train_data, method = \"rf\", trControl = ctrl, tuneLength = 3)\n",
    "pred_rf_prob <- predict(model_rf, newdata = test_data, type = \"prob\")[,2]\n",
    "\n",
    "# 3. KNN (k-Nearest Neighbors)\n",
    "model_knn <- train(churn ~ ., data = train_data, method = \"knn\", \n",
    "                   preProcess = c(\"center\", \"scale\"), trControl = ctrl)\n",
    "pred_knn_prob <- predict(model_knn, newdata = test_data, type = \"prob\")[,2]\n",
    "\n",
    "# XGBoost\n",
    "\n",
    "get_oof <- function(model) {\n",
    "  model$pred %>% \n",
    "    arrange(rowIndex) %>% \n",
    "    pull(X1)\n",
    "}\n",
    "\n",
    "train_meta <- data.frame(\n",
    "  LR = get_oof(model_lr),\n",
    "  RF = get_oof(model_rf),\n",
    "  KNN = get_oof(model_knn),\n",
    "  churn = train_data$churn # Target\n",
    ")\n",
    "\n",
    "train_meta_x <- as.matrix(train_meta[, c(\"LR\", \"RF\", \"KNN\")])\n",
    "train_meta_y <- as.numeric(train_meta$churn) - 1 # 0/1\n",
    "\n",
    "xgb_meta <- xgboost(data = train_meta_x, label = train_meta_y,\n",
    "                    nrounds = 100, objective = \"binary:logistic\", verbose = 0)\n",
    "\n",
    "test_meta_x <- as.matrix(data.frame(\n",
    "  LR = pred_lr_prob,\n",
    "  RF = pred_rf_prob,\n",
    "  KNN = pred_knn_prob\n",
    "))\n",
    "\n",
    "pred_meta_prob <- predict(xgb_meta, test_meta_x)\n",
    "pred_meta_class <- ifelse(pred_meta_prob > 0.5, \"X1\", \"X0\")\n",
    "\n",
    "acc_lr <- confusionMatrix(predict(model_lr, test_data), test_data$churn)$overall['Accuracy']\n",
    "acc_rf <- confusionMatrix(predict(model_rf, test_data), test_data$churn)$overall['Accuracy']\n",
    "acc_knn <- confusionMatrix(predict(model_knn, test_data), test_data$churn)$overall['Accuracy']\n",
    "acc_meta <- mean(pred_meta_class == test_data$churn)\n",
    "\n",
    "results <- data.frame(\n",
    "  Model = c(\"LogReg\", \"KNN\", \"Random Forest\", \"Stacking (XGBoost)\"),\n",
    "  Accuracy = c(acc_lr, acc_knn, acc_rf, acc_meta)\n",
    ")\n",
    "\n",
    "print(\"ИТОГОВОЕ СРАВНЕНИЕ\")\n",
    "print(results %>% arrange(desc(Accuracy)))\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "ba9899b4",
   "metadata": {
    "papermill": {
     "duration": 0.010545,
     "end_time": "2026-01-06T01:36:13.674347",
     "exception": false,
     "start_time": "2026-01-06T01:36:13.663802",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "Сначала были построены модели логистической регрессии, knn и rf. Потом на основе их предсказаний обучалась xgboost.\n",
    "Вся морока себя не оправдала, точность rf оказалась выше, чем у xgboost. \n",
    "Скорее всего, добавление результатов логистической регрессии и knn просто слегка увеличило количество шумов, которые ухудшили результат бустинга."
   ]
  }
 ],
 "metadata": {
  "kaggle": {
   "accelerator": "none",
   "dataSources": [
    {
     "datasetId": 6884382,
     "sourceId": 11050606,
     "sourceType": "datasetVersion"
    },
    {
     "datasetId": 6888624,
     "sourceId": 11056718,
     "sourceType": "datasetVersion"
    },
    {
     "datasetId": 6943691,
     "sourceId": 11133244,
     "sourceType": "datasetVersion"
    },
    {
     "datasetId": 2445309,
     "sourceId": 4139805,
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
   "duration": 253.801848,
   "end_time": "2026-01-06T01:36:13.908692",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2026-01-06T01:32:00.106844",
   "version": "2.6.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
