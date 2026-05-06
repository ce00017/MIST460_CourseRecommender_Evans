import streamlit as st
from fetch_data import fetch_data, fetch_text

def get_job_title(record):
    return record['JobTitle']

def get_course_recommendations_for_selected_job_ui():
    st.title("Course Recommendations for Selected Job")

    df = fetch_data("get_all_jobs/", {})

    selected_job = st.selectbox("Select a job to see course recommendations:", options=df.to_dict(orient="records"), format_func=get_job_title)

    if st.button("Get Course Recommendations"):
        params = {"job_description": selected_job['JobDescription']}
        response = fetch_text("get_course_recommendations_for_selected_job/", params)
        if response:
            st.subheader("Recommended Courses:")
            st.markdown(response, unsafe_allow_html=True)
        else:
            st.info("No course recommendations found for the selected job. Please try a different job or check back later.")