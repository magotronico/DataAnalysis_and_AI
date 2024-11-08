import pandas as pd

def xlsx2csv(xlsx_file, csv_file):
    data_xls = pd.read_excel(xlsx_file)
    data_xls.to_csv(csv_file, encoding='utf-8', index=False)


if __name__ == '__main__':
    xlsx2csv(r'C:\Users\dilan\Documents\Github\DataAnalysis_and_AI\period_3\web_Dev\vendedores.xlsx', 'vendedores.csv')
    print('¡Listo!')