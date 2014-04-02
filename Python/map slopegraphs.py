# -*- coding: utf-8 -*-
# At least on OSX, this needs to run in an iPython console
from plotSlope import slope
import pandas as pd
import os

renew_highlights  = {"ReNEW: RCAA":'blue',
          'ReNEW: DTA':'blue',
          'ReNEW: STA':'blue',
          'ReNEW: SCH':'blue',
}

all_map_data = pd.read_csv(os.path.join('./../Data','all map percs.csv'),
                          na_values=''
)
    
def make_and_save_slope_plot_gs(df):
    grade = df.iloc[0]['grade']
    subject = df.iloc[0]['subject']
    d = df[["school", "boy", "moy"]]
    d = d.set_index("school")
    f = slope(d,
        # Need to manually adjust width and height depending on data
        height=16,width=10,font_size=8,
        title="MAP Scores for {0}, Grade {1}".format(subject, grade),
        font_family='GillSans', color=renew_highlights
    )
    f.savefig('./../Output/scaled slopegraph map {0} grade {1}.png'.format(subject, grade))

all_map_data.groupby(["grade", "subject"]).apply(make_and_save_slope_plot_gs)
