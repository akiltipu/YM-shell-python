import os

# print("File writing completed. Now reading the file...\n")

# Writing to a file
file = open('example.txt', 'w')
file.write("First line of the file.\n")
file.write("Second line of the file.\n")
file.close()

sample_content = """Line 1: Hello, World!
Line 2: This is a sample file.
Line 3: Python file reading example.
Line 4: End of file."""

# with open('sample.txt', 'w') as f:
#     f.write(sample_content)

# with open('sample.txt', 'r') as myfile:
#     content = myfile.read()
#     print("Full file content:")
#     print("-" * 40)
#     print(content)

# print("-" * 40)

if os.path.exists('sample1.txt'):
    print("File 'sample.txt' exists.")
else:
    print("File 'sample.txt' does not exist.")

