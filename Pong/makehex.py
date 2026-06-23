f = open("pong.hex")
text = f.read() # Store the file text
f.close()

bytes_list = text.split() # Split text by space and place in a list
bytes_list = [b for b in bytes_list if not b.startswith("@")] # Remove the @00000000

output = "00005137\n"

for i in range(0, len(bytes_list), 4): # Start at 0, Go to list end, steps of 4
	group = bytes_list[i:i+4] # Take current + next 3 bits (i+4 is exclusive)
	word = "".join(group[::-1]) # Join together and reverse 
	output = output + word + "\n"  

f = open("pong.hex", "w")
f.write(output)
f.close()
