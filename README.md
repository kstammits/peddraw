# peddraw
Utility for drawing pedigree diagrams with R Kinship

Run pedDraw.R as an Rscript, with the command line argument giving the CSV file of your pedigree.

Examples are in the bat and sh files. The bat may need to be edited on your system to find the correct file path to Rscript

Copy the example_family.csv and edit it with your intended family pedigree, and use the new filename in the bar or sh script. (bat for windows, sh for unix).

For multiple statuses on each individual's icons: add or remove columns "status2" through "status4" in the family CSV.

The settings.txt holds more R code which sets up parameters. The PDF file size is given in inches. If your text is too large on the 8x6 inch default page, try making the file 12x10 inches instead. Also to conserve space, be sure your individual IDs are short codes rather than full subject names. 



