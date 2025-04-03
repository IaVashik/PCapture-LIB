def create_all_in_one(input_file, output_file):
    """
    Creates an all-in-one version of PCapture-LIB by recursively
    replacing IncludeScript calls with the contents of included files.

    Args:
        input_file (str): The path to the main PCapture-LIB file.
        output_file (str): The path to the output file for the all-in-one version. 
    """
    with open(output_file, "w", encoding="utf-8") as outfile:
        _process_file(input_file, outfile)

def _process_file(file_path, outfile):
    """
    Recursively processes a file, replacing IncludeScript calls.

    Args:
        file_path (str): The path to the file to process.
        outfile (file): The output file to write the processed code to.
    """
    file_path = file_path.replace("PCapture-LIB/", "")
    with open(file_path, "r", encoding="utf-8") as infile:
        for line in infile:
            included_file_path = None
            if line.startswith("IncludeScript("):
                included_file_path = line[len("IncludeScript("):-2].replace('"', '').strip()
            if line.startswith("DoIncludeScript("):
                included_file_path = line[len("DoIncludeScript("):-len('", rootScope)')].replace('"', '').strip() # bruh
            
            
            if included_file_path is not None:
                if not included_file_path.endswith(".nut"):
                    included_file_path += ".nut"
                _process_file(included_file_path, outfile)
            else: 
                outfile.write(line)
        outfile.write("\n")
    

create_all_in_one("SRC/PCapture-Lib.nut", "OUTPUT/PCapture-Lib.nut") 