import streamlit as st
from fetch_data import fetch_data

def validate_user_ui():

    st.header("Validate User")

    email = st.text_input("Username/Email")
    password = st.text_input("Password", type="password")

    if st.button("Validate User"):
        input_params = {}
        if not email.strip():
            st.error("Username/Email is required.")
        else:
            input_params["email"] = email.strip()
        if not password.strip():
            st.error("Password is required.")
        else:
            input_params["password"] = password.strip()


        df = fetch_data("validate_user/", input_params)

        if df is not None and not df.empty:
            st.success("User validated successfully.")
            output_string = "AppUserID: " + str(df["AppUserID"].values[0]) + ", Fullname: " + df["Fullname"].values[0]
            st.write(output_string)
            st.session_state.app_user_id = df["AppUserID"].values[0]
        
        else:
            st.info("Invalid user credentials.")

