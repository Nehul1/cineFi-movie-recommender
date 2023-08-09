import googleapiclient.discovery
import google.auth 
from google.cloud import firestore
import pickle
from datetime import date
from google.cloud import storage
from sklearn.neighbors import NearestNeighbors
import pandas as pd
import io

def get_predictions(recommender_model,df,user_id):
    itemIds = df['movieId'].unique()

    # get the list of itemIds that user 1 has already rated
    rated_itemIds = df.loc[df['userId']==user_id, 'movieId'].values

    # get the list of itemIds that user 1 has not rated
    unrated_itemIds = list(set(itemIds) - set(rated_itemIds))

    # create a list of tuples with (userId, itemId) for unrated items
    complete_list = [(user_id, itemId) for itemId in unrated_itemIds]

    # make predictions for the testset
    predictions=[]
    for model_input in complete_list:
        pred=recommender_model.predict(model_input[0],model_input[1])
        predictions.append([pred.iid,pred.est])
    predictions = sorted(predictions, key=lambda x: x[1], reverse=True)
    
    return predictions

def generate_recommendations(event, context):
    db = firestore.Client(project="movie-recommendation-sys-136fc")

    print(event)
    print(context.resource)
    print(type(context.resource))

    path_parts = context.resource.split('/documents/')[1].split('/')
    collection_path = path_parts[0]
    print(collection_path)

    collections = db.collection(collection_path).document(u'input').get()
    print(collections.to_dict())

    data = collections.to_dict()
    
    storage_client = storage.Client()

    bucket = storage_client.get_bucket('movie-recommender-8')
    blob = bucket.blob('model.pkl')
    fileName = blob.download_as_string()
    
    recommender_model = pickle.loads(fileName)
    
    # result=model_trained.predict(data["userID"],data["movieID"])

    # bucket = storage_client.get_bucket('movie_rec_dataset')
    # blob = bucket.blob("helper_data.csv")
    # data = blob.download_as_bytes()
    # df = pd.read_csv(io.BytesIO(data))

    # blob = bucket.blob("complete_data.csv")
    # data = blob.download_as_bytes()
    # complete_df=pd.read_csv(io.BytesIO(data))

    df = pd.read_csv('gs://movie_rec_dataset/helper_data.csv')
    complete_df = pd.read_csv('gs://movie_rec_dataset/complete_data.csv')

    predictions=get_predictions(recommender_model,complete_df,int(data["userID"]))

    n=len(predictions)//5

    predictions=predictions[:n]

    matching_rows = [sublist[0] for sublist in predictions ]

    result_df = df.loc[df['movieId'].isin(matching_rows)]

    list_geners=data["genres"]

    cols=result_df.columns.tolist()
    
    cols.pop(0)
    cols.pop(0)
    
    df_knn = pd.DataFrame(columns=cols)
    
    dict_gen={}
    for col in df_knn.columns:
        if col in list_geners:
            dict_gen[col]=1
        else:
            dict_gen[col]=0
    
    df_knn = df_knn.append(dict_gen, ignore_index=True)

    # Building the model
    model_knn= NearestNeighbors(metric= 'cosine',n_neighbors=10, algorithm='brute')
    sample_df=result_df.drop(['movieId','title'],axis=1)

    # Fitting the model
    model_knn.fit(sample_df)
    distance,indexes= model_knn.kneighbors(df_knn)

    print('Output: {}'.format(result_df.iloc[indexes[0]]["title"].tolist()))

    doc_ref = db.collection(u'recommended_movies').document(u'result')
    doc_ref.set({
        u'titles':firestore.ArrayUnion(result_df.iloc[indexes[0]]["title"].tolist()),
    })