from collections import OrderedDict
import codecs
import struct
from Crypto.Cipher import AES
import random


ALLOWED = [' ', '\n', '\'', ',', ';', '"', ':', '?', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+']


def generate_ascii():
    arr = []
    for i in range(256):
        arr.append(chr(i))
    return arr


def only_english(s):
    allowed = [ord(i) for i in ALLOWED]
    return all((ord(c) >= ord('a') and ord(c) <= ord('z')) or
               (ord(c) >= ord('A') and ord(c) <= ord('Z')) or
               ord(c) in allowed for c in s)


def str_to_binary(s):
    res = ""
    for i in s:
        bin_s = format(i if isinstance(i, int) else ord(i), 'b')
        zeros = 8 - len(bin_s)
        for n in range(zeros):
            res += "0"
        res += bin_s
    return res


def hamming_dist(s1, s2):
    b_s1 = str_to_binary(s1)
    b_s2 = str_to_binary(s2)

    count = 0
    for x, y in zip(b_s1, b_s2):
        count = count + 1 if x != y else count
    return count


def transpose(blocks):
    sen_arr = OrderedDict()
    for i in blocks:
        for ne in range(len(i)):
            sen_arr[ne] = sen_arr.get(ne, b'') + chr(i[ne]).encode()
    return sen_arr


def create_blocks(data, size):
    blocks = []
    itr = 0
    breaker = 0
    while True:
        if breaker:
            break
        blocks.append(data[itr * size:(itr + 1) * size])
        itr += 1
        if itr * size >= len(data):
            breaker = len(data)
    return blocks


def frequency(s):
    chart = {
        'e': 13, 't': 12, 'a': 11, 'o': 10, 'i': 9, 'n': 8, ' ': 7, 's': 6, 'h': 5, 'r': 4, 'd': 3, 'l': 2, 'u': 1
    }
    count = 0
    for i in s:
        count += chart.get(i.lower(), 0)
    return count


def normalize(data, n):
    parts = [data[i:i + n] for i in range(0, len(data), n)]
    sums = []
    for i in range(len(parts) - 1):
        sums.append(hamming_dist(parts[i], parts[i + 1]) / n)
    return sum(sums) / len(sums)


def to_base64(s):
    return codecs.encode(s, 'base64')


def fixed_xor(s1, s2):
    new_s = b""
    for x, y in zip(s1, s2):
        x = ord(x) if type(x) == str else x
        y = ord(y) if type(y) == str else y
        xored = (x ^ y)
        new_s += struct.pack('B', xored)
    return new_s


def xor_cipher(s):
    obj = {}
    arr = []
    char_set = generate_ascii()
    for i in char_set:
        new_s = ""
        for n in s:
            new_s += chr(n ^ ord(i))
        count = frequency(new_s)
        if not obj.get('count') or obj['count'] <= count:
            obj = {'sen': new_s, 'count': count, 'key': i, 'num': ord(i), 'org': s}
            if not len(arr) or arr[0]['count'] == count:
                arr.append(obj)
            else:
                arr = [obj]
    return arr


def single_char_XOR(lines):
    arr = []
    for i in lines:
        s = codecs.decode(i.strip(), 'hex')
        res = xor_cipher(s)
        if (len(res) and not len(arr)) or (len(arr) and len(res) and arr[0]['count'] < res[0]['count']):
            arr = res
    return arr


def repeat_key_XOR(s, key):
    new_s = ""
    i = 0
    n = 0
    while True:
        new_s += chr(s[i] ^ ord(key[n]))
        i += 1
        n += 1
        if n == len(key):
            n = 0
        if i == len(s):
            break
    new_s = new_s.encode()
    return codecs.encode(new_s, 'hex')


def break_repeat_key_XOR(data):
    key_dict = {}
    for i in range(2, 41):
        norm_dist = normalize(data, i)
        key_dict[i] = norm_dist
    key_size = min(key_dict, key=key_dict.get)
    blocks = create_blocks(data, key_size)
    transposed = transpose(blocks)
    key = ''
    for i in transposed:
        key += xor_cipher(transposed[i])[0]['key']
    text = repeat_key_XOR(data, key)
    # print("key: {}\ntext: {}".format(key, codecs.decode(text, 'hex')))
    coded = repeat_key_XOR(codecs.decode(text, 'hex'), key)
    coded = codecs.encode(codecs.decode(coded, 'hex'), 'base64')
    # print(coded)
    return key


def decrypt_aes_in_ecb(data, key):
    obj = AES.new(key, AES.MODE_ECB)
    res = obj.decrypt(data)
    return res


def encrypt_aes_in_ecb(data, key):
    obj = AES.new(key, AES.MODE_ECB)
    res = obj.encrypt(data)
    return res


def detect_aes_in_ecb(lines):
    ans = []
    for i in lines:
        arr = create_blocks(i.strip(), 16)
        data = {}
        while(len(arr)):
            n = arr[0]
            arr.remove(n)
            if n in arr:
                if data.get(n):
                    data[n] = data[n] + 1
                else:
                    data[n] = 1
        if len(data):
            ans.append({'line': i, 'data': data})
    return ans


def pkcs_7_padding(s, n=None):
    if not n:
        n = len(s) + (((int(len(s) / 16) + 1) * 16) - len(s)) if len(s) % 16 else len(s)
    size = n - len(s)
    ans = s
    for i in range(size):
        ans += struct.pack('B', size)
    return ans, size


def de_pad(s, size):
    return s[0:len(s) - size]


def challenge_1():
    hex_str = "49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d"
    s = codecs.decode(hex_str, 'hex')
    ans = to_base64(s).decode().strip()
    to_match = "SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t"
    if ans != to_match:
        print("Error: Challenge_1")
    else:
        print("Success: Challenge_1")


def challenge_2():
    xor_s1 = "1c0111001f010100061a024b53535009181c"
    xor_s2 = "686974207468652062756c6c277320657965"
    s1 = codecs.decode(xor_s1, 'hex')
    s2 = codecs.decode(xor_s2, 'hex')
    ans = codecs.encode(fixed_xor(s1, s2), 'hex').decode()
    to_match = "746865206b696420646f6e277420706c6179"
    if ans != to_match:
        print("Error: Challenge_2")
    else:
        print("Success: Challenge_2")


def challenge_3():
    cipher_str = "1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736"
    s = codecs.decode(cipher_str, 'hex')
    ans = xor_cipher(s)[0]
    to_match_1 = "Cooking MC's like a pound of bacon"
    to_match_2 = "X"
    if ans['sen'] != to_match_1 or ans['key'] != to_match_2:
        print("Error: Challenge_3")
    else:
        print("Success: Challenge_3")


def challenge_4():
    with open('./ch4_file.txt', 'r') as file:
        lines = file.readlines()
        ans = single_char_XOR(lines)[0]
        to_match_1 = "Now that the party is jumping\n"
        to_match_2 = "5"
        if ans['sen'] != to_match_1 or ans['key'] != to_match_2:
            print("Error: Challenge_4")
        else:
            print("Success: Challenge_4")


def challenge_5():
    repeat_XOR_txt = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
    s = repeat_XOR_txt.encode()
    ans = repeat_key_XOR(s, 'ICE').decode()
    to_match = "0b3637272a2b2e63622c2e69692a23693a2a3c6324202d623d63343c2a26226324272765272a282b2f20430a652e2c652a3124333a653e2b2027630c692b20283165286326302e27282f"
    if ans != to_match:
        print("Error: Challenge_5")
    else:
        print("Success: Challenge_5")


def check_hamming_distance():
    ham_s1 = "this is a test"
    ham_s2 = "wokka wokka!!!"
    ans = hamming_dist(ham_s1, ham_s2)
    to_match = 37
    if ans != to_match:
        print("Error: Hamming Distance")
    else:
        print("Success: Hamming Distance")


def challenge_6():
    with open('./ch6_file.txt', 'r') as file:
        data = file.read()
        data = data.encode()
        data = codecs.decode(data, 'base64')
        ans = break_repeat_key_XOR(data)
        to_match = 'Terminator X: Bring the noise'
        if ans != to_match:
            print("Error: Challenge_6")
        else:
            print("Success: Challenge_6")


def challenge_7():
    with open('./ch7_file.txt') as file:
        data = file.read()
        data = data.encode()
        data = codecs.decode(data, 'base64')
        ans = decrypt_aes_in_ecb(data, "YELLOW SUBMARINE").decode()
        if "Stage 2 -- Yea the one ya' wanna listen to" not in ans:
            print("Error: Challenge_7")
        else:
            print("Success: Challenge_7")


def challenge_8():
    with open('./ch8_file.txt') as file:
        lines = file.readlines()
        ans = detect_aes_in_ecb(lines)[0]
        if ans['line'] not in lines:
            print("Error: Challenge_8")
        else:
            print("Success: Challenge_8")


def challenge_9():
    s = "YELLOW SUBMARINE"
    ans, size = pkcs_7_padding(s.encode(), 20)
    ans = de_pad(ans, size).decode()
    if ans != s:
        print("Error: Challenge_9")
    else:
        print("Success: Challenge_9")


def cbc_encode(s, k, iv):
    blocks = create_blocks(s, 16)
    ans = []
    for n in range(len(blocks)):
        if n == 0:
            enc = fixed_xor(blocks[n], iv)
            cipher = encrypt_aes_in_ecb(enc, k)
            ans.append(cipher)
        else:
            enc = fixed_xor(blocks[n], cipher)
            cipher = encrypt_aes_in_ecb(enc, k)
            ans.append(cipher)
    res = b""
    for i in ans:
        res += i
    return res


def cbc_decode(s, k, iv):
    blocks = create_blocks(s, 16)
    ans = []
    for n in range(len(blocks)):
        if n == 0:
            dec = decrypt_aes_in_ecb(blocks[n], k)
            de_cipher = fixed_xor(dec, iv)
            ans.append(de_cipher)
        else:
            dec = decrypt_aes_in_ecb(blocks[n], k)
            de_cipher = fixed_xor(dec, blocks[n - 1])
            ans.append(de_cipher)
    res = b""
    for i in ans:
        res += i
    return res


def challenge_10():
    s = "testing is for noobs"
    padded_s, size = pkcs_7_padding(s.encode(), 32)

    k = "YELLOW SUBMARINE"
    iv = "".join([chr(0) for _ in range(16)]).encode()

    ans1 = encrypt_aes_in_ecb(padded_s, k)
    ans2 = decrypt_aes_in_ecb(ans1, k)
    ans2 = de_pad(ans2, size).decode()
    if s != ans2:
        print("Error: error in encrypt or decrypt aes_ecb! Challenge_10")
    else:
        print("AES encrypt and decrypt work fine!")

    ans3 = cbc_encode(padded_s, k, iv)
    ans4 = cbc_decode(ans3, k, iv)
    ans4 = de_pad(ans4, size).decode()
    if s != ans4:
        print("Error: error in encrypt or decrypt cbc! Challenge_10")
    else:
        print("CBC encode and decode work fine!")

    with open('./ch10_file.txt') as file:
        data = file.read()
        data = data.encode()
        data = codecs.decode(data, 'base64')
        ans = cbc_decode(data, k, iv).decode()
        if "Stage 2 -- Yea the one ya' wanna listen to" not in ans:
            print("Error: Challenge_10")
        else:
            print("Success: Challenge_10")


def generate_random_byte_string(n):
    s = b""
    for _ in range(n):
        i = random.randint(0, 256)
        s += struct.pack('B', i)
    return s


def encryption_oracle(s, key, iv):
    pre_bytes_append = ""
    for _ in range(random.randint(5, 10)):
        pre_bytes_append += chr(0)
    post_bytes_append = ""
    for _ in range(random.randint(5, 10)):
        post_bytes_append += chr(0)
    pre_bytes_append = pre_bytes_append.encode()
    post_bytes_append = post_bytes_append.encode()
    s = pre_bytes_append + s.encode() + post_bytes_append

    s, size = pkcs_7_padding(s)

    rander = random.randint(0, 1)
    ans = encrypt_aes_in_ecb(s, key) if rander == 0 else cbc_encode(s, key, iv)
    return ans, rander


def challenge_11():
    key = generate_random_byte_string(16)
    iv = generate_random_byte_string(16)
    s = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    ans, mode = encryption_oracle(s, key, iv)
    res = detect_aes_in_ecb([ans])
    s = 0 if len(res) else 1
    # print("Is CBC!" if s else "Is ECB!")
    if s == mode:
        print("Success: Challenge_11")
    else:
        print("Error: Challenge_11")


def aes_128_ecb(s, key):
    s, size = pkcs_7_padding(s)
    ans = encrypt_aes_in_ecb(s, key)
    return ans


def get_block_size(plain_txt, unknown_txt, key):
    chng1 = 0
    chng2 = 0
    temp = ''
    ans1 = aes_128_ecb(unknown_txt, key)
    first_chng = False
    for i in plain_txt:
        temp += i
        s = temp.encode() + unknown_txt
        ans2 = aes_128_ecb(s, key)
        if not first_chng and len(ans1) != len(ans2):
            ans1 = ans2
            first_chng = True
        if first_chng and len(ans1) != len(ans2):
            break
        if not first_chng:
            chng1 += 1
        chng2 += 1
    return chng2 - chng1


def decode_aes_128_ecb(plain_text, unknown_txt, block_size, key):
    breaker = False
    res = ''
    obs = ''.join([plain_text[x] for x in range(block_size - 1)])
    itr = 1
    res_len = 0
    while True:
        if breaker:
            break
        obs1 = obs[0:len(obs) - res_len]
        ans1 = aes_128_ecb(obs1.encode() + unknown_txt, key)
        for i in range(0, 256):
            obs2 = (obs1 + res).encode() + struct.pack('B', i) + unknown_txt
            ans2 = aes_128_ecb(obs2, key)
            if ans1[0:block_size * itr] == ans2[0:block_size * itr]:
                res += chr(i)
                res_len += 1
                if len(res) % block_size == 0:
                    itr += 1
                    res_len = 0
                break
            if i == 255:
                breaker = True
    return res


def challenge_12():
    s1 = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    s2 = """
        Um9sbGluJyBpbiBteSA1LjAKV2l0aCBteSByYWctdG9wIGRvd24gc28gbXkg
        aGFpciBjYW4gYmxvdwpUaGUgZ2lybGllcyBvbiBzdGFuZGJ5IHdhdmluZyBq
        dXN0IHRvIHNheSBoaQpEaWQgeW91IHN0b3A/IE5vLCBJIGp1c3QgZHJvdmUg
        YnkK
    """
    key = generate_random_byte_string(16)
    s2 = codecs.decode(s2.encode(), 'base64')
    s = s1.encode() + s2
    ans = aes_128_ecb(s, key)
    block_size = get_block_size(s1, s2, key)
    res = detect_aes_in_ecb([ans])
    is_ecb = True if len(res) else False
    if not is_ecb:
        print("Error: Not ECB!")

    unknown_txt = decode_aes_128_ecb(s1, s2, block_size, key)
    # print(unknown_txt)
    if s2.decode() == unknown_txt[:-1]:
        print("Success: Challenge_12")
    else:
        print("Error: Challenge_12")


def profile_for(x):
    obj = {
        "email": x.replace('=', '').replace('&', ''), "uid": 10, "role": "user"
    }
    enc = [f'{x}={y}' for x, y in obj.items()]
    return '&'.join(enc)


def parse_profile(x):
    dec = x.split('&')
    ans = {}
    for i in dec:
        arr = i.split('=')
        ans[arr[0]] = arr[1]
    return ans


def is_admin(cipher, key, size):
    dec = decrypt_aes_in_ecb(cipher, key)
    dec = de_pad(dec, size).decode()
    parsed = parse_profile(dec)
    return parsed['role']


def challenge_13():
    key = generate_random_byte_string(16)

    enc1 = profile_for("aaaaaaaaaaaaa")
    enc1, size1 = pkcs_7_padding(enc1.encode())
    ans1 = encrypt_aes_in_ecb(enc1, key)

    TO_PAD = 11
    enc2 = profile_for("aaaaaaaaaaadmin" + 'a' * TO_PAD)
    enc2, size2 = pkcs_7_padding(enc2.encode())
    ans2 = encrypt_aes_in_ecb(enc2, key)

    crafted = ans1[:32] + ans2[16:32]
    res = is_admin(crafted, key, TO_PAD)
    if res == 'admin':
        print("Success: Challenge_13")
    else:
        print("Error: Challenge_13")


# challenge_1()
# challenge_2()
# challenge_3()
# challenge_4()
# challenge_5()
# check_hamming_distance()
# challenge_6()
# challenge_7()
# challenge_8()
# challenge_9()
# challenge_10()
# challenge_11()
# challenge_12()
# challenge_13()
