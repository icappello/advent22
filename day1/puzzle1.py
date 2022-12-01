fp = open("./puzzle1.in", "r")

lines = fp.readlines()


current_max = -1
current_user = -1


for line in lines:
    if line.strip() == "":
        if(current_user > current_max):
            current_max = current_user
        current_user = 0
    else:
        current_user = current_user + int(line)

print(current_max)
