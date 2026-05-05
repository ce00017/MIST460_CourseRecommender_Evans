from datetime import datetime


def find_current_semester() -> str:
    month = datetime.now().month
    if month <= 5:
        return "Spring"
    if month <= 8:
        return "Summer"
    return "Fall"
