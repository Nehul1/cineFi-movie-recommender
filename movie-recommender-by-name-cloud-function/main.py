import googleapiclient.discovery
import google.auth 
from google.cloud import firestore
import pickle
from datetime import date
from google.cloud import storage
from sklearn.neighbors import NearestNeighbors
import pandas as pd

def get_similar_by_corr(corr_helper_df, ratings_df, movie_name):
    matrix=corr_helper_df.pivot_table(index='userId',values='rating',columns='title')
 
    sample_movie=matrix[movie_name]
    similar_movies= matrix.corrwith(sample_movie)
 
    result_df=pd.DataFrame(similar_movies,columns=['Correlation'])
    result_df.dropna(inplace=True)
    result_df = result_df.reset_index(drop=False).rename(columns={'index': 'title'})
 
    print(result_df.head())
    result_df= result_df.merge(ratings_df,on="title")
 
    condition = result_df['title'] == movie_name
    result_df.loc[condition, 'count of ratings'] = 150
    return result_df[result_df['count of ratings']>100].sort_values(by='Correlation',ascending=False).head(100)


def get_similar_movies(movie_name, movies_df, res_df):
    res_df= res_df.merge(movies_df,on="title")
    genres_df = res_df['genres'].str.get_dummies('|')

    # Rename columns
    genres_df.columns = [col.lower() for col in genres_df.columns]

    # Concatenate genres_df with original dataframe
    res_df = pd.concat([res_df, genres_df], axis=1)

    # Drop original genres column
    res_df = res_df.drop('genres', axis=1)
    res_df.drop("movieId",axis=1,inplace=True)

    # Building the model
    if res_df.shape[0]>10:
        model_knn= NearestNeighbors(metric= 'cosine',n_neighbors=6, algorithm='brute')
    else:
        model_knn= NearestNeighbors(metric= 'cosine',n_neighbors=res_df.shape[0], algorithm='brute')
    
    filtered_df = res_df[res_df['title'] == movie_name]
    sample_df=res_df.drop(['count of ratings','year_of_release'],axis=1)
    
    filtered_df = sample_df[sample_df['title'] == movie_name]
    sample_df=sample_df.drop('title',axis=1)
    
    filtered_df=filtered_df.drop('title',axis=1)
    
    # Fitting the model
    model_knn.fit(sample_df)
    
    distance,indexes= model_knn.kneighbors(filtered_df)
    
    return  res_df, indexes

def generate_recommendations_with_title(event, context):
    db = firestore.Client(project="movie-recommendation-sys-136fc")
    print(event)
    print(context.resource)
    print(type(context.resource))

    path_parts = context.resource.split('/documents/')[1].split('/')
    collection_path = path_parts[0]
    print(collection_path)

    collections = db.collection(collection_path).document(u'movie_input').get()
    print(collections.to_dict())

    data = collections.to_dict()
    
    movies_df = pd.read_csv('gs://movie_rec_dataset/corr_movies.csv')
    ratings_df = pd.read_csv('gs://movie_rec_dataset/corr_ratings.csv')
    corr_helper_df = pd.read_csv('gs://movie_rec_dataset/corr_helper_data.csv')

    res_df=get_similar_by_corr(corr_helper_df, ratings_df, data["title"])
    result,indexes= get_similar_movies(data["title"], movies_df, res_df)
    print('Output: {}'.format(result.iloc[indexes[0]]["title"].tolist()))

    doc_ref = db.collection(u'recommended_movies').document(u'result1')
    doc_ref.set({
        u'titles':firestore.ArrayUnion(result.iloc[indexes[0]]["title"].tolist()),
    })