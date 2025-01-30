import re

file_name: str = input("What is the name of the file? (Do no include extension): ")
f = open((file_name + ".csv"), "r")
file_info: str = f.read()
f.close()
csv_file_info: str = re.sub(" +",", ",file_info)
new_f = open((file_name + ".csv"), "w")
new_f.write(csv_file_info)
new_f.close()
print("Conversion complete")