//  MIT License
//
// Copyright (c) 2018 pankajsoni@softwarejoint.com pankajsoni@softwarejoint.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//
// BertEncoder.swift
//

import BigInt

typealias BertArray = Array<Any>

final class BertAtom {

    private let ATOM_EXT_MAX_LEN : Int = 255
    private var atom : String? = nil

    required init(atom: String) {
        if atom.isEmpty {
            print("ERROR: Atom can't be empty")
        }
        else if atom.count > ATOM_EXT_MAX_LEN {
            print("ERROR: Atom max length can be only \(ATOM_EXT_MAX_LEN)")
        }
        else {
            self.atom = atom
        }
    }

    func stringVal() -> String {
        if let atom = atom, !atom.isEmpty{
            return atom
        }

        return ""
    }

    var description: String {
        let atom = stringVal()
        return "BertAtom (\(atom))"
    }
}

final class BertEncoder {

    private var NIL                         :UInt8      = 0
    private var DELIMITER                   :UInt8      = 0

    private var MAGIC                       :UInt8      = 131
    private var NIL_EXT                     :UInt8      = 106

    private var SMALL_INTEGER_EXT_MIN_VAL   :Int        = 0
    private var TUPLE_2                     :UInt8      = 2
    private var FOUR                        :UInt8      = 4
    private var SMALL_INTEGER_EXT_MAX_VAL   :Int        = 255

    private var INTEGER_EXT_MIN_VAL         :Int        = Int(Int32.min)
    private var INTEGER_EXT_MAX_VAL         :Int        = Int(Int32.max)

    private var INTEGER_EXT                 :UInt8      = 3
    private var SMALL_INTEGER_EXT           :UInt8      = 97

    private var FLOAT_LENGTH                :Int32       = 31

    private var FLOAT_EXT                   :UInt8      = 99
    private var NEW_FLOAT_EXT               :UInt8      = 70

    private var SMALL_BIG_EXT               :UInt8      = 110
    private var LARGE_BIG_EXT               :UInt8      = 111

    private var ATOM_EXT                    :UInt8      = 100
    private var SMALL_ATOM_EXT              :UInt8      = 115

    private var STRING_EXT_MAX_VAL          :Int        = 65535

    private var STRING_EXT                  :UInt8      = 107
    private var LIST_EXT                    :UInt8      = 108

    private var BINARY_EXT                  :UInt8      = 109

    private var SMALL_TUPLE_EXT             :UInt8      = 104
    private var LARGE_TUPLE_EXT             :UInt8      = 105

    private var MAP_EXT                     :UInt8      = 116
    
    private var data: Data!

    private var encodeMapKeysAsAtom     = true
    private var encodeMapKeysAsString   = true
    private var encodeMapAsPropList     = false
    
    public func withEncodeMapAsPropList(encodeMapAsPropList  : Bool) -> BertEncoder {
        self.encodeMapAsPropList = encodeMapAsPropList
        return self
    }
    
    public func withEncodeMapKeysAsAtom(encodeMapKeysAsAtom: Bool) ->BertEncoder {
        self.encodeMapKeysAsAtom = encodeMapKeysAsAtom
        return self
    }
    
    public func withEncodeMapKeysAsString(encodeMapKeysAsString : Bool) -> BertEncoder {
        self.encodeMapKeysAsString = encodeMapKeysAsString
        return self
    }
    
    public func encodeAny(any: Any!) -> Data {
        data = Data()
        _ = encode(any: any)
        return data
    }
    
    public func reset() {
        data = nil
    }
    
    private func encode(any: Any!) -> Data {
        switch any {
        case nil:
            encodeNull()
        case let num as NSNumber:
            if isFraction(num: num) {
                encodeDouble(someDouble: num.doubleValue)
            } else {
                return encodeInteger(someInt: Int(num.int64Value))
            }
        case let someInt as Int:
            return encodeInteger(someInt: someInt)
        case let someLong as Int64:
            encodeBigInteger(bigInt: BigInt(someLong))
        case let someFloat as Float:
            let someDouble = Double(someFloat)
            encodeDouble(someDouble: someDouble)
        case let someDouble as Double:
            encodeDouble(someDouble: someDouble)
        case let bigInt as BigInt:
            encodeBigInteger(bigInt: bigInt)
        case let bool as Bool:
            encodeAtom(atom: bool.description)
        case let atom as BertAtom:
            encodeAtom(atom: atom.stringVal())
        case let string as String:
            encodeString(string: string)
        case let binary as Data:
            return encodeBinary(binary: binary)
        case let array as BertArray:
            let elems = array.map {$0 as Any}
            encodeArray(array: elems)
        case let dict as NSDictionary:
            encodeDict(dict: dict)
        default: break
        }

        return Data()
    }
    
    private func encodeNull(){
        data.append(&NIL_EXT, count: 1)
    }

    private func encodeDelimiter(){
        data.append(&DELIMITER, count: 1)
    }
    
    private func encodeByte(someByte: Int) {
        data.append(&SMALL_INTEGER_EXT, count: 1)
        putUnsignedByte(someByte: someByte);
    }

    private func encodeSmallInt(someByte: Int) -> Data {
        var localData: Data = Data()

        localData.append(contentsOf: [UInt8](repeating: 0, count: 63))
        localData.append(unsignedByte(someByte: someByte))

        return localData
    }

    private func encodeInt(someByte: Int) -> Data {
        var localData: Data = Data()

        var value = UInt32(someByte).bigEndian
        let valueData = UnsafeBufferPointer(start: &value, count: 1)
        localData.append(contentsOf: [UInt8](repeating: 0, count: 60))
        localData.append(valueData)

        return localData
    }
    
    private func encodeInteger(someInt: Int) -> Data {
        var localData: Data = Data()

        if (SMALL_INTEGER_EXT_MIN_VAL <= someInt && someInt <= SMALL_INTEGER_EXT_MAX_VAL) {
            localData.append(&INTEGER_EXT, count: 1)
            localData.append(encodeSmallInt(someByte: someInt))
        } else if (INTEGER_EXT_MIN_VAL <= someInt && someInt <= INTEGER_EXT_MAX_VAL) {
            localData.append(&INTEGER_EXT, count: 1)
            localData.append(encodeInt(someByte: someInt))
        } else {
            encodeBigInteger(bigInt: BigInt(someInt))
        }

        return localData
    }
    
    private func encodeDouble(someDouble: Double){
        var array = toByteArray(value: someDouble)
        data.append(&NEW_FLOAT_EXT, count: 1)
        data.append(&array, count: MemoryLayout<Double>.size)
    }
    
    private func encodeBigInteger(bigInt: BigInt){
        
        let bytes = bigInt.magnitude.serialize()
        let count = bytes.count
        
        if (count <= SMALL_INTEGER_EXT_MAX_VAL){
            data.append(&SMALL_BIG_EXT, count: 1)
            putUnsignedByte(someByte: count);
        } else {
            data.append(&LARGE_BIG_EXT, count: 1)
            putUnsignedInt(someInt: count);
        }
        
        var sign: UInt8 = bigInt.sign == BigInt.Sign.minus ? 1 : 0
        
        data.append(&sign, count: 1)
        data.append(bytes)
    }
    
    private func encodeAtom(atom: String) {
        let count = atom.count;
        
        if (count <= SMALL_INTEGER_EXT_MAX_VAL){
            data.append(&SMALL_ATOM_EXT, count: 1)
            putUnsignedByte(someByte: count)
        } else{
            data.append(&ATOM_EXT, count: 1)
            putUnsignedShort(someShort: count)
        }
        
        data.append(atom.data(using: String.Encoding.utf8)!)
    }

    private func encodedString(string: String) -> Data? {
        var localData: Data = Data()

        let count = string.count
        if (count <= STRING_EXT_MAX_VAL){
            localData.append(string.data(using: String.Encoding.utf8)!)

            return localData
        } else {
            encodeArray(array: Array(arrayLiteral: string))
            return nil
        }
    }
    
    private func encodeString(string: String){
        encodeDelimiter()

        let count = string.count
        if (count <= STRING_EXT_MAX_VAL){
            putUnsignedShort(someShort: count);
            data.append(string.data(using: String.Encoding.utf8)!)
        } else {
            encodeArray(array: Array(arrayLiteral: string))
        }
    }
    
    private func encodeBinary(binary: Data?) -> Data {
        var localData: Data = Data()
        localData.append(&DELIMITER, count: 1)

        if let binary = binary {
            var int: UInt32 = UInt32(binary.count).bigEndian
            localData.append(UnsafeBufferPointer(start: &int, count: 1))
            localData.append(binary)
        }

        return localData
    }
    
    private func encodeArray(array: Array<Any>) {
        var atom_size: Int = 0
        if array[0] is String {
            var sliceData: Data = Data()
            var count: Int = 0

            let slice = array.dropFirst()
            for o: Any in slice {
                if o is String {
                    let preparedData = Base64EncodeDecodeUtil.decodeBase64((o as! String))
                    let result = encode(any: preparedData)
                    count += result.count
                    sliceData.append(result)
                } else {
                    let result = encode(any: o)
                    count += result.count
                    sliceData.append(result)
                }
            }

            data.append(&TUPLE_2, count: 1)
            atom_size = (array[0] as! String).length

            if let d = encodedString(string: (array[0] as! String)) {
                let prefixLength = 5 + d.count + count
                putUnsignedInt(someInt: prefixLength);
                data.append(&FOUR, count: 1)
                putUnsignedInt(someInt: atom_size);
                data.append(d)
                data.append(sliceData)
            }
        }
    }
    
    private func encodeDict(dict: NSDictionary){
        if (encodeMapAsPropList){
            data.append(&LIST_EXT, count: 1)
        } else{
            data.append(&MAP_EXT, count: 1)
        }
        
        putUnsignedInt(someInt: dict.count);
        
        for (key, value) in dict {
            if (encodeMapAsPropList){
                data.append(&SMALL_TUPLE_EXT, count: 1)
                putUnsignedByte(someByte: 2)
            }
            
            if (encodeMapKeysAsAtom) {
                encodeAtom(atom: String(describing: key));
            } else if (encodeMapKeysAsString) {
                encodeString(string: String(describing: key));
            } else {
                _ = encode(any: key)
            }
            
            _ = encode(any: value)
        }
        
        if (encodeMapAsPropList){
            encodeNull();
        }
    }
    
    private func putUnsignedByte(someByte: Int) {
        var byte: UInt8 = UInt8(someByte);
        data.append(&byte, count: 1)
    }

    private func unsignedByte(someByte: Int) -> Data {
        var localData = Data()

        var byte: UInt8 = UInt8(someByte);
        localData.append(&byte, count: 1)

        return localData
    }
    
    private func putUnsignedShort(someShort: Int) {
        var short: UInt16 = UInt16(someShort).bigEndian
        data.append(UnsafeBufferPointer(start: &short, count: 1))
    }
    
    private func putUnsignedInt(someInt: Int) {
        var int: UInt32 = UInt32(someInt).bigEndian
        data.append(UnsafeBufferPointer(start: &int, count: 1))
    }
    
    public func toByteArray<T>(value: T) -> [UInt8] {
        var v: T = value
        return withUnsafePointer(to: &v) {
            Array(UnsafeBufferPointer(start: UnsafeRawPointer($0).assumingMemoryBound(to: UInt8.self), count: MemoryLayout<T>.size).reversed())
        }
    }

    private func isFraction(num: NSNumber) -> Bool {
        let dValue = num.doubleValue
        if (dValue < 0.0) {
            return (dValue != ceil(dValue));
        } else {
            return (dValue != floor(dValue));
        }
    }
}


