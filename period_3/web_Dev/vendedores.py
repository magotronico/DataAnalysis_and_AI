# ─────────────────────────────────────────────────────────────────────────────                                                                       
# Script Name : vendedores.py                                           
# Created On  : November 8, 2024          
# Last Update : November 8, 2024                                    
# Version     : 1.0.0                                          
# Description : Practice streamlit app to display vendor sales data.
# ─────────────────────────────────────────────────────────────────────────────

import streamlit as st
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

def load_data():
    """Loads CSV data uploaded by the user."""
    file = st.file_uploader('Cargar archivo CSV', type='csv')
    if file is not None:
        data = pd.read_csv(file)
        return data

def display_region_filter(data):
    """Displays and filters data by the selected region."""
    st.header('En esta sección se muestran los vendedores filtrados por región.')
    regiones = np.append(['Todas las regiones'], data['REGION'].unique())
    region_seleccionada = st.selectbox('Selecciona una región', regiones)
    
    if region_seleccionada == 'Todas las regiones':
        datos_filtrados = data
    else:
        datos_filtrados = data[data['REGION'] == region_seleccionada]

    st.subheader(f'Datos de los vendedores en la región: {region_seleccionada}')
    st.write(datos_filtrados)
    return datos_filtrados

def display_graphs(datos_filtrados):
    """Displays bar plots for 'UNIDADES VENDIDAS', 'VENTAS TOTALES', and 'PORCENTAJE DE VENTAS'."""
    st.header('Gráficas')

    st.subheader('Unidades Vendidas')
    fig, ax = plt.subplots(figsize=(20, 8))
    sns.barplot(x='NOMBRE', y='UNIDADES VENDIDAS', data=datos_filtrados, ax=ax)
    plt.xticks(rotation=45)
    st.pyplot(fig)

    st.subheader('Ventas Totales')
    fig, ax = plt.subplots(figsize=(20, 8))
    sns.barplot(x='NOMBRE', y='VENTAS TOTALES', data=datos_filtrados, ax=ax)
    plt.xticks(rotation=45)
    st.pyplot(fig)

    st.subheader('Porcentajes de Ventas')
    fig, ax = plt.subplots(figsize=(20, 8))
    sns.barplot(x='NOMBRE', y='PORCENTAJE DE VENTAS', data=datos_filtrados, ax=ax)
    plt.xticks(rotation=45)
    st.pyplot(fig)

def display_vendor_info(data):
    """Displays information about a specific vendor."""
    st.header('Información de un vendedor específico')
    vendedor = st.text_input('Ingresa el nombre del vendedor')
    if vendedor:
        datos_vendedor = data[data['NOMBRE'].str.lower() == vendedor.lower()]
        st.write(datos_vendedor)

def app():
    """Main function to run the Streamlit app."""
    st.title('Ventas de Vendedores')
    st.subheader('Cargar archivo con datos')
    data = load_data()

    if data is not None:
        datos_filtrados = display_region_filter(data)
        display_graphs(datos_filtrados)
        display_vendor_info(data)

if __name__ == '__main__':
    app()
