fp = open("./puzzle1.in", "r")

lines = fp.readlines()


results = []
current_user = -1


for line in lines:
    if line.strip() == "":
        results.append(current_user)
        current_user = 0
    else:
        current_user = current_user + int(line)

results.sort()

top_three = results[-3:]

print(sum(top_three))
