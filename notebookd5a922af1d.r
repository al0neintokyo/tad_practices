{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 1,
   "id": "31d4975b",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:06.903816Z",
     "iopub.status.busy": "2026-01-13T04:51:06.901735Z",
     "iopub.status.idle": "2026-01-13T04:51:14.252966Z",
     "shell.execute_reply": "2026-01-13T04:51:14.251081Z"
    },
    "papermill": {
     "duration": 7.362156,
     "end_time": "2026-01-13T04:51:14.256198",
     "exception": false,
     "start_time": "2026-01-13T04:51:06.894042",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
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
    }
   ],
   "source": [
    "# --- БЛОК 0: БИБЛИОТЕКИ И ДАННЫЕ ---\n",
    "\n",
    "library(caret)\n",
    "library(caretEnsemble)\n",
    "library(dplyr)\n",
    "library(infotheo)\n",
    "library(ggplot2)\n",
    "library(haven)\n",
    "library(pROC)\n",
    "library(tidyr)\n",
    "\n",
    "# чтение RLMS-файла\n",
    "df <- read_sav(\"/kaggle/input/kursovaya/r33i_os_84.sav\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 2,
   "id": "f87f92e4",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:14.301629Z",
     "iopub.status.busy": "2026-01-13T04:51:14.270001Z",
     "iopub.status.idle": "2026-01-13T04:51:14.423851Z",
     "shell.execute_reply": "2026-01-13T04:51:14.421723Z"
    },
    "papermill": {
     "duration": 0.164771,
     "end_time": "2026-01-13T04:51:14.426727",
     "exception": false,
     "start_time": "2026-01-13T04:51:14.261956",
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
   "id": "144749e6",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:14.441336Z",
     "iopub.status.busy": "2026-01-13T04:51:14.439824Z",
     "iopub.status.idle": "2026-01-13T04:51:18.766737Z",
     "shell.execute_reply": "2026-01-13T04:51:18.763877Z"
    },
    "papermill": {
     "duration": 4.337898,
     "end_time": "2026-01-13T04:51:18.770111",
     "exception": false,
     "start_time": "2026-01-13T04:51:14.432213",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Считаем Mutual Information...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Запускаем RFE (Recursive Feature Elimination)...\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "Recursive feature selection\n",
      "\n",
      "Outer resampling method: Cross-Validated (3 fold) \n",
      "\n",
      "Resampling performance over subset size:\n",
      "\n",
      " Variables Accuracy  Kappa AccuracySD KappaSD Selected\n",
      "         5   0.8315 0.1416   0.008443 0.04551         \n",
      "        10   0.8567 0.2327   0.000699 0.02676        *\n",
      "        15   0.8511 0.1851   0.021814 0.13054         \n",
      "        20   0.8455 0.1553   0.005633 0.03702         \n",
      "\n",
      "The top 5 variables (out of 10):\n",
      "   bmi_sq, bmi, sport_freq, weight, grades\n",
      "\n"
     ]
    },
    {
     "data": {
      "image/png": "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\nH6NWbDl/XS+UKt+x96j+rStZpw/uEdzukzF/zl96Ncms8a44cPyUije3z1v3w500tkLdVp9M\nHO7BMb2Cgjovj37bW53P+HdPfrd0w57YG/GM4FW9UYfQUT3VLENEGUnnVkZtPBl7MdOtdK2G\nrRte2razztTI/hVexD4DAABAsSfNYDdj+tYuI4YN9FH8c2DL+gUfmHzXDarmaZ21c9aO4WEz\n6niz386bvmTS2BK1W4VNm8fc/+uTGcs/P9otokWppw5uSj07dvrSmr1HTx1dOf1ebOTc5dP8\nGs0JLCOak2eNmXrJs8GocZ9omaS965bMv26oUOfximvWrPnjjz+srwVBmDVrlhN2nYiIYfI4\nGwkADtNoNK4uwfV4niciuVyObthwHEf48bBjbQjLsuiJDcuyTm2IxZLfBwmkGeyqjI3o26IU\nEVWrWS/1/MCYqMODFnWzzqo4/MOODUoTUZ9RVfZNPDF18uCyCo7K+fbQrT90NokcCHYZhpNp\nFrFj51ZVtQqqVCFisvaWwp2IEv5Z/LdBMXfF+EpKjoiq1tD8MeBj+xUvX778+++/W19rtVqZ\nTFaoOw0AhQm/oTbWv1KurqJoQUOyYRgGvzLZOK8hZrM5n7nSDHZd63nZXrfq6LNr42GirGDn\nWd3D+oIXZKzslbIKzvrWg2NJFB0ZXOUV1Kryj7OGDQ+o/2qN6tXr1m/SqKyWiO78ck2pbW9N\ndUQkU9dq5C6Pt1sxICDAZDJZX6vV6vT09OfYxfzgXxyA5+e839CXiEwmY1nWbDbb/u0CnucZ\nhsnMzHR1IUUFz/Mcx4mimJGR4epaigqO4ziOc15DRFG0nijNlTSDnf2VSN5NxjB57f+zBCCG\n8widt7b3+RN/nzl37vSB7V8tC+geHj64riUje4LmnyiE+vXr169fP+tri8WSkJDwDFt3hPXq\nCQA8j+TkZFeX4HoajYZl2czMTIPB4OpaigpBEFiWxY+HjSAIKpXKYrGgJzYKhUKtVju1IUql\nMq9Z0jy1s+/vx5np0M4b6tJvFOLgied3rli9zb96g2593poY/lnkyCqn964lIl1Tb2Pi/qvG\nrHhnSo39LRn/4wcAAIAXR5qndn6PnLItc3gdH+U/B7ZEX0sdvrBxIQ4u06Tt3hltELSdG1Zi\nUuL37IsT/IKJ6JVGIf78/6ZMjhw9qHMJNmnP2oUsPsMAAAAAL5AEgx3La6cNa742euGm+xk+\n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\nbmuGPlZdhdXtLxgLVs+M/K9b1xmzl6uZ/LTdW9Zf1bXq+M8DV61a9dVXX5mX3dzcDh48WL+t\ng5pwd3e3dwmOhed5nuftXYWjYBgGDamIYRgiUigUcrnc3rU4EIZhZDKZvatwFOYnCcdxeHWt\niGEY2zXEaDRa2epwwY6TyaUMw7Byubz8v02+x9RxL3aotJs+58jBX/JX7YsI5KVE5Nc20Hh2\n4v4tl/tFBxER32N+aL+OROQTMvfxvd9m3tFTM9Wd8wk/6xVr35nfWsER0RP+yrEvrSKiEt35\nYpPQf2CvJ9Ryat0qerH6utzZSoXV7Z/70+aLOvna7X+P3971+wlvVXxgcXHx3bt3y79NjjP/\nZ4AGhrZXgoZUgoZUCW2pBA25H3pSie0aYn1khwt292vRx+f+lbqs84IgLBk/suJKviybKIiI\nmvf1tax04VgSiIjunMxWqPuZUxcRyZy7dXGS5hAp3UN6tfly9WtTArt0bu/v36lLj26+90zv\nq6S6/W99/UfF8aWqJ7s5y25UeGBISMhTTz1VfnSZTKfTPWQnaorjOBuNLAK2a3uj4+TkREQG\ng6G0tNTetTgKlUpVWlqKhlgolUqO40pLSw0Gg71rcRRyuZxhGL1eb+9CHIVMJpPJZCaTqaio\n3u5Z0dhJJBKZTGa7hgiC4Oxc7RmoRhDsVM5VFCnhZQzHf5C6q+JKhpWaF6TKqpLNfdPmXCVs\nDhHDuUSsSx6dce7ipStXfjxxaM+2wOFRUaGdqqunuv1NJZVPjUroniMGBQUFBQWZl00mU25u\nbnWHqCOJpBH8WO0FL8cW5mBXWlqKnlgoFAo0pCK5XM5xnNFoRE8sOI5jWRYNsTCfShAEAT2x\nkMvlUqnUpg2xEuwc8T52NaHyCCZTUXquUVFOvm9VZMKJm1Ye0qynlz7v+O/68vhl1P96+q6B\niPIyDm9POujj33XImFcWRr0TN73tj2nJVsapbn/N0x4Vxy8ryvyuAH/jAgAAQMNprKd2ZM5d\np3Ry370wRjFtVDsvp4vHk45m5EQubGblIZpO4W1l05Ytjgt/eWATNv/TPQnOco6IpK7FRw+n\n6nj1wKDWTOGNY59m897DrIxT3f5Nu4X5SF63jH8seRPutQIAAAANqbEGOyIavDzOkLjpwNY1\n2lKpd6sOEbFLOzlJrezPSNxXxi/dvHHPhtVLSaHpOWbhjLPrU4h4z/FRk+8mpyUvStXxbprW\n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\nSUVORK5CYII="
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    },
    {
     "data": {
      "image/png": "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\nWqNF2HcxMy2/eELHWrL8G+JO1jGjUHUwoyAtGWeUs7OzEGLAgAGzZ88u8wC1Wt2jR4/KLUq6\nYNfU2eHclWgh+ty769T5XHvnxuU+s726nhDiQuFfix1KCi8IIWq7ONx1ZF7iJy8uj31u+/X5\n/WsKIUTPvv3bmap3envq2QlPbwlbn+b5Q0/j1q1bhRDRqYUGfdLWrVtdaz7SrZXnvx+ilFKp\nHDRo0P32RkZGOjo6Ojk5lecDmy0/P1+lUsk1uiQ2xmcIIUa1C7LoT2E1rGBGoUphRkFacs0o\nR0dHIURoaGhEREQlD/0Aki2emDWw1s3z06ZqYu/afnbTu1MSMgO6zSj3mZ28h9grFGf2p5Zu\nyTp9UAgxzMf5riPzru0WQjz9iF/pFu/WLwohjp7MzL2QVVJ0bezQQWFhYWFhYTNOpOlyDoaF\nhU34JO6hhkAlKDGaNpxODg5wa1rdVe5aAACwJJIFu17fajp7O348Mrh592Fvz/n486VfLPxo\n5uj+bZsOfd/Oufl/fxpQ7jMr1XUn1XU7Pfe70rbomhl/ulQf1c397ouurrX7CCGW7kos3ZJ6\naKEQon1rr05L40x32N2/trPPcJPJlPBD54caApXgl/PpqXk6Hl8HAMDDkqwV6+DSek/CwanP\nv7J04/qP9q8r3d6s55hPv1/azd3RnJNPjpq0MHRW14k+/wkPidsROeVk+us7Pi7de3r++Ld/\nS5oVta5t4Ovv9Vowe3Qn94R3+gQHJsf/Nn/W577tJ37U+J/v03rwEKhMPJcYAIDykfIBxY7e\nrT9Zd/Cj9CuHj8YmZ+aoqnk1CQltVluCm9/9Orx7IsrupVlLhn6R5lkn5J1lh+f0DSzdm3li\n35YtF14sNgjhMGNHrO/MSd+vWvzT+8m+9Rp3fnn+wg9f+zfrjB88BCpNscG44XRSm5ruDX1c\n5K4FAAALI+mbJ4QQQqh96nQfUEfy0waPnPH7yLJv1Osadd4Udftrhb3nCx/88MIH/3C23tuv\n3rsq+gFDoNLsPpeeWVD8Vg8u1wEA8NAku8dOCCFMut3LF7/19prSDQOHjfnw6035RpOUo8Cq\naWK0QojhrXhLLwAAD80CXikG26E3GDedTm5fy6O+N31YAAAemmTBrvSVYrv2vFW68eb12AXj\nH00/sbzv1ENSDQQrtjMhLauwmGUTAACUj2TBrvSVYqGNfUo33nql2AsBrueXvSfVQLBimhit\n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"
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
    "# --- БЛОК 1.2: MUTUAL INFORMATION ---\n",
    "\n",
    "print(\"Считаем Mutual Information...\")\n",
    "\n",
    "data_disc   <- discretize(df_eda %>% select(-target))\n",
    "target_disc <- df_eda$target\n",
    "\n",
    "mi_list <- sapply(data_disc, function(x) mutinformation(target_disc, x))\n",
    "\n",
    "mi_df <- data.frame(\n",
    "  Feature = names(mi_list),\n",
    "  MI      = as.numeric(mi_list)\n",
    ") %>%\n",
    "  arrange(desc(MI))\n",
    "\n",
    "ggplot(mi_df, aes(x = reorder(Feature, MI), y = MI)) +\n",
    "  geom_bar(stat = \"identity\", fill = \"steelblue\") +\n",
    "  coord_flip() +\n",
    "  labs(\n",
    "    title = \"Важность признаков (Mutual Information)\",\n",
    "    x = \"Признак\",\n",
    "    y = \"Взаимная информация\"\n",
    "  )\n",
    "\n",
    "# --- БЛОК 1.3: RFE ---\n",
    "\n",
    "print(\"Запускаем RFE (Recursive Feature Elimination)...\")\n",
    "\n",
    "ctrl_rfe <- rfeControl(functions = rfFuncs, method = \"cv\", number = 3)\n",
    "subsample <- df_eda[sample(nrow(df_eda), min(500, nrow(df_eda))), ]\n",
    "\n",
    "rfe_res <- rfe(\n",
    "  subsample %>% select(-target),\n",
    "  subsample$target,\n",
    "  sizes = c(5, 10, 15),\n",
    "  rfeControl = ctrl_rfe\n",
    ")\n",
    "\n",
    "print(rfe_res)\n",
    "plot(rfe_res, type = c(\"g\",\"o\"), main = \"RFE: Сколько признаков нужно?\")\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 4,
   "id": "84475979",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:18.789398Z",
     "iopub.status.busy": "2026-01-13T04:51:18.787844Z",
     "iopub.status.idle": "2026-01-13T04:51:19.460836Z",
     "shell.execute_reply": "2026-01-13T04:51:19.457779Z"
    },
    "papermill": {
     "duration": 0.687099,
     "end_time": "2026-01-13T04:51:19.465298",
     "exception": false,
     "start_time": "2026-01-13T04:51:18.778199",
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
      "“\u001b[1m\u001b[22m`qplot()` was deprecated in ggplot2 3.4.0.”\n"
     ]
    },
    {
     "data": {
      "image/png": "iVBORw0KGgoAAAANSUhEUgAAA0gAAANICAIAAAByhViMAAAABmJLR0QA/wD/AP+gvaeTAAAg\nAElEQVR4nOzdZ2BT5dvH8etkdO9CGQXKKENmAUFAEGWoqMj4g8gQF45HUFERFByIKKAiIKiA\nioIyRMGFW1AQBZUle5SpjAKlg660Sc7zItikK01Lk5Om38+r3vdZV04b8uPkvs9RVFUVAAAA\nVH46rQsAAABAxSDYAQAA+AiCHQAAgI8g2AEAAPgIgh0AAICPINgBAAD4CIIdAACAjyDYAQAA\n+AifDXaWnBPvTXu8d5fW1SPDjAa/sOja7a+99dm5K9MsleOGzLX9DUpBOp0uOCyyxVW9Js1b\nZXJ4ETtndFAUpecXx9xUSW7a740CjVN3JNua5/6+1VZPdPOZJW2iWtLrBRhtq23PzHNTYVWZ\nas3sFxM8YP5urQsBAHgX3wx2GSe+7lSv2aiJs9b+ccAYUbv9lQl1wq3bN6yZ+siQuCv6/ZWe\nq3WBrqrVsFH8fxrWr2XOTNv759qXHx7U5Prn8i4joKrWzN9+++2PLf+4svKcWwZltHz5mYTo\nQv2pB587mG0udpMLeyb9Yyp+ESqEogt+e+WIrx7p8Wvl+WMGAHiALwY7NfeezrdvOZfdbNCz\nu06lnjq6f/PmP/ceOXN+/4YHutVKO/RVn27PaF2iq97dsvvQfxKPnMzOTv1q3hijopz46cU7\nvj5R7t2asw927dr1+v+9U+qaybteGL/x9BPL7ivUrzPorZascT+fKnarzZO+EhGjTil3hShV\n7Wvf6heeOWLYSq0LAQB4ER8MdmnHpnxyKiMgsteWj19oUSMwvz+qSde3ftraJsQveeerr/57\nUcMKy03nF3bL6Lmf3tZQRNZO/MEDR5w3dG5wjTvGN44o1B/ReJxOUTY9/WUx26imJ9edCoi6\nsUOInwcqrML0L0/r+M+3o75NydG6EgCAt/DBYJeyc5OIBNe4M7jIFSOdX60X21QTkXVHLyPY\nqaazedbLKPBydX6qjYhknVnr7gNlJ3/2wt4LLSaML7rIP7z7I7EhF/ZMPGayFFqUevjFfVl5\nDYc+z/U6d2s49HWD5I5/YbvWhQAAvIUPBju/yCARyTj19qncYuLXzWsTMzIyPutSy96lmn98\nd/KNna6ICg0IjohJuG7g659ucdxk/4KrFUUZczg14/g3t3drHuIX9OHZLNui4xuX3dX/2tiY\nSP+giMatOjz0wvzErMJjy1xZp0ws2bZhVYUTlQPr+o+m3XpN6+oRIX7B4Q1adnno+XdO/ZfA\nVlxRzS+knYikn3hRUZTopu+XtJf9b7yoqupjIxoVu/S+CS2tlovjfj1dqH/b8x+LyD0TWhS7\n1ak/P733fz3r1ojyDwxv1LzdqElz96Vfml2RfvwZpQQJT2/N38PONW8NueGqGtFhfoFhdRu3\nv+vx1w6mFzM/I/P0m8XuaviBCyW9XhHZM6dTSTWMO5rmuKbzMrLOLVMUJarx2/YNVNPgWiGK\notz+7l2uvMzdn826qVv7WhEBhda5esH+/HWMwW3H1g459MH4yjEhCADgAarPyb24JdqoF5Hw\nxr1eff+Lo+dznK5unja4mYjo9CFtO3Xr0KqxQVFE5Jpxq/PX2De/i4iM2vZ9QphfYI0mvW7q\n+0Vytqqqm2aN1CuKoig16je/+qo21YINIhIc22NtUlb+tq6sU6xafnoR+fpCdtFF83vEiki1\nVgttzb+nXykiPT4/mr/CnDvaiIiiKDUatrqm85WRtrMRf+uezDxVVXe8PmX8E3eLiH/Y1U89\n9dSUmVtKqmFM7RBjcCtrwc6zO/qKSK1O3+Rc+FZEYtovLLjc0inM3z+si0VVrw7zF5FtGbn5\ny7YveMA28K56vWZXd06ICTGKSGD1zmuOX1RVNevs8kH/iQ80iEiv/v+zNZ/46LBtD19N7GP7\nu42s07Tb1R1rBRlEJDC680/nCp+oiyfniEhAVNf8fV5bN0REhu1PdnLad8++SkSqX9VnkINu\n1QNF5IkjqfmrlVpG5tmlIhIZ/1b+Joc+7C8i4Q0eyHDhZR77bIyiKDp9cNfeffNXvvHKaiLS\nZf4+x4L/eLSliLx/JtPJiwIAVB0+GOxUVT30yaQafnrbR6+iGBq17X7/uCkff/vbuWxzoTX3\nL7xVRMLjB//1X9JK2raqYYBBUfSLTmXYemzBLqZBSI+nl2VZLuWctCNv+esUv5BWC39KtPVY\n8s6/PaaTiITH329xeZ2SFA12Vkv28QPb5zx2KVLc99O/tv5Cwe7oqhEi4h/e4Yud5209uRcP\nPn5tLRGJu2XxpZ6MbSISVu9ZJwVYcs8G6pTI+DmF+vODnaqq99cK0Rki/zXZX0r68VdEpPEd\nP6tFgl3GqY+C9TpDYPzcNXsvvSJz6gfje4hISOwgU8H8OKZ2SKFQqKpq8q6pOkUxBNR/55dj\n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"
     },
     "metadata": {
      "image/png": {
       "height": 420,
       "width": 420
      }
     },
     "output_type": "display_data"
    },
    {
     "data": {
      "image/png": "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\n/wPji5FS5y9Q4AAAAABJRU5ErkJggg=="
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
    "# --- БЛОК 2: PCA АНАЛИЗ ---\n",
    "\n",
    "nums <- df_eda %>%\n",
    "  select(where(is.numeric)) %>%\n",
    "  select(where(~ var(.) != 0))\n",
    "\n",
    "pca_res <- prcomp(nums, center = TRUE, scale. = TRUE)\n",
    "\n",
    "var_explained <- pca_res$sdev^2 / sum(pca_res$sdev^2)\n",
    "\n",
    "qplot(seq_along(var_explained), var_explained) +\n",
    "  geom_line(color = \"blue\", linewidth = 1) +\n",
    "  geom_point(size = 2) +\n",
    "  labs(\n",
    "    title = \"Scree Plot (Метод локтя)\",\n",
    "    subtitle = \"Сколько компонент нужно?\",\n",
    "    x = \"Номер компоненты\",\n",
    "    y = \"Доля объяснённой дисперсии\"\n",
    "  ) +\n",
    "  theme_minimal()\n",
    "\n",
    "pca_data <- as.data.frame(pca_res$x)\n",
    "pca_data$Group <- df_eda$target\n",
    "\n",
    "ggplot(pca_data, aes(x = PC1, y = PC2, color = Group)) +\n",
    "  geom_point(alpha = 0.6, size = 2) +\n",
    "  labs(\n",
    "    title = \"PCA: Визуализация пространства признаков\",\n",
    "    subtitle = \"Видно ли разделение классов?\",\n",
    "    color = \"Здоровье\"\n",
    "  ) +\n",
    "  theme_minimal()\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "e8443ff6",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:19.493372Z",
     "iopub.status.busy": "2026-01-13T04:51:19.491801Z",
     "iopub.status.idle": "2026-01-13T04:51:19.663512Z",
     "shell.execute_reply": "2026-01-13T04:51:19.661556Z"
    },
    "papermill": {
     "duration": 0.18895,
     "end_time": "2026-01-13T04:51:19.666359",
     "exception": false,
     "start_time": "2026-01-13T04:51:19.477409",
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
    "# --- БЛОК 3: ДАННЫЕ ДЛЯ МОДЕЛЕЙ (df_mod) И TRAIN/TEST SPLIT ---\n",
    "\n",
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
    "}\n",
    "\n",
    "# Чистим имена колонок для моделей\n",
    "\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 6,
   "id": "914f988d",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:19.693505Z",
     "iopub.status.busy": "2026-01-13T04:51:19.691986Z",
     "iopub.status.idle": "2026-01-13T04:51:43.086838Z",
     "shell.execute_reply": "2026-01-13T04:51:43.085019Z"
    },
    "papermill": {
     "duration": 23.410917,
     "end_time": "2026-01-13T04:51:43.089166",
     "exception": false,
     "start_time": "2026-01-13T04:51:19.678249",
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
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "data": {
      "text/plain": [
       "\n",
       "Call:\n",
       "summary.resamples(object = results)\n",
       "\n",
       "Models: xgbTree, rf, glm, glm_pca, rf_pca \n",
       "Number of resamples: 5 \n",
       "\n",
       "Accuracy \n",
       "             Min.   1st Qu.    Median      Mean   3rd Qu.      Max. NA's\n",
       "xgbTree 0.7794118 0.7834862 0.7992634 0.7970646 0.8069853 0.8161765    0\n",
       "rf      0.8018349 0.8066298 0.8088235 0.8099282 0.8106618 0.8216912    0\n",
       "glm     0.7679558 0.7922794 0.8088235 0.7974113 0.8088235 0.8091743    0\n",
       "glm_pca 0.7882136 0.8033088 0.8143382 0.8073432 0.8146789 0.8161765    0\n",
       "rf_pca  0.7900552 0.8106618 0.8125000 0.8088145 0.8146789 0.8161765    0\n",
       "\n",
       "Kappa \n",
       "              Min.    1st Qu.     Median       Mean    3rd Qu.      Max. NA's\n",
       "xgbTree 0.05325444 0.06015257 0.08818083 0.07925830 0.08952882 0.1051749    0\n",
       "rf      0.05721425 0.06549639 0.06594652 0.08155142 0.10162602 0.1174739    0\n",
       "glm     0.06701031 0.09205290 0.09213224 0.09429015 0.09907959 0.1211757    0\n",
       "glm_pca 0.09411066 0.09523334 0.10369031 0.10640225 0.10398320 0.1349938    0\n",
       "rf_pca  0.04480055 0.06217617 0.09416295 0.08305509 0.09523334 0.1189024    0\n"
      ]
     },
     "metadata": {},
     "output_type": "display_data"
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "A glm ensemble of 5 base models: xgbTree, rf, glm, glm_pca, rf_pca\n",
      "\n",
      "Ensemble results:\n",
      "Generalized Linear Model \n",
      "\n",
      "2720 samples\n",
      "   5 predictor\n",
      "   2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 2175, 2177, 2176, 2175, 2177 \n",
      "Resampling results:\n",
      "\n",
      "  Accuracy   Kappa     \n",
      "  0.8136024  0.07489841\n",
      "\n"
     ]
    },
    {
     "data": {
      "image/png": "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\nRK5CYII="
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
    "# --- БЛОК 4: ОБУЧЕНИЕ МОДЕЛЕЙ И СТЭКИНГ (TRAIN) ---\n",
    "\n",
    "set.seed(123)\n",
    "my_folds <- createFolds(df_train$target, k = 5)\n",
    "\n",
    "ctrl <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  index  = my_folds,\n",
    "  savePredictions = \"final\",\n",
    "  classProbs = TRUE,\n",
    "  allowParallel = TRUE\n",
    ")\n",
    "\n",
    "model_list <- caretList(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  trControl = ctrl,\n",
    "  continue_on_fail = TRUE,\n",
    "  tuneList = list(\n",
    "    xgbTree = caretModelSpec(method = \"xgbTree\", tuneLength = 3, verbosity = 0),\n",
    "    rf      = caretModelSpec(method = \"rf\",      tuneLength = 3),\n",
    "    glm     = caretModelSpec(method = \"glm\"),\n",
    "    glm_pca = caretModelSpec(\n",
    "      method = \"glm\",\n",
    "      preProcess = c(\"center\",\"scale\",\"pca\")\n",
    "    ),\n",
    "    rf_pca  = caretModelSpec(\n",
    "      method = \"rf\",\n",
    "      preProcess = c(\"center\",\"scale\",\"pca\"),\n",
    "      tuneLength = 3\n",
    "    )\n",
    "  )\n",
    ")\n",
    "\n",
    "results <- resamples(model_list)\n",
    "summary(results)\n",
    "dotplot(results, main = \"Сравнение моделей (CV, train)\")\n",
    "\n",
    "# --- СТЭКИНГ (общий гибрид) ---\n",
    "meta_ctrl <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "stack_final <- caretStack(\n",
    "  model_list,\n",
    "  method  = \"glm\",\n",
    "  metric  = \"Kappa\",\n",
    "  trControl = meta_ctrl\n",
    ")\n",
    "\n",
    "print(stack_final)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 7,
   "id": "8292dbb7",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:43.120852Z",
     "iopub.status.busy": "2026-01-13T04:51:43.118444Z",
     "iopub.status.idle": "2026-01-13T04:51:43.373960Z",
     "shell.execute_reply": "2026-01-13T04:51:43.371513Z"
    },
    "papermill": {
     "duration": 0.27451,
     "end_time": "2026-01-13T04:51:43.377018",
     "exception": false,
     "start_time": "2026-01-13T04:51:43.102508",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"=== МЕТРИКИ НА TEST (4+ показателя на модель) ===\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "           Model Accuracy  Kappa Sensitivity Specificity Precision    NPV\n",
      "1        XGBoost   0.8274 0.2018      0.9853      0.1562    0.8323 0.7143\n",
      "2  Random Forest   0.8214 0.1600      0.9853      0.1250    0.8272 0.6667\n",
      "3 GLM (Logistic)   0.8155 0.1468      0.9779      0.1250    0.8261 0.5714\n",
      "4      GLM + PCA   0.8214 0.1600      0.9853      0.1250    0.8272 0.6667\n",
      "5       RF + PCA   0.8095 0.1884      0.9559      0.1875    0.8333 0.5000\n",
      "6       Stacking   0.8155 0.1167      0.9853      0.0938    0.8221 0.6000\n",
      "      F1\n",
      "1 0.9024\n",
      "2 0.8993\n",
      "3 0.8956\n",
      "4 0.8993\n",
      "5 0.8904\n",
      "6 0.8963\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК 5: ПОЛНЫЕ МЕТРИКИ НА TEST ---\n",
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
    "  sens <- cm$byClass[\"Sensitivity\"]      # Recall Healthy\n",
    "  spec <- cm$byClass[\"Specificity\"]      # Recall Not_Healthy\n",
    "  ppv  <- cm$byClass[\"Pos Pred Value\"]   # Precision Healthy\n",
    "  npv  <- cm$byClass[\"Neg Pred Value\"]   # Precision Not_Healthy\n",
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
    "}\n",
    "\n",
    "metrics_table <- dplyr::bind_rows(\n",
    "  get_full_metrics(model_list$xgbTree, \"XGBoost\",        df_test),\n",
    "  get_full_metrics(model_list$rf,      \"Random Forest\",  df_test),\n",
    "  get_full_metrics(model_list$glm,     \"GLM (Logistic)\", df_test),\n",
    "  get_full_metrics(model_list$glm_pca, \"GLM + PCA\",      df_test),\n",
    "  get_full_metrics(model_list$rf_pca,  \"RF + PCA\",       df_test),\n",
    "  get_full_metrics(stack_final,        \"Stacking\",       df_test)\n",
    ")\n",
    "\n",
    "print(\"=== МЕТРИКИ НА TEST (4+ показателя на модель) ===\")\n",
    "print(metrics_table)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 8,
   "id": "349448b0",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:51:43.407956Z",
     "iopub.status.busy": "2026-01-13T04:51:43.406048Z",
     "iopub.status.idle": "2026-01-13T04:52:08.837200Z",
     "shell.execute_reply": "2026-01-13T04:52:08.834820Z"
    },
    "papermill": {
     "duration": 25.449666,
     "end_time": "2026-01-13T04:52:08.840117",
     "exception": false,
     "start_time": "2026-01-13T04:51:43.390451",
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
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "A glm ensemble of 3 base models: xgbTree, rf, glm\n",
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
      "Summary of sample sizes: 544, 544, 543, 544, 545 \n",
      "Resampling results:\n",
      "\n",
      "  Accuracy   Kappa    \n",
      "  0.8220872  0.1404495\n",
      "\n"
     ]
    }
   ],
   "source": [
    "# --- СТЭКИНГ 1: только базовые модели (без PCA) ---\n",
    "\n",
    "set.seed(123)\n",
    "ctrl_stack <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  savePredictions = \"final\",\n",
    "  classProbs = TRUE\n",
    ")\n",
    "\n",
    "model_list_base <- caretList(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  trControl = ctrl_stack,\n",
    "  tuneList = list(\n",
    "    xgbTree = caretModelSpec(method = \"xgbTree\", tuneLength = 3, verbosity = 0),\n",
    "    rf      = caretModelSpec(method = \"rf\",      tuneLength = 3),\n",
    "    glm     = caretModelSpec(method = \"glm\")\n",
    "  )\n",
    ")\n",
    "\n",
    "stack_base <- caretStack(\n",
    "  model_list_base,\n",
    "  method = \"glm\",\n",
    "  metric = \"Kappa\",\n",
    "  trControl = ctrl_stack\n",
    ")\n",
    "print(stack_base)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 9,
   "id": "f0317893",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:52:08.870835Z",
     "iopub.status.busy": "2026-01-13T04:52:08.869224Z",
     "iopub.status.idle": "2026-01-13T04:52:16.778894Z",
     "shell.execute_reply": "2026-01-13T04:52:16.776898Z"
    },
    "papermill": {
     "duration": 7.92774,
     "end_time": "2026-01-13T04:52:16.781507",
     "exception": false,
     "start_time": "2026-01-13T04:52:08.853767",
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
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stderr",
     "output_type": "stream",
     "text": [
      "Warning message in randomForest.default(x, y, mtry = param$mtry, ...):\n",
      "“invalid mtry: reset to within valid range”\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "A glm ensemble of 2 base models: glm_pca, rf_pca\n",
      "\n",
      "Ensemble results:\n",
      "Generalized Linear Model \n",
      "\n",
      "680 samples\n",
      "  2 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 543, 544, 544, 544, 545 \n",
      "Resampling results:\n",
      "\n",
      "  Accuracy   Kappa    \n",
      "  0.8176325  0.1325822\n",
      "\n"
     ]
    }
   ],
   "source": [
    "# --- СТЭКИНГ 2: только модели с PCA ---\n",
    "\n",
    "model_list_pca <- caretList(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  trControl = ctrl_stack,\n",
    "  tuneList = list(\n",
    "    glm_pca = caretModelSpec(\n",
    "      method = \"glm\",\n",
    "      preProcess = c(\"center\",\"scale\",\"pca\")\n",
    "    ),\n",
    "    rf_pca = caretModelSpec(\n",
    "      method = \"rf\",\n",
    "      preProcess = c(\"center\",\"scale\",\"pca\"),\n",
    "      tuneLength = 3\n",
    "    )\n",
    "  )\n",
    ")\n",
    "\n",
    "stack_pca <- caretStack(\n",
    "  model_list_pca,\n",
    "  method = \"glm\",\n",
    "  metric = \"Kappa\",\n",
    "  trControl = ctrl_stack\n",
    ")\n",
    "print(stack_pca)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 10,
   "id": "a990bd76",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:52:16.814427Z",
     "iopub.status.busy": "2026-01-13T04:52:16.812819Z",
     "iopub.status.idle": "2026-01-13T04:52:41.990755Z",
     "shell.execute_reply": "2026-01-13T04:52:41.988685Z"
    },
    "papermill": {
     "duration": 25.197518,
     "end_time": "2026-01-13T04:52:41.993106",
     "exception": false,
     "start_time": "2026-01-13T04:52:16.795588",
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
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "A glm ensemble of 3 base models: xgbTree, rf, glm_pca\n",
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
      "Summary of sample sizes: 543, 544, 544, 544, 545 \n",
      "Resampling results:\n",
      "\n",
      "  Accuracy   Kappa    \n",
      "  0.8220119  0.1378589\n",
      "\n"
     ]
    }
   ],
   "source": [
    "# --- СТЭКИНГ 3: гибрид лучших (rf, xgbTree, glm_pca) ---\n",
    "\n",
    "model_list_hybrid <- caretList(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  trControl = ctrl_stack,\n",
    "  tuneList = list(\n",
    "    xgbTree = caretModelSpec(method = \"xgbTree\", tuneLength = 3, verbosity = 0),\n",
    "    rf      = caretModelSpec(method = \"rf\",      tuneLength = 3),\n",
    "    glm_pca = caretModelSpec(\n",
    "      method = \"glm\",\n",
    "      preProcess = c(\"center\",\"scale\",\"pca\")\n",
    "    )\n",
    "  )\n",
    ")\n",
    "\n",
    "stack_hybrid <- caretStack(\n",
    "  model_list_hybrid,\n",
    "  method = \"glm\",\n",
    "  metric = \"Kappa\",\n",
    "  trControl = ctrl_stack\n",
    ")\n",
    "print(stack_hybrid)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 11,
   "id": "54cfdc0e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:52:42.025706Z",
     "iopub.status.busy": "2026-01-13T04:52:42.024083Z",
     "iopub.status.idle": "2026-01-13T04:52:42.298979Z",
     "shell.execute_reply": "2026-01-13T04:52:42.296789Z"
    },
    "papermill": {
     "duration": 0.293613,
     "end_time": "2026-01-13T04:52:42.301413",
     "exception": false,
     "start_time": "2026-01-13T04:52:42.007800",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "            Model Accuracy  Kappa Sensitivity Specificity Precision    NPV\n",
      "1         XGBoost   0.8274 0.2018      0.9853      0.1562    0.8323 0.7143\n",
      "2   Random Forest   0.8214 0.1600      0.9853      0.1250    0.8272 0.6667\n",
      "3  GLM (Logistic)   0.8155 0.1468      0.9779      0.1250    0.8261 0.5714\n",
      "4       GLM + PCA   0.8214 0.1600      0.9853      0.1250    0.8272 0.6667\n",
      "5        RF + PCA   0.8095 0.1884      0.9559      0.1875    0.8333 0.5000\n",
      "6   Stacking base   0.8155 0.1468      0.9779      0.1250    0.8261 0.5714\n",
      "7    Stacking PCA   0.8214 0.1881      0.9779      0.1562    0.8312 0.6250\n",
      "8 Stacking hybrid   0.8155 0.1468      0.9779      0.1250    0.8261 0.5714\n",
      "      F1\n",
      "1 0.9024\n",
      "2 0.8993\n",
      "3 0.8956\n",
      "4 0.8993\n",
      "5 0.8904\n",
      "6 0.8956\n",
      "7 0.8986\n",
      "8 0.8956\n"
     ]
    }
   ],
   "source": [
    "metrics_table <- dplyr::bind_rows(\n",
    "  get_full_metrics(model_list$xgbTree, \"XGBoost\",        df_test),\n",
    "  get_full_metrics(model_list$rf,      \"Random Forest\",  df_test),\n",
    "  get_full_metrics(model_list$glm,     \"GLM (Logistic)\", df_test),\n",
    "  get_full_metrics(model_list$glm_pca, \"GLM + PCA\",      df_test),\n",
    "  get_full_metrics(model_list$rf_pca,  \"RF + PCA\",       df_test),\n",
    "  get_full_metrics(stack_base,         \"Stacking base\",   df_test),\n",
    "  get_full_metrics(stack_pca,          \"Stacking PCA\",    df_test),\n",
    "  get_full_metrics(stack_hybrid,       \"Stacking hybrid\", df_test)\n",
    ")\n",
    "print(metrics_table)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 12,
   "id": "1c5b7790",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:52:42.334465Z",
     "iopub.status.busy": "2026-01-13T04:52:42.332757Z",
     "iopub.status.idle": "2026-01-13T04:52:54.484087Z",
     "shell.execute_reply": "2026-01-13T04:52:54.481900Z"
    },
    "papermill": {
     "duration": 12.171497,
     "end_time": "2026-01-13T04:52:54.487351",
     "exception": false,
     "start_time": "2026-01-13T04:52:42.315854",
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
      "            Model Accuracy  Kappa Sensitivity Specificity Precision   NPV    F1\n",
      "1 RF + upsampling   0.7857 0.1409      0.9265      0.1875    0.8289 0.375 0.875\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК 6: RF С UPSAMPLING (SMOTE-РАЗДЕЛ) ---\n",
    "\n",
    "ctrl_up <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  sampling = \"up\",      # вместо \"smote\" оставим upsampling (стабильнее)\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "set.seed(123)\n",
    "rf_up <- train(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  method = \"rf\",\n",
    "  trControl = ctrl_up,\n",
    "  tuneLength = 3\n",
    ")\n",
    "\n",
    "print(rf_up)   # CV-результаты\n",
    "\n",
    "# Метрики на test для RF + upsampling\n",
    "metrics_rf_up <- get_full_metrics(rf_up, \"RF + upsampling\", df_test)\n",
    "print(metrics_rf_up)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 13,
   "id": "eb6d7157",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:52:54.519721Z",
     "iopub.status.busy": "2026-01-13T04:52:54.518218Z",
     "iopub.status.idle": "2026-01-13T04:53:27.464178Z",
     "shell.execute_reply": "2026-01-13T04:53:27.462003Z"
    },
    "papermill": {
     "duration": 32.964656,
     "end_time": "2026-01-13T04:53:27.466501",
     "exception": false,
     "start_time": "2026-01-13T04:52:54.501845",
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
      "Summary of sample sizes: 543, 544, 545, 544, 544 \n",
      "Addtional sampling using up-sampling\n",
      "\n",
      "Resampling results:\n",
      "\n",
      "  Accuracy   Kappa     \n",
      "  0.6192494  0.09289755\n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                  Model Accuracy  Kappa Sensitivity Specificity Precision\n",
      "1 Stacking + upsampling    0.631 0.1191      0.6618         0.5    0.8491\n",
      "     NPV     F1\n",
      "1 0.2581 0.7438\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК 7: СТЭКИНГ МОДЕЛЕЙ С UPSAMPLING ---\n",
    "\n",
    "set.seed(123)\n",
    "ctrl_up_stack <- trainControl(\n",
    "  method = \"cv\",\n",
    "  number = 5,\n",
    "  sampling = \"up\",\n",
    "  classProbs = TRUE,\n",
    "  savePredictions = \"final\"\n",
    ")\n",
    "\n",
    "model_list_up <- caretList(\n",
    "  target ~ .,\n",
    "  data = df_train,\n",
    "  trControl = ctrl_up_stack,\n",
    "  tuneList = list(\n",
    "    rf_up      = caretModelSpec(method = \"rf\",      tuneLength = 3),\n",
    "    xgb_up     = caretModelSpec(method = \"xgbTree\", tuneLength = 3, verbosity = 0),\n",
    "    glm_up     = caretModelSpec(method = \"glm\")\n",
    "  )\n",
    ")\n",
    "\n",
    "stack_up <- caretStack(\n",
    "  model_list_up,\n",
    "  method  = \"glm\",\n",
    "  metric  = \"Kappa\",\n",
    "  trControl = ctrl_up_stack\n",
    ")\n",
    "\n",
    "print(stack_up)\n",
    "\n",
    "# Метрики на test для стэкинга с upsampling\n",
    "metrics_stack_up <- get_full_metrics(stack_up, \"Stacking + upsampling\", df_test)\n",
    "print(metrics_stack_up)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 14,
   "id": "a2d3412e",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:53:27.501219Z",
     "iopub.status.busy": "2026-01-13T04:53:27.499599Z",
     "iopub.status.idle": "2026-01-13T04:53:27.523752Z",
     "shell.execute_reply": "2026-01-13T04:53:27.521662Z"
    },
    "papermill": {
     "duration": 0.042896,
     "end_time": "2026-01-13T04:53:27.525978",
     "exception": false,
     "start_time": "2026-01-13T04:53:27.483082",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"=== ВСЕ МОДЕЛИ (включая upsampling) НА TEST ===\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "                   Model Accuracy  Kappa Sensitivity Specificity Precision\n",
      "1                XGBoost   0.8274 0.2018      0.9853      0.1562    0.8323\n",
      "2          Random Forest   0.8214 0.1600      0.9853      0.1250    0.8272\n",
      "3         GLM (Logistic)   0.8155 0.1468      0.9779      0.1250    0.8261\n",
      "4              GLM + PCA   0.8214 0.1600      0.9853      0.1250    0.8272\n",
      "5               RF + PCA   0.8095 0.1884      0.9559      0.1875    0.8333\n",
      "6          Stacking base   0.8155 0.1468      0.9779      0.1250    0.8261\n",
      "7           Stacking PCA   0.8214 0.1881      0.9779      0.1562    0.8312\n",
      "8        Stacking hybrid   0.8155 0.1468      0.9779      0.1250    0.8261\n",
      "9        RF + upsampling   0.7857 0.1409      0.9265      0.1875    0.8289\n",
      "10 Stacking + upsampling   0.6310 0.1191      0.6618      0.5000    0.8491\n",
      "      NPV     F1\n",
      "1  0.7143 0.9024\n",
      "2  0.6667 0.8993\n",
      "3  0.5714 0.8956\n",
      "4  0.6667 0.8993\n",
      "5  0.5000 0.8904\n",
      "6  0.5714 0.8956\n",
      "7  0.6250 0.8986\n",
      "8  0.5714 0.8956\n",
      "9  0.3750 0.8750\n",
      "10 0.2581 0.7438\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК 8: СВОДНАЯ ТАБЛИЦА ВСЕХ МОДЕЛЕЙ ---\n",
    "\n",
    "metrics_all <- dplyr::bind_rows(\n",
    "  metrics_table,              # та, где 8 моделей без upsampling\n",
    "  metrics_rf_up,\n",
    "  metrics_stack_up\n",
    ")\n",
    "\n",
    "print(\"=== ВСЕ МОДЕЛИ (включая upsampling) НА TEST ===\")\n",
    "print(metrics_all)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 15,
   "id": "cf4a2fa6",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:53:27.558847Z",
     "iopub.status.busy": "2026-01-13T04:53:27.557218Z",
     "iopub.status.idle": "2026-01-13T04:53:27.579731Z",
     "shell.execute_reply": "2026-01-13T04:53:27.577404Z"
    },
    "papermill": {
     "duration": 0.041782,
     "end_time": "2026-01-13T04:53:27.582195",
     "exception": false,
     "start_time": "2026-01-13T04:53:27.540413",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Оставшиеся признаки для подвыборок:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      " [1] \"age\"           \"weight\"        \"height\"        \"grades\"       \n",
      " [5] \"class_size\"    \"internet\"      \"has_phone\"     \"screen_limit\" \n",
      " [9] \"sport_freq\"    \"pe_lessons\"    \"friends_meet\"  \"hospital_3m\"  \n",
      "[13] \"minor_illness\" \"checkup\"       \"region\"        \"status\"       \n",
      "[17] \"age_sq\"        \"bmi_sq\"        \"friends_sq\"   \n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК 9: СПИСОК ПРИЗНАКОВ ПОСЛЕ ПРЕПРОЦЕССИНГА ---\n",
    "\n",
    "features_left <- setdiff(colnames(df_mod), \"target\")\n",
    "print(\"Оставшиеся признаки для подвыборок:\")\n",
    "print(features_left)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 16,
   "id": "e56c8a75",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:53:27.615309Z",
     "iopub.status.busy": "2026-01-13T04:53:27.613742Z",
     "iopub.status.idle": "2026-01-13T04:53:27.872584Z",
     "shell.execute_reply": "2026-01-13T04:53:27.870562Z"
    },
    "papermill": {
     "duration": 0.278005,
     "end_time": "2026-01-13T04:53:27.874931",
     "exception": false,
     "start_time": "2026-01-13T04:53:27.596926",
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
      "=====================================\n",
      "МОДЕЛЬ: XGBoost \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         134          27\n",
      "  Not_Healthy       2           5\n",
      "Accuracy: 0.8274 \n",
      "Kappa:    0.2018 \n",
      "Sens (Healthy):  0.9853 \n",
      "Spec (Not_Healthy): 0.1562 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: Random Forest \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         134          28\n",
      "  Not_Healthy       2           4\n",
      "Accuracy: 0.8214 \n",
      "Kappa:    0.16 \n",
      "Sens (Healthy):  0.9853 \n",
      "Spec (Not_Healthy): 0.125 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: GLM (Logistic) \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         133          28\n",
      "  Not_Healthy       3           4\n",
      "Accuracy: 0.8155 \n",
      "Kappa:    0.1468 \n",
      "Sens (Healthy):  0.9779 \n",
      "Spec (Not_Healthy): 0.125 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: GLM + PCA \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         134          28\n",
      "  Not_Healthy       2           4\n",
      "Accuracy: 0.8214 \n",
      "Kappa:    0.16 \n",
      "Sens (Healthy):  0.9853 \n",
      "Spec (Not_Healthy): 0.125 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: RF + PCA \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         130          26\n",
      "  Not_Healthy       6           6\n",
      "Accuracy: 0.8095 \n",
      "Kappa:    0.1884 \n",
      "Sens (Healthy):  0.9559 \n",
      "Spec (Not_Healthy): 0.1875 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: Stacking base \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         133          28\n",
      "  Not_Healthy       3           4\n",
      "Accuracy: 0.8155 \n",
      "Kappa:    0.1468 \n",
      "Sens (Healthy):  0.9779 \n",
      "Spec (Not_Healthy): 0.125 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: Stacking PCA \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         133          27\n",
      "  Not_Healthy       3           5\n",
      "Accuracy: 0.8214 \n",
      "Kappa:    0.1881 \n",
      "Sens (Healthy):  0.9779 \n",
      "Spec (Not_Healthy): 0.1562 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: Stacking hybrid \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         133          28\n",
      "  Not_Healthy       3           4\n",
      "Accuracy: 0.8155 \n",
      "Kappa:    0.1468 \n",
      "Sens (Healthy):  0.9779 \n",
      "Spec (Not_Healthy): 0.125 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: RF + upsampling \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy         126          26\n",
      "  Not_Healthy      10           6\n",
      "Accuracy: 0.7857 \n",
      "Kappa:    0.1409 \n",
      "Sens (Healthy):  0.9265 \n",
      "Spec (Not_Healthy): 0.1875 \n",
      "\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=====================================\n",
      "МОДЕЛЬ: Stacking + upsampling \n",
      "=====================================\n",
      "             Reference\n",
      "Prediction    Healthy Not_Healthy\n",
      "  Healthy          90          16\n",
      "  Not_Healthy      46          16\n",
      "Accuracy: 0.631 \n",
      "Kappa:    0.1191 \n",
      "Sens (Healthy):  0.6618 \n",
      "Spec (Not_Healthy): 0.5 \n",
      "\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК: МАТРИЦЫ ОШИБОК ДЛЯ ВСЕХ МОДЕЛЕЙ НА TEST ---\n",
    "\n",
    "print_confusion <- function(model, model_name, data) {\n",
    "  preds <- predict(model, newdata = data)\n",
    "  cm <- confusionMatrix(preds, data$target)\n",
    "\n",
    "  cat(\"\\n=====================================\\n\")\n",
    "  cat(paste(\"МОДЕЛЬ:\", model_name, \"\\n\"))\n",
    "  cat(\"=====================================\\n\")\n",
    "  print(cm$table)\n",
    "  cat(paste(\"Accuracy:\", round(cm$overall[\"Accuracy\"], 4), \"\\n\"))\n",
    "  cat(paste(\"Kappa:   \", round(cm$overall[\"Kappa\"], 4), \"\\n\"))\n",
    "  cat(paste(\"Sens (Healthy): \",\n",
    "            round(cm$byClass[\"Sensitivity\"], 4), \"\\n\"))\n",
    "  cat(paste(\"Spec (Not_Healthy):\",\n",
    "            round(cm$byClass[\"Specificity\"], 4), \"\\n\"))\n",
    "  cat(\"\\n\")\n",
    "}\n",
    "\n",
    "# Базовые модели\n",
    "print_confusion(model_list$xgbTree, \"XGBoost\",        df_test)\n",
    "print_confusion(model_list$rf,      \"Random Forest\",  df_test)\n",
    "print_confusion(model_list$glm,     \"GLM (Logistic)\", df_test)\n",
    "print_confusion(model_list$glm_pca, \"GLM + PCA\",      df_test)\n",
    "print_confusion(model_list$rf_pca,  \"RF + PCA\",       df_test)\n",
    "\n",
    "# Три стэкинга\n",
    "print_confusion(stack_base,   \"Stacking base\",   df_test)\n",
    "print_confusion(stack_pca,    \"Stacking PCA\",    df_test)\n",
    "print_confusion(stack_hybrid, \"Stacking hybrid\", df_test)\n",
    "\n",
    "# Если уже обучены RF + upsampling и стэкинг с upsampling:\n",
    " print_confusion(rf_up,    \"RF + upsampling\",      df_test)\n",
    " print_confusion(stack_up, \"Stacking + upsampling\", df_test)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 17,
   "id": "7739ebf0",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:53:27.909321Z",
     "iopub.status.busy": "2026-01-13T04:53:27.907768Z",
     "iopub.status.idle": "2026-01-13T04:53:32.151918Z",
     "shell.execute_reply": "2026-01-13T04:53:32.149565Z"
    },
    "papermill": {
     "duration": 4.264539,
     "end_time": "2026-01-13T04:53:32.155024",
     "exception": false,
     "start_time": "2026-01-13T04:53:27.890485",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Распределение классов по GRADES:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 71 × 4\u001b[39m\n",
      "\u001b[90m# Groups:   grades [40]\u001b[39m\n",
      "   grades target          n  prop\n",
      "    \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<fct>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m 1\u001b[39m      1 Healthy         3 1    \n",
      "\u001b[90m 2\u001b[39m      2 Healthy         3 1    \n",
      "\u001b[90m 3\u001b[39m      3 Healthy         1 0.5  \n",
      "\u001b[90m 4\u001b[39m      3 Not_Healthy     1 0.5  \n",
      "\u001b[90m 5\u001b[39m      4 Healthy         2 0.667\n",
      "\u001b[90m 6\u001b[39m      4 Not_Healthy     1 0.333\n",
      "\u001b[90m 7\u001b[39m      5 Healthy         3 1    \n",
      "\u001b[90m 8\u001b[39m      6 Healthy         3 0.6  \n",
      "\u001b[90m 9\u001b[39m      6 Not_Healthy     2 0.4  \n",
      "\u001b[90m10\u001b[39m      7 Healthy         2 0.667\n",
      "\u001b[90m# ℹ 61 more rows\u001b[39m\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Распределение классов по STATUS:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 8 × 4\u001b[39m\n",
      "\u001b[90m# Groups:   status [4]\u001b[39m\n",
      "  status target          n  prop\n",
      "   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<fct>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m      1 Healthy       269 0.787\n",
      "\u001b[90m2\u001b[39m      1 Not_Healthy    73 0.213\n",
      "\u001b[90m3\u001b[39m      2 Healthy       221 0.857\n",
      "\u001b[90m4\u001b[39m      2 Not_Healthy    37 0.143\n",
      "\u001b[90m5\u001b[39m      3 Healthy        38 0.644\n",
      "\u001b[90m6\u001b[39m      3 Not_Healthy    21 0.356\n",
      "\u001b[90m7\u001b[39m      4 Healthy       156 0.825\n",
      "\u001b[90m8\u001b[39m      4 Not_Healthy    33 0.175\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=============================\n",
      "STATUS = 3\n",
      "=============================\n",
      "Слишком мало наблюдений, пропускаем.\n",
      "\n",
      "=============================\n",
      "STATUS = 2\n",
      "=============================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Random Forest \n",
      "\n",
      "207 samples\n",
      " 16 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 165, 166, 166, 166, 165 \n",
      "Resampling results across tuning parameters:\n",
      "\n",
      "  mtry  Accuracy   Kappa    \n",
      "   2    0.8599303  0.0000000\n",
      "  16    0.8504065  0.0270499\n",
      "\n",
      "Accuracy was used to select the optimal model using the largest value.\n",
      "The final value used for the model was mtry = 2.\n",
      "          Model Accuracy Kappa Sensitivity Specificity Precision NPV     F1\n",
      "1 RF (status=2)   0.8431     0           1           0    0.8431 NaN 0.9149\n",
      "\n",
      "=============================\n",
      "STATUS = 1\n",
      "=============================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Random Forest \n",
      "\n",
      "274 samples\n",
      " 16 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 219, 220, 219, 219, 219 \n",
      "Resampling results across tuning parameters:\n",
      "\n",
      "  mtry  Accuracy   Kappa     \n",
      "   2    0.8065320  0.06516251\n",
      "  16    0.7917845  0.07737764\n",
      "\n",
      "Accuracy was used to select the optimal model using the largest value.\n",
      "The final value used for the model was mtry = 2.\n",
      "          Model Accuracy  Kappa Sensitivity Specificity Precision NPV     F1\n",
      "1 RF (status=1)   0.7353 0.0741           1      0.0526    0.7313   1 0.8448\n",
      "\n",
      "=============================\n",
      "STATUS = 4\n",
      "=============================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Random Forest \n",
      "\n",
      "149 samples\n",
      " 16 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 119, 120, 118, 120, 119 \n",
      "Resampling results across tuning parameters:\n",
      "\n",
      "  mtry  Accuracy   Kappa      \n",
      "   2    0.7851984  0.028636260\n",
      "  16    0.7511754  0.002113056\n",
      "\n",
      "Accuracy was used to select the optimal model using the largest value.\n",
      "The final value used for the model was mtry = 2.\n",
      "          Model Accuracy   Kappa Sensitivity Specificity Precision NPV     F1\n",
      "1 RF (status=4)     0.95 -0.0256      0.9744           0    0.9744   0 0.9744\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК: ПОДВЫБОРКИ ПО GRADES И STATUS ---\n",
    "\n",
    "library(dplyr)\n",
    "\n",
    "# 1. Описательная статистика: распределение классов по grades и status\n",
    "\n",
    "table_grades <- df_mod %>%\n",
    "  group_by(grades, target) %>%\n",
    "  summarise(n = n(), .groups = \"drop\") %>%\n",
    "  group_by(grades) %>%\n",
    "  mutate(prop = round(n / sum(n), 3))\n",
    "\n",
    "print(\"Распределение классов по GRADES:\")\n",
    "print(table_grades)\n",
    "\n",
    "table_status <- df_mod %>%\n",
    "  group_by(status, target) %>%\n",
    "  summarise(n = n(), .groups = \"drop\") %>%\n",
    "  group_by(status) %>%\n",
    "  mutate(prop = round(n / sum(n), 3))\n",
    "\n",
    "print(\"Распределение классов по STATUS:\")\n",
    "print(table_status)\n",
    "\n",
    "# 2. Функция для обучения RF и вывода метрик по подвыборке\n",
    "\n",
    "run_by_group <- function(data_train, data_test, group_var, value) {\n",
    "  cat(\"\\n=============================\\n\")\n",
    "  cat(paste0(toupper(group_var), \" = \", value, \"\\n\"))\n",
    "  cat(\"=============================\\n\")\n",
    "\n",
    "  sub_train <- data_train %>% filter(.data[[group_var]] == value)\n",
    "  sub_test  <- data_test  %>% filter(.data[[group_var]] == value)\n",
    "\n",
    "  if (nrow(sub_train) < 50 | nrow(sub_test) < 30) {\n",
    "    cat(\"Слишком мало наблюдений, пропускаем.\\n\")\n",
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
    "    data = sub_train,\n",
    "    method = \"rf\",\n",
    "    trControl = ctrl_sub,\n",
    "    tuneLength = 2\n",
    "  )\n",
    "\n",
    "  print(model_sub_rf)\n",
    "  print(get_full_metrics(model_sub_rf,\n",
    "                         paste(\"RF (\", group_var, \"=\", value, \")\", sep = \"\"),\n",
    "                         sub_test))\n",
    "}\n",
    "\n",
    "# 3. Запуск по всем значениям grades и status\n",
    "\n",
    "unique_grades <- sort(unique(df_mod$grades))\n",
    "unique_status <- unique(df_mod$status)\n",
    "\n",
    "\n",
    "# По status\n",
    "by_status_results <- lapply(unique_status, function(s)\n",
    "  run_by_group(df_train, df_test, \"status\", s))\n"
   ]
  },
  {
   "cell_type": "markdown",
   "id": "6a06f04e",
   "metadata": {
    "papermill": {
     "duration": 0.01574,
     "end_time": "2026-01-13T04:53:32.186470",
     "exception": false,
     "start_time": "2026-01-13T04:53:32.170730",
     "status": "completed"
    },
    "tags": []
   },
   "source": [
    "первая группа - крупный город\n",
    "вторая - прочие города \n",
    "третья - пгт\n",
    "четверта - поселки"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 18,
   "id": "a60809e9",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:53:32.221714Z",
     "iopub.status.busy": "2026-01-13T04:53:32.220100Z",
     "iopub.status.idle": "2026-01-13T04:53:37.055456Z",
     "shell.execute_reply": "2026-01-13T04:53:37.053148Z"
    },
    "papermill": {
     "duration": 4.856349,
     "end_time": "2026-01-13T04:53:37.058639",
     "exception": false,
     "start_time": "2026-01-13T04:53:32.202290",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Распределение классов по возрастным группам:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 4 × 4\u001b[39m\n",
      "\u001b[90m# Groups:   age_group [2]\u001b[39m\n",
      "  age_group target          n  prop\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m     \u001b[3m\u001b[90m<fct>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m 13-17     Healthy       178 0.757\n",
      "\u001b[90m2\u001b[39m 13-17     Not_Healthy    57 0.243\n",
      "\u001b[90m3\u001b[39m 7-12      Healthy       506 0.825\n",
      "\u001b[90m4\u001b[39m 7-12      Not_Healthy   107 0.175\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "=============================\n",
      "AGE_GROUP = 7-12\n",
      "=============================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Random Forest \n",
      "\n",
      "495 samples\n",
      " 16 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 396, 397, 395, 397, 395 \n",
      "Resampling results across tuning parameters:\n",
      "\n",
      "  mtry  Accuracy   Kappa     \n",
      "   2    0.8222486  0.00000000\n",
      "  16    0.8141051  0.07122764\n",
      "\n",
      "Accuracy was used to select the optimal model using the largest value.\n",
      "The final value used for the model was mtry = 2.\n",
      "                   Model Accuracy  Kappa Sensitivity Specificity Precision NPV\n",
      "1 RF (age_group = 7-12 )   0.8475 0.0853           1      0.0526    0.8462   1\n",
      "      F1\n",
      "1 0.9167\n",
      "\n",
      "=============================\n",
      "AGE_GROUP = 13-17\n",
      "=============================\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "Random Forest \n",
      "\n",
      "185 samples\n",
      " 16 predictor\n",
      "  2 classes: 'Healthy', 'Not_Healthy' \n",
      "\n",
      "No pre-processing\n",
      "Resampling: Cross-Validated (5 fold) \n",
      "Summary of sample sizes: 148, 148, 147, 148, 149 \n",
      "Resampling results across tuning parameters:\n",
      "\n",
      "  mtry  Accuracy   Kappa    \n",
      "   2    0.7891339  0.2305485\n",
      "  16    0.7786155  0.2579356\n",
      "\n",
      "Accuracy was used to select the optimal model using the largest value.\n",
      "The final value used for the model was mtry = 2.\n",
      "                    Model Accuracy  Kappa Sensitivity Specificity Precision NPV\n",
      "1 RF (age_group = 13-17 )     0.76 0.2208      0.9459      0.2308    0.7778 0.6\n",
      "      F1\n",
      "1 0.8537\n"
     ]
    }
   ],
   "source": [
    "# --- БЛОК: ПОДВЫБОРКИ ПО ВОЗРАСТУ ---\n",
    "\n",
    "# Добавим возрастную группу в df_train и df_test\n",
    "df_train <- df_train %>%\n",
    "  mutate(age_group = ifelse(age <= 12, \"7-12\", \"13-17\"))\n",
    "df_test  <- df_test %>%\n",
    "  mutate(age_group = ifelse(age <= 12, \"7-12\", \"13-17\"))\n",
    "\n",
    "# Описательное распределение классов по возрастным группам\n",
    "table_age <- df_mod %>%\n",
    "  mutate(age_group = ifelse(age <= 12, \"7-12\", \"13-17\")) %>%\n",
    "  group_by(age_group, target) %>%\n",
    "  summarise(n = n(), .groups = \"drop\") %>%\n",
    "  group_by(age_group) %>%\n",
    "  mutate(prop = round(n / sum(n), 3))\n",
    "\n",
    "print(\"Распределение классов по возрастным группам:\")\n",
    "print(table_age)\n",
    "\n",
    "# Функция та же, что была выше, только group_var = \"age_group\"\n",
    "run_by_age <- function(value) {\n",
    "  cat(\"\\n=============================\\n\")\n",
    "  cat(paste0(\"AGE_GROUP = \", value, \"\\n\"))\n",
    "  cat(\"=============================\\n\")\n",
    "\n",
    "  sub_train <- df_train %>% filter(age_group == value)\n",
    "  sub_test  <- df_test  %>% filter(age_group == value)\n",
    "\n",
    "  if (nrow(sub_train) < 50 | nrow(sub_test) < 30) {\n",
    "    cat(\"Слишком мало наблюдений, пропускаем.\\n\")\n",
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
    "    data = sub_train %>% select(-age_group),\n",
    "    method = \"rf\",\n",
    "    trControl = ctrl_sub,\n",
    "    tuneLength = 2\n",
    "  )\n",
    "\n",
    "  print(model_sub_rf)\n",
    "  print(get_full_metrics(\n",
    "    model_sub_rf,\n",
    "    paste(\"RF (age_group =\", value, \")\"),\n",
    "    sub_test %>% select(-age_group)\n",
    "  ))\n",
    "}\n",
    "\n",
    "age_groups <- c(\"7-12\", \"13-17\")\n",
    "age_results <- lapply(age_groups, run_by_age)\n"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 19,
   "id": "051bf8b8",
   "metadata": {
    "execution": {
     "iopub.execute_input": "2026-01-13T04:53:37.094079Z",
     "iopub.status.busy": "2026-01-13T04:53:37.092550Z",
     "iopub.status.idle": "2026-01-13T04:53:37.243246Z",
     "shell.execute_reply": "2026-01-13T04:53:37.241134Z"
    },
    "papermill": {
     "duration": 0.171352,
     "end_time": "2026-01-13T04:53:37.246002",
     "exception": false,
     "start_time": "2026-01-13T04:53:37.074650",
     "status": "completed"
    },
    "tags": []
   },
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Описательная статистика числовых переменных:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 1 × 35\u001b[39m\n",
      "  age_mean age_sd age_min age_med age_max weight_mean weight_sd weight_min\n",
      "     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m  \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m     \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m      \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m     10.8   1.91       7      11    13.5        38.8      11.2         15\n",
      "\u001b[90m# ℹ 27 more variables: weight_med <dbl>, weight_max <dbl>, height_mean <dbl>,\u001b[39m\n",
      "\u001b[90m#   height_sd <dbl>, height_min <dbl>, height_med <dbl>, height_max <dbl>,\u001b[39m\n",
      "\u001b[90m#   grades_mean <dbl>, grades_sd <dbl>, grades_min <dbl>, grades_med <dbl>,\u001b[39m\n",
      "\u001b[90m#   grades_max <dbl>, class_size_mean <dbl>, class_size_sd <dbl>,\u001b[39m\n",
      "\u001b[90m#   class_size_min <dbl>, class_size_med <dbl>, class_size_max <dbl>,\u001b[39m\n",
      "\u001b[90m#   sport_freq_mean <dbl>, sport_freq_sd <dbl>, sport_freq_min <dbl>,\u001b[39m\n",
      "\u001b[90m#   sport_freq_med <dbl>, sport_freq_max <dbl>, friends_meet_mean <dbl>, …\u001b[39m\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Распределение целевой переменной (здоровье):\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\n",
      "    Healthy Not_Healthy \n",
      "  0.8066038   0.1933962 \n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Распределение по STATUS:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 8 × 4\u001b[39m\n",
      "\u001b[90m# Groups:   status [4]\u001b[39m\n",
      "  status target          n  prop\n",
      "   \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<fct>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m      1 Healthy       269 0.787\n",
      "\u001b[90m2\u001b[39m      1 Not_Healthy    73 0.213\n",
      "\u001b[90m3\u001b[39m      2 Healthy       221 0.857\n",
      "\u001b[90m4\u001b[39m      2 Not_Healthy    37 0.143\n",
      "\u001b[90m5\u001b[39m      3 Healthy        38 0.644\n",
      "\u001b[90m6\u001b[39m      3 Not_Healthy    21 0.356\n",
      "\u001b[90m7\u001b[39m      4 Healthy       156 0.825\n",
      "\u001b[90m8\u001b[39m      4 Not_Healthy    33 0.175\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "[1] \"Распределение по возрастным группам:\"\n"
     ]
    },
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "\u001b[90m# A tibble: 4 × 4\u001b[39m\n",
      "\u001b[90m# Groups:   age_group [2]\u001b[39m\n",
      "  age_group target          n  prop\n",
      "  \u001b[3m\u001b[90m<chr>\u001b[39m\u001b[23m     \u001b[3m\u001b[90m<fct>\u001b[39m\u001b[23m       \u001b[3m\u001b[90m<int>\u001b[39m\u001b[23m \u001b[3m\u001b[90m<dbl>\u001b[39m\u001b[23m\n",
      "\u001b[90m1\u001b[39m 13-17     Healthy       178 0.757\n",
      "\u001b[90m2\u001b[39m 13-17     Not_Healthy    57 0.243\n",
      "\u001b[90m3\u001b[39m 7-12      Healthy       506 0.825\n",
      "\u001b[90m4\u001b[39m 7-12      Not_Healthy   107 0.175\n"
     ]
    }
   ],
   "source": [
    "# --- ОПИСАНИЕ РАСПРЕДЕЛЕНИЙ (ДЛЯ П.2.1) ---\n",
    "\n",
    "# 1. Числовые переменные: среднее, sd, min, max, медиана\n",
    "num_vars <- c(\"age\", \"weight\", \"height\", \"grades\",\n",
    "              \"class_size\", \"sport_freq\", \"friends_meet\")\n",
    "\n",
    "desc_num <- df_mod %>%\n",
    "  select(all_of(num_vars)) %>%\n",
    "  summarise(across(\n",
    "    everything(),\n",
    "    list(\n",
    "      mean = ~round(mean(., na.rm = TRUE), 2),\n",
    "      sd   = ~round(sd(.,   na.rm = TRUE), 2),\n",
    "      min  = ~min(., na.rm = TRUE),\n",
    "      med  = ~median(., na.rm = TRUE),\n",
    "      max  = ~max(., na.rm = TRUE)\n",
    "    ),\n",
    "    .names = \"{.col}_{.fn}\"\n",
    "  ))\n",
    "\n",
    "print(\"Описательная статистика числовых переменных:\")\n",
    "print(desc_num)\n",
    "\n",
    "# 2. Распределение целевой переменной\n",
    "print(\"Распределение целевой переменной (здоровье):\")\n",
    "print(prop.table(table(df_mod$target)))\n",
    "\n",
    "# 3. Распределение по status и возрастным группам (мы уже считали, можно переиспользовать)\n",
    "print(\"Распределение по STATUS:\")\n",
    "print(table_status)\n",
    "\n",
    "print(\"Распределение по возрастным группам:\")\n",
    "print(table_age)\n"
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
   "duration": 154.224928,
   "end_time": "2026-01-13T04:53:37.384828",
   "environment_variables": {},
   "exception": null,
   "input_path": "__notebook__.ipynb",
   "output_path": "__notebook__.ipynb",
   "parameters": {},
   "start_time": "2026-01-13T04:51:03.159900",
   "version": "2.6.0"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
