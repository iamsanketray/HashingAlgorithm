func murmurhash3(key: [UInt8], seed: UInt32) -> UInt32 {
    let c1: UInt32 = 0xcc9e2d51
    let c2: UInt32 = 0x1b873593
    let r1: UInt32 = 15
    let r2: UInt32 = 13
    let m: UInt32 = 5
    let n: UInt32 = 0xe6546b64

    var hash: UInt32 = seed
    let len = key.count
    let blocks = len / 4

    for i in 0..<blocks {
        var k1 = UInt32(key[i * 4 + 0]) | (UInt32(key[i * 4 + 1]) << 8) | (UInt32(key[i * 4 + 2]) << 16) | (UInt32(key[i * 4 + 3]) << 24)
        k1 = k1 &* c1
        k1 = (k1 << r1) | (k1 >> (32 - r1))
        k1 = k1 &* c2
        hash = hash ^ k1
        hash = (hash << r2) | (hash >> (32 - r2))
        hash = hash &* m &+ n
    }

    var k1: UInt32 = 0
    let remaining = len % 4

    if remaining == 3 {
        k1 = UInt32(key[blocks * 4 + 2]) << 16
        fallthrough
    }
    if remaining >= 2 {
        k1 |= UInt32(key[blocks * 4 + 1]) << 8
        fallthrough
    }
    if remaining >= 1 {
        k1 |= UInt32(key[blocks * 4 + 0])
        k1 = k1 &* c1
        k1 = (k1 << r1) | (k1 >> (32 - r1))
        k1 = k1 &* c2
        hash = hash ^ k1
    }

    hash = hash ^ UInt32(len)

    hash = hash ^ (hash >> 16)
    hash = hash &* 0x85ebca6b
    hash = hash ^ (hash >> 13)
    hash = hash &* 0xc2b2ae35
    hash = hash ^ (hash >> 16)

    return hash
}
