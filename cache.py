import matplotlib.pyplot as plt
import random
import math


class Block:
    def __init__(self, replacement):
        self.v = False
        self.tag = 0
        self.replacement = replacement
        self.sign = 0   #标志位, LRU中的cnt, FIFO中的time

    def update(self, time):
        self.sign = time
    
    def replace(self, tag, time):
        self.v = True
        self.tag = tag
        if self.replacement == 'LRU' or self.replacement == 'FIFO':
            self.sign = time

    def init(self, tag, time):
        self.v = True
        self.tag = tag
        if self.replacement == 'LRU' or self.replacement == 'FIFO':
            self.sign = time



class Set:
    def __init__(self, setSize, replacement):
        self.block = []
        for _ in range(setSize):
            self.block.append(Block(replacement))


class Cache:
    def __init__(self, size, blockSize, associativities, replacement):
        self.size = size
        self.blockSize = blockSize
        self.associativities = associativities
        self.replacement = replacement
        self.hit = 0
        self.notHit = 0

        self.set = []
        for _ in range(self.size // (self.associativities * self.blockSize)):
            self.set.append(Set(self.associativities, replacement))
    
    def decode(self, address, time):
        address = hexStr2binStr(address)
        #print(address)
        rowSize = self.size // (self.associativities * self.blockSize)
        indexSize = int(math.log2(rowSize))
        byteInBlockSize = int(math.log2(self.blockSize))
        #print(rowSize, indexSize, byteInBlockSize)

        tag = address[: 32 - (indexSize + byteInBlockSize)]
        index = address[32 - (indexSize + byteInBlockSize) : 32 - byteInBlockSize]
        #byteInBlock = address[32 - byteInBlockSize:]

        #return (tag, int(index, 2), int(byteInBlock, 2))
        rowNum = int(index, 2) if len(index) > 0 else 0
        #print(tag, rowNum)
        return (tag, rowNum)

    def process(self, address, time):
        tag, rowNum = self.decode(address, time)
        row = self.set[rowNum]
        for block in row.block:
            if block.tag == tag and block.v == True:    #hit!
                self.hit += 1
                if self.replacement == 'LRU':
                    block.update(time)
                return
        
        #not hit
        self.notHit += 1
        writed = False
        minNum = 10000000000
        minPos = -1
        for i, block in enumerate(row.block):
            if block.v == False:    #直接写入
                block.init(tag, time)
                writed = True
                break
            else:
                if block.sign < minNum:
                    minNum = block.sign
                    minPos = i
        if not writed:  #需要替换
            if self.replacement == 'LRU' or self.replacement == 'FIFO':
                row.block[minPos].replace(tag, time)
            elif self.replacement == 'Random':
                row.block[random.randint(0, len(row.block) - 1)].replace(tag, time)


def printStatus(cache):
    print("**************************************")
    for i in range(len(cache.set)):
        for j in range(len(cache.set[i].block)):
            block = cache.set[i].block[j] 
            print(block.v, block.tag, block.sign)
        print("------------------------")
    print(cache.hit, cache.notHit)
        

def test1():
    cache = Cache(4, 1, 4, 'Random')
    cache.process("000004b0", 1)
    printStatus(cache)
    cache.process("000004c0", 2)
    printStatus(cache)
    cache.process("000004b0", 3)
    printStatus(cache)
    cache.process("000004c0", 4)
    hit_rate = cache.hit / (cache.hit + cache.notHit)
    print(hit_rate, cache.hit, cache.notHit)


def test(size, blockSize, associativities, replacement):
    cache = Cache(size, blockSize, associativities, replacement)
    with open("trace.txt") as trace:
        for i, row in enumerate(trace):
            cache.process(row, i)
    hit_rate = cache.hit / (cache.hit + cache.notHit) 
    return hit_rate
    


def main():
    '''
    hit_rate = []
    for size in [1024, 2048, 4096, 8192, 16384]:
        hit_rate.append(test(size, 16, 1, 'LRU'))
    print(hit_rate)
    fig = plt.figure()
    ax = fig.add_subplot()
    ax.set_xticks([1024, 2048, 4096, 8192, 16384])
    plt.title("Cache Size")
    plt.plot([1024, 2048, 4096, 8192, 16384], hit_rate)
    plt.savefig("/mnt/d/cacheSize.png")
    plt.close('all')

    hit_rate = []
    for blockSize in [8, 16, 32]:
        hit_rate.append(test(4096, blockSize, 1, 'LRU'))
    print(hit_rate)
    fig = plt.figure()
    ax = fig.add_subplot()
    ax.set_xticks([8, 16, 32])
    plt.title("Block Size")
    plt.plot([8, 16, 32], hit_rate)
    plt.savefig("/mnt/d/blockSize.png")
    plt.close('all')

    hit_rate = []
    for setSize in [1, 2, 4, 8]:
        hit_rate.append(test(4096, 16, setSize, 'LRU'))
    print(hit_rate)
    fig = plt.figure()
    ax = fig.add_subplot()
    ax.set_xticks([1, 2, 4, 8])
    plt.title("Set Size")
    plt.plot([1, 2, 4, 8], hit_rate)
    plt.savefig("/mnt/d/setSize.png")
    plt.close('all')
    '''
     
    '''
    for setSize in [2, 4, 8]:
        hit_rate = []
        for replacementMethod in ['Random', 'FIFO', 'LRU']:
            hit_rate.append(test(4096, 16, setSize, replacementMethod))
        print(hit_rate)
    fig = plt.figure()
    plt.title("Replacement Method")
    plt.plot(['Random', 'FIFO', 'LRU'], hit_rate)
    plt.savefig("/mnt/d/replacementMethod.png")
    plt.close('all')
    '''

    for size in [1024, 2048, 4096, 8192, 16384]:
        bestHitRate = 0.
        bestBlockSize = 0
        bestSetSize = 0
        bestReplacementMethod = '' 
        for blockSize in [8, 16, 32]:
            for setSize in [1, 2, 4, 8]:
                for replacementMethod in ['Random', 'FIFO', 'LRU']:
                    hitRate = test(size, blockSize, setSize, replacementMethod)
                    print(hitRate)
                    if(hitRate > bestHitRate):
                        bestBlockSize = blockSize
                        bestSetSize = setSize
                        bestReplacementMethod = replacementMethod
                        bestHitRate = hitRate
        print(size, bestBlockSize, bestSetSize, bestReplacementMethod, bestHitRate)


def hexStr2binStr(string):
    binStr = bin(int(string, 16))[2:]
    while len(binStr) < 32:
        binStr = '0' +binStr
    return binStr


if __name__ == "__main__":
    main()