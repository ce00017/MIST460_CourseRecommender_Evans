from get_db_connection import get_db_connection
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
import json



def create_embeddings_for_chunks():

    conn = get_db_connection()
    cursor = conn.cursor(as_dict=True)

    #initialize openAI model and text splitter
    embedding_model = OpenAIEmbeddings(model="text-embedding-3-small")
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=250, chunk_overlap=20)


    # Fetch all chunks
    cursor.execute("EXEC procGetAllCourses")
    all_courses = cursor.fetchall()

    for each_course in all_courses:
        course_id = each_course['CourseID']
        course_description = each_course['CourseDescription']

        # Generate embedding for the chunk
        chunks_for_each_course_description = text_splitter.split_text(course_description)
        embeddings_for_chunks = embedding_model.embed_documents(chunks_for_each_course_description)

        # insert the chunk with the generated embedding
        
        for course_chunk, chunk_embedding in zip(chunks_for_each_course_description, embeddings_for_chunks):
            cursor.execute("EXEC procInsertChunk %s, %s, %s", (course_chunk, json.dumps(chunk_embedding), course_id))
            

        conn.commit()
        print(f"Embeddings created for course ID: {course_id}")

    cursor.close()
    conn.close()
    print("All embeddings created and stored in the database.")

if __name__ == "__main__":
    create_embeddings_for_chunks()