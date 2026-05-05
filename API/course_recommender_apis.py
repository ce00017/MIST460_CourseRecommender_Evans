from fastapi import FastAPI
from fastapi.responses import JSONResponse

from get_course_sections_for_specified_course import get_course_sections_for_specified_course
from get_course_prerequisites import get_course_prerequisites
from validate_user import validate_user
from has_student_met_prerequisites_for_course import has_student_met_prerequisites_for_course
from register_student import register_student
from enroll_student_in_section import enroll_student_in_section
from get_course_recommendations_for_selected_job import get_course_recommendations_for_selected_job

app = FastAPI()

@app.get("/get_course_sections_for_specified_course")
def get_course_sections_for_specified_course_endpoint(subject_code: str | None = None, course_number: str | None = None):
    return get_course_sections_for_specified_course(subject_code, course_number)

@app.get("/get_course_prerequisites")
def get_course_prerequisites_endpoint(subject_code: str | None = None, course_number: str | None = None):
    return get_course_prerequisites(subject_code, course_number)

@app.get("/validate_user")
def validate_user_endpoint(email: str, password: str):
    return validate_user(email, password)

@app.get("/has_student_met_prerequisites_for_course")
def has_student_met_prerequisites_for_course_endpoint(student_id: int | None = None, subject_code: str | None = None, course_number: str | None = None):
    return has_student_met_prerequisites_for_course(student_id, subject_code, course_number)

@app.get("/register_student")
def register_student_endpoint(student_id: int, registration_semester: str, registration_year: int):
    return register_student(student_id, registration_semester, registration_year)

@app.get("/enroll_student_in_section")
def enroll_student_in_section_endpoint(registration_id: str, section_id: str):
    return enroll_student_in_section(registration_id, section_id)

@app.get("/get_course_recommendations_for_selected_job")
def get_course_recommendations_for_selected_job_endpoint(job_description: str):
    from get_course_recommendations_for_selected_job import get_course_recommendations_for_selected_job
    return get_course_recommendations_for_selected_job(job_description)