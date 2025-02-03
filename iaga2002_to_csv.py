import re

def conversion():
    file_name: str = input("What is the name of the file? (Do no include extension): ")
    try:
        f = open((file_name + ".csv"), "r")
    except FileNotFoundError:
        print("That is not a valid file. Please try again.")
        conversion()
    except:
        print("How did you even do this? I am actually impressed, please contact me about this.")
        exit()
    
    file_info: str = f.read()
    f.close()
    file_info: str = re.sub(" +\|","",file_info)
    csv_file_info: str = re.sub(" +",", ",file_info)
    new_f = open((file_name + ".csv"), "w")
    new_f.write(csv_file_info)
    new_f.close()
    print("Conversion complete")
    again: str = input("Do you want to convert another file? ")
    
    if again.lower() == 'yes':
        conversion()
    else:
        print("Rightio.")
        exit()
    

if __name__ == "__main__":
    conversion()