import streamlit as st
from fetch_data import fetch_data

def enroll_student_in_section_ui():

    st.header("Enroll Student in Section")

    registration_id = st.number_input("Registration ID", value=st.session_state.registration_id, disabled=True)
    section_id = st.number_input("Section ID", min_value=1, step=1)

    if st.button("Enroll Student in Section"):
        input_params = {}
        if registration_id:
            input_params["registration_id"] = registration_id
        if section_id:
            input_params["section_id"] = section_id

        df = fetch_data("enroll_student_in_section/", input_params)

        if df is not None and not df.empty:
            st.success("Student enrolled in section successfully.")
            st.dataframe(df, use_container_width=True, hide_index=True)
        else:
            st.info("Failed to enroll student in section.")