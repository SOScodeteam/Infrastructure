members = ["Inix3K"]

teams = {
  "Ops" = []
  "20B" = ["Inix3K"]
  "20C" = []
  "SOS_APP_TEAM" = []
  "AR_APP_TEAM" = []
}

repos = {
  "Infrastructure" = ["Ops"]
  "SOS_App"        = ["SOS_APP_TEAM","20B"]
  "AR_App"         = ["AR_APP_TEAM"]
}
