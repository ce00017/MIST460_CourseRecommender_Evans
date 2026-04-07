import streamlit as st
from get_course_sections_for_specified_course_ui import get_course_sections_for_specified_course_ui
from get_course_prerequisites_ui import get_course_prerequisites_ui
from validate_user_ui import validate_user_ui
from has_student_met_prerequisites_for_course_ui import has_student_met_prerequisites_for_course_ui
from register_student_ui import register_student_ui
from enroll_student_in_section_ui import enroll_student_in_section_ui

with st.sidebar:
    st.title("Course Recommender System")
    
    #dropdown for course recommendation functionality
    api_end_point = st.selectbox(
        "Select a course recommendation functionality",
        (
            "Get Course Sections for Specified Course",
            "Get Course Prerequisites",
            "Validate User",
            "Has Student Met Prerequisites for Course",
            "Register Student",
            "Enroll Student in Section"
        )
    )

if api_end_point == "Get Course Sections for Specified Course":
    get_course_sections_for_specified_course_ui()

elif api_end_point == "Get Course Prerequisites":
    get_course_prerequisites_ui()

elif api_end_point == "Validate User":
    validate_user_ui()

elif api_end_point == "Has Student Met Prerequisites for Course":
    has_student_met_prerequisites_for_course_ui()

elif api_end_point == "Register Student":
    register_student_ui()

elif api_end_point == "Enroll Student in Section":
    enroll_student_in_section_ui()  