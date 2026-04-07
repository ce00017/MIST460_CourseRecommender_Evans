import streamlit as st
from fetch_data import fetch_data

def register_student_ui():

    st.header("Register Student")

    student_id = st.number_input("Student ID", value=st.session_state.app_user_id, disabled=True)
    registration_semester = st.selectbox("Registration Semester", ["Spring", "Summer", "Fall"])
    registration_year = st.number_input("Registration Year", min_value=2000, step=1)

    if st.button("Register Student"):
        input_params = {}
        if student_id:
            input_params["student_id"] = student_id
        if registration_semester:
            input_params["registration_semester"] = registration_semester
        if registration_year:
            input_params["registration_year"] = registration_year

        df = fetch_data("register_student/", input_params)

        if df is not None and not df.empty:
            st.success("User registered successfully.")
            output_string = "Registration ID: " + str(df["Registration ID"].values[0]) + ", Registration Date: " + str(df["RegistrationDate"].values[0])
            st.write(output_string)
            st.session_state.registration_id = df["Registration ID"].values[0]
        else:
            st.info("Failed to register student.")